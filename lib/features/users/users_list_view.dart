import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:isar_community/isar.dart';
import '../../core/db/isar_provider.dart';
import '../../core/theme/app_theme.dart';
import '../sync/models/user.dart';
import 'services/user_excel_exporter.dart';

class UsersListView extends ConsumerStatefulWidget {
  const UsersListView({super.key});

  @override
  ConsumerState<UsersListView> createState() => _UsersListViewState();
}

class _UsersListViewState extends ConsumerState<UsersListView> {
  final _searchController = TextEditingController();
  final _horizontalScrollController = ScrollController();
  final _verticalScrollController = ScrollController();
  List<User> _allUsers = [];
  List<User> _filteredUsers = [];
  bool _isLoading = true;
  StreamSubscription<void>? _usersSub;

  @override
  void initState() {
    super.initState();
    _loadUsers();
    final isar = ref.read(isarProvider);
    _usersSub = isar.users.watchLazy().listen((_) {
      _loadUsers();
    });
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _usersSub?.cancel();
    _searchController.dispose();
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    final isar = ref.read(isarProvider);
    List<User> users;
    try {
      users = await isar.users.where().findAll();
    } catch (e) {
      debugPrint('[UsersListView] Errore lettura Isar (disallineamento schema): $e');
      try {
        await isar.writeTxn(() async => await isar.users.clear());
      } catch (_) {}
      users = [];
    }
    if (mounted) {
      setState(() {
        _allUsers = users;
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

  int? _sortColumnIndex;
  bool _sortAscending = true;
  int _currentPage = 0;
  static const int _pageSize = 50;

  // Stato Filtri Avanzati
  bool _isAdvancedFiltersOpen = false;
  bool? _filterActive;
  bool? _filterConfirmed;
  final Set<String> _selectedOrgs = {};
  final Set<String> _selectedCourseLangs = {};
  final Set<String> _selectedEditions = {};
  final Set<String> _selectedGenders = {};
  final Set<String> _selectedQualPartnerRefs = {};
  DateTime? _dobFrom;
  DateTime? _dobTo;

  int get _activeFiltersCount {
    int count = 0;
    if (_filterActive != null) count++;
    if (_filterConfirmed != null) count++;
    if (_selectedOrgs.isNotEmpty) count++;
    if (_selectedCourseLangs.isNotEmpty) count++;
    if (_selectedEditions.isNotEmpty) count++;
    if (_selectedGenders.isNotEmpty) count++;
    if (_selectedQualPartnerRefs.isNotEmpty) count++;
    if (_dobFrom != null || _dobTo != null) count++;
    return count;
  }

  bool _isExporting = false;

  Future<void> _exportToExcel() async {
    if (_filteredUsers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nessun utente disponibile per l\'esportazione.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isExporting = true);
    try {
      final resultPath = await UserExcelExporter.exportUsers(_filteredUsers);
      if (mounted) {
        if (resultPath != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text('Esportati con successo ${_filteredUsers.length} utenti in Excel!'),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFF107C41),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore durante l\'esportazione: $e'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  void _resetAdvancedFilters() {
    setState(() {
      _filterActive = null;
      _filterConfirmed = null;
      _selectedOrgs.clear();
      _selectedCourseLangs.clear();
      _selectedEditions.clear();
      _selectedGenders.clear();
      _selectedQualPartnerRefs.clear();
      _dobFrom = null;
      _dobTo = null;
      _applyFilter();
    });
  }

  String? _getCustomFieldValue(User u, List<String> keywords) {
    if (u.customfields == null) return null;
    for (final cf in u.customfields!) {
      final name = (cf.name ?? '').toLowerCase();
      final shortname = (cf.shortname ?? '').toLowerCase();
      for (final kw in keywords) {
        if (name.contains(kw) || shortname.contains(kw)) {
          final val = cf.displayvalue?.trim().isNotEmpty == true
              ? cf.displayvalue
              : cf.value?.trim().isNotEmpty == true
                  ? cf.value
                  : null;
          if (val != null) return val;
        }
      }
    }
    return null;
  }

  int get _totalPages => (_filteredUsers.isEmpty) ? 1 : ((_filteredUsers.length - 1) ~/ _pageSize) + 1;

  List<User> get _paginatedUsers {
    final start = _currentPage * _pageSize;
    if (start >= _filteredUsers.length) return [];
    final end = (start + _pageSize < _filteredUsers.length) ? start + _pageSize : _filteredUsers.length;
    return _filteredUsers.sublist(start, end);
  }

  void _applyFilter() {
    final query = _searchController.text.trim().toLowerCase();
    _filteredUsers = _allUsers.where((u) {
      // 1. Ricerca generale
      if (query.isNotEmpty) {
        final username = (u.username ?? '').toLowerCase();
        final fullname = (u.fullname ?? '').toLowerCase();
        final firstname = (u.firstname ?? '').toLowerCase();
        final lastname = (u.lastname ?? '').toLowerCase();
        final email = (u.email ?? '').toLowerCase();
        final dept = (u.department ?? '').toLowerCase();
        final idStr = '${u.id}';

        bool matchesDob = false;
        if (u.effectiveDob != null) {
          final dob = u.effectiveDob!;
          final fmtIt = DateFormat('dd/MM/yyyy').format(dob);
          final fmtIso = DateFormat('yyyy-MM-dd').format(dob);
          matchesDob = fmtIt.contains(query) ||
              fmtIso.contains(query) ||
              dob.year.toString().contains(query);
        }

        final matchesQuery = username.contains(query) ||
            fullname.contains(query) ||
            firstname.contains(query) ||
            lastname.contains(query) ||
            email.contains(query) ||
            dept.contains(query) ||
            idStr.contains(query) ||
            matchesDob;
        if (!matchesQuery) return false;
      }

      // 2. Account Attivo (Attivo / Sospeso)
      if (_filterActive != null) {
        final isActive = u.suspended != true;
        if (isActive != _filterActive) return false;
      }

      // 3. Account Confermato (Confermato / Non Confermato)
      if (_filterConfirmed != null) {
        final isConfirmed = u.confirmed == true;
        if (isConfirmed != _filterConfirmed) return false;
      }

      // 4. Membership Organization (Multi-select)
      if (_selectedOrgs.isNotEmpty) {
        final val = _getCustomFieldValue(u, ['membership', 'organization', 'organizzaz'])?.toLowerCase() ?? '';
        final matches = _selectedOrgs.any((org) => val.contains(org.trim().toLowerCase()));
        if (!matches) return false;
      }

      // 3. User's pref. course Lang (Multi-select)
      if (_selectedCourseLangs.isNotEmpty) {
        final val = _getCustomFieldValue(u, ['course lang', 'course_lang', 'prefcourselang', 'pref_course_lang', 'lang'])?.toLowerCase() ?? '';
        final userLang = (u.lang ?? '').toLowerCase();
        final matches = _selectedCourseLangs.any((lang) {
          final target = lang.trim().toLowerCase();
          return val.contains(target) || userLang.contains(target);
        });
        if (!matches) return false;
      }

      // 4. Edition (Multi-select)
      if (_selectedEditions.isNotEmpty) {
        final val = _getCustomFieldValue(u, ['edition', 'edizione'])?.toLowerCase() ?? '';
        final matches = _selectedEditions.any((ed) => val.contains(ed.trim().toLowerCase()));
        if (!matches) return false;
      }

      // 5. Gender (Multi-select)
      if (_selectedGenders.isNotEmpty) {
        final val = _getCustomFieldValue(u, ['gender', 'sesso', 'genere'])?.toLowerCase() ?? '';
        final matches = _selectedGenders.any((g) => val.contains(g.trim().toLowerCase()));
        if (!matches) return false;
      }

      // 6. Qualification Partener Reference (Multi-select)
      if (_selectedQualPartnerRefs.isNotEmpty) {
        final val = _getCustomFieldValue(u, ['qualification', 'partener', 'partner'])?.toLowerCase() ?? '';
        final matches = _selectedQualPartnerRefs.any((q) => val.contains(q.trim().toLowerCase()));
        if (!matches) return false;
      }

      // 7. Date Of Birth (Da - A)
      if (_dobFrom != null || _dobTo != null) {
        final parsed = u.effectiveDob;
        if (parsed == null) return false;
        if (_dobFrom != null && parsed.isBefore(_dobFrom!)) return false;
        if (_dobTo != null && parsed.isAfter(_dobTo!.add(const Duration(days: 1)))) return false;
      }

      return true;
    }).toList();

    _currentPage = 0;
    _applySorting();
  }

  Widget _buildUserAvatar(User user, {double radius = 17, bool isDialog = false}) {
    final url = (user.profileimageurl?.trim().isNotEmpty == true)
        ? user.profileimageurl!.trim()
        : (user.profileimageurlsmall?.trim().isNotEmpty == true
            ? user.profileimageurlsmall!.trim()
            : null);

    final initials = ((user.firstname?.isNotEmpty == true ? user.firstname![0] : '') +
            (user.lastname?.isNotEmpty == true ? user.lastname![0] : ''))
        .toUpperCase();
    final fallbackText = initials.isNotEmpty
        ? initials
        : (user.username?.isNotEmpty == true ? user.username![0].toUpperCase() : 'U');

    final fallbackWidget = Container(
      width: radius * 2,
      height: radius * 2,
      color: isDialog ? const Color(0xFF1A365D) : AppTheme.primaryBlue.withAlpha(22),
      alignment: Alignment.center,
      child: Text(
        fallbackText,
        style: TextStyle(
          fontSize: radius * 0.72,
          fontWeight: FontWeight.bold,
          color: isDialog ? Colors.white : AppTheme.primaryBlue,
        ),
      ),
    );

    final hasValidUrl = url != null && (url.startsWith('http://') || url.startsWith('https://'));

    final imageWidget = hasValidUrl
        ? Image.network(
            url,
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => fallbackWidget,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: SizedBox(
                  width: radius * 0.9,
                  height: radius * 0.9,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            },
          )
        : fallbackWidget;

    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isDialog ? Colors.white.withAlpha(120) : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: ClipOval(
        child: imageWidget,
      ),
    );
  }

  void _applySorting() {
    if (_sortColumnIndex == null) return;
    switch (_sortColumnIndex) {
      case 2:
        _filteredUsers.sort((a, b) => _sortAscending ? a.id.compareTo(b.id) : b.id.compareTo(a.id));
        break;
      case 3:
        _filteredUsers.sort((a, b) {
          final aV = (a.fullname ?? '${a.firstname ?? ""} ${a.lastname ?? ""}').trim().toLowerCase();
          final bV = (b.fullname ?? '${b.firstname ?? ""} ${b.lastname ?? ""}').trim().toLowerCase();
          return _sortAscending ? aV.compareTo(bV) : bV.compareTo(aV);
        });
        break;
      case 4:
        _filteredUsers.sort((a, b) {
          final aV = a.email?.toLowerCase() ?? '';
          final bV = b.email?.toLowerCase() ?? '';
          return _sortAscending ? aV.compareTo(bV) : bV.compareTo(aV);
        });
        break;
      case 5:
        _filteredUsers.sort((a, b) {
          final aV = a.department?.toLowerCase() ?? '';
          final bV = b.department?.toLowerCase() ?? '';
          return _sortAscending ? aV.compareTo(bV) : bV.compareTo(aV);
        });
        break;
      case 6:
        _filteredUsers.sort((a, b) {
          final aV = a.suspended == true ? 1 : 0;
          final bV = b.suspended == true ? 1 : 0;
          return _sortAscending ? aV.compareTo(bV) : bV.compareTo(aV);
        });
        break;
      case 7:
        _filteredUsers.sort((a, b) {
          final aV = a.confirmed == true ? 1 : 0;
          final bV = b.confirmed == true ? 1 : 0;
          return _sortAscending ? aV.compareTo(bV) : bV.compareTo(aV);
        });
        break;
      case 9:
        _filteredUsers.sort((a, b) {
          final aV = a.lastaccess ?? 0;
          final bV = b.lastaccess ?? 0;
          return _sortAscending ? aV.compareTo(bV) : bV.compareTo(aV);
        });
        break;
    }
  }

  void _onSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      _applySorting();
    });
  }

  void _showUserDetailDialog(User user) {
    showDialog(
      context: context,
      builder: (context) {
        final isSuspended = user.suspended == true;
        final isConfirmed = user.confirmed == true;
        final firstAccessStr = (user.firstaccess != null && user.firstaccess! > 0)
            ? DateFormat('dd/MM/yyyy HH:mm')
                .format(DateTime.fromMillisecondsSinceEpoch(user.firstaccess! * 1000))
            : 'Nessun accesso';

        final lastAccessStr = (user.lastaccess != null && user.lastaccess! > 0)
            ? DateFormat('dd/MM/yyyy HH:mm')
                .format(DateTime.fromMillisecondsSinceEpoch(user.lastaccess! * 1000))
            : 'Mai';

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          clipBehavior: Clip.antiAlias,
          elevation: 16,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620, maxHeight: 720),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header moderno con blu sfumato
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 24, 16, 24),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF0F2027),
                        Color(0xFF203A43),
                        Color(0xFF2C5364),
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Avatar con bordo luminescente
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withAlpha(220),
                                  Colors.white.withAlpha(90),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(60),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: _buildUserAvatar(user, radius: 30, isDialog: true),
                          ),
                          const SizedBox(width: 16),
                          // Dettagli anagrafici e badge
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.fullname?.trim().isNotEmpty == true
                                      ? user.fullname!
                                      : (user.username ?? 'Utente'),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '@${user.username ?? "sconosciuto"}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withAlpha(200),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // Badge stato, conferma e ID
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 6,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withAlpha(35),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.white.withAlpha(50)),
                                      ),
                                      child: Text(
                                        'ID #${user.id}',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          fontFamily: 'monospace',
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: isSuspended
                                            ? Colors.red.shade700.withAlpha(200)
                                            : Colors.green.shade700.withAlpha(200),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            isSuspended ? Icons.cancel_outlined : Icons.check_circle_outline,
                                            size: 13,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            isSuspended ? 'Account Sospeso' : 'Account Attivo',
                                            style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: isConfirmed
                                            ? Colors.blue.shade700.withAlpha(200)
                                            : Colors.amber.shade900.withAlpha(200),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        isConfirmed ? 'Confermato' : 'In Attesa',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Pulsante chiusura
                          IconButton(
                            icon: const Icon(Icons.close_rounded, color: Colors.white70),
                            onPressed: () => Navigator.of(context).pop(),
                            tooltip: 'Chiudi',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Corpo modale
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Riquadro info anagrafiche
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            children: [
                              _buildCoolInfoTile(Icons.alternate_email_rounded, 'Email', user.email ?? 'Non specificata'),
                              const Divider(height: 16),
                              _buildCoolInfoTile(Icons.domain_rounded, 'Dipartimento', user.department?.isNotEmpty == true ? user.department! : 'Non specificato'),
                              const Divider(height: 16),
                              _buildCoolInfoTile(Icons.security_rounded, 'Metodo Autenticazione', user.auth ?? 'manual'),
                              const Divider(height: 16),
                              _buildCoolInfoTile(Icons.language_rounded, 'Lingua / Fuso Orario', '${user.lang ?? "en"} • GMT ${user.timezone ?? "99"}'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Date di Accesso
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50.withAlpha(120),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.blue.shade100),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.login_rounded, size: 16, color: Colors.blue.shade700),
                                        const SizedBox(width: 6),
                                        Text('Primo Accesso', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blue.shade800)),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(firstAccessStr, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.teal.shade50.withAlpha(120),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.teal.shade100),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.history_rounded, size: 16, color: Colors.teal.shade700),
                                        const SizedBox(width: 6),
                                        Text('Ultimo Accesso', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.teal.shade800)),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(lastAccessStr, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Descrizione (se presente)
                        if (user.description?.isNotEmpty == true) ...[
                          const SizedBox(height: 20),
                          const Row(
                            children: [
                              Icon(Icons.notes_rounded, size: 16, color: AppTheme.primaryBlue),
                              SizedBox(width: 6),
                              Text('Descrizione Profilo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.primaryBlue)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Text(user.description!, style: const TextStyle(fontSize: 12, height: 1.4)),
                          ),
                        ],

                        // Custom Fields (se presenti)
                        if (user.customfields != null && user.customfields!.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          const Row(
                            children: [
                              Icon(Icons.tune_rounded, size: 16, color: AppTheme.primaryBlue),
                              SizedBox(width: 6),
                              Text('Campi Personalizzati (Custom Fields)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.primaryBlue)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: user.customfields!.map((cf) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryBlue.withAlpha(12),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppTheme.primaryBlue.withAlpha(45)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${cf.name ?? cf.shortname}: ',
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                                    ),
                                    Text(
                                      cf.displayvalue ?? cf.value ?? '-',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade800),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // Footer
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    border: Border(top: BorderSide(color: Colors.grey.shade200)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                        ),
                        child: const Text('Chiudi', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCoolInfoTile(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 10),
        SizedBox(
          width: 150,
          child: Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
        ),
        Expanded(
          child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
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
                onPressed: _isExporting ? null : _exportToExcel,
                backgroundColor: const Color(0xFF107C41),
                foregroundColor: Colors.white,
                elevation: 4,
                shape: const CircleBorder(),
                tooltip: 'Esporta ${_filteredUsers.length} utenti in Excel (.xlsx)',
                child: _isExporting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.2, color: Colors.white),
                      )
                    : const Icon(Icons.table_view_rounded, size: 24),
              ),
            ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 700;

          return Row(
            children: [
              // Area Principale
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(isCompact ? 16 : 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [


                      // Barra di Ricerca + Pulsante Filtri Avanzati
                      Row(
                        children: [
                          Expanded(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                child: TextField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    icon: const Icon(Icons.search, color: AppTheme.primaryBlue),
                                    hintText: 'Cerca per username, nome, cognome, email o dipartimento...',
                                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                                    border: InputBorder.none,
                                    suffixIcon: _searchController.text.isNotEmpty
                                        ? IconButton(
                                            icon: const Icon(Icons.clear, size: 20),
                                            onPressed: () {
                                              _searchController.clear();
                                              _applyFilter();
                                            },
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.fastOutSlowIn,
                            child: !_isAdvancedFiltersOpen
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 12),
                                    child: ElevatedButton.icon(
                                      onPressed: () => setState(() => _isAdvancedFiltersOpen = true),
                                      icon: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          const Icon(Icons.tune_rounded, size: 18),
                                          if (_activeFiltersCount > 0)
                                            Positioned(
                                              right: -6,
                                              top: -6,
                                              child: Container(
                                                padding: const EdgeInsets.all(4),
                                                decoration: const BoxDecoration(
                                                  color: AppTheme.accentRed,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Text(
                                                  '$_activeFiltersCount',
                                                  style: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      label: Text(
                                        _activeFiltersCount > 0 ? 'Filtri ($_activeFiltersCount)' : 'Filtri Avanzati',
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: AppTheme.primaryBlue,
                                        elevation: 0,
                                        side: BorderSide(
                                          color: _activeFiltersCount > 0 ? AppTheme.accentRed : AppTheme.primaryBlue.withAlpha(80),
                                          width: _activeFiltersCount > 0 ? 1.5 : 1,
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),

                      // Chips filtri attivi sotto la barra di ricerca
                      _buildActiveFiltersChips(),
                      const SizedBox(height: 12),

                      // Contenuto: Loading, Tabella o Empty State
                      Expanded(
                        child: _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : _allUsers.isEmpty
                                ? _buildNoUsersInDbState()
                                : _filteredUsers.isEmpty
                                    ? _buildNoSearchResultsState()
                                    : _buildTableView(constraints),
                      ),
                    ],
                  ),
                ),
              ),

              // Menu a Destra Filtri Avanzati con transizione fluida
              AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                curve: Curves.fastOutSlowIn,
                width: _isAdvancedFiltersOpen ? 340 : 0,
                child: ClipRect(
                  child: OverflowBox(
                    minWidth: 340,
                    maxWidth: 340,
                    alignment: Alignment.topRight,
                    child: _buildAdvancedFiltersPanel(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActiveFiltersChips() {
    final hasSearch = _searchController.text.trim().isNotEmpty;
    final totalActive = (hasSearch ? 1 : 0) +
        (_filterActive != null ? 1 : 0) +
        (_filterConfirmed != null ? 1 : 0) +
        _selectedOrgs.length +
        _selectedCourseLangs.length +
        _selectedEditions.length +
        _selectedGenders.length +
        _selectedQualPartnerRefs.length +
        (_dobFrom != null ? 1 : 0) +
        (_dobTo != null ? 1 : 0);

    if (totalActive == 0) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Wrap(
        spacing: 8,
        runSpacing: 6,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.filter_list_rounded, size: 14, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                'Filtri attivi:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
              ),
            ],
          ),

          // 1. Ricerca testuale
          if (hasSearch)
            _buildActiveChip(
              label: 'Cerca: "${_searchController.text.trim()}"',
              onDeleted: () {
                _searchController.clear();
                _applyFilter();
              },
            ),

          // 2. Account Attivo
          if (_filterActive != null)
            _buildActiveChip(
              label: 'Attivo: ${_filterActive! ? "True" : "False"}',
              color: _filterActive! ? Colors.teal : Colors.red,
              onDeleted: () {
                setState(() {
                  _filterActive = null;
                  _applyFilter();
                });
              },
            ),

          // 3. Account Confermato
          if (_filterConfirmed != null)
            _buildActiveChip(
              label: 'Confermato: ${_filterConfirmed! ? "True" : "False"}',
              color: _filterConfirmed! ? Colors.teal : Colors.red,
              onDeleted: () {
                setState(() {
                  _filterConfirmed = null;
                  _applyFilter();
                });
              },
            ),

          // 4. Membership Organization
          ..._selectedOrgs.map((org) => _buildActiveChip(
                label: 'Org: $org',
                onDeleted: () {
                  setState(() {
                    _selectedOrgs.remove(org);
                    _applyFilter();
                  });
                },
              )),

          // 5. Course Lang
          ..._selectedCourseLangs.map((lang) => _buildActiveChip(
                label: 'Lingua: $lang',
                onDeleted: () {
                  setState(() {
                    _selectedCourseLangs.remove(lang);
                    _applyFilter();
                  });
                },
              )),

          // 6. Edition
          ..._selectedEditions.map((ed) => _buildActiveChip(
                label: 'Edizione: $ed',
                onDeleted: () {
                  setState(() {
                    _selectedEditions.remove(ed);
                    _applyFilter();
                  });
                },
              )),

          // 7. Gender
          ..._selectedGenders.map((g) => _buildActiveChip(
                label: 'Genere: $g',
                onDeleted: () {
                  setState(() {
                    _selectedGenders.remove(g);
                    _applyFilter();
                  });
                },
              )),

          // 8. Qual Partner Ref
          ..._selectedQualPartnerRefs.map((q) => _buildActiveChip(
                label: 'Partner: $q',
                onDeleted: () {
                  setState(() {
                    _selectedQualPartnerRefs.remove(q);
                    _applyFilter();
                  });
                },
              )),

          // 9. Data di nascita Da
          if (_dobFrom != null)
            _buildActiveChip(
              label: 'Nascita da: ${DateFormat('dd/MM/yyyy').format(_dobFrom!)}',
              onDeleted: () {
                setState(() {
                  _dobFrom = null;
                  _applyFilter();
                });
              },
            ),

          // 10. Data di nascita A
          if (_dobTo != null)
            _buildActiveChip(
              label: 'Nascita a: ${DateFormat('dd/MM/yyyy').format(_dobTo!)}',
              onDeleted: () {
                setState(() {
                  _dobTo = null;
                  _applyFilter();
                });
              },
            ),

          // Cancella tutti (se più di 1 filtro attivo)
          if (totalActive > 1)
            InkWell(
              onTap: () {
                setState(() {
                  _searchController.clear();
                  _resetAdvancedFilters();
                });
              },
              borderRadius: BorderRadius.circular(6),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Text(
                  'Cancella tutti',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActiveChip({
    required String label,
    required VoidCallback onDeleted,
    MaterialColor? color,
  }) {
    final baseColor = color ?? Colors.blue;
    return Chip(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      labelPadding: const EdgeInsets.symmetric(horizontal: 8),
      backgroundColor: baseColor.shade50,
      side: BorderSide(color: baseColor.shade200),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      label: Text(
        label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: baseColor.shade800),
      ),
      deleteIcon: Icon(Icons.close_rounded, size: 14, color: baseColor.shade800),
      onDeleted: onDeleted,
    );
  }

  List<String> _getDistinctCustomFieldValues(List<String> keywords) {
    final set = <String>{};
    for (final u in _allUsers) {
      final val = _getCustomFieldValue(u, keywords);
      if (val != null && val.trim().isNotEmpty) {
        set.add(val.trim());
      }
    }
    final list = set.toList()..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return list;
  }

  List<String> _getCourseLangOptions() {
    final set = <String>{};
    for (final u in _allUsers) {
      final val = _getCustomFieldValue(u, ['course lang', 'course_lang', 'prefcourselang', 'pref_course_lang', 'lang']);
      if (val != null && val.trim().isNotEmpty) set.add(val.trim());
      if (u.lang != null && u.lang!.trim().isNotEmpty) set.add(u.lang!.trim());
    }
    if (set.isEmpty) {
      set.addAll(['en', 'it', 'es', 'fr', 'de']);
    }
    final list = set.toList()..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return list;
  }

  List<String> _getGenderOptions() {
    final set = <String>{};
    for (final u in _allUsers) {
      final val = _getCustomFieldValue(u, ['gender', 'sesso', 'genere']);
      if (val != null && val.trim().isNotEmpty) set.add(val.trim());
    }
    if (set.isEmpty) {
      set.addAll(['Male', 'Female', 'Other']);
    }
    final list = set.toList()..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return list;
  }

  Widget _buildAdvancedFiltersPanel() {
    final orgOptions = _getDistinctCustomFieldValues(['membership', 'organization', 'organizzaz']);
    final langOptions = _getCourseLangOptions();
    final editionOptions = _getDistinctCustomFieldValues(['edition', 'edizione']);
    final genderOptions = _getGenderOptions();
    final qualOptions = _getDistinctCustomFieldValues(['qualification', 'partener', 'partner']);

    return Container(
      width: 340,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: Colors.grey.shade200)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 10,
            offset: const Offset(-2, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Pannello Filtri con Gradiente Blu sfumato
          Container(
            padding: const EdgeInsets.fromLTRB(18, 18, 12, 18),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0F2027),
                  Color(0xFF203A43),
                  Color(0xFF2C5364),
                ],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(30),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white.withAlpha(50)),
                      ),
                      child: const Icon(Icons.tune_rounded, color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Filtri Avanzati',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                    if (_activeFiltersCount > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.accentRed,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(40),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Text(
                          '$_activeFiltersCount',
                          style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white70, size: 22),
                  onPressed: () => setState(() => _isAdvancedFiltersOpen = false),
                  tooltip: 'Chiudi pannello',
                ),
              ],
            ),
          ),

          // Campi di Filtro con Menu a Tendina
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Account Attivo (True / False)
                  _buildBooleanStatusFilter(
                    label: 'Account Attivo',
                    value: _filterActive,
                    onChanged: (val) {
                      setState(() {
                        _filterActive = val;
                        _applyFilter();
                      });
                    },
                  ),

                  // 2. Account Confermato (True / False)
                  _buildBooleanStatusFilter(
                    label: 'Account Confermato',
                    value: _filterConfirmed,
                    onChanged: (val) {
                      setState(() {
                        _filterConfirmed = val;
                        _applyFilter();
                      });
                    },
                  ),

                  // 3. Membership Organization (Multi-select con Ricerca)
                  _buildMultiSelectField(
                    label: 'Membership Organization',
                    selected: _selectedOrgs,
                    allOptions: orgOptions,
                    onChanged: (newSet) {
                      setState(() {
                        _selectedOrgs.clear();
                        _selectedOrgs.addAll(newSet);
                        _applyFilter();
                      });
                    },
                  ),

                  // 2. User's pref. course Lang (Multi-select con Ricerca)
                  _buildMultiSelectField(
                    label: "User's pref. course Lang",
                    selected: _selectedCourseLangs,
                    allOptions: langOptions,
                    onChanged: (newSet) {
                      setState(() {
                        _selectedCourseLangs.clear();
                        _selectedCourseLangs.addAll(newSet);
                        _applyFilter();
                      });
                    },
                  ),

                  // 3. Edition (Multi-select con Ricerca)
                  _buildMultiSelectField(
                    label: 'Edition',
                    selected: _selectedEditions,
                    allOptions: editionOptions,
                    onChanged: (newSet) {
                      setState(() {
                        _selectedEditions.clear();
                        _selectedEditions.addAll(newSet);
                        _applyFilter();
                      });
                    },
                  ),

                  // 4. Gender (Multi-select con Ricerca)
                  _buildMultiSelectField(
                    label: 'Gender',
                    selected: _selectedGenders,
                    allOptions: genderOptions,
                    onChanged: (newSet) {
                      setState(() {
                        _selectedGenders.clear();
                        _selectedGenders.addAll(newSet);
                        _applyFilter();
                      });
                    },
                  ),

                  // 5. Qualification Partener Reference (Multi-select con Ricerca)
                  _buildMultiSelectField(
                    label: 'Qualification Partener Reference',
                    selected: _selectedQualPartnerRefs,
                    allOptions: qualOptions,
                    onChanged: (newSet) {
                      setState(() {
                        _selectedQualPartnerRefs.clear();
                        _selectedQualPartnerRefs.addAll(newSet);
                        _applyFilter();
                      });
                    },
                  ),

                  // 6. Date Of Birth (Da - A)
                  const Text(
                    'Date Of Birth',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      // Da
                      Expanded(
                        child: InkWell(
                          onTap: () => _pickDobDate(isFrom: true),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: _dobFrom != null ? AppTheme.primaryBlue : Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                              color: _dobFrom != null ? AppTheme.primaryBlue.withAlpha(12) : Colors.white,
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today_rounded, size: 13, color: _dobFrom != null ? AppTheme.primaryBlue : Colors.grey),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    _dobFrom != null ? DateFormat('dd/MM/yy').format(_dobFrom!) : 'Da: Data',
                                    style: TextStyle(fontSize: 11, fontWeight: _dobFrom != null ? FontWeight.bold : FontWeight.normal),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (_dobFrom != null)
                                  GestureDetector(
                                    onTap: () => setState(() { _dobFrom = null; _applyFilter(); }),
                                    child: const Icon(Icons.close, size: 13),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      // A
                      Expanded(
                        child: InkWell(
                          onTap: () => _pickDobDate(isFrom: false),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: _dobTo != null ? AppTheme.primaryBlue : Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                              color: _dobTo != null ? AppTheme.primaryBlue.withAlpha(12) : Colors.white,
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.event_available_rounded, size: 13, color: _dobTo != null ? AppTheme.primaryBlue : Colors.grey),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    _dobTo != null ? DateFormat('dd/MM/yy').format(_dobTo!) : 'A: Data',
                                    style: TextStyle(fontSize: 11, fontWeight: _dobTo != null ? FontWeight.bold : FontWeight.normal),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (_dobTo != null)
                                  GestureDetector(
                                    onTap: () => setState(() { _dobTo = null; _applyFilter(); }),
                                    child: const Icon(Icons.close, size: 13),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Footer Pannello Filtri
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _activeFiltersCount > 0 ? _resetAdvancedFilters : null,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red.shade700,
                      side: BorderSide(color: Colors.red.shade200),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Azzera', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => _isAdvancedFiltersOpen = false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Chiudi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBooleanStatusFilter({
    required String label,
    required bool? value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
              ),
              if (value != null)
                InkWell(
                  onTap: () => onChanged(null),
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Text(
                      'Azzera',
                      style: TextStyle(fontSize: 11, color: Colors.red.shade700, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: value != null ? AppTheme.primaryBlue : Colors.grey.shade300,
                width: value != null ? 1.4 : 1.0,
              ),
            ),
            child: Row(
              children: [
                _buildSegmentButton(
                  title: 'Tutti',
                  isSelected: value == null,
                  onTap: () => onChanged(null),
                ),
                const SizedBox(width: 3),
                _buildSegmentButton(
                  title: 'True',
                  isSelected: value == true,
                  activeColor: Colors.teal.shade700,
                  icon: Icons.check_circle_rounded,
                  onTap: () => onChanged(value == true ? null : true),
                ),
                const SizedBox(width: 3),
                _buildSegmentButton(
                  title: 'False',
                  isSelected: value == false,
                  activeColor: Colors.red.shade700,
                  icon: Icons.cancel_rounded,
                  onTap: () => onChanged(value == false ? null : false),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    Color? activeColor,
    IconData? icon,
  }) {
    final color = activeColor ?? AppTheme.primaryBlue;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withAlpha(25),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    )
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null && isSelected) ...[
                Icon(icon, size: 13, color: Colors.white),
                const SizedBox(width: 4),
              ],
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMultiSelectField({
    required String label,
    required Set<String> selected,
    required List<String> allOptions,
    required ValueChanged<Set<String>> onChanged,
  }) {
    final hasSelection = selected.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (hasSelection)
                InkWell(
                  onTap: () => onChanged({}),
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Text(
                      'Azzera (${selected.length})',
                      style: TextStyle(fontSize: 11, color: Colors.red.shade700, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          InkWell(
            onTap: () async {
              final result = await showDialog<Set<String>>(
                context: context,
                builder: (ctx) => _MultiSelectSearchDialog(
                  title: label,
                  options: allOptions,
                  initialSelected: selected,
                ),
              );
              if (result != null) {
                onChanged(result);
              }
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
              decoration: BoxDecoration(
                color: hasSelection ? AppTheme.primaryBlue.withAlpha(12) : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: hasSelection ? AppTheme.primaryBlue : Colors.grey.shade300,
                  width: hasSelection ? 1.4 : 1.0,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    hasSelection ? Icons.check_circle_rounded : Icons.search_rounded,
                    size: 16,
                    color: hasSelection ? AppTheme.primaryBlue : Colors.grey.shade500,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      hasSelection
                          ? '${selected.length} element${selected.length == 1 ? "o" : "i"} selezionat${selected.length == 1 ? "o" : "i"}'
                          : 'Tutti (${allOptions.length} opzioni - Cerca)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: hasSelection ? FontWeight.bold : FontWeight.normal,
                        color: hasSelection ? AppTheme.primaryBlue : Colors.grey.shade600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down_rounded, color: Colors.grey, size: 20),
                ],
              ),
            ),
          ),
          if (hasSelection) ...[
            const SizedBox(height: 6),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                ...selected.take(4).map((item) {
                  return Chip(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                    backgroundColor: AppTheme.primaryBlue.withAlpha(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: BorderSide(color: AppTheme.primaryBlue.withAlpha(45)),
                    ),
                    label: Text(
                      item,
                      style: const TextStyle(fontSize: 11, color: AppTheme.primaryBlue, fontWeight: FontWeight.w600),
                    ),
                    deleteIcon: const Icon(Icons.close_rounded, size: 13, color: AppTheme.primaryBlue),
                    onDeleted: () {
                      final next = Set<String>.from(selected)..remove(item);
                      onChanged(next);
                    },
                  );
                }),
                if (selected.length > 4)
                  Chip(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                    backgroundColor: Colors.grey.shade200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    label: Text(
                      '+${selected.length - 4} altri',
                      style: TextStyle(fontSize: 10, color: Colors.grey.shade700, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _pickDobDate({required bool isFrom}) async {
    final now = DateTime.now();
    final initial = isFrom
        ? (_dobFrom ?? DateTime(1990, 1, 1))
        : (_dobTo ?? DateTime(2010, 1, 1));
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1920),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _dobFrom = picked;
        } else {
          _dobTo = picked;
        }
        _applyFilter();
      });
    }
  }

  // Vista Tabellare Enterprise Responsive con Paginazione a 50
  Widget _buildTableView(BoxConstraints constraints) {
    final paginatedUsers = _paginatedUsers;
    final total = _filteredUsers.length;
    final startRecord = total == 0 ? 0 : (_currentPage * _pageSize) + 1;
    final endRecord = (_currentPage * _pageSize) + paginatedUsers.length;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(6),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, cardConstraints) {
                return Scrollbar(
                  controller: _horizontalScrollController,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: _horizontalScrollController,
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: cardConstraints.maxWidth),
                      child: Scrollbar(
                        controller: _verticalScrollController,
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          controller: _verticalScrollController,
                          scrollDirection: Axis.vertical,
                          child: DataTable(
                            border: null,
                            dividerThickness: 1,
                            headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                            headingTextStyle: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF475569),
                              fontSize: 12,
                              letterSpacing: 0.4,
                            ),
                            dataRowMinHeight: 52,
                            dataRowMaxHeight: 58,
                            horizontalMargin: 20,
                            columnSpacing: 24,
                            showCheckboxColumn: false,
                            sortColumnIndex: _sortColumnIndex,
                            sortAscending: _sortAscending,
                            columns: [
                              const DataColumn(
                                label: Text('AZIONI'),
                              ),
                              const DataColumn(
                                label: Text('FOTO'),
                              ),
                              DataColumn(
                                label: const Text('ID'),
                                numeric: true,
                                onSort: (col, asc) => _onSort(col, asc),
                              ),
                              DataColumn(
                                label: const Text('UTENTE'),
                                onSort: (col, asc) => _onSort(col, asc),
                              ),
                              DataColumn(
                                label: const Text('EMAIL'),
                                onSort: (col, asc) => _onSort(col, asc),
                              ),
                              DataColumn(
                                label: const Text('DIPARTIMENTO'),
                                onSort: (col, asc) => _onSort(col, asc),
                              ),
                              DataColumn(
                                label: const Text('STATO'),
                                onSort: (col, asc) => _onSort(col, asc),
                              ),
                              DataColumn(
                                label: const Text('CONFERMATO'),
                                onSort: (col, asc) => _onSort(col, asc),
                              ),
                              const DataColumn(
                                label: Text('AUTH'),
                              ),
                              DataColumn(
                                label: const Text('ULTIMO ACCESSO'),
                                onSort: (col, asc) => _onSort(col, asc),
                              ),
                            ],
                            rows: List.generate(paginatedUsers.length, (index) {
                              final user = paginatedUsers[index];
                              final isSuspended = user.suspended == true;
                              final isConfirmed = user.confirmed == true;
                              final lastAccessStr = (user.lastaccess != null && user.lastaccess! > 0)
                                  ? DateFormat('dd/MM/yyyy HH:mm')
                                      .format(DateTime.fromMillisecondsSinceEpoch(user.lastaccess! * 1000))
                                  : '-';
                              final displayName = user.fullname?.isNotEmpty == true
                                  ? user.fullname!
                                  : '${user.firstname ?? ""} ${user.lastname ?? ""}'.trim();

                              return DataRow(
                                color: WidgetStateProperty.resolveWith<Color?>((states) {
                                  if (states.contains(WidgetState.hovered)) {
                                    return AppTheme.primaryBlue.withAlpha(12);
                                  }
                                  return Colors.white;
                                }),
                                onSelectChanged: (_) => _showUserDetailDialog(user),
                                cells: [
                                  // Azioni
                                  DataCell(
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () => _showUserDetailDialog(user),
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: AppTheme.primaryBlue.withAlpha(14),
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: AppTheme.primaryBlue.withAlpha(35)),
                                          ),
                                          child: const Icon(Icons.visibility_rounded, size: 16, color: AppTheme.primaryBlue),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Foto profilo rotonda
                                  DataCell(
                                    _buildUserAvatar(user, radius: 17),
                                  ),

                                  // ID
                                  DataCell(
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        '#${user.id}',
                                        style: TextStyle(
                                          fontFamily: 'monospace',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 11,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Utente (Nome e @username)
                                  DataCell(
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          displayName.isNotEmpty ? displayName : (user.username ?? 'Utente'),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                            color: Color(0xFF1E293B),
                                          ),
                                        ),
                                        Text(
                                          '@${user.username ?? "-"}',
                                          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Email
                                  DataCell(
                                    Text(
                                      user.email?.isNotEmpty == true ? user.email! : '-',
                                      style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
                                    ),
                                  ),

                                  // Dipartimento
                                  DataCell(
                                    user.department?.isNotEmpty == true
                                        ? Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF1F5F9),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              user.department!,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF334155),
                                              ),
                                            ),
                                          )
                                        : Text('-', style: TextStyle(color: Colors.grey.shade400)),
                                  ),

                                  // Stato (Pill con indicatore a pallino)
                                  DataCell(
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: isSuspended ? const Color(0xFFFEF2F2) : const Color(0xFFF0FDF4),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isSuspended ? const Color(0xFFFECACA) : const Color(0xFFBBF7D0),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 6,
                                            height: 6,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: isSuspended ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            isSuspended ? 'Sospeso' : 'Attivo',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: isSuspended ? const Color(0xFF991B1B) : const Color(0xFF166534),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // Confermato (Pill)
                                  DataCell(
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: isConfirmed ? const Color(0xFFF0FDF4) : const Color(0xFFF8FAFC),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isConfirmed ? const Color(0xFFBBF7D0) : const Color(0xFFE2E8F0),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            isConfirmed ? Icons.check_circle_rounded : Icons.pending_outlined,
                                            size: 13,
                                            color: isConfirmed ? const Color(0xFF16A34A) : Colors.grey.shade500,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            isConfirmed ? 'Sì' : 'No',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: isConfirmed ? const Color(0xFF166534) : Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // Auth
                                  DataCell(
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF8FAFC),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: const Color(0xFFE2E8F0)),
                                      ),
                                      child: Text(
                                        user.auth ?? 'manual',
                                        style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),

                                  // Ultimo Accesso
                                  DataCell(
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.schedule_rounded, size: 13, color: Colors.grey.shade400),
                                        const SizedBox(width: 5),
                                        Text(
                                          lastAccessStr,
                                          style: const TextStyle(fontSize: 11, color: Color(0xFF475569)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Barra di Paginazione moderna e responsive
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: LayoutBuilder(
              builder: (context, footerConstraints) {
                final isCompact = footerConstraints.maxWidth < 560;

                final textWidget = RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    children: [
                      const TextSpan(text: 'Mostrati '),
                      TextSpan(
                        text: '$startRecord - $endRecord',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                      ),
                      const TextSpan(text: ' di '),
                      TextSpan(
                        text: '$total',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                      ),
                      if (total != _allUsers.length) ...[
                        TextSpan(
                          text: ' (filtrati da ${_allUsers.length} totali)',
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                        ),
                      ] else ...[
                        const TextSpan(text: ' utenti'),
                      ],
                    ],
                  ),
                );

                final controlsWidget = Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.first_page_rounded, size: 19),
                      onPressed: _currentPage > 0 ? () => setState(() => _currentPage = 0) : null,
                      tooltip: 'Prima pagina',
                      splashRadius: 18,
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_left_rounded, size: 19),
                      onPressed: _currentPage > 0 ? () => setState(() => _currentPage--) : null,
                      tooltip: 'Pagina precedente',
                      splashRadius: 18,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        '${_currentPage + 1} / $_totalPages',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right_rounded, size: 19),
                      onPressed: _currentPage < _totalPages - 1 ? () => setState(() => _currentPage++) : null,
                      tooltip: 'Pagina successiva',
                      splashRadius: 18,
                    ),
                    IconButton(
                      icon: const Icon(Icons.last_page_rounded, size: 19),
                      onPressed: _currentPage < _totalPages - 1 ? () => setState(() => _currentPage = _totalPages - 1) : null,
                      tooltip: 'Ultima pagina',
                      splashRadius: 18,
                    ),
                  ],
                );

                if (isCompact) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      textWidget,
                      const SizedBox(height: 6),
                      controlsWidget,
                    ],
                  );
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: textWidget),
                    controlsWidget,
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoUsersInDbState() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 450),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.people_outline, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                const Text(
                  'Nessun utente nel database',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Non hai ancora scaricato gli utenti dal server. Vai nel menu Impostazioni -> Sync per avviare la sincronizzazione.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoSearchResultsState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            'Nessun utente corrispondente a "${_searchController.text}"',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'Prova a modificare i termini di ricerca.',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

class _MultiSelectSearchDialog extends StatefulWidget {
  final String title;
  final List<String> options;
  final Set<String> initialSelected;

  const _MultiSelectSearchDialog({
    required this.title,
    required this.options,
    required this.initialSelected,
  });

  @override
  State<_MultiSelectSearchDialog> createState() => _MultiSelectSearchDialogState();
}

class _MultiSelectSearchDialogState extends State<_MultiSelectSearchDialog> {
  late final TextEditingController _searchCtrl;
  late final ScrollController _scrollCtrl;
  late final Set<String> _tempSelected;

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController();
    _scrollCtrl = ScrollController();
    _tempSelected = Set<String>.from(widget.initialSelected);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchCtrl.text.trim().toLowerCase();
    final filteredOptions = query.isEmpty
        ? widget.options
        : widget.options.where((opt) => opt.toLowerCase().contains(query)).toList();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 620),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header con Gradiente Blu
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
                children: [
                  const Icon(Icons.tune_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(35),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_tempSelected.length} selez.',
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white70, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Barra di Ricerca
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
              child: TextField(
                controller: _searchCtrl,
                decoration: InputDecoration(
                  hintText: 'Cerca opzione... (${widget.options.length} disponibili)',
                  hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                  prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppTheme.primaryBlue),
                  suffixIcon: _searchCtrl.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 18),
                          onPressed: () {
                            _searchCtrl.clear();
                            setState(() {});
                          },
                        )
                      : null,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppTheme.primaryBlue, width: 1.5),
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),

            // Azioni rapide
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    icon: const Icon(Icons.select_all_rounded, size: 16),
                    label: Text(
                      query.isNotEmpty ? 'Seleziona visibili (${filteredOptions.length})' : 'Seleziona tutti',
                      style: const TextStyle(fontSize: 12),
                    ),
                    onPressed: filteredOptions.isEmpty
                        ? null
                        : () {
                            setState(() {
                              _tempSelected.addAll(filteredOptions);
                            });
                          },
                  ),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red.shade700,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    icon: const Icon(Icons.deselect_rounded, size: 16),
                    label: const Text('Deseleziona tutti', style: TextStyle(fontSize: 12)),
                    onPressed: _tempSelected.isEmpty
                        ? null
                        : () {
                            setState(() {
                              _tempSelected.clear();
                            });
                          },
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Lista opzioni scrollabile con checkbox
            Expanded(
              child: filteredOptions.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          query.isNotEmpty
                              ? 'Nessuna opzione trovata per "$query"'
                              : 'Nessuna opzione disponibile',
                          style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                        ),
                      ),
                    )
                  : Scrollbar(
                      controller: _scrollCtrl,
                      thumbVisibility: true,
                      child: ListView.separated(
                        controller: _scrollCtrl,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        itemCount: filteredOptions.length,
                        separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade100),
                        itemBuilder: (context, index) {
                          final opt = filteredOptions[index];
                          final isChecked = _tempSelected.contains(opt);
                          return CheckboxListTile(
                            value: isChecked,
                            dense: true,
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: AppTheme.primaryBlue,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                            title: Text(
                              opt,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isChecked ? FontWeight.w600 : FontWeight.normal,
                                color: isChecked ? AppTheme.primaryBlue : Colors.black87,
                              ),
                            ),
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  _tempSelected.add(opt);
                                } else {
                                  _tempSelected.remove(opt);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
            ),
            const Divider(height: 1),

            // Footer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Annulla', style: TextStyle(fontSize: 13)),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(_tempSelected),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      'Applica (${_tempSelected.length})',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
