import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:isar_community/isar.dart';

import '../../core/db/isar_provider.dart';
import '../../core/theme/app_theme.dart';
import '../sync/models/course_info.dart';
import 'services/course_info_excel_exporter.dart';

class CourseInfoListView extends ConsumerStatefulWidget {
  const CourseInfoListView({super.key});

  @override
  ConsumerState<CourseInfoListView> createState() => _CourseInfoListViewState();
}

class _CourseInfoListViewState extends ConsumerState<CourseInfoListView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  List<CourseInfo> _allSections = [];
  List<CourseInfo> _filteredSections = [];

  bool _isLoading = true;
  bool _isExporting = false;
  bool _isAdvancedFiltersOpen = false;

  // Paginazione
  static const int _pageSize = 50;
  int _currentPage = 0;

  // Ordinamento: 0: ID, 1: Nome Sezione, 2: Numero Sezione, 3: Visibile, 4: Conteggio Moduli
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  // Filtri Avanzati
  int? _filterVisible; // null: Tutti, 1: Visibile, 0: Nascosto
  bool? _filterUserVisible; // null: Tutti, true: Sì, false: No
  bool? _filterHasModules; // null: Tutti, true: Con moduli, false: Senza moduli
  final Set<String> _selectedModuleTypes = {}; // Tipi di moduli selezionati (es. forum, quiz, assign...)

  StreamSubscription<void>? _courseInfoSub;

  @override
  void initState() {
    super.initState();
    _loadData();
    final isar = ref.read(isarProvider);
    _courseInfoSub = isar.courseInfos.watchLazy().listen((_) {
      _loadData();
    });
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _courseInfoSub?.cancel();
    _searchController.dispose();
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final isar = ref.read(isarProvider);
    List<CourseInfo> list;
    try {
      list = await isar.courseInfos.where().findAll();
    } catch (e) {
      debugPrint('[CourseInfoListView] Errore lettura Isar: $e');
      try {
        await isar.writeTxn(() async => await isar.courseInfos.clear());
      } catch (_) {}
      list = [];
    }
    if (mounted) {
      setState(() {
        _allSections = list;
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

  int get _totalPages => (_filteredSections.isEmpty) ? 1 : ((_filteredSections.length - 1) ~/ _pageSize) + 1;

  List<CourseInfo> get _paginatedSections {
    final start = _currentPage * _pageSize;
    if (start >= _filteredSections.length) return [];
    final end = (start + _pageSize < _filteredSections.length) ? start + _pageSize : _filteredSections.length;
    return _filteredSections.sublist(start, end);
  }

  void _applyFilter() {
    final query = _searchController.text.trim().toLowerCase();
    _filteredSections = _allSections.where((item) {
      // 1. Ricerca rapida testuale
      if (query.isNotEmpty) {
        final idStr = '${item.id}';
        final name = (item.name ?? '').toLowerCase();
        final section = '${item.section ?? ''}';
        final summary = (item.summary ?? '').toLowerCase();
        final moduleNames = (item.modules ?? []).map((m) => (m.name ?? '').toLowerCase()).join(' ');
        final moduleTypes = (item.modules ?? []).map((m) => (m.modname ?? '').toLowerCase()).join(' ');

        final matches = idStr.contains(query) ||
            name.contains(query) ||
            section.contains(query) ||
            summary.contains(query) ||
            moduleNames.contains(query) ||
            moduleTypes.contains(query);
        if (!matches) return false;
      }

      // 2. Filtro Visibilità
      if (_filterVisible != null && item.visible != _filterVisible) {
        return false;
      }

      // 3. Filtro Visibilità Utente
      if (_filterUserVisible != null && item.uservisible != _filterUserVisible) {
        return false;
      }

      // 4. Filtro Moduli Presenti
      final modulesCount = item.modules?.length ?? 0;
      if (_filterHasModules != null) {
        if (_filterHasModules == true && modulesCount == 0) return false;
        if (_filterHasModules == false && modulesCount > 0) return false;
      }

      // 5. Filtro Tipo Modulo
      if (_selectedModuleTypes.isNotEmpty) {
        final itemTypes = (item.modules ?? []).map((m) => m.modname?.toLowerCase() ?? '').toSet();
        final hasAny = _selectedModuleTypes.any((t) => itemTypes.contains(t.toLowerCase()));
        if (!hasAny) return false;
      }

      return true;
    }).toList();

    _sortData();
    _currentPage = 0;
  }

  void _sortData() {
    _filteredSections.sort((a, b) {
      int cmp = 0;
      switch (_sortColumnIndex) {
        case 0: // ID
          cmp = a.id.compareTo(b.id);
          break;
        case 1: // Nome
          cmp = (a.name ?? '').toLowerCase().compareTo((b.name ?? '').toLowerCase());
          break;
        case 2: // Sezione
          cmp = (a.section ?? -1).compareTo(b.section ?? -1);
          break;
        case 3: // Visibile
          cmp = (a.visible ?? 0).compareTo(b.visible ?? 0);
          break;
        case 4: // Numero moduli
          cmp = (a.modules?.length ?? 0).compareTo(b.modules?.length ?? 0);
          break;
      }
      return _sortAscending ? cmp : -cmp;
    });
  }

  void _onSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      _sortData();
    });
  }

  int get _activeFiltersCount {
    int count = 0;
    if (_filterVisible != null) count++;
    if (_filterUserVisible != null) count++;
    if (_filterHasModules != null) count++;
    if (_selectedModuleTypes.isNotEmpty) count += _selectedModuleTypes.length;
    return count;
  }

  void _clearAllFilters() {
    setState(() {
      _filterVisible = null;
      _filterUserVisible = null;
      _filterHasModules = null;
      _selectedModuleTypes.clear();
      _searchController.clear();
      _applyFilter();
    });
  }

  // Estrazione lista univoca di tipi di modulo per il modale di selezione
  List<String> get _allAvailableModuleTypes {
    final types = <String>{};
    for (final sec in _allSections) {
      if (sec.modules != null) {
        for (final m in sec.modules!) {
          if (m.modname != null && m.modname!.trim().isNotEmpty) {
            types.add(m.modname!.trim());
          }
        }
      }
    }
    final sorted = types.toList()..sort();
    return sorted;
  }

  Future<void> _exportToExcel() async {
    if (_isExporting || _filteredSections.isEmpty) return;
    setState(() => _isExporting = true);
    try {
      final path = await CourseInfoExcelExporter.exportCourseInfo(_filteredSections);
      if (mounted) {
        if (path != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('File esportato con successo: $path'),
              backgroundColor: Colors.green.shade700,
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
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
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
                elevation: 4,
                tooltip: 'Esporta tabella in formato Excel (.xlsx)',
                onPressed: _isExporting ? null : _exportToExcel,
                child: _isExporting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.table_view_rounded, size: 22),
              ),
            ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sezione Contenuto Principale
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header e Search Bar
                _buildHeaderAndSearch(),

                // Chips dei filtri attivi
                if (_activeFiltersCount > 0) _buildActiveFilterChips(),

                // Tabella Principale
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _buildTableContainer(),
                ),

                // Footer Responsive con Paginazione
                _buildResponsiveFooter(),
              ],
            ),
          ),

          // Drawer Filtri Avanzati Animato a destra (340px ↔ 0px)
          AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            curve: Curves.fastOutSlowIn,
            width: _isAdvancedFiltersOpen ? 340 : 0,
            child: ClipRect(
              child: OverflowBox(
                minWidth: 0,
                maxWidth: 340,
                alignment: Alignment.topRight,
                child: SizedBox(
                  width: 340,
                  child: _buildAdvancedFiltersDrawer(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Header & Barra di Ricerca
  Widget _buildHeaderAndSearch() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
      color: Colors.white,
      child: Row(
        children: [
          // Search Bar
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Icon(Icons.search_rounded, color: Colors.grey.shade500, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Cerca per nome sezione, ID, modulo, tipo, descrizione...',
                        border: InputBorder.none,
                        isDense: true,
                        hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      color: Colors.grey.shade600,
                      onPressed: () => _searchController.clear(),
                    ),
                ],
              ),
            ),
          ),

              // Pulsante Filtri Avanzati
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                child: _isAdvancedFiltersOpen
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: OutlinedButton.icon(
                          onPressed: () => setState(() => _isAdvancedFiltersOpen = true),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: _activeFiltersCount > 0 ? AppTheme.primaryBlue : Colors.grey.shade300,
                            ),
                            backgroundColor:
                                _activeFiltersCount > 0 ? AppTheme.primaryBlue.withAlpha(15) : Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          icon: Badge(
                            isLabelVisible: _activeFiltersCount > 0,
                            label: Text('$_activeFiltersCount', style: const TextStyle(fontSize: 11)),
                            backgroundColor: AppTheme.accentRed,
                            child: Icon(
                              Icons.filter_list_rounded,
                              size: 18,
                              color: _activeFiltersCount > 0 ? AppTheme.primaryBlue : Colors.grey.shade700,
                            ),
                          ),
                          label: Text(
                            'Filtri Avanzati',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: _activeFiltersCount > 0 ? FontWeight.bold : FontWeight.w500,
                              color: _activeFiltersCount > 0 ? AppTheme.primaryBlue : Colors.grey.shade800,
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
    );
  }

  // Chips Filtri Attivi
  Widget _buildActiveFilterChips() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      child: Wrap(
        spacing: 8,
        runSpacing: 6,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            'Filtri attivi:',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
          ),
          if (_filterVisible != null)
            Chip(
              avatar: Icon(
                _filterVisible == 1 ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                size: 14,
                color: _filterVisible == 1 ? Colors.green.shade700 : Colors.red.shade700,
              ),
              label: Text(_filterVisible == 1 ? 'Stato: Visibile' : 'Stato: Nascosto', style: const TextStyle(fontSize: 12)),
              backgroundColor: _filterVisible == 1 ? Colors.green.shade50 : Colors.red.shade50,
              side: BorderSide.none,
              deleteIcon: const Icon(Icons.close_rounded, size: 14),
              onDeleted: () {
                setState(() {
                  _filterVisible = null;
                  _applyFilter();
                });
              },
            ),
          if (_filterUserVisible != null)
            Chip(
              avatar: const Icon(Icons.person_outline, size: 14, color: AppTheme.primaryBlue),
              label: Text(_filterUserVisible == true ? 'Utente Visibile: Sì' : 'Utente Visibile: No', style: const TextStyle(fontSize: 12)),
              backgroundColor: AppTheme.primaryBlue.withAlpha(20),
              side: BorderSide.none,
              deleteIcon: const Icon(Icons.close_rounded, size: 14),
              onDeleted: () {
                setState(() {
                  _filterUserVisible = null;
                  _applyFilter();
                });
              },
            ),
          if (_filterHasModules != null)
            Chip(
              avatar: const Icon(Icons.layers_rounded, size: 14, color: Color(0xFF8B5CF6)),
              label: Text(_filterHasModules == true ? 'Con Moduli' : 'Senza Moduli (Vuote)', style: const TextStyle(fontSize: 12)),
              backgroundColor: const Color(0xFF8B5CF6).withAlpha(20),
              side: BorderSide.none,
              deleteIcon: const Icon(Icons.close_rounded, size: 14),
              onDeleted: () {
                setState(() {
                  _filterHasModules = null;
                  _applyFilter();
                });
              },
            ),
          ..._selectedModuleTypes.map(
            (type) => Chip(
              avatar: const Icon(Icons.extension_outlined, size: 14, color: Color(0xFF0284C7)),
              label: Text('Tipo: $type', style: const TextStyle(fontSize: 12)),
              backgroundColor: const Color(0xFF0284C7).withAlpha(20),
              side: BorderSide.none,
              deleteIcon: const Icon(Icons.close_rounded, size: 14),
              onDeleted: () {
                setState(() {
                  _selectedModuleTypes.remove(type);
                  _applyFilter();
                });
              },
            ),
          ),
          if (_activeFiltersCount > 1)
            ActionChip(
              avatar: const Icon(Icons.delete_sweep_rounded, size: 14, color: AppTheme.accentRed),
              label: const Text('Cancella tutti', style: TextStyle(fontSize: 12, color: AppTheme.accentRed, fontWeight: FontWeight.bold)),
              backgroundColor: Colors.red.shade50,
              side: BorderSide.none,
              onPressed: _clearAllFilters,
            ),
        ],
      ),
    );
  }

  // Contenitore Tabella Dati Enterprise
  Widget _buildTableContainer() {
    if (_filteredSections.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              'Nessuna sezione trovata',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 6),
            Text(
              _allSections.isEmpty
                  ? 'Il database locale è vuoto. Esegui la sincronizzazione dal menu Sync.'
                  : 'Nessun risultato corrisponde ai criteri di ricerca o ai filtri applicati.',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(6),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Scrollbar(
          controller: _horizontalScrollController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _horizontalScrollController,
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 900),
              child: Scrollbar(
                controller: _verticalScrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _verticalScrollController,
                  child: DataTable(
                    border: null,
                    dividerThickness: 1,
                    headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                    headingTextStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF475569),
                      letterSpacing: 0.5,
                    ),
                    dataRowMinHeight: 52,
                    dataRowMaxHeight: 58,
                    sortColumnIndex: _sortColumnIndex,
                    sortAscending: _sortAscending,
                    columns: [
                      const DataColumn(label: Text('AZIONI')),
                      DataColumn(
                        label: const Text('ID'),
                        onSort: (col, asc) => _onSort(0, asc),
                      ),
                      DataColumn(
                        label: const Text('SEZIONE / NOME'),
                        onSort: (col, asc) => _onSort(1, asc),
                      ),
                      DataColumn(
                        label: const Text('NUMERO'),
                        onSort: (col, asc) => _onSort(2, asc),
                      ),
                      DataColumn(
                        label: const Text('STATO'),
                        onSort: (col, asc) => _onSort(3, asc),
                      ),
                      DataColumn(
                        label: const Text('MODULI DIDATTICI'),
                        onSort: (col, asc) => _onSort(4, asc),
                      ),
                      const DataColumn(label: Text('VISIBILE UTENTE')),
                      const DataColumn(label: Text('SOMMARIO')),
                    ],
                    rows: _paginatedSections.map((item) {
                      return DataRow(
                        color: WidgetStateProperty.resolveWith<Color?>((states) {
                          if (states.contains(WidgetState.hovered)) {
                            return AppTheme.primaryBlue.withAlpha(12);
                          }
                          return Colors.white;
                        }),
                        cells: [
                          // Colonna Azioni (Dettaglio)
                          DataCell(
                            Container(
                              decoration: BoxDecoration(
                                color: AppTheme.primaryBlue.withAlpha(15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.visibility_outlined, size: 18, color: AppTheme.primaryBlue),
                                tooltip: 'Visualizza dettagli sezione e moduli',
                                onPressed: () => _showDetailModal(item),
                              ),
                            ),
                          ),

                          // Colonna ID Badge
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Text(
                                '#${item.id}',
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                            ),
                          ),

                          // Cella Principale: Avatar + Nome Sezione + identificatore secondario
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: const Color(0xFF8B5CF6).withAlpha(30),
                                  child: Text(
                                    (item.name != null && item.name!.trim().isNotEmpty)
                                        ? item.name!.trim()[0].toUpperCase()
                                        : 'S',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: Color(0xFF8B5CF6),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 240),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        (item.name != null && item.name!.trim().isNotEmpty)
                                            ? item.name!
                                            : 'Sezione senza nome',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                          color: Color(0xFF0F172A),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      Text(
                                        'Sezione #${item.section ?? 0}${item.component != null ? ' • ${item.component}' : ''}',
                                        style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Numero Sezione
                          DataCell(
                            Text(
                              item.section != null ? '${item.section}' : '-',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                          ),

                          // Badge di Stato Visibilità
                          DataCell(
                            _buildStatusPill(
                              isActive: item.visible == 1,
                              activeLabel: 'Visibile',
                              inactiveLabel: 'Nascosto',
                            ),
                          ),

                          // Badge Moduli Didattici
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: (item.modules?.isNotEmpty ?? false)
                                        ? const Color(0xFF0284C7).withAlpha(20)
                                        : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.layers_outlined,
                                        size: 14,
                                        color: (item.modules?.isNotEmpty ?? false)
                                            ? const Color(0xFF0284C7)
                                            : Colors.grey.shade500,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '${item.modules?.length ?? 0} Moduli',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: (item.modules?.isNotEmpty ?? false)
                                              ? const Color(0xFF0284C7)
                                              : Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Visibile Utente
                          DataCell(
                            Icon(
                              item.uservisible == true ? Icons.check_circle_rounded : Icons.cancel_rounded,
                              color: item.uservisible == true ? Colors.green.shade600 : Colors.grey.shade400,
                              size: 18,
                            ),
                          ),

                          // Sommario
                          DataCell(
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 200),
                              child: Text(
                                (item.summary != null && item.summary!.trim().isNotEmpty)
                                    ? item.summary!.replaceAll(RegExp(r'<[^>]*>'), '').trim()
                                    : '-',
                                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
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
    );
  }

  // Pill di Stato con pallino colorato
  Widget _buildStatusPill({
    required bool isActive,
    required String activeLabel,
    required String inactiveLabel,
  }) {
    final color = isActive ? Colors.green.shade700 : Colors.red.shade700;
    final bgColor = isActive ? Colors.green.shade50 : Colors.red.shade50;
    final dotColor = isActive ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            isActive ? activeLabel : inactiveLabel,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  // Footer Responsive con Paginazione (LayoutBuilder obbligatorio)
  Widget _buildResponsiveFooter() {
    final total = _filteredSections.length;
    final allTotal = _allSections.length;
    final start = total == 0 ? 0 : (_currentPage * _pageSize) + 1;
    final end = math.min((_currentPage + 1) * _pageSize, total);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 560;

          final counterText = total == allTotal
              ? 'Mostrati $start - $end di $total sezioni'
              : 'Mostrati $start - $end di $total (filtrati da $allTotal totali)';

          final controls = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.first_page_rounded, size: 20),
                tooltip: 'Prima pagina',
                onPressed: _currentPage > 0 ? () => setState(() => _currentPage = 0) : null,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_left_rounded, size: 20),
                tooltip: 'Pagina precedente',
                onPressed: _currentPage > 0 ? () => setState(() => _currentPage--) : null,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_currentPage + 1} / $_totalPages',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right_rounded, size: 20),
                tooltip: 'Pagina successiva',
                onPressed: _currentPage < _totalPages - 1 ? () => setState(() => _currentPage++) : null,
              ),
              IconButton(
                icon: const Icon(Icons.last_page_rounded, size: 20),
                tooltip: 'Ultima pagina',
                onPressed: _currentPage < _totalPages - 1 ? () => setState(() => _currentPage = _totalPages - 1) : null,
              ),
            ],
          );

          if (isNarrow) {
            return Column(
              children: [
                Text(counterText, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                const SizedBox(height: 8),
                controls,
              ],
            );
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(counterText, style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
              controls,
            ],
          );
        },
      ),
    );
  }

  // Drawer Filtri Avanzati
  Widget _buildAdvancedFiltersDrawer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 16,
            offset: const Offset(-4, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Gradiente Istituzionale
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 16, 20),
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
                const Expanded(
                  child: Text(
                    'Filtri Avanzati',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                if (_activeFiltersCount > 0)
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.accentRed,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$_activeFiltersCount',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
                  onPressed: () => setState(() => _isAdvancedFiltersOpen = false),
                  tooltip: 'Chiudi pannello filtri',
                ),
              ],
            ),
          ),

          // Contenuto Filtri
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // 1. Visibilità Sezione (Pulsante a 3 segmenti)
                _buildFilterLabel('Visibilità Sezione'),
                const SizedBox(height: 8),
                _buildThreeSegmentButton(
                  value: _filterVisible,
                  labels: const ['Tutti', 'Visibile', 'Nascosto'],
                  values: const [null, 1, 0],
                  onChanged: (val) {
                    setState(() {
                      _filterVisible = val;
                      _applyFilter();
                    });
                  },
                ),
                const SizedBox(height: 22),

                // 2. Visibilità Utente (Pulsante a 3 segmenti)
                _buildFilterLabel('Visibile per l\'Utente'),
                const SizedBox(height: 8),
                _buildThreeSegmentButton<bool?>(
                  value: _filterUserVisible,
                  labels: const ['Tutti', 'Sì', 'No'],
                  values: const [null, true, false],
                  onChanged: (val) {
                    setState(() {
                      _filterUserVisible = val;
                      _applyFilter();
                    });
                  },
                ),
                const SizedBox(height: 22),

                // 3. Moduli Presenti (Pulsante a 3 segmenti)
                _buildFilterLabel('Contenuto Moduli'),
                const SizedBox(height: 8),
                _buildThreeSegmentButton<bool?>(
                  value: _filterHasModules,
                  labels: const ['Tutti', 'Con Moduli', 'Vuote'],
                  values: const [null, true, false],
                  onChanged: (val) {
                    setState(() {
                      _filterHasModules = val;
                      _applyFilter();
                    });
                  },
                ),
                const SizedBox(height: 22),

                // 4. Tipo di Modulo Attività (Multi-selezione con modale)
                _buildFilterLabel('Tipologia Moduli Attività'),
                const SizedBox(height: 6),
                Text(
                  'Filtra le sezioni che contengono specifiche attività.',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: _showModuleTypeSelectorModal,
                  icon: const Icon(Icons.add_task_rounded, size: 16),
                  label: Text(
                    _selectedModuleTypes.isEmpty
                        ? 'Seleziona Tipi Attività'
                        : 'Modifica (${_selectedModuleTypes.length} selezionati)',
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryBlue,
                    side: BorderSide(color: AppTheme.primaryBlue.withAlpha(100)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                if (_selectedModuleTypes.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: _selectedModuleTypes.map((type) {
                      return Chip(
                        label: Text(type, style: const TextStyle(fontSize: 11)),
                        backgroundColor: const Color(0xFF0284C7).withAlpha(20),
                        side: BorderSide.none,
                        deleteIcon: const Icon(Icons.close_rounded, size: 14),
                        onDeleted: () {
                          setState(() {
                            _selectedModuleTypes.remove(type);
                            _applyFilter();
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),

          // Footer Drawer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _activeFiltersCount > 0 ? _clearAllFilters : null,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.accentRed,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Azzera Filtri', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => _isAdvancedFiltersOpen = false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Chiudi', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterLabel(String label) {
    return Text(
      label,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
    );
  }

  // Pulsante Segmentato a 3 Stati
  Widget _buildThreeSegmentButton<T>({
    required T value,
    required List<String> labels,
    required List<T> values,
    required ValueChanged<T> onChanged,
  }) {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: List.generate(labels.length, (idx) {
          final isSelected = value == values[idx];
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(values[idx]),
              child: Container(
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: isSelected
                      ? [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 4, offset: const Offset(0, 1))]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  labels[idx],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? AppTheme.primaryBlue : Colors.grey.shade700,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // Finestra Modale di Selezione Tipi Modulo con Ricerca Real-Time
  void _showModuleTypeSelectorModal() {
    final available = _allAvailableModuleTypes;
    final tempSelection = Set<String>.from(_selectedModuleTypes);
    String filterQuery = '';

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            final visibleItems = available
                .where((item) => item.toLowerCase().contains(filterQuery.toLowerCase()))
                .toList();

            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              title: Row(
                children: [
                  const Icon(Icons.extension_outlined, color: AppTheme.primaryBlue),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Seleziona Tipologia Moduli',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    '${tempSelection.length} selezionati',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              content: SizedBox(
                width: 440,
                height: 380,
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search, size: 20),
                        hintText: 'Cerca tipo modulo (forum, quiz, url...)',
                        isDense: true,
                        filled: true,
                        fillColor: AppTheme.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (val) {
                        setDialogState(() => filterQuery = val);
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            setDialogState(() {
                              tempSelection.addAll(visibleItems);
                            });
                          },
                          child: const Text('Seleziona visibili', style: TextStyle(fontSize: 12)),
                        ),
                        TextButton(
                          onPressed: () {
                            setDialogState(() {
                              tempSelection.clear();
                            });
                          },
                          child: const Text('Deseleziona tutti', style: TextStyle(fontSize: 12, color: Colors.red)),
                        ),
                      ],
                    ),
                    const Divider(),
                    Expanded(
                      child: visibleItems.isEmpty
                          ? Center(
                              child: Text('Nessun tipo modulo trovato', style: TextStyle(color: Colors.grey.shade500)),
                            )
                          : ListView.builder(
                              itemCount: visibleItems.length,
                              itemBuilder: (c, i) {
                                final item = visibleItems[i];
                                final checked = tempSelection.contains(item);
                                return CheckboxListTile(
                                  dense: true,
                                  title: Text(item, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                                  value: checked,
                                  activeColor: AppTheme.primaryBlue,
                                  onChanged: (val) {
                                    setDialogState(() {
                                      if (val == true) {
                                        tempSelection.add(item);
                                      } else {
                                        tempSelection.remove(item);
                                      }
                                    });
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Annulla'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedModuleTypes.clear();
                      _selectedModuleTypes.addAll(tempSelection);
                      _applyFilter();
                    });
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('Applica'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Modale Dettaglio Entità a Schede Tematizzate
  void _showDetailModal(CourseInfo item) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          clipBehavior: Clip.antiAlias,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720, maxHeight: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Modale con Gradiente Istituzionale e Glow
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(25),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF8B5CF6).withAlpha(120),
                              blurRadius: 18,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.layers_rounded, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name ?? 'Sezione senza nome',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'ID Sezione: #${item.id} • Numero: ${item.section ?? 0}',
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade300),
                            ),
                          ],
                        ),
                      ),
                      _buildStatusPill(
                        isActive: item.visible == 1,
                        activeLabel: 'Visibile',
                        inactiveLabel: 'Nascosto',
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                ),

                // Contenuto a Card
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card Info Anagrafica Sezione
                        _buildSectionHeader('INFORMAZIONI SEZIONE'),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            children: [
                              _buildDetailRow('Nome Sezione', item.name ?? '-'),
                              _buildDetailRow('Numero Sezione', '${item.section ?? 0}'),
                              _buildDetailRow('Visibile all\'Utente', item.uservisible == true ? 'Sì' : 'No'),
                              _buildDetailRow('Componente', item.component ?? '-'),
                              _buildDetailRow('Item ID', item.itemid != null ? '${item.itemid}' : '-'),
                              _buildDetailRow('Sezioni Nascoste', '${item.hiddenbynumsections ?? 0}'),
                              _buildDetailRow(
                                'Ultima Sincronizzazione',
                                item.lastSyncedAt != null
                                    ? DateFormat('dd/MM/yyyy HH:mm:ss').format(item.lastSyncedAt!)
                                    : '-',
                              ),
                            ],
                          ),
                        ),

                        // Sommario
                        if (item.summary != null && item.summary!.trim().isNotEmpty) ...[
                          const SizedBox(height: 20),
                          _buildSectionHeader('SOMMARIO / DESCRIZIONE'),
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Text(
                              item.summary!.replaceAll(RegExp(r'<[^>]*>'), '').trim(),
                              style: TextStyle(fontSize: 13, color: Colors.grey.shade800, height: 1.4),
                            ),
                          ),
                        ],

                        // Moduli Didattici Associati
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            _buildSectionHeader('MODULI DIDATTICI ASSOCIATI'),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0284C7).withAlpha(25),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${item.modules?.length ?? 0}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0284C7),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        if (item.modules == null || item.modules!.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.background,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline_rounded, color: Colors.grey.shade500, size: 20),
                                const SizedBox(width: 10),
                                Text(
                                  'Nessun modulo didattico presente in questa sezione.',
                                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          )
                        else
                          Column(
                            children: item.modules!.map((m) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey.shade200),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 14,
                                          backgroundColor: AppTheme.primaryBlue.withAlpha(20),
                                          child: Icon(
                                            _getIconForModName(m.modname),
                                            size: 16,
                                            color: AppTheme.primaryBlue,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            m.name ?? 'Modulo senza nome',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF0F172A),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF0284C7).withAlpha(15),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            m.modname?.toUpperCase() ?? 'MODULO',
                                            style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF0284C7),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(height: 20),
                                    Wrap(
                                      spacing: 16,
                                      runSpacing: 8,
                                      children: [
                                        _buildMiniTag('ID', '#${m.id ?? '-'}'),
                                        _buildMiniTag('Instance', '${m.instance ?? '-'}'),
                                        _buildMiniTag('Visibile', m.visible == 1 ? 'Sì' : 'No'),
                                        _buildMiniTag('Utente Visibile', m.uservisible == true ? 'Sì' : 'No'),
                                        _buildMiniTag('Completamento', '${m.completion ?? 0}'),
                                        if (m.purpose != null) _buildMiniTag('Scopo', m.purpose!),
                                        if (m.branded != null) _buildMiniTag('Branded', m.branded == true ? 'Sì' : 'No'),
                                      ],
                                    ),
                                    if (m.url != null && m.url!.isNotEmpty) ...[
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Icon(Icons.link_rounded, size: 14, color: Colors.grey.shade500),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              m.url!,
                                              style: TextStyle(fontSize: 11, color: Colors.blue.shade700),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              );
                            }).toList(),
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

  IconData _getIconForModName(String? modName) {
    switch (modName?.toLowerCase()) {
      case 'forum':
        return Icons.forum_outlined;
      case 'quiz':
        return Icons.quiz_outlined;
      case 'assign':
        return Icons.assignment_outlined;
      case 'url':
        return Icons.link_rounded;
      case 'page':
        return Icons.article_outlined;
      case 'resource':
      case 'file':
        return Icons.insert_drive_file_outlined;
      case 'folder':
        return Icons.folder_outlined;
      case 'h5pactivity':
        return Icons.smart_toy_outlined;
      default:
        return Icons.extension_outlined;
    }
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: AppTheme.primaryBlue,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 180,
            child: Text(
              label,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A), fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniTag(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$label: ', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
        Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
      ],
    );
  }
}
