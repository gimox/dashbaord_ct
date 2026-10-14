import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:isar_community/isar.dart';

import '../../core/db/isar_provider.dart';
import '../../core/theme/app_theme.dart';
import '../sync/models/stat_mdl.dart';
import '../sync/models/user.dart';
import 'models/user_course_stat_group.dart';
import 'services/user_course_stats_excel_exporter.dart';

class UserCourseStatsView extends ConsumerStatefulWidget {
  const UserCourseStatsView({super.key});

  @override
  ConsumerState<UserCourseStatsView> createState() => _UserCourseStatsViewState();
}

class _UserCourseStatsViewState extends ConsumerState<UserCourseStatsView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  List<UserCourseStatGroup> _allGroups = [];
  List<UserCourseStatGroup> _filteredGroups = [];

  bool _isLoading = true;
  bool _isExporting = false;
  bool _isAdvancedFiltersOpen = false;

  // Paginazione
  static const int _pageSize = 50;
  int _currentPage = 0;

  // Ordinamento: 1: ID Utente, 2: Utente, 3: Genere, 4: Corso, 5: Tipo Corso, 6: Progresso, 7: Stato, 8: Data Completamento
  int _sortColumnIndex = 1;
  bool _sortAscending = true;

  // Filtri Avanzati
  String? _filterStatoCorso; // null: Tutti, oppure "Completato", "In corso"
  String? _filterTipoCorso; // null: Tutti, oppure "async", "sync"
  String? _filterGenere; // null: Tutti, oppure "M", "F"
  String? _filterProgresso; // null: Tutti, oppure "100", ">50", "<50"
  DateTime? _filterDataDa;
  DateTime? _filterDataA;

  StreamSubscription<void>? _statMdlSub;

  @override
  void initState() {
    super.initState();
    _loadData();
    final isar = ref.read(isarProvider);
    _statMdlSub = isar.statMdls.watchLazy().listen((_) {
      _loadData();
    });
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _statMdlSub?.cancel();
    _searchController.dispose();
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final isar = ref.read(isarProvider);
    List<StatMdl> rawStats = [];
    Map<int, User> usersMap = {};

    try {
      rawStats = await isar.statMdls.where().findAll();
      final usersList = await isar.users.where().findAll();
      for (final u in usersList) {
        usersMap[u.id] = u;
      }
    } catch (e) {
      debugPrint('[UserCourseStatsView] Errore lettura Isar: $e');
    }

    // Raggruppamento per (userId, idCorso)
    final Map<String, List<StatMdl>> groupsMap = {};
    for (final stat in rawStats) {
      final key = '${stat.userId ?? 0}_${stat.idCorso ?? 0}';
      groupsMap.putIfAbsent(key, () => []).add(stat);
    }

    final List<UserCourseStatGroup> groups = [];
    groupsMap.forEach((key, list) {
      if (list.isEmpty) return;
      final first = list.first;
      final matchedUser = first.userId != null ? usersMap[first.userId!] : null;

      final fullName = (first.fullName.isNotEmpty)
          ? first.fullName
          : (matchedUser?.fullname ?? first.username ?? '-');

      final email = first.email ?? matchedUser?.email;

      String? userGender = first.gender;
      if (userGender == null || userGender.trim().isEmpty) {
        if (matchedUser?.customfields != null) {
          for (final f in matchedUser!.customfields!) {
            final sname = (f.shortname ?? '').toLowerCase();
            final name = (f.name ?? '').toLowerCase();
            if (sname == 'gender' || sname == 'sesso' || sname == 'genere' || name == 'gender' || name == 'sesso' || name == 'genere') {
              userGender = f.value ?? f.displayvalue;
              break;
            }
          }
        }
      }

      groups.add(UserCourseStatGroup(
        userId: first.userId,
        username: first.username ?? matchedUser?.username,
        fullName: fullName,
        email: email,
        idCorso: first.idCorso,
        shorthNomeCorso: first.shorthNomeCorso,
        nomeCorso: first.nomeCorso,
        statoCompletamentoCorso: first.statoCompletamentoCorso,
        dataCompletamentoCorso: first.dataCompletamentoCorso,
        primoAccessoPiattaforma: first.primoAccessoPiattaforma,
        ultimoAccessoPiattaforma: first.ultimoAccessoPiattaforma,
        gender: userGender,
        dateOfBirthCnv: first.dateOfBirthCnv ?? first.dateOfBirth,
        qualification: first.qualification,
        membershipOrg: first.membershipOrg,
        userCourseLang: first.userCourseLang,
        activities: list,
      ));
    });

    if (mounted) {
      setState(() {
        _allGroups = groups;
        _isLoading = false;
        _applyFilter();
      });
    }
  }

  void _onSearchChanged() {
    setState(() {
      _applyFilter();
    });
  }

  int get _totalPages => (_filteredGroups.isEmpty) ? 1 : ((_filteredGroups.length - 1) ~/ _pageSize) + 1;

  List<UserCourseStatGroup> get _paginatedGroups {
    final start = _currentPage * _pageSize;
    if (start >= _filteredGroups.length) return [];
    final end = (start + _pageSize < _filteredGroups.length) ? start + _pageSize : _filteredGroups.length;
    return _filteredGroups.sublist(start, end);
  }

  void _applyFilter() {
    final q = _searchController.text.trim().toLowerCase();

    List<UserCourseStatGroup> results = _allGroups.where((group) {
      if (q.isNotEmpty) {
        final userIdStr = group.userId?.toString() ?? '';
        final usernameStr = group.username?.toLowerCase() ?? '';
        final nameStr = group.fullName.toLowerCase();
        final emailStr = group.email?.toLowerCase() ?? '';
        final courseIdStr = group.idCorso?.toString() ?? '';
        final courseCodeStr = group.shorthNomeCorso?.toLowerCase() ?? '';
        final courseNameStr = group.nomeCorso?.toLowerCase() ?? '';

        final matches = userIdStr.contains(q) ||
            usernameStr.contains(q) ||
            nameStr.contains(q) ||
            (group.gender?.toLowerCase() ?? '').contains(q) ||
            emailStr.contains(q) ||
            courseIdStr.contains(q) ||
            courseCodeStr.contains(q) ||
            courseNameStr.contains(q) ||
            group.courseType.toLowerCase().contains(q) ||
            (group.userCourseLang?.toLowerCase() ?? '').contains(q);

        if (!matches) return false;
      }

      // Filtro Stato Corso
      if (_filterStatoCorso != null) {
        final isCompleted = group.isCourseCompleted;
        if (_filterStatoCorso == 'Completato' && !isCompleted) return false;
        if (_filterStatoCorso == 'In corso' && isCompleted) return false;
      }

      // Filtro Tipo Corso (Async / Sync)
      if (_filterTipoCorso != null) {
        if (group.courseType != _filterTipoCorso) return false;
      }

      // Filtro Genere
      if (_filterGenere != null) {
        final g = (group.gender ?? '').trim().toUpperCase();
        if (_filterGenere == 'M' && g != 'M' && g != 'MASCHIO') return false;
        if (_filterGenere == 'F' && g != 'F' && g != 'FEMMINA') return false;
      }

      // Filtro Progresso Moduli
      if (_filterProgresso != null) {
        if (_filterProgresso == '100' && group.completionProgress < 1.0) return false;
        if (_filterProgresso == '>50' && group.completionProgress < 0.5) return false;
        if (_filterProgresso == '<50' && group.completionProgress >= 0.5) return false;
        if (_filterProgresso == '0' && group.completedActivities > 0) return false;
      }

      // Filtro Data Completamento Da
      if (_filterDataDa != null) {
        if (group.dataCompletamentoCorso == null || group.dataCompletamentoCorso!.isBefore(_filterDataDa!)) {
          return false;
        }
      }

      // Filtro Data Completamento A
      if (_filterDataA != null) {
        final endOfDay = DateTime(_filterDataA!.year, _filterDataA!.month, _filterDataA!.day, 23, 59, 59);
        if (group.dataCompletamentoCorso == null || group.dataCompletamentoCorso!.isAfter(endOfDay)) {
          return false;
        }
      }

      return true;
    }).toList();

    _sortGroups(results);

    _filteredGroups = results;
    _currentPage = 0;
  }

  void _sortGroups(List<UserCourseStatGroup> list) {
    list.sort((a, b) {
      int cmp = 0;
      switch (_sortColumnIndex) {
        case 1:
          cmp = (a.userId ?? 0).compareTo(b.userId ?? 0);
          break;
        case 2:
          cmp = a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase());
          break;
        case 3:
          cmp = (a.gender ?? '').toLowerCase().compareTo((b.gender ?? '').toLowerCase());
          break;
        case 4:
          cmp = (a.nomeCorso ?? '').toLowerCase().compareTo(b.nomeCorso ?? '');
          break;
        case 5:
          cmp = a.courseType.compareTo(b.courseType);
          break;
        case 6:
          cmp = (a.userCourseLang ?? '').toLowerCase().compareTo((b.userCourseLang ?? '').toLowerCase());
          break;
        case 7:
          cmp = a.completionProgress.compareTo(b.completionProgress);
          break;
        case 8:
          cmp = (a.statoCompletamentoCorso ?? '').toLowerCase().compareTo(b.statoCompletamentoCorso ?? '');
          break;
        case 9:
          final da = a.dataCompletamentoCorso ?? DateTime.fromMillisecondsSinceEpoch(0);
          final db = b.dataCompletamentoCorso ?? DateTime.fromMillisecondsSinceEpoch(0);
          cmp = da.compareTo(db);
          break;
        default:
          cmp = (a.userId ?? 0).compareTo(b.userId ?? 0);
      }
      return _sortAscending ? cmp : -cmp;
    });
  }

  void _onSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      _sortGroups(_filteredGroups);
    });
  }

  int get _activeFiltersCount {
    int count = 0;
    if (_filterStatoCorso != null) count++;
    if (_filterTipoCorso != null) count++;
    if (_filterGenere != null) count++;
    if (_filterProgresso != null) count++;
    if (_filterDataDa != null) count++;
    if (_filterDataA != null) count++;
    return count;
  }

  void _resetAllFilters() {
    setState(() {
      _searchController.clear();
      _filterStatoCorso = null;
      _filterTipoCorso = null;
      _filterGenere = null;
      _filterProgresso = null;
      _filterDataDa = null;
      _filterDataA = null;
      _applyFilter();
    });
  }

  Future<void> _exportExcel() async {
    if (_isExporting) return;
    setState(() => _isExporting = true);
    try {
      final path = await UserCourseStatsExcelExporter.exportUserCourseStats(_filteredGroups);
      if (mounted && path != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(child: Text('Esportazione completata: $path')),
              ],
            ),
            backgroundColor: Colors.green.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore esportazione Excel: $e'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  void _showDetailModal(UserCourseStatGroup group) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
    final isCompleted = group.isCourseCompleted;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760, maxHeight: 820),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header Modale
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    gradient: LinearGradient(
                      colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white.withAlpha(30),
                        child: Text(
                          group.fullName.isNotEmpty ? group.fullName[0].toUpperCase() : '?',
                          style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              group.fullName,
                              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${group.email ?? '-'} • @${group.username ?? '-'} • ID: #${group.userId ?? '-'}${group.gender != null && group.gender!.trim().isNotEmpty ? ' • Genere: ${group.gender!.trim().toUpperCase()}' : ''}',
                              style: TextStyle(color: Colors.white.withAlpha(200), fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      if (group.gender != null && group.gender!.trim().isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(25),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.white.withAlpha(60)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                (group.gender!.trim().toUpperCase() == 'M' || group.gender!.toLowerCase() == 'maschio')
                                    ? Icons.male_rounded
                                    : ((group.gender!.trim().toUpperCase() == 'F' || group.gender!.toLowerCase() == 'femmina')
                                        ? Icons.female_rounded
                                        : Icons.person_outline_rounded),
                                color: Colors.white,
                                size: 15,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                'Genere: ${group.gender!.trim().toUpperCase()}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isCompleted ? Colors.green.withAlpha(50) : Colors.orange.withAlpha(50),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: isCompleted ? Colors.greenAccent : Colors.orangeAccent),
                        ),
                        child: Text(
                          isCompleted ? 'Corso Completato' : 'In Corso',
                          style: TextStyle(
                            color: isCompleted ? Colors.greenAccent : Colors.orangeAccent,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white70),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),

                // Contenuto
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card Dati Anagrafici Utente
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.person_rounded, color: AppTheme.primaryBlue, size: 20),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'PROFILO ANAGRAFICO',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.primaryBlue, letterSpacing: 0.5),
                                  ),
                                  const Spacer(),
                                  _buildGenderBadge(group.gender),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 24,
                                runSpacing: 10,
                                children: [
                                  _buildModalInfoItem('Genere', group.gender != null && group.gender!.trim().isNotEmpty ? (group.gender!.trim().toUpperCase() == 'M' ? 'Maschio (M)' : (group.gender!.trim().toUpperCase() == 'F' ? 'Femmina (F)' : group.gender!.trim())) : '-'),
                                  _buildModalInfoItem('Email', group.email ?? '-'),
                                  _buildModalInfoItem('Username', '@${group.username ?? '-'}'),
                                  if (group.dateOfBirthCnv != null && group.dateOfBirthCnv!.isNotEmpty)
                                    _buildModalInfoItem('Data di Nascita', group.dateOfBirthCnv!),
                                  if (group.qualification != null && group.qualification!.isNotEmpty)
                                    _buildModalInfoItem('Qualifica', group.qualification!),
                                  if (group.membershipOrg != null && group.membershipOrg!.isNotEmpty)
                                    _buildModalInfoItem('Organizzazione', group.membershipOrg!),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Card Info Corso e Progresso
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.school_rounded, color: AppTheme.primaryBlue, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      group.nomeCorso ?? 'Corso senza titolo',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.primaryBlue),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: group.isAsync ? const Color(0xFFEFF6FF) : const Color(0xFFF0FDF4),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: group.isAsync ? const Color(0xFFBFDBFE) : const Color(0xFFBBF7D0),
                                      ),
                                    ),
                                    child: Text(
                                      'TIPO: ${group.courseType.toUpperCase()}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: group.isAsync ? const Color(0xFF1D4ED8) : const Color(0xFF15803D),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'ID Corso: #${group.idCorso ?? '-'}',
                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blue.shade800),
                                    ),
                                  ),
                                  if (group.userCourseLang != null && group.userCourseLang!.trim().isNotEmpty) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF3E8FF),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: const Color(0xFFE9D5FF)),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.language_rounded, size: 12, color: Color(0xFF7E22CE)),
                                          const SizedBox(width: 4),
                                          Text(
                                            group.userCourseLang!.trim().toUpperCase(),
                                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF7E22CE)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('AVANZAMENTO MODULI', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
                                        const SizedBox(height: 6),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(6),
                                          child: LinearProgressIndicator(
                                            value: group.completionProgress,
                                            backgroundColor: Colors.grey.shade200,
                                            color: isCompleted ? Colors.green : AppTheme.primaryBlue,
                                            minHeight: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    '${group.completedActivities} / ${group.totalActivities} (${(group.completionProgress * 100).toInt()}%)',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.primaryBlue),
                                  ),
                                ],
                              ),
                              if (group.dataCompletamentoCorso != null) ...[
                                const SizedBox(height: 12),
                                Text(
                                  'Completato il: ${dateFormat.format(group.dataCompletamentoCorso!)}',
                                  style: TextStyle(fontSize: 12, color: Colors.green.shade800, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Tabella Singole Attività / Moduli Svolti
                        const Text(
                          'MODULI E ATTIVITÀ DEL CORSO',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue, letterSpacing: 0.8),
                        ),
                        const SizedBox(height: 10),

                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Table(
                              columnWidths: const {
                                0: FlexColumnWidth(1.2),
                                1: FlexColumnWidth(3.0),
                                2: FlexColumnWidth(2.0),
                                3: FlexColumnWidth(1.5),
                              },
                              children: [
                                TableRow(
                                  decoration: const BoxDecoration(color: Color(0xFFF1F5F9)),
                                  children: [
                                    _buildTableHeaderCell('TIPO'),
                                    _buildTableHeaderCell('ATTIVITÀ'),
                                    _buildTableHeaderCell('DATA COMPLETAMENTO'),
                                    _buildTableHeaderCell('STATO'),
                                  ],
                                ),
                                ...group.activities.map((act) {
                                  final isActDone = act.dataCompletamento != null;
                                  return TableRow(
                                    decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
                                    ),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              (act.tipoModulo ?? 'MOD').toUpperCase(),
                                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                                            ),
                                            if (act.ntag != null && act.ntag!.trim().isNotEmpty) ...[
                                              const SizedBox(height: 3),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFEFF6FF),
                                                  borderRadius: BorderRadius.circular(4),
                                                  border: Border.all(color: const Color(0xFFBFDBFE)),
                                                ),
                                                child: Text(
                                                  act.ntag!.trim(),
                                                  style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Color(0xFF1D4ED8)),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                        child: Text(
                                          act.nomeAttivita ?? '-',
                                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                        child: Text(
                                          act.dataCompletamento != null ? dateFormat.format(act.dataCompletamento!) : '-',
                                          style: TextStyle(fontSize: 12, color: isActDone ? Colors.grey.shade800 : Colors.grey.shade400),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                        child: Row(
                                          children: [
                                            Icon(
                                              isActDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                                              size: 14,
                                              color: isActDone ? Colors.green : Colors.grey,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              isActDone ? 'Fatto' : 'Non fatto',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: isActDone ? Colors.green.shade800 : Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTableHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF334155), letterSpacing: 0.5),
      ),
    );
  }

  Widget _buildGenderBadge(String? gender) {
    if (gender == null || gender.trim().isEmpty || gender.trim() == '-') {
      return Text('-', style: TextStyle(color: Colors.grey.shade400, fontSize: 13));
    }
    final g = gender.trim().toUpperCase();
    final isMale = g == 'M' || g == 'MASCHIO';
    final isFemale = g == 'F' || g == 'FEMMINA';

    final bgColor = isMale
        ? const Color(0xFFEFF6FF)
        : (isFemale ? const Color(0xFFFDF2F8) : const Color(0xFFF1F5F9));
    final borderColor = isMale
        ? const Color(0xFFBFDBFE)
        : (isFemale ? const Color(0xFFFBCFE8) : Colors.grey.shade300);
    final textColor = isMale
        ? const Color(0xFF1D4ED8)
        : (isFemale ? const Color(0xFFBE185D) : const Color(0xFF475569));
    final icon = isMale
        ? Icons.male_rounded
        : (isFemale ? Icons.female_rounded : Icons.person_outline_rounded);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: textColor),
          const SizedBox(width: 4),
          Text(
            isMale ? 'M' : (isFemale ? 'F' : g),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModalInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade500),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      floatingActionButton: _isAdvancedFiltersOpen
          ? null
          : Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: FloatingActionButton(
                shape: const CircleBorder(),
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
                tooltip: 'Esporta tabella aggregata in Excel (.xlsx)',
                onPressed: _isExporting ? null : _exportExcel,
                child: _isExporting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Icon(Icons.table_view_rounded),
              ),
            ),
      body: Row(
        children: [
          // Vista Principale
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Barra di Ricerca e Pulsante Filtri
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Cerca per nome utente, username, email, ID o nome corso...',
                            prefixIcon: const Icon(Icons.search, size: 20, color: AppTheme.primaryBlue),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 18),
                                    onPressed: () => _searchController.clear(),
                                  )
                                : null,
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade200),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: AppTheme.primaryBlue, width: 1.5),
                            ),
                          ),
                        ),
                      ),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 200),
                        child: !_isAdvancedFiltersOpen
                            ? Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Badge(
                                  isLabelVisible: _activeFiltersCount > 0,
                                  label: Text('$_activeFiltersCount'),
                                  backgroundColor: AppTheme.accentRed,
                                  child: OutlinedButton.icon(
                                    onPressed: () => setState(() => _isAdvancedFiltersOpen = true),
                                    icon: const Icon(Icons.filter_list_rounded, size: 18),
                                    label: const Text('Filtri Avanzati'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppTheme.primaryBlue,
                                      side: BorderSide(
                                        color: _activeFiltersCount > 0 ? AppTheme.primaryBlue : Colors.grey.shade300,
                                      ),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),

                  // Chips Filtri Attivi
                  if (_activeFiltersCount > 0 || _searchController.text.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (_searchController.text.isNotEmpty)
                          InputChip(
                            label: Text('Ricerca: "${_searchController.text}"'),
                            onDeleted: () => _searchController.clear(),
                            deleteIconColor: Colors.grey.shade700,
                            backgroundColor: Colors.white,
                          ),
                        if (_filterStatoCorso != null)
                          InputChip(
                            label: Text('Stato Corso: $_filterStatoCorso'),
                            onDeleted: () {
                              setState(() {
                                _filterStatoCorso = null;
                                _applyFilter();
                              });
                            },
                            deleteIconColor: Colors.grey.shade700,
                            backgroundColor: Colors.white,
                          ),
                        if (_filterTipoCorso != null)
                          InputChip(
                            label: Text('Tipo Corso: ${_filterTipoCorso!.toUpperCase()}'),
                            onDeleted: () {
                              setState(() {
                                _filterTipoCorso = null;
                                _applyFilter();
                              });
                            },
                            deleteIconColor: Colors.grey.shade700,
                            backgroundColor: Colors.white,
                          ),
                        if (_filterGenere != null)
                          InputChip(
                            label: Text('Genere: ${_filterGenere == 'M' ? 'Maschio (M)' : 'Femmina (F)'}'),
                            onDeleted: () {
                              setState(() {
                                _filterGenere = null;
                                _applyFilter();
                              });
                            },
                            deleteIconColor: Colors.grey.shade700,
                            backgroundColor: Colors.white,
                          ),
                        if (_filterProgresso != null)
                          InputChip(
                            label: Text('Progresso: $_filterProgresso%'),
                            onDeleted: () {
                              setState(() {
                                _filterProgresso = null;
                                _applyFilter();
                              });
                            },
                            deleteIconColor: Colors.grey.shade700,
                            backgroundColor: Colors.white,
                          ),
                        if (_filterDataDa != null)
                          InputChip(
                            label: Text('Da: ${DateFormat('dd/MM/yyyy').format(_filterDataDa!)}'),
                            onDeleted: () {
                              setState(() {
                                _filterDataDa = null;
                                _applyFilter();
                              });
                            },
                            deleteIconColor: Colors.grey.shade700,
                            backgroundColor: Colors.white,
                          ),
                        if (_filterDataA != null)
                          InputChip(
                            label: Text('A: ${DateFormat('dd/MM/yyyy').format(_filterDataA!)}'),
                            onDeleted: () {
                              setState(() {
                                _filterDataA = null;
                                _applyFilter();
                              });
                            },
                            deleteIconColor: Colors.grey.shade700,
                            backgroundColor: Colors.white,
                          ),
                        if (_activeFiltersCount > 1 || (_activeFiltersCount >= 1 && _searchController.text.isNotEmpty))
                          ActionChip(
                            avatar: const Icon(Icons.delete_sweep_outlined, size: 16, color: Colors.red),
                            label: const Text('Cancella tutti', style: TextStyle(color: Colors.red, fontSize: 12)),
                            onPressed: _resetAllFilters,
                            backgroundColor: Colors.red.shade50,
                            side: BorderSide(color: Colors.red.shade200),
                          ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 14),

                  // Tabella Dati Enterprise
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(5),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : _filteredGroups.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.person_search_outlined, size: 54, color: Colors.grey.shade400),
                                        const SizedBox(height: 14),
                                        Text(
                                          'Nessun record aggregato trovato',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          'Verifica i filtri o sincronizza le statistiche da Impostazioni -> Sync.',
                                          style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                                        ),
                                      ],
                                    ),
                                  )
                                : Scrollbar(
                                    controller: _verticalScrollController,
                                    thumbVisibility: true,
                                    child: SingleChildScrollView(
                                      controller: _verticalScrollController,
                                      scrollDirection: Axis.vertical,
                                      child: Scrollbar(
                                        controller: _horizontalScrollController,
                                        thumbVisibility: true,
                                        child: SingleChildScrollView(
                                          controller: _horizontalScrollController,
                                          scrollDirection: Axis.horizontal,
                                          child: DataTable(
                                            sortColumnIndex: _sortColumnIndex,
                                            sortAscending: _sortAscending,
                                            headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                                            dataRowMinHeight: 64,
                                            dataRowMaxHeight: double.infinity,
                                            dividerThickness: 1,
                                            horizontalMargin: 20,
                                            columnSpacing: 24,
                                            columns: [
                                              const DataColumn(label: Text('AZIONI')),
                                              DataColumn(
                                                label: const Text('ID UTENTE'),
                                                onSort: _onSort,
                                              ),
                                              DataColumn(
                                                label: const Text('UTENTE'),
                                                onSort: _onSort,
                                              ),
                                              DataColumn(
                                                label: const Text('GENERE'),
                                                onSort: _onSort,
                                              ),
                                              DataColumn(
                                                label: const Text('CORSO & MODULI'),
                                                onSort: _onSort,
                                              ),
                                              DataColumn(
                                                label: const Text('TIPO CORSO'),
                                                onSort: _onSort,
                                              ),
                                              DataColumn(
                                                label: const Text('LINGUA'),
                                                onSort: _onSort,
                                              ),
                                              DataColumn(
                                                label: const Text('PROGRESSO MODULI'),
                                                onSort: _onSort,
                                              ),
                                              DataColumn(
                                                label: const Text('STATO CORSO'),
                                                onSort: _onSort,
                                              ),
                                              DataColumn(
                                                label: const Text('DATA COMPLETAMENTO'),
                                                onSort: _onSort,
                                              ),
                                            ],
                                            rows: _paginatedGroups.map((group) {
                                              final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
                                              final isCompleted = group.isCourseCompleted;

                                              return DataRow(
                                                cells: [
                                                  // Azioni
                                                  DataCell(
                                                    IconButton(
                                                      icon: const Icon(Icons.visibility_outlined, size: 20, color: AppTheme.primaryBlue),
                                                      tooltip: 'Dettagli Attività',
                                                      onPressed: () => _showDetailModal(group),
                                                    ),
                                                  ),
                                                  // ID Utente Badge
                                                  DataCell(
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: const Color(0xFFF1F5F9),
                                                        borderRadius: BorderRadius.circular(6),
                                                      ),
                                                      child: Text(
                                                        '#${group.userId ?? '-'}',
                                                        style: const TextStyle(
                                                          fontFamily: 'monospace',
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.bold,
                                                          color: Color(0xFF334155),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  // Utente
                                                  DataCell(
                                                    Row(
                                                      children: [
                                                        CircleAvatar(
                                                          radius: 16,
                                                          backgroundColor: AppTheme.primaryBlue.withAlpha(20),
                                                          child: Text(
                                                            group.fullName.isNotEmpty ? group.fullName[0].toUpperCase() : '?',
                                                            style: const TextStyle(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.bold,
                                                              color: AppTheme.primaryBlue,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(width: 10),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              group.fullName,
                                                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                                            ),
                                                            Text(
                                                              group.email ?? '@${group.username ?? '-'}',
                                                              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  // Genere
                                                  DataCell(
                                                    Center(
                                                      child: _buildGenderBadge(group.gender),
                                                    ),
                                                  ),
                                                  // Corso & Moduli
                                                  DataCell(
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                                      child: ConstrainedBox(
                                                        constraints: const BoxConstraints(maxWidth: 440),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            // Nome Corso
                                                            Text(
                                                              group.nomeCorso ?? '-',
                                                              style: const TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 13,
                                                                color: Color(0xFF0F172A),
                                                              ),
                                                            ),
                                                            const SizedBox(height: 2),
                                                            Text(
                                                              'Codice: ${group.shorthNomeCorso ?? '-'} (ID: ${group.idCorso ?? '-'})',
                                                              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                                                            ),
                                                            // Sotto-lista Moduli del corso per l'utente
                                                            if (group.activities.isNotEmpty) ...[
                                                              const SizedBox(height: 6),
                                                              Container(
                                                                padding: const EdgeInsets.all(8),
                                                                decoration: BoxDecoration(
                                                                  color: const Color(0xFFF8FAFC),
                                                                  borderRadius: BorderRadius.circular(8),
                                                                  border: Border.all(color: Colors.grey.shade200),
                                                                ),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: group.activities.map((act) {
                                                                    final isActDone = act.dataCompletamento != null;
                                                                    return Padding(
                                                                      padding: const EdgeInsets.symmetric(vertical: 2.5),
                                                                      child: Row(
                                                                        children: [
                                                                          Icon(
                                                                            isActDone
                                                                                ? Icons.check_circle_rounded
                                                                                : Icons.radio_button_unchecked,
                                                                            size: 13,
                                                                            color: isActDone
                                                                                ? Colors.green.shade600
                                                                                : Colors.grey.shade400,
                                                                          ),
                                                                          const SizedBox(width: 6),
                                                                          Container(
                                                                            padding: const EdgeInsets.symmetric(
                                                                              horizontal: 5,
                                                                              vertical: 1,
                                                                            ),
                                                                            decoration: BoxDecoration(
                                                                              color: Colors.white,
                                                                              borderRadius: BorderRadius.circular(4),
                                                                              border: Border.all(color: Colors.grey.shade300),
                                                                            ),
                                                                            child: Text(
                                                                              (act.tipoModulo ?? 'MOD').toUpperCase(),
                                                                              style: TextStyle(
                                                                                fontSize: 9,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.blueGrey.shade800,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          if (act.ntag != null && act.ntag!.trim().isNotEmpty) ...[
                                                                            const SizedBox(width: 4),
                                                                            Container(
                                                                              padding: const EdgeInsets.symmetric(
                                                                                horizontal: 5,
                                                                                vertical: 1,
                                                                              ),
                                                                              decoration: BoxDecoration(
                                                                                color: const Color(0xFFEFF6FF),
                                                                                borderRadius: BorderRadius.circular(4),
                                                                                border: Border.all(color: const Color(0xFFBFDBFE)),
                                                                              ),
                                                                              child: Text(
                                                                                act.ntag!.trim(),
                                                                                style: const TextStyle(
                                                                                  fontSize: 9,
                                                                                  fontWeight: FontWeight.w600,
                                                                                  color: Color(0xFF1D4ED8),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                          const SizedBox(width: 6),
                                                                          Expanded(
                                                                            child: Text(
                                                                              act.nomeAttivita ?? '-',
                                                                              style: TextStyle(
                                                                                fontSize: 11,
                                                                                fontWeight: FontWeight.w500,
                                                                                color: isActDone
                                                                                    ? const Color(0xFF1E293B)
                                                                                    : Colors.grey.shade600,
                                                                              ),
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                          ),
                                                                          if (isActDone && act.dataCompletamento != null) ...[
                                                                            const SizedBox(width: 6),
                                                                            Text(
                                                                              DateFormat('dd/MM/yy HH:mm').format(act.dataCompletamento!),
                                                                              style: TextStyle(
                                                                                fontSize: 10,
                                                                                color: Colors.green.shade800,
                                                                                fontWeight: FontWeight.w500,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ],
                                                                      ),
                                                                    );
                                                                  }).toList(),
                                                                ),
                                                              ),
                                                            ],
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  // Tipo Corso (Async / Sync)
                                                  DataCell(
                                                    Center(
                                                      child: Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                        decoration: BoxDecoration(
                                                          color: group.isAsync ? const Color(0xFFEFF6FF) : const Color(0xFFF0FDF4),
                                                          borderRadius: BorderRadius.circular(12),
                                                          border: Border.all(
                                                            color: group.isAsync ? const Color(0xFFBFDBFE) : const Color(0xFFBBF7D0),
                                                          ),
                                                        ),
                                                        child: Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Icon(
                                                              group.isAsync ? Icons.play_circle_outline_rounded : Icons.groups_rounded,
                                                              size: 13,
                                                              color: group.isAsync ? const Color(0xFF1D4ED8) : const Color(0xFF15803D),
                                                            ),
                                                            const SizedBox(width: 5),
                                                            Text(
                                                              group.courseType.toUpperCase(),
                                                              style: TextStyle(
                                                                fontSize: 11,
                                                                fontWeight: FontWeight.bold,
                                                                letterSpacing: 0.5,
                                                                color: group.isAsync ? const Color(0xFF1D4ED8) : const Color(0xFF15803D),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  // Lingua (user_course_lang)
                                                  DataCell(
                                                    Center(
                                                      child: Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                        decoration: BoxDecoration(
                                                          color: const Color(0xFFF3E8FF),
                                                          borderRadius: BorderRadius.circular(8),
                                                          border: Border.all(color: const Color(0xFFE9D5FF)),
                                                        ),
                                                        child: Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            const Icon(
                                                              Icons.language_rounded,
                                                              size: 12,
                                                              color: Color(0xFF7E22CE),
                                                            ),
                                                            const SizedBox(width: 4),
                                                            Text(
                                                              (group.userCourseLang == null || group.userCourseLang!.trim().isEmpty)
                                                                  ? '-'
                                                                  : group.userCourseLang!.trim().toUpperCase(),
                                                              style: const TextStyle(
                                                                fontSize: 11,
                                                                fontWeight: FontWeight.bold,
                                                                color: Color(0xFF7E22CE),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  // Progresso Moduli
                                                  DataCell(
                                                    ConstrainedBox(
                                                      constraints: const BoxConstraints(maxWidth: 160),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(
                                                                '${group.completedActivities}/${group.totalActivities} fatti',
                                                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                                              ),
                                                              Text(
                                                                '${(group.completionProgress * 100).toInt()}%',
                                                                style: TextStyle(
                                                                  fontSize: 11,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: isCompleted ? Colors.green.shade700 : AppTheme.primaryBlue,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(height: 4),
                                                          ClipRRect(
                                                            borderRadius: BorderRadius.circular(3),
                                                            child: LinearProgressIndicator(
                                                              value: group.completionProgress,
                                                              backgroundColor: Colors.grey.shade200,
                                                              color: isCompleted ? Colors.green : AppTheme.primaryBlue,
                                                              minHeight: 5,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  // Stato Corso Pill
                                                  DataCell(
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: isCompleted ? Colors.green.shade50 : Colors.orange.shade50,
                                                        borderRadius: BorderRadius.circular(12),
                                                        border: Border.all(
                                                          color: isCompleted ? Colors.green.shade200 : Colors.orange.shade200,
                                                        ),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Icon(
                                                            Icons.circle,
                                                            size: 7,
                                                            color: isCompleted ? Colors.green.shade700 : Colors.orange.shade700,
                                                          ),
                                                          const SizedBox(width: 6),
                                                          Text(
                                                            isCompleted ? 'Completato' : 'In corso',
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              fontWeight: FontWeight.bold,
                                                              color: isCompleted ? Colors.green.shade800 : Colors.orange.shade800,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  // Data Completamento Corso
                                                  DataCell(
                                                    Text(
                                                      group.dataCompletamentoCorso != null
                                                          ? dateFormat.format(group.dataCompletamentoCorso!)
                                                          : '-',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: group.dataCompletamentoCorso != null
                                                            ? Colors.grey.shade800
                                                            : Colors.grey.shade400,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Footer Responsive con Paginazione
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isNarrow = constraints.maxWidth < 560;

                      final countText = Text(
                        _filteredGroups.length == _allGroups.length
                            ? 'Mostrati ${_filteredGroups.isEmpty ? 0 : (_currentPage * _pageSize) + 1} - ${math.min((_currentPage + 1) * _pageSize, _filteredGroups.length)} di ${_allGroups.length} record'
                            : 'Mostrati ${_filteredGroups.isEmpty ? 0 : (_currentPage * _pageSize) + 1} - ${math.min((_currentPage + 1) * _pageSize, _filteredGroups.length)} di ${_filteredGroups.length} (filtrati da ${_allGroups.length} totali)',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                      );

                      final controls = Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.first_page_rounded),
                            onPressed: _currentPage > 0 ? () => setState(() => _currentPage = 0) : null,
                            tooltip: 'Prima pagina',
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_left_rounded),
                            onPressed: _currentPage > 0 ? () => setState(() => _currentPage--) : null,
                            tooltip: 'Pagina precedente',
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${_currentPage + 1} / $_totalPages',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.primaryBlue),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_right_rounded),
                            onPressed: _currentPage < _totalPages - 1 ? () => setState(() => _currentPage++) : null,
                            tooltip: 'Pagina successiva',
                          ),
                          IconButton(
                            icon: const Icon(Icons.last_page_rounded),
                            onPressed: _currentPage < _totalPages - 1 ? () => setState(() => _currentPage = _totalPages - 1) : null,
                            tooltip: 'Ultima pagina',
                          ),
                        ],
                      );

                      if (isNarrow) {
                        return Column(
                          children: [
                            countText,
                            const SizedBox(height: 8),
                            controls,
                          ],
                        );
                      }

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          countText,
                          controls,
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Drawer Laterale Filtri Avanzati
          AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            curve: Curves.fastOutSlowIn,
            width: _isAdvancedFiltersOpen ? 340 : 0,
            child: ClipRect(
              child: OverflowBox(
                minWidth: 0,
                maxWidth: 340,
                alignment: Alignment.topRight,
                child: Container(
                  width: 340,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(left: BorderSide(color: Colors.grey.shade200)),
                  ),
                  child: Column(
                    children: [
                      // Header Drawer
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.tune_rounded, color: Colors.white, size: 20),
                                const SizedBox(width: 10),
                                const Text(
                                  'Filtri Avanzati',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                if (_activeFiltersCount > 0) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppTheme.accentRed,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '$_activeFiltersCount',
                                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.white),
                              onPressed: () => setState(() => _isAdvancedFiltersOpen = false),
                              tooltip: 'Chiudi pannello filtri',
                            ),
                          ],
                        ),
                      ),

                      // Corpo Filtri
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Filtro Stato Corso
                              const Text('STATO CORSO', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 6,
                                children: [
                                  ChoiceChip(
                                    label: const Text('Tutti'),
                                    selected: _filterStatoCorso == null,
                                    onSelected: (val) {
                                      if (val) setState(() { _filterStatoCorso = null; _applyFilter(); });
                                    },
                                  ),
                                  ChoiceChip(
                                    label: const Text('Completato'),
                                    selected: _filterStatoCorso == 'Completato',
                                    onSelected: (val) {
                                      setState(() { _filterStatoCorso = val ? 'Completato' : null; _applyFilter(); });
                                    },
                                  ),
                                  ChoiceChip(
                                    label: const Text('In corso'),
                                    selected: _filterStatoCorso == 'In corso',
                                    onSelected: (val) {
                                      setState(() { _filterStatoCorso = val ? 'In corso' : null; _applyFilter(); });
                                    },
                                  ),
                                ],
                              ),

                              const Divider(height: 32),

                              // Filtro Tipo Corso (Async / Sync)
                              const Text('TIPO CORSO', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 6,
                                children: [
                                  ChoiceChip(
                                    label: const Text('Tutti'),
                                    selected: _filterTipoCorso == null,
                                    onSelected: (val) {
                                      if (val) setState(() { _filterTipoCorso = null; _applyFilter(); });
                                    },
                                  ),
                                  ChoiceChip(
                                    label: const Text('Async'),
                                    selected: _filterTipoCorso == 'async',
                                    onSelected: (val) {
                                      setState(() { _filterTipoCorso = val ? 'async' : null; _applyFilter(); });
                                    },
                                  ),
                                  ChoiceChip(
                                    label: const Text('Sync'),
                                    selected: _filterTipoCorso == 'sync',
                                    onSelected: (val) {
                                      setState(() { _filterTipoCorso = val ? 'sync' : null; _applyFilter(); });
                                    },
                                  ),
                                ],
                              ),

                              const Divider(height: 32),

                              // Filtro Genere
                              const Text('GENERE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 6,
                                children: [
                                  ChoiceChip(
                                    label: const Text('Tutti'),
                                    selected: _filterGenere == null,
                                    onSelected: (val) {
                                      if (val) setState(() { _filterGenere = null; _applyFilter(); });
                                    },
                                  ),
                                  ChoiceChip(
                                    label: const Text('Maschio (M)'),
                                    selected: _filterGenere == 'M',
                                    onSelected: (val) {
                                      setState(() { _filterGenere = val ? 'M' : null; _applyFilter(); });
                                    },
                                  ),
                                  ChoiceChip(
                                    label: const Text('Femmina (F)'),
                                    selected: _filterGenere == 'F',
                                    onSelected: (val) {
                                      setState(() { _filterGenere = val ? 'F' : null; _applyFilter(); });
                                    },
                                  ),
                                ],
                              ),

                              const Divider(height: 32),

                              // Filtro Progresso Moduli
                              const Text('PROGRESSO MODULI', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 6,
                                children: [
                                  ChoiceChip(
                                    label: const Text('Tutti'),
                                    selected: _filterProgresso == null,
                                    onSelected: (val) {
                                      if (val) setState(() { _filterProgresso = null; _applyFilter(); });
                                    },
                                  ),
                                  ChoiceChip(
                                    label: const Text('100% Fatti'),
                                    selected: _filterProgresso == '100',
                                    onSelected: (val) {
                                      setState(() { _filterProgresso = val ? '100' : null; _applyFilter(); });
                                    },
                                  ),
                                  ChoiceChip(
                                    label: const Text('≥ 50%'),
                                    selected: _filterProgresso == '>50',
                                    onSelected: (val) {
                                      setState(() { _filterProgresso = val ? '>50' : null; _applyFilter(); });
                                    },
                                  ),
                                  ChoiceChip(
                                    label: const Text('< 50%'),
                                    selected: _filterProgresso == '<50',
                                    onSelected: (val) {
                                      setState(() { _filterProgresso = val ? '<50' : null; _applyFilter(); });
                                    },
                                  ),
                                ],
                              ),

                              const Divider(height: 32),

                              // Filtro Data Completamento Corso
                              const Text('DATA COMPLETAMENTO CORSO', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      icon: const Icon(Icons.date_range, size: 16),
                                      label: Text(
                                        _filterDataDa != null ? DateFormat('dd/MM/yy').format(_filterDataDa!) : 'Da',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      onPressed: () async {
                                        final picked = await showDatePicker(
                                          context: context,
                                          initialDate: _filterDataDa ?? DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2035),
                                        );
                                        if (picked != null) {
                                          setState(() { _filterDataDa = picked; _applyFilter(); });
                                        }
                                      },
                                    ),
                                  ),
                                  if (_filterDataDa != null)
                                    IconButton(
                                      icon: const Icon(Icons.clear, size: 16),
                                      onPressed: () => setState(() { _filterDataDa = null; _applyFilter(); }),
                                    ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      icon: const Icon(Icons.date_range, size: 16),
                                      label: Text(
                                        _filterDataA != null ? DateFormat('dd/MM/yy').format(_filterDataA!) : 'A',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      onPressed: () async {
                                        final picked = await showDatePicker(
                                          context: context,
                                          initialDate: _filterDataA ?? DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2035),
                                        );
                                        if (picked != null) {
                                          setState(() { _filterDataA = picked; _applyFilter(); });
                                        }
                                      },
                                    ),
                                  ),
                                  if (_filterDataA != null)
                                    IconButton(
                                      icon: const Icon(Icons.clear, size: 16),
                                      onPressed: () => setState(() { _filterDataA = null; _applyFilter(); }),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Footer Drawer
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          border: Border(top: BorderSide(color: Colors.grey.shade200)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _activeFiltersCount > 0 ? _resetAllFilters : null,
                                child: const Text('Azzera Filtri'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryBlue,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () => setState(() => _isAdvancedFiltersOpen = false),
                                child: const Text('Chiudi'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
