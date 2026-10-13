import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:isar_community/isar.dart';

import '../../core/db/isar_provider.dart';
import '../../core/theme/app_theme.dart';
import '../sync/models/category.dart';
import 'services/category_excel_exporter.dart';

class CategoriesListView extends ConsumerStatefulWidget {
  const CategoriesListView({super.key});

  @override
  ConsumerState<CategoriesListView> createState() => _CategoriesListViewState();
}

class _CategoriesListViewState extends ConsumerState<CategoriesListView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  List<Category> _allCategories = [];
  List<Category> _filteredCategories = [];

  bool _isLoading = true;
  bool _isExporting = false;
  bool _isAdvancedFiltersOpen = false;

  // Paginazione
  static const int _pageSize = 50;
  int _currentPage = 0;

  // Ordinamento
  int _sortColumnIndex = 0; // 0: ID, 1: Nome, 2: Corsi, 3: Modifica
  bool _sortAscending = true;

  // Filtri Avanzati
  bool? _filterVisible; // null: Tutti, true: Visibile (1), false: Nascosta (0)
  bool? _filterHasCourses; // null: Tutti, true: >0, false: 0
  DateTime? _modifiedFrom;
  DateTime? _modifiedTo;

  StreamSubscription<void>? _categoriesSub;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    final isar = ref.read(isarProvider);
    _categoriesSub = isar.categories.watchLazy().listen((_) {
      _loadCategories();
    });
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _categoriesSub?.cancel();
    _searchController.dispose();
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    final isar = ref.read(isarProvider);
    List<Category> categories;
    try {
      categories = await isar.categories.where().findAll();
    } catch (e) {
      debugPrint('[CategoriesListView] Errore lettura Isar (disallineamento schema): $e');
      try {
        await isar.writeTxn(() async => await isar.categories.clear());
      } catch (_) {}
      categories = [];
    }
    if (mounted) {
      setState(() {
        _allCategories = categories;
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

  int get _totalPages => (_filteredCategories.isEmpty) ? 1 : ((_filteredCategories.length - 1) ~/ _pageSize) + 1;

  List<Category> get _paginatedCategories {
    final start = _currentPage * _pageSize;
    if (start >= _filteredCategories.length) return [];
    final end = (start + _pageSize < _filteredCategories.length) ? start + _pageSize : _filteredCategories.length;
    return _filteredCategories.sublist(start, end);
  }

  void _applyFilter() {
    final query = _searchController.text.trim().toLowerCase();
    _filteredCategories = _allCategories.where((c) {
      // 1. Ricerca generale
      if (query.isNotEmpty) {
        final idStr = '${c.id}';
        final name = (c.name ?? '').toLowerCase();
        final idnumber = (c.idnumber ?? '').toLowerCase();
        final path = (c.path ?? '').toLowerCase();
        final desc = c.plainDescription.toLowerCase();

        final matches = idStr.contains(query) ||
            name.contains(query) ||
            idnumber.contains(query) ||
            path.contains(query) ||
            desc.contains(query);
        if (!matches) return false;
      }

      // 2. Visibilità
      if (_filterVisible != null) {
        final isVis = c.isVisible;
        if (isVis != _filterVisible) return false;
      }

      // 3. Corsi associati
      if (_filterHasCourses != null) {
        final hasCourses = (c.coursecount ?? 0) > 0;
        if (hasCourses != _filterHasCourses) return false;
      }

      // 4. Data Modifica
      if (_modifiedFrom != null || _modifiedTo != null) {
        final mod = c.timemodifiedDate;
        if (mod == null) return false;
        if (_modifiedFrom != null && mod.isBefore(_modifiedFrom!)) return false;
        if (_modifiedTo != null && mod.isAfter(_modifiedTo!.add(const Duration(days: 1)))) return false;
      }

      return true;
    }).toList();

    _currentPage = 0;
    _applySorting();
  }

  void _applySorting() {
    _filteredCategories.sort((a, b) {
      int cmp = 0;
      switch (_sortColumnIndex) {
        case 0:
          cmp = a.id.compareTo(b.id);
          break;
        case 1:
          cmp = (a.name ?? '').toLowerCase().compareTo((b.name ?? '').toLowerCase());
          break;
        case 2:
          cmp = (a.coursecount ?? 0).compareTo(b.coursecount ?? 0);
          break;
        case 3:
          final aDate = a.timemodifiedDate ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bDate = b.timemodifiedDate ?? DateTime.fromMillisecondsSinceEpoch(0);
          cmp = aDate.compareTo(bDate);
          break;
        default:
          cmp = a.id.compareTo(b.id);
      }
      return _sortAscending ? cmp : -cmp;
    });
  }

  void _onSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      _applySorting();
    });
  }

  int get _activeFiltersCount {
    int count = 0;
    if (_filterVisible != null) count++;
    if (_filterHasCourses != null) count++;
    if (_modifiedFrom != null || _modifiedTo != null) count++;
    return count;
  }

  void _clearAllFilters() {
    setState(() {
      _filterVisible = null;
      _filterHasCourses = null;
      _modifiedFrom = null;
      _modifiedTo = null;
      _applyFilter();
    });
  }

  Future<void> _exportToExcel() async {
    if (_filteredCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nessuna categoria da esportare con i filtri attuali.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isExporting = true);
    try {
      final resultPath = await CategoryExcelExporter.exportCategories(_filteredCategories);
      if (mounted) {
        if (resultPath != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text('Esportate con successo ${_filteredCategories.length} categorie in Excel!'),
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
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Widget _buildCategoryThumbnail(Category cat, {double radius = 17}) {
    final imgUrl = cat.imageUrl;
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF0284C7).withAlpha(25),
        border: Border.all(color: Colors.grey.shade300, width: 1.2),
      ),
      child: ClipOval(
        child: (imgUrl != null && imgUrl.isNotEmpty)
            ? Image.network(
                imgUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.category_rounded,
                  size: radius,
                  color: const Color(0xFF0284C7),
                ),
              )
            : Icon(
                Icons.category_rounded,
                size: radius,
                color: const Color(0xFF0284C7),
              ),
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
                onPressed: _isExporting ? null : _exportToExcel,
                backgroundColor: const Color(0xFF107C41),
                foregroundColor: Colors.white,
                elevation: 4,
                shape: const CircleBorder(),
                tooltip: 'Esporta ${_filteredCategories.length} categorie in Excel (.xlsx)',
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


                      // Barra di Ricerca e Bottone Filtri
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Cerca per nome, codice IDNumber, ID o descrizione...',
                                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                                prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.primaryBlue),
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear_rounded, size: 18),
                                        onPressed: () => _searchController.clear(),
                                      )
                                    : null,
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: AppTheme.primaryBlue, width: 1.8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 200),
                            child: !_isAdvancedFiltersOpen
                                ? Badge(
                                    isLabelVisible: _activeFiltersCount > 0,
                                    label: Text('$_activeFiltersCount'),
                                    backgroundColor: AppTheme.accentRed,
                                    child: OutlinedButton.icon(
                                      onPressed: () => setState(() => _isAdvancedFiltersOpen = true),
                                      icon: const Icon(Icons.filter_list_rounded, size: 20),
                                      label: const Text('Filtri Avanzati'),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                                        side: BorderSide(
                                          color: _activeFiltersCount > 0 ? AppTheme.primaryBlue : Colors.grey.shade300,
                                          width: _activeFiltersCount > 0 ? 1.5 : 1.0,
                                        ),
                                        foregroundColor: _activeFiltersCount > 0 ? AppTheme.primaryBlue : Colors.grey.shade800,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        backgroundColor: Colors.white,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),

                      // Barra Chips Filtri Attivi
                      if (_activeFiltersCount > 0) ...[
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            if (_filterVisible != null)
                              _buildActiveFilterChip(
                                label: 'Visibilità: ${_filterVisible! ? "Visibile" : "Nascosta"}',
                                onDeleted: () => setState(() {
                                  _filterVisible = null;
                                  _applyFilter();
                                }),
                              ),
                            if (_filterHasCourses != null)
                              _buildActiveFilterChip(
                                label: 'Corsi: ${_filterHasCourses! ? "> 0 corsi" : "0 corsi"}',
                                onDeleted: () => setState(() {
                                  _filterHasCourses = null;
                                  _applyFilter();
                                }),
                              ),
                            if (_modifiedFrom != null || _modifiedTo != null)
                              _buildActiveFilterChip(
                                label: 'Modifica: ${_modifiedFrom != null ? DateFormat("dd/MM/yy").format(_modifiedFrom!) : "Inizio"} ➔ ${_modifiedTo != null ? DateFormat("dd/MM/yy").format(_modifiedTo!) : "Oggi"}',
                                onDeleted: () => setState(() {
                                  _modifiedFrom = null;
                                  _modifiedTo = null;
                                  _applyFilter();
                                }),
                              ),
                            if (_activeFiltersCount > 1)
                              TextButton.icon(
                                onPressed: _clearAllFilters,
                                icon: const Icon(Icons.close_rounded, size: 16),
                                label: const Text('Cancella tutti', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                style: TextButton.styleFrom(foregroundColor: AppTheme.accentRed),
                              ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 16),

                      // Tabella Dati Enterprise
                      Expanded(
                        child: _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : _filteredCategories.isEmpty
                                ? _buildEmptyState()
                                : Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(color: Colors.grey.shade200),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withAlpha(6),
                                          blurRadius: 10,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: Scrollbar(
                                        controller: _verticalScrollController,
                                        thumbVisibility: true,
                                        child: Scrollbar(
                                          controller: _horizontalScrollController,
                                          thumbVisibility: true,
                                          notificationPredicate: (notif) => notif.depth == 1,
                                          child: SingleChildScrollView(
                                            controller: _verticalScrollController,
                                            child: SingleChildScrollView(
                                              controller: _horizontalScrollController,
                                              scrollDirection: Axis.horizontal,
                                              child: ConstrainedBox(
                                                constraints: BoxConstraints(minWidth: constraints.maxWidth - (isCompact ? 32 : 64)),
                                                child: DataTable(
                                                  sortColumnIndex: _sortColumnIndex,
                                                  sortAscending: _sortAscending,
                                                  headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                                                  headingRowHeight: 46,
                                                  dataRowMinHeight: 52,
                                                  dataRowMaxHeight: 58,
                                                  dividerThickness: 1,
                                                  horizontalMargin: 20,
                                                  columnSpacing: 24,
                                                  columns: [
                                                    const DataColumn(label: Text('AZIONI', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, letterSpacing: 0.5))),
                                                    DataColumn(
                                                      label: const Text('ID', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, letterSpacing: 0.5)),
                                                      onSort: (col, asc) => _onSort(0, asc),
                                                    ),
                                                    DataColumn(
                                                      label: const Text('CATEGORIA', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, letterSpacing: 0.5)),
                                                      onSort: (col, asc) => _onSort(1, asc),
                                                    ),
                                                    const DataColumn(label: Text('STATO', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, letterSpacing: 0.5))),
                                                    DataColumn(
                                                      label: const Text('CORSI', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, letterSpacing: 0.5)),
                                                      onSort: (col, asc) => _onSort(2, asc),
                                                    ),
                                                    const DataColumn(label: Text('LIVELLO / PATH', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, letterSpacing: 0.5))),
                                                    DataColumn(
                                                      label: const Text('ULTIMA MODIFICA', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, letterSpacing: 0.5)),
                                                      onSort: (col, asc) => _onSort(3, asc),
                                                    ),
                                                  ],
                                                  rows: _paginatedCategories.map((c) {
                                                    return DataRow(
                                                      cells: [
                                                        DataCell(
                                                          IconButton(
                                                            icon: Container(
                                                              padding: const EdgeInsets.all(6),
                                                              decoration: BoxDecoration(
                                                                color: AppTheme.primaryBlue.withAlpha(15),
                                                                borderRadius: BorderRadius.circular(8),
                                                              ),
                                                              child: const Icon(Icons.visibility_outlined, size: 16, color: AppTheme.primaryBlue),
                                                            ),
                                                            onPressed: () => _showCategoryDetails(c),
                                                            tooltip: 'Dettagli Categoria',
                                                          ),
                                                        ),
                                                        DataCell(
                                                          Container(
                                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                                            decoration: BoxDecoration(
                                                              color: Colors.grey.shade100,
                                                              borderRadius: BorderRadius.circular(6),
                                                              border: Border.all(color: Colors.grey.shade300),
                                                            ),
                                                            child: Text(
                                                              '#${c.id}',
                                                              style: const TextStyle(fontFamily: 'monospace', fontSize: 12, fontWeight: FontWeight.bold),
                                                            ),
                                                          ),
                                                        ),
                                                        DataCell(
                                                          Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              _buildCategoryThumbnail(c),
                                                              const SizedBox(width: 12),
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    c.name ?? 'Senza Nome',
                                                                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                                                  ),
                                                                  if (c.idnumber != null && c.idnumber!.isNotEmpty)
                                                                    Text(
                                                                      'Cod: ${c.idnumber}',
                                                                      style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                                                                    ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        DataCell(
                                                          Container(
                                                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                                            decoration: BoxDecoration(
                                                              color: c.isVisible ? Colors.green.shade50 : Colors.grey.shade100,
                                                              borderRadius: BorderRadius.circular(20),
                                                              border: Border.all(color: c.isVisible ? Colors.green.shade200 : Colors.grey.shade300),
                                                            ),
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Container(
                                                                  width: 6,
                                                                  height: 6,
                                                                  decoration: BoxDecoration(
                                                                    shape: BoxShape.circle,
                                                                    color: c.isVisible ? Colors.green.shade600 : Colors.grey.shade500,
                                                                  ),
                                                                ),
                                                                const SizedBox(width: 6),
                                                                Text(
                                                                  c.isVisible ? 'Visibile' : 'Nascosta',
                                                                  style: TextStyle(
                                                                    fontSize: 11,
                                                                    fontWeight: FontWeight.w600,
                                                                    color: c.isVisible ? Colors.green.shade800 : Colors.grey.shade700,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        DataCell(
                                                          Container(
                                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                            decoration: BoxDecoration(
                                                              color: const Color(0xFF0284C7).withAlpha(15),
                                                              borderRadius: BorderRadius.circular(8),
                                                            ),
                                                            child: Text(
                                                              '${c.coursecount ?? 0} corsi',
                                                              style: const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.bold,
                                                                color: Color(0xFF0284C7),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        DataCell(
                                                          Text(
                                                            'Lvl ${c.depth ?? 1} (${c.path ?? "/"})',
                                                            style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontFamily: 'monospace'),
                                                          ),
                                                        ),
                                                        DataCell(
                                                          Text(
                                                            c.timemodifiedDate != null
                                                                ? DateFormat('dd/MM/yyyy HH:mm').format(c.timemodifiedDate!)
                                                                : 'N/D',
                                                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
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
                      ),

                      // Footer Responsive con Paginazione
                      const SizedBox(height: 14),
                      _buildFooterPagination(),
                    ],
                  ),
                ),
              ),

              // Drawer Laterale Filtri Avanzati
              AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                curve: Curves.fastOutSlowIn,
                width: _isAdvancedFiltersOpen ? 340 : 0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(left: BorderSide(color: Colors.grey.shade200)),
                ),
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
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.category_outlined, size: 52, color: Colors.grey.shade400),
            const SizedBox(height: 14),
            const Text('Nessuna categoria trovata', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(
              _allCategories.isEmpty
                  ? 'Il database locale è vuoto. Esegui la sincronizzazione dal menu Impostazioni -> Sync.'
                  : 'Nessun risultato corrisponde ai criteri di ricerca e ai filtri impostati.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            if (_activeFiltersCount > 0 || _searchController.text.isNotEmpty) ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () {
                  _searchController.clear();
                  _clearAllFilters();
                },
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: const Text('Reimposta filtri'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFooterPagination() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 560;

        final totalFiltered = _filteredCategories.length;
        final startItem = totalFiltered == 0 ? 0 : (_currentPage * _pageSize) + 1;
        final endItem = math.min((_currentPage + 1) * _pageSize, totalFiltered);

        final textInfo = Text(
          totalFiltered == _allCategories.length
              ? 'Mostrate $startItem - $endItem di $totalFiltered categorie'
              : 'Mostrate $startItem - $endItem di $totalFiltered (filtrate da ${_allCategories.length} totali)',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
        );

        final paginationControls = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.first_page_rounded, size: 20),
              onPressed: _currentPage > 0 ? () => setState(() => _currentPage = 0) : null,
              tooltip: 'Prima pagina',
            ),
            IconButton(
              icon: const Icon(Icons.chevron_left_rounded, size: 20),
              onPressed: _currentPage > 0 ? () => setState(() => _currentPage--) : null,
              tooltip: 'Pagina precedente',
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                '${_currentPage + 1} / $_totalPages',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right_rounded, size: 20),
              onPressed: _currentPage < _totalPages - 1 ? () => setState(() => _currentPage++) : null,
              tooltip: 'Pagina successiva',
            ),
            IconButton(
              icon: const Icon(Icons.last_page_rounded, size: 20),
              onPressed: _currentPage < _totalPages - 1 ? () => setState(() => _currentPage = _totalPages - 1) : null,
              tooltip: 'Ultima pagina',
            ),
          ],
        );

        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textInfo,
              const SizedBox(height: 8),
              Center(child: paginationControls),
            ],
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            textInfo,
            paginationControls,
          ],
        );
      },
    );
  }

  Widget _buildActiveFilterChip({required String label, required VoidCallback onDeleted}) {
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      deleteIcon: const Icon(Icons.close_rounded, size: 14),
      onDeleted: onDeleted,
      backgroundColor: AppTheme.primaryBlue.withAlpha(15),
      side: BorderSide(color: AppTheme.primaryBlue.withAlpha(60)),
    );
  }

  Widget _buildAdvancedFiltersDrawer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header con Gradiente Istituzionale
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                  const Icon(Icons.tune_rounded, color: Colors.white, size: 22),
                  const SizedBox(width: 10),
                  const Text(
                    'Filtri Avanzati',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  if (_activeFiltersCount > 0) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.accentRed,
                        borderRadius: BorderRadius.circular(12),
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
                icon: const Icon(Icons.close_rounded, color: Colors.white70, size: 20),
                onPressed: () => setState(() => _isAdvancedFiltersOpen = false),
                tooltip: 'Chiudi pannello',
              ),
            ],
          ),
        ),

        // Corpo Filtri
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // 1. Visibilità (Segmented Button a 3 stati)
              const Text('VISIBILITÀ CATALOGO', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.8, color: Colors.grey)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildFilterSegment(
                      label: 'Tutti',
                      isSelected: _filterVisible == null,
                      onTap: () => setState(() {
                        _filterVisible = null;
                        _applyFilter();
                      }),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _buildFilterSegment(
                      label: 'Visibili',
                      isSelected: _filterVisible == true,
                      onTap: () => setState(() {
                        _filterVisible = true;
                        _applyFilter();
                      }),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _buildFilterSegment(
                      label: 'Nascoste',
                      isSelected: _filterVisible == false,
                      onTap: () => setState(() {
                        _filterVisible = false;
                        _applyFilter();
                      }),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 2. Corsi Associati
              const Text('CORSI ASSOCIATI', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.8, color: Colors.grey)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildFilterSegment(
                      label: 'Tutti',
                      isSelected: _filterHasCourses == null,
                      onTap: () => setState(() {
                        _filterHasCourses = null;
                        _applyFilter();
                      }),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _buildFilterSegment(
                      label: 'Con Corsi (>0)',
                      isSelected: _filterHasCourses == true,
                      onTap: () => setState(() {
                        _filterHasCourses = true;
                        _applyFilter();
                      }),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _buildFilterSegment(
                      label: 'Senza Corsi (0)',
                      isSelected: _filterHasCourses == false,
                      onTap: () => setState(() {
                        _filterHasCourses = false;
                        _applyFilter();
                      }),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 3. Range Data Modifica
              const Text('DATA ULTIMA MODIFICA', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.8, color: Colors.grey)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _modifiedFrom ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() {
                            _modifiedFrom = picked;
                            _applyFilter();
                          });
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        _modifiedFrom != null ? DateFormat('dd/MM/yy').format(_modifiedFrom!) : 'Da Data',
                        style: TextStyle(fontSize: 12, color: _modifiedFrom != null ? AppTheme.primaryBlue : Colors.grey.shade700),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _modifiedTo ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          setState(() {
                            _modifiedTo = picked;
                            _applyFilter();
                          });
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        _modifiedTo != null ? DateFormat('dd/MM/yy').format(_modifiedTo!) : 'A Data',
                        style: TextStyle(fontSize: 12, color: _modifiedTo != null ? AppTheme.primaryBlue : Colors.grey.shade700),
                      ),
                    ),
                  ),
                  if (_modifiedFrom != null || _modifiedTo != null) ...[
                    const SizedBox(width: 6),
                    IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      onPressed: () => setState(() {
                        _modifiedFrom = null;
                        _modifiedTo = null;
                        _applyFilter();
                      }),
                      tooltip: 'Rimuovi date',
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),

        // Footer Drawer
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            border: Border(top: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            children: [
              if (_activeFiltersCount > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: _clearAllFilters,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.accentRed,
                      side: const BorderSide(color: AppTheme.accentRed),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Azzera Filtri'),
                  ),
                ),
              if (_activeFiltersCount > 0) const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => setState(() => _isAdvancedFiltersOpen = false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Applica e Chiudi'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterSegment({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryBlue : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? AppTheme.primaryBlue : Colors.grey.shade300),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : Colors.grey.shade800,
          ),
        ),
      ),
    );
  }

  void _showCategoryDetails(Category cat) {
    showDialog(
      context: context,
      builder: (context) {
        final imgUrl = cat.imageUrl;
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          clipBehavior: Clip.antiAlias,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 580, maxHeight: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header Dialog con Gradiente Istituzionale
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    children: [
                      _buildCategoryThumbnail(cat, radius: 24),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cat.name ?? 'Senza Nome',
                              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'ID #${cat.id} • Codice: ${cat.idnumber?.isNotEmpty == true ? cat.idnumber : "N/D"}',
                              style: const TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'monospace'),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                // Contenuto Dialog
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Immagine se presente
                        if (imgUrl != null && imgUrl.isNotEmpty) ...[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              imgUrl,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                            ),
                          ),
                          const SizedBox(height: 18),
                        ],

                        // Card Parametri
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                _buildDetailRow('Visibilità', cat.isVisible ? 'Visibile nel catalogo' : 'Nascosta'),
                                const Divider(height: 18),
                                _buildDetailRow('Numero Corsi Associati', '${cat.coursecount ?? 0}'),
                                const Divider(height: 18),
                                _buildDetailRow('Livello Gerarchico (Depth)', '${cat.depth ?? 1}'),
                                const Divider(height: 18),
                                _buildDetailRow('Categoria Genitore (Parent ID)', '${cat.parent ?? 0}'),
                                const Divider(height: 18),
                                _buildDetailRow('Percorso (Path)', cat.path ?? '/${cat.id}'),
                                const Divider(height: 18),
                                _buildDetailRow('Ordinamento (Sort Order)', '${cat.sortorder ?? 0}'),
                                const Divider(height: 18),
                                _buildDetailRow(
                                  'Ultima Modifica',
                                  cat.timemodifiedDate != null
                                      ? DateFormat('dd/MM/yyyy HH:mm:ss').format(cat.timemodifiedDate!)
                                      : 'N/D',
                                ),
                                if (cat.descriptionformat != null) ...[
                                  const Divider(height: 18),
                                  _buildDetailRow('Formato Descrizione', 'Format ${cat.descriptionformat}'),
                                ],
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Descrizione Completa
                        if (cat.description != null && cat.description!.trim().isNotEmpty) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'DESCRIZIONE',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryBlue,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              if (cat.descriptionformat != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'HTML Format ${cat.descriptionformat}',
                                    style: TextStyle(fontSize: 10, color: Colors.grey.shade700, fontWeight: FontWeight.bold),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppTheme.background,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (cat.plainDescription.isNotEmpty) ...[
                                  Text(
                                    cat.plainDescription,
                                    style: const TextStyle(fontSize: 13, height: 1.4, color: Color(0xFF1E293B)),
                                  ),
                                  const SizedBox(height: 10),
                                  const Divider(),
                                  const SizedBox(height: 6),
                                ],
                                SelectableText(
                                  cat.description!,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontFamily: 'monospace',
                                    color: Colors.grey.shade700,
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ] else ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Text(
                              'Nessuna descrizione registrata per questa categoria.',
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontStyle: FontStyle.italic),
                            ),
                          ),
                        ],
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

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
