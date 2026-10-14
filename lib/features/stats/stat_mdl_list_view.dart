import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:isar_community/isar.dart';

import '../../core/db/isar_provider.dart';
import '../../core/theme/app_theme.dart';
import '../sync/models/stat_mdl.dart';
import 'services/stat_mdl_excel_exporter.dart';

class StatMdlListView extends ConsumerStatefulWidget {
  const StatMdlListView({super.key});

  @override
  ConsumerState<StatMdlListView> createState() => _StatMdlListViewState();
}

class _StatMdlListViewState extends ConsumerState<StatMdlListView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  List<StatMdl> _allItems = [];
  List<StatMdl> _filteredItems = [];

  bool _isLoading = true;
  bool _isExporting = false;
  bool _isAdvancedFiltersOpen = false;

  // Paginazione
  static const int _pageSize = 50;
  int _currentPage = 0;

  // Ordinamento: 0: ID Utente, 1: Utente/Nome, 2: Corso, 3: Attività/Modulo, 4: Data Completamento, 5: Stato
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  // Filtri Avanzati
  String? _filterStatoCompletamento; // null: Tutti, oppure "Completato", ecc.
  String? _filterTipoModulo; // null: Tutti, oppure "scorm", "forum", ecc.
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
    List<StatMdl> list;
    try {
      list = await isar.statMdls.where().findAll();
    } catch (e) {
      debugPrint('[StatMdlListView] Errore lettura Isar: $e');
      try {
        await isar.writeTxn(() async => await isar.statMdls.clear());
      } catch (_) {}
      list = [];
    }
    if (mounted) {
      setState(() {
        _allItems = list;
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

  int get _totalPages => (_filteredItems.isEmpty) ? 1 : ((_filteredItems.length - 1) ~/ _pageSize) + 1;

  List<StatMdl> get _paginatedItems {
    final start = _currentPage * _pageSize;
    if (start >= _filteredItems.length) return [];
    final end = (start + _pageSize < _filteredItems.length) ? start + _pageSize : _filteredItems.length;
    return _filteredItems.sublist(start, end);
  }

  void _applyFilter() {
    final q = _searchController.text.trim().toLowerCase();

    List<StatMdl> results = _allItems.where((item) {
      if (q.isNotEmpty) {
        final userIdStr = item.userId?.toString() ?? '';
        final usernameStr = item.username?.toLowerCase() ?? '';
        final nameStr = item.fullName.toLowerCase();
        final emailStr = item.email?.toLowerCase() ?? '';
        final courseStr = item.nomeCorso?.toLowerCase() ?? '';
        final activityStr = item.nomeAttivita?.toLowerCase() ?? '';
        final tipoStr = item.tipoModulo?.toLowerCase() ?? '';

        final matchesQuery = userIdStr.contains(q) ||
            usernameStr.contains(q) ||
            nameStr.contains(q) ||
            emailStr.contains(q) ||
            courseStr.contains(q) ||
            activityStr.contains(q) ||
            tipoStr.contains(q);

        if (!matchesQuery) return false;
      }

      // Filtro Stato Completamento Corso
      if (_filterStatoCompletamento != null) {
        if ((item.statoCompletamentoCorso ?? '').toLowerCase() != _filterStatoCompletamento!.toLowerCase()) {
          return false;
        }
      }

      // Filtro Tipo Modulo
      if (_filterTipoModulo != null) {
        if ((item.tipoModulo ?? '').toLowerCase() != _filterTipoModulo!.toLowerCase()) {
          return false;
        }
      }

      // Filtro Data Da
      if (_filterDataDa != null) {
        if (item.dataCompletamento == null || item.dataCompletamento!.isBefore(_filterDataDa!)) {
          return false;
        }
      }

      // Filtro Data A
      if (_filterDataA != null) {
        final endOfDay = DateTime(_filterDataA!.year, _filterDataA!.month, _filterDataA!.day, 23, 59, 59);
        if (item.dataCompletamento == null || item.dataCompletamento!.isAfter(endOfDay)) {
          return false;
        }
      }

      return true;
    }).toList();

    _sortItems(results);

    _filteredItems = results;
    _currentPage = 0;
  }

  void _sortItems(List<StatMdl> list) {
    list.sort((a, b) {
      int cmp = 0;
      switch (_sortColumnIndex) {
        case 0:
          cmp = (a.userId ?? 0).compareTo(b.userId ?? 0);
          break;
        case 1:
          cmp = (a.fullName).toLowerCase().compareTo(b.fullName.toLowerCase());
          break;
        case 2:
          cmp = (a.nomeCorso ?? '').toLowerCase().compareTo(b.nomeCorso ?? '');
          break;
        case 3:
          cmp = (a.nomeAttivita ?? '').toLowerCase().compareTo(b.nomeAttivita ?? '');
          break;
        case 4:
          final da = a.dataCompletamento ?? DateTime.fromMillisecondsSinceEpoch(0);
          final db = b.dataCompletamento ?? DateTime.fromMillisecondsSinceEpoch(0);
          cmp = da.compareTo(db);
          break;
        case 5:
          cmp = (a.statoCompletamentoCorso ?? '').toLowerCase().compareTo(b.statoCompletamentoCorso ?? '');
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
      _sortItems(_filteredItems);
    });
  }

  int get _activeFiltersCount {
    int count = 0;
    if (_filterStatoCompletamento != null) count++;
    if (_filterTipoModulo != null) count++;
    if (_filterDataDa != null) count++;
    if (_filterDataA != null) count++;
    return count;
  }

  void _resetAllFilters() {
    setState(() {
      _searchController.clear();
      _filterStatoCompletamento = null;
      _filterTipoModulo = null;
      _filterDataDa = null;
      _filterDataA = null;
      _applyFilter();
    });
  }

  Future<void> _exportExcel() async {
    if (_isExporting) return;
    setState(() => _isExporting = true);
    try {
      final path = await StatMdlExcelExporter.exportStatMdl(_filteredItems);
      if (mounted) {
        if (path != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle_outline, color: Colors.white),
                  const SizedBox(width: 10),
                  Expanded(child: Text('File esportato con successo in: $path')),
                ],
              ),
              backgroundColor: Colors.green.shade700,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
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

  void _showDetailModal(StatMdl item) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
    final isCompleted = (item.statoCompletamentoCorso ?? '').toLowerCase() == 'completato';

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620, maxHeight: 720),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header Modale con Gradiente Istituzionale
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
                        radius: 26,
                        backgroundColor: Colors.white.withAlpha(30),
                        child: const Icon(Icons.analytics_rounded, color: Colors.amberAccent, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.nomeAttivita ?? 'Attività Senza Nome',
                              style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${item.fullName} (@${item.username ?? '-'})',
                              style: TextStyle(color: Colors.white.withAlpha(200), fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isCompleted ? Colors.green.withAlpha(50) : Colors.orange.withAlpha(50),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isCompleted ? Colors.greenAccent : Colors.orangeAccent),
                        ),
                        child: Text(
                          item.statoCompletamentoCorso ?? 'In corso',
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

                // Contenuto a schede
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildModalCard(
                          title: 'Anagrafica & Profilo Utente',
                          icon: Icons.person_outline,
                          children: [
                            _buildModalRow('ID Utente', '#${item.userId ?? '-'}'),
                            _buildModalRow('Nome Completo', item.fullName.isNotEmpty ? item.fullName : '-'),
                            _buildModalRow('Username', item.username ?? '-'),
                            _buildModalRow('Email', item.email ?? '-'),
                            _buildModalRow('Genere', item.gender ?? '-'),
                            _buildModalRow('Data di Nascita', item.dateOfBirthCnv ?? item.dateOfBirth ?? '-'),
                            _buildModalRow('Qualifica', item.qualification ?? '-'),
                            _buildModalRow('Organizzazione', item.membershipOrg ?? '-'),
                            _buildModalRow('Lingua Corso', item.userCourseLang ?? '-'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildModalCard(
                          title: 'Dettagli Corso & Modulo',
                          icon: Icons.school_outlined,
                          children: [
                            _buildModalRow('ID Corso', '#${item.idCorso ?? '-'}'),
                            _buildModalRow('Codice Corso', item.shorthNomeCorso ?? '-'),
                            _buildModalRow('Nome Corso', item.nomeCorso ?? '-'),
                            _buildModalRow('ID Modulo', '#${item.idModulo ?? '-'}'),
                            _buildModalRow('Tipo Modulo', (item.tipoModulo ?? '-').toUpperCase()),
                            _buildModalRow('Attività', item.nomeAttivita ?? '-'),
                            _buildModalRow('Tag Attività', item.ntag != null ? '${item.ntag} (ID: ${item.tagId})' : '-'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildModalCard(
                          title: 'Accessi & Completamento',
                          icon: Icons.timelapse_outlined,
                          children: [
                            _buildModalRow('Stato Corso', item.statoCompletamentoCorso ?? '-'),
                            _buildModalRow(
                              'Data Completamento Corso',
                              item.dataCompletamentoCorso != null ? dateFormat.format(item.dataCompletamentoCorso!) : 'Non completato',
                            ),
                            _buildModalRow(
                              'Data Completamento Modulo',
                              item.dataCompletamento != null ? dateFormat.format(item.dataCompletamento!) : 'Non completato',
                            ),
                            _buildModalRow(
                              'Primo Accesso Piattaforma',
                              item.primoAccessoPiattaforma != null ? dateFormat.format(item.primoAccessoPiattaforma!) : '-',
                            ),
                            _buildModalRow(
                              'Ultimo Accesso Piattaforma',
                              item.ultimoAccessoPiattaforma != null ? dateFormat.format(item.ultimoAccessoPiattaforma!) : '-',
                            ),
                          ],
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

  Widget _buildModalCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
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
              Icon(icon, size: 18, color: AppTheme.primaryBlue),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.primaryBlue),
              ),
            ],
          ),
          const Divider(height: 18),
          ...children,
        ],
      ),
    );
  }

  Widget _buildModalRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 170,
            child: Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
            ),
          ),
        ],
      ),
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
                tooltip: 'Esporta tabella in Excel (.xlsx)',
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
          // Vista Principale Tabella
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Barra Ricerca e Pulsante Filtri
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Cerca per utente, email, corso, modulo, attività...',
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
                        if (_filterStatoCompletamento != null)
                          InputChip(
                            label: Text('Stato: $_filterStatoCompletamento'),
                            onDeleted: () {
                              setState(() {
                                _filterStatoCompletamento = null;
                                _applyFilter();
                              });
                            },
                            deleteIconColor: Colors.grey.shade700,
                            backgroundColor: Colors.white,
                          ),
                        if (_filterTipoModulo != null)
                          InputChip(
                            label: Text('Tipo: ${_filterTipoModulo!.toUpperCase()}'),
                            onDeleted: () {
                              setState(() {
                                _filterTipoModulo = null;
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
                            : _filteredItems.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.analytics_outlined, size: 54, color: Colors.grey.shade400),
                                        const SizedBox(height: 14),
                                        Text(
                                          'Nessuna statistica trovata',
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
                                            dataRowMinHeight: 52,
                                            dataRowMaxHeight: 58,
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
                                                label: const Text('CORSO'),
                                                onSort: _onSort,
                                              ),
                                              DataColumn(
                                                label: const Text('ATTIVITÀ / MODULO'),
                                                onSort: _onSort,
                                              ),
                                              DataColumn(
                                                label: const Text('COMPLETAMENTO'),
                                                onSort: _onSort,
                                              ),
                                              DataColumn(
                                                label: const Text('STATO CORSO'),
                                                onSort: _onSort,
                                              ),
                                            ],
                                            rows: _paginatedItems.map((item) {
                                              final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
                                              final isCompleted =
                                                  (item.statoCompletamentoCorso ?? '').toLowerCase() == 'completato';

                                              return DataRow(
                                                cells: [
                                                  // Azioni
                                                  DataCell(
                                                    IconButton(
                                                      icon: const Icon(Icons.visibility_outlined, size: 20, color: AppTheme.primaryBlue),
                                                      tooltip: 'Dettagli Statistici',
                                                      onPressed: () => _showDetailModal(item),
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
                                                        '#${item.userId ?? '-'}',
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
                                                            item.fullName.isNotEmpty
                                                                ? item.fullName[0].toUpperCase()
                                                                : '?',
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
                                                              item.fullName.isNotEmpty ? item.fullName : (item.username ?? '-'),
                                                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                                            ),
                                                            Text(
                                                              item.email ?? '@${item.username ?? '-'}',
                                                              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  // Corso
                                                  DataCell(
                                                    ConstrainedBox(
                                                      constraints: const BoxConstraints(maxWidth: 240),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            item.nomeCorso ?? '-',
                                                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                          Text(
                                                            'Codice: ${item.shorthNomeCorso ?? '-'} (ID: ${item.idCorso ?? '-'})',
                                                            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  // Attività / Modulo
                                                  DataCell(
                                                    ConstrainedBox(
                                                      constraints: const BoxConstraints(maxWidth: 240),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                            decoration: BoxDecoration(
                                                              color: Colors.amber.shade50,
                                                              borderRadius: BorderRadius.circular(4),
                                                              border: Border.all(color: Colors.amber.shade200),
                                                            ),
                                                            child: Text(
                                                              (item.tipoModulo ?? 'MOD').toUpperCase(),
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.amber.shade900,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(width: 8),
                                                          Expanded(
                                                            child: Text(
                                                              item.nomeAttivita ?? '-',
                                                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  // Data Completamento
                                                  DataCell(
                                                    Text(
                                                      item.dataCompletamento != null
                                                          ? dateFormat.format(item.dataCompletamento!)
                                                          : '-',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: item.dataCompletamento != null
                                                            ? Colors.grey.shade800
                                                            : Colors.grey.shade400,
                                                      ),
                                                    ),
                                                  ),
                                                  // Stato Corso Pill
                                                  DataCell(
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: isCompleted
                                                            ? Colors.green.shade50
                                                            : Colors.orange.shade50,
                                                        borderRadius: BorderRadius.circular(12),
                                                        border: Border.all(
                                                          color: isCompleted
                                                              ? Colors.green.shade200
                                                              : Colors.orange.shade200,
                                                        ),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Icon(
                                                            Icons.circle,
                                                            size: 7,
                                                            color: isCompleted
                                                                ? Colors.green.shade700
                                                                : Colors.orange.shade700,
                                                          ),
                                                          const SizedBox(width: 6),
                                                          Text(
                                                            item.statoCompletamentoCorso ?? 'In corso',
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              fontWeight: FontWeight.bold,
                                                              color: isCompleted
                                                                  ? Colors.green.shade800
                                                                  : Colors.orange.shade800,
                                                            ),
                                                          ),
                                                        ],
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
                        _filteredItems.length == _allItems.length
                            ? 'Mostrati ${_filteredItems.isEmpty ? 0 : (_currentPage * _pageSize) + 1} - ${math.min((_currentPage + 1) * _pageSize, _filteredItems.length)} di ${_allItems.length} record'
                            : 'Mostrati ${_filteredItems.isEmpty ? 0 : (_currentPage * _pageSize) + 1} - ${math.min((_currentPage + 1) * _pageSize, _filteredItems.length)} di ${_filteredItems.length} (filtrati da ${_allItems.length} totali)',
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

          // Drawer Laterale Filtri Avanzati Animato
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
                              // Filtro Stato Corso (3 segmenti)
                              const Text('STATO CORSO', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 6,
                                children: [
                                  ChoiceChip(
                                    label: const Text('Tutti'),
                                    selected: _filterStatoCompletamento == null,
                                    onSelected: (val) {
                                      if (val) setState(() { _filterStatoCompletamento = null; _applyFilter(); });
                                    },
                                  ),
                                  ChoiceChip(
                                    label: const Text('Completato'),
                                    selected: _filterStatoCompletamento == 'Completato',
                                    onSelected: (val) {
                                      setState(() { _filterStatoCompletamento = val ? 'Completato' : null; _applyFilter(); });
                                    },
                                  ),
                                  ChoiceChip(
                                    label: const Text('In corso / Altro'),
                                    selected: _filterStatoCompletamento == 'In corso',
                                    onSelected: (val) {
                                      setState(() { _filterStatoCompletamento = val ? 'In corso' : null; _applyFilter(); });
                                    },
                                  ),
                                ],
                              ),

                              const Divider(height: 32),

                              // Filtro Tipo Modulo
                              const Text('TIPO MODULO', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: [
                                  ChoiceChip(
                                    label: const Text('Tutti'),
                                    selected: _filterTipoModulo == null,
                                    onSelected: (val) {
                                      if (val) setState(() { _filterTipoModulo = null; _applyFilter(); });
                                    },
                                  ),
                                  ChoiceChip(
                                    label: const Text('SCORM'),
                                    selected: _filterTipoModulo == 'scorm',
                                    onSelected: (val) {
                                      setState(() { _filterTipoModulo = val ? 'scorm' : null; _applyFilter(); });
                                    },
                                  ),
                                  ChoiceChip(
                                    label: const Text('TEST / QUIZ'),
                                    selected: _filterTipoModulo == 'quiz',
                                    onSelected: (val) {
                                      setState(() { _filterTipoModulo = val ? 'quiz' : null; _applyFilter(); });
                                    },
                                  ),
                                  ChoiceChip(
                                    label: const Text('FORUM'),
                                    selected: _filterTipoModulo == 'forum',
                                    onSelected: (val) {
                                      setState(() { _filterTipoModulo = val ? 'forum' : null; _applyFilter(); });
                                    },
                                  ),
                                ],
                              ),

                              const Divider(height: 32),

                              // Filtro Range Date Completamento
                              const Text('DATA COMPLETAMENTO', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
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
