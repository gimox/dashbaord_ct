import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:isar_community/isar.dart';

import '../../core/db/isar_provider.dart';
import '../../core/theme/app_theme.dart';
import '../sync/models/course.dart';
import 'services/course_excel_exporter.dart';

class CoursesListView extends ConsumerStatefulWidget {
  const CoursesListView({super.key});

  @override
  ConsumerState<CoursesListView> createState() => _CoursesListViewState();
}

class _CoursesListViewState extends ConsumerState<CoursesListView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  List<Course> _allCourses = [];
  List<Course> _filteredCourses = [];

  bool _isLoading = true;
  bool _isExporting = false;
  bool _isAdvancedFiltersOpen = false;

  // Paginazione
  static const int _pageSize = 50;
  int _currentPage = 0;

  // Ordinamento
  int _sortColumnIndex = 0; // 0: ID, 1: Titolo, 2: Categoria, 3: Inizio, 4: Modifica
  bool _sortAscending = true;

  // Filtri Avanzati
  bool? _filterVisible; // null: Tutti, true: Visibile (1), false: Nascosto (0)
  String? _filterCourseType; // null: Tutti, oppure tipo corso (es. async, sync)
  String? _filterFormat; // null: Tutti, oppure formato (es. site, topics, weeks)
  DateTime? _startDateFrom;
  DateTime? _startDateTo;
  DateTime? _modifiedFrom;
  DateTime? _modifiedTo;

  StreamSubscription<void>? _coursesSub;

  @override
  void initState() {
    super.initState();
    _loadCourses();
    final isar = ref.read(isarProvider);
    _coursesSub = isar.courses.watchLazy().listen((_) {
      _loadCourses();
    });
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _coursesSub?.cancel();
    _searchController.dispose();
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  Future<void> _loadCourses() async {
    final isar = ref.read(isarProvider);
    List<Course> courses;
    try {
      courses = await isar.courses.where().findAll();
    } catch (e) {
      debugPrint('[CoursesListView] Errore lettura Isar (disallineamento schema): $e');
      try {
        await isar.writeTxn(() async => await isar.courses.clear());
      } catch (_) {}
      courses = [];
    }
    if (mounted) {
      setState(() {
        _allCourses = courses;
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

  int get _totalPages => (_filteredCourses.isEmpty) ? 1 : ((_filteredCourses.length - 1) ~/ _pageSize) + 1;

  List<Course> get _paginatedCourses {
    final start = _currentPage * _pageSize;
    if (start >= _filteredCourses.length) return [];
    final end = (start + _pageSize < _filteredCourses.length) ? start + _pageSize : _filteredCourses.length;
    return _filteredCourses.sublist(start, end);
  }

  void _applyFilter() {
    final query = _searchController.text.trim().toLowerCase();
    _filteredCourses = _allCourses.where((c) {
      // 1. Ricerca generale
      if (query.isNotEmpty) {
        final idStr = '${c.id}';
        final fullname = (c.fullname ?? '').toLowerCase();
        final shortname = (c.shortname ?? '').toLowerCase();
        final idnumber = (c.idnumber ?? '').toLowerCase();
        final catIdStr = '${c.categoryid ?? ''}';
        final format = (c.format ?? '').toLowerCase();
        final type = (c.courseType ?? '').toLowerCase();
        final summary = c.cleanSummary.toLowerCase();

        final matches = idStr.contains(query) ||
            fullname.contains(query) ||
            shortname.contains(query) ||
            idnumber.contains(query) ||
            catIdStr.contains(query) ||
            format.contains(query) ||
            type.contains(query) ||
            summary.contains(query);
        if (!matches) return false;
      }

      // 2. Visibilità
      if (_filterVisible != null) {
        final isVis = c.isVisible;
        if (isVis != _filterVisible) return false;
      }

      // 3. Tipologia Corso
      if (_filterCourseType != null && _filterCourseType!.isNotEmpty) {
        final type = (c.courseType ?? '').toLowerCase();
        if (type != _filterCourseType!.toLowerCase()) return false;
      }

      // 4. Formato
      if (_filterFormat != null && _filterFormat!.isNotEmpty) {
        final fmt = (c.format ?? '').toLowerCase();
        if (fmt != _filterFormat!.toLowerCase()) return false;
      }

      // 5. Data Inizio
      if (_startDateFrom != null || _startDateTo != null) {
        final start = c.startDateTime;
        if (start == null) return false;
        if (_startDateFrom != null && start.isBefore(_startDateFrom!)) return false;
        if (_startDateTo != null && start.isAfter(_startDateTo!.add(const Duration(days: 1)))) return false;
      }

      // 6. Data Modifica
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
    _filteredCourses.sort((a, b) {
      int cmp = 0;
      switch (_sortColumnIndex) {
        case 0:
          cmp = a.id.compareTo(b.id);
          break;
        case 1:
          cmp = (a.fullname ?? '').toLowerCase().compareTo((b.fullname ?? '').toLowerCase());
          break;
        case 2:
          cmp = (a.categoryid ?? 0).compareTo(b.categoryid ?? 0);
          break;
        case 3:
          final aDate = a.startDateTime ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bDate = b.startDateTime ?? DateTime.fromMillisecondsSinceEpoch(0);
          cmp = aDate.compareTo(bDate);
          break;
        case 4:
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
    if (_filterCourseType != null) count++;
    if (_filterFormat != null) count++;
    if (_startDateFrom != null || _startDateTo != null) count++;
    if (_modifiedFrom != null || _modifiedTo != null) count++;
    return count;
  }

  void _clearAllFilters() {
    setState(() {
      _filterVisible = null;
      _filterCourseType = null;
      _filterFormat = null;
      _startDateFrom = null;
      _startDateTo = null;
      _modifiedFrom = null;
      _modifiedTo = null;
      _applyFilter();
    });
  }

  Future<void> _exportToExcel() async {
    if (_filteredCourses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nessun corso da esportare con i filtri attuali.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isExporting = true);
    try {
      final resultPath = await CourseExcelExporter.exportCourses(_filteredCourses);
      if (mounted) {
        if (resultPath != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text('Esportati con successo ${_filteredCourses.length} corsi in Excel!'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: _isAdvancedFiltersOpen
          ? null
          : Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: FloatingActionButton(
                shape: const CircleBorder(),
                elevation: 4,
                backgroundColor: const Color(0xFF107C41),
                tooltip: 'Esporta Corsi in Excel (.xlsx)',
                onPressed: _isExporting ? null : _exportToExcel,
                child: _isExporting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Icon(Icons.table_view_rounded, color: Colors.white, size: 24),
              ),
            ),
      body: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Barra Ricerca e Azione Filtri
                      _buildSearchAndFilterBar(),
                      const SizedBox(height: 12),

                      // Barra Chips Filtri Attivi
                      if (_activeFiltersCount > 0) ...[
                        _buildActiveFilterChips(),
                        const SizedBox(height: 12),
                      ],

                      // Contenitore Tabella
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.grey.shade200),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: _isLoading
                                ? const Center(child: CircularProgressIndicator())
                                : _filteredCourses.isEmpty
                                    ? _buildEmptyState()
                                    : Column(
                                        children: [
                                          Expanded(
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
                                                      constraints: const BoxConstraints(minWidth: 950),
                                                      child: _buildDataTable(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const Divider(height: 1, thickness: 1),
                                          _buildPaginationFooter(),
                                        ],
                                      ),
                          ),
                        ),
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
                    minWidth: 340,
                    maxWidth: 340,
                    alignment: Alignment.topRight,
                    child: _buildAdvancedFiltersDrawer(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Search Bar & Filter Button ---
  Widget _buildSearchAndFilterBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade500, size: 20),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          _applyFilter();
                        },
                      )
                    : null,
                hintText: 'Cerca per titolo, codice breve, IDNumber, categoria, tipologia...',
                hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Bottone Filtri Avanzati con contatore
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: _isAdvancedFiltersOpen
              ? const SizedBox.shrink()
              : InkWell(
                  onTap: () => setState(() => _isAdvancedFiltersOpen = true),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 46,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: _activeFiltersCount > 0 ? AppTheme.primaryBlue.withValues(alpha: 0.08) : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _activeFiltersCount > 0 ? AppTheme.primaryBlue : Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.filter_list_rounded,
                          size: 19,
                          color: _activeFiltersCount > 0 ? AppTheme.primaryBlue : Colors.grey.shade700,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Filtri Avanzati',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _activeFiltersCount > 0 ? AppTheme.primaryBlue : Colors.grey.shade800,
                          ),
                        ),
                        if (_activeFiltersCount > 0) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryBlue,
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
                  ),
                ),
        ),
      ],
    );
  }

  // --- Active Filter Chips ---
  Widget _buildActiveFilterChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          'Filtri attivi:',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
        ),
        if (_filterVisible != null)
          _buildChip(
            label: _filterVisible! ? 'Solo Visibili' : 'Solo Nascosti',
            onDeleted: () {
              setState(() {
                _filterVisible = null;
                _applyFilter();
              });
            },
          ),
        if (_filterCourseType != null)
          _buildChip(
            label: 'Tipo: $_filterCourseType',
            onDeleted: () {
              setState(() {
                _filterCourseType = null;
                _applyFilter();
              });
            },
          ),
        if (_filterFormat != null)
          _buildChip(
            label: 'Formato: $_filterFormat',
            onDeleted: () {
              setState(() {
                _filterFormat = null;
                _applyFilter();
              });
            },
          ),
        if (_startDateFrom != null || _startDateTo != null)
          _buildChip(
            label: 'Inizio: ${_formatDateRange(_startDateFrom, _startDateTo)}',
            onDeleted: () {
              setState(() {
                _startDateFrom = null;
                _startDateTo = null;
                _applyFilter();
              });
            },
          ),
        if (_modifiedFrom != null || _modifiedTo != null)
          _buildChip(
            label: 'Modifica: ${_formatDateRange(_modifiedFrom, _modifiedTo)}',
            onDeleted: () {
              setState(() {
                _modifiedFrom = null;
                _modifiedTo = null;
                _applyFilter();
              });
            },
          ),
        if (_activeFiltersCount > 1)
          TextButton(
            onPressed: _clearAllFilters,
            style: TextButton.styleFrom(
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            child: const Text('Cancella tutti', style: TextStyle(fontSize: 12, color: Colors.red)),
          ),
      ],
    );
  }

  Widget _buildChip({required String label, required VoidCallback onDeleted}) {
    return Chip(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      backgroundColor: AppTheme.primaryBlue.withValues(alpha: 0.08),
      side: BorderSide(color: AppTheme.primaryBlue.withValues(alpha: 0.2)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      label: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.primaryBlue),
      ),
      deleteIcon: const Icon(Icons.close, size: 14, color: AppTheme.primaryBlue),
      onDeleted: onDeleted,
    );
  }

  String _formatDateRange(DateTime? from, DateTime? to) {
    final f = DateFormat('dd/MM/yy');
    if (from != null && to != null) return '${f.format(from)} - ${f.format(to)}';
    if (from != null) return 'da ${f.format(from)}';
    if (to != null) return 'fino a ${f.format(to)}';
    return '';
  }

  // --- Data Table (Material 3 Enterprise) ---
  Widget _buildDataTable() {
    return DataTable(
      sortColumnIndex: _sortColumnIndex,
      sortAscending: _sortAscending,
      dataRowMinHeight: 52,
      dataRowMaxHeight: 58,
      headingRowHeight: 46,
      headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
      horizontalMargin: 16,
      columnSpacing: 22,
      dividerThickness: 1,
      columns: [
        const DataColumn(
          label: Text('AZIONI', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.5)),
        ),
        DataColumn(
          label: const Text('ID', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.5)),
          onSort: (idx, asc) => _onSort(0, asc),
        ),
        DataColumn(
          label: const Text('CORSO', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.5)),
          onSort: (idx, asc) => _onSort(1, asc),
        ),
        const DataColumn(
          label: Text('CODICE / SHORTNAME', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.5)),
        ),
        DataColumn(
          label: const Text('CATEGORIA', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.5)),
          onSort: (idx, asc) => _onSort(2, asc),
        ),
        const DataColumn(
          label: Text('TIPOLOGIA', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.5)),
        ),
        const DataColumn(
          label: Text('FORMATO', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.5)),
        ),
        const DataColumn(
          label: Text('STATO', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.5)),
        ),
        DataColumn(
          label: const Text('DATA INIZIO', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.5)),
          onSort: (idx, asc) => _onSort(3, asc),
        ),
      ],
      rows: _paginatedCourses.map((c) {
        return DataRow(
          cells: [
            // 0. Azione Dettaglio
            DataCell(
              Center(
                child: InkWell(
                  onTap: () => _showCourseDetailModal(c),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.visibility_outlined, size: 17, color: AppTheme.primaryBlue),
                  ),
                ),
              ),
            ),
            // 1. ID
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
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                ),
              ),
            ),
            // 2. Corso (Avatar + Titolo completo)
            DataCell(
              InkWell(
                onTap: () => _showCourseDetailModal(c),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.primaryBlue.withValues(alpha: 0.85),
                            AppTheme.primaryBlue,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Icon(Icons.school_rounded, color: Colors.white, size: 18),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 320),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.fullname ?? 'Senza Titolo',
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF0F172A)),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          if (c.idnumber != null && c.idnumber!.isNotEmpty)
                            Text(
                              'IDN: ${c.idnumber}',
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
            ),
            // 3. Codice / Shortname
            DataCell(
              Text(
                c.shortname ?? '-',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF475569)),
              ),
            ),
            // 4. Categoria ID
            DataCell(
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.purple.shade100),
                ),
                child: Text(
                  'Cat: ${c.categoryid ?? 0}',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.purple.shade700),
                ),
              ),
            ),
            // 5. Tipologia
            DataCell(
              c.courseType != null && c.courseType!.isNotEmpty
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Text(
                        c.courseType!.toUpperCase(),
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blue.shade800),
                      ),
                    )
                  : const Text('-', style: TextStyle(color: Colors.grey)),
            ),
            // 6. Formato
            DataCell(
              Text(
                c.format ?? '-',
                style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
              ),
            ),
            // 7. Stato Visibilità
            DataCell(
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: c.isVisible ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: c.isVisible ? const Color(0xFFA7F3D0) : const Color(0xFFFECACA),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: c.isVisible ? const Color(0xFF059669) : const Color(0xFFDC2626),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      c.isVisible ? 'Visibile' : 'Nascosto',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: c.isVisible ? const Color(0xFF065F46) : const Color(0xFF991B1B),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 8. Data Inizio
            DataCell(
              Text(
                c.startDateTime != null
                    ? DateFormat('dd/MM/yyyy').format(c.startDateTime!)
                    : 'N/D',
                style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  // --- Pagination Footer ---
  Widget _buildPaginationFooter() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 560;

        final start = _filteredCourses.isEmpty ? 0 : (_currentPage * _pageSize) + 1;
        final end = math.min((_currentPage + 1) * _pageSize, _filteredCourses.length);

        final textWidget = Text(
          _filteredCourses.length == _allCourses.length
              ? 'Mostrati $start - $end di ${_allCourses.length} corsi'
              : 'Mostrati $start - $end di ${_filteredCourses.length} (filtrati da ${_allCourses.length} totali)',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        );

        final controlsWidget = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.first_page, size: 18),
              onPressed: _currentPage > 0 ? () => setState(() => _currentPage = 0) : null,
              tooltip: 'Prima pagina',
            ),
            IconButton(
              icon: const Icon(Icons.chevron_left, size: 18),
              onPressed: _currentPage > 0 ? () => setState(() => _currentPage--) : null,
              tooltip: 'Pagina precedente',
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${_currentPage + 1} / $_totalPages',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, size: 18),
              onPressed: _currentPage < _totalPages - 1 ? () => setState(() => _currentPage++) : null,
              tooltip: 'Pagina successiva',
            ),
            IconButton(
              icon: const Icon(Icons.last_page, size: 18),
              onPressed: _currentPage < _totalPages - 1 ? () => setState(() => _currentPage = _totalPages - 1) : null,
              tooltip: 'Ultima pagina',
            ),
          ],
        );

        if (isNarrow) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              children: [
                textWidget,
                const SizedBox(height: 6),
                controlsWidget,
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              textWidget,
              controlsWidget,
            ],
          ),
        );
      },
    );
  }

  // --- Empty State ---
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school_outlined, size: 54, color: Colors.grey.shade300),
            const SizedBox(height: 14),
            Text(
              _allCourses.isEmpty ? 'Nessun corso presente nel database locale' : 'Nessun corso corrisponde ai filtri',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 6),
            Text(
              _allCourses.isEmpty
                  ? 'Esegui una sincronizzazione dalla sezione Sync per popolare il catalogo corsi.'
                  : 'Prova a modificare i termini di ricerca o azzera i filtri applicati.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            ),
            if (_activeFiltersCount > 0 || _searchController.text.isNotEmpty) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  _searchController.clear();
                  _clearAllFilters();
                },
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Ripristina filtri'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // --- Advanced Filters Drawer ---
  Widget _buildAdvancedFiltersDrawer() {
    // Lista univoca di tipologie e formati disponibili
    final types = _allCourses.map((c) => c.courseType).where((t) => t != null && t.isNotEmpty).toSet().toList();
    final formats = _allCourses.map((c) => c.format).where((f) => f != null && f.isNotEmpty).toSet().toList();

    return Container(
      width: 340,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: Colors.grey.shade200)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(-4, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Drawer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
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
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    if (_activeFiltersCount > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
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
                  icon: const Icon(Icons.close, color: Colors.white, size: 20),
                  onPressed: () => setState(() => _isAdvancedFiltersOpen = false),
                  tooltip: 'Chiudi pannello',
                ),
              ],
            ),
          ),

          // Contenuto Filtri Scrollabile
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: [
                // 1. Stato Visibilità (Segmented Button 3 Stati)
                const Text(
                  'STATO VISIBILITÀ',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.5),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildSegmentButton(
                      label: 'Tutti',
                      isSelected: _filterVisible == null,
                      onTap: () => setState(() {
                        _filterVisible = null;
                        _applyFilter();
                      }),
                    ),
                    const SizedBox(width: 6),
                    _buildSegmentButton(
                      label: 'Visibile',
                      isSelected: _filterVisible == true,
                      onTap: () => setState(() {
                        _filterVisible = true;
                        _applyFilter();
                      }),
                    ),
                    const SizedBox(width: 6),
                    _buildSegmentButton(
                      label: 'Nascosto',
                      isSelected: _filterVisible == false,
                      onTap: () => setState(() {
                        _filterVisible = false;
                        _applyFilter();
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 2. Tipologia Corso
                if (types.isNotEmpty) ...[
                  const Text(
                    'TIPOLOGIA CORSO',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      FilterChip(
                        selected: _filterCourseType == null,
                        label: const Text('Tutti', style: TextStyle(fontSize: 12)),
                        onSelected: (_) => setState(() {
                          _filterCourseType = null;
                          _applyFilter();
                        }),
                      ),
                      ...types.map(
                        (t) => FilterChip(
                          selected: _filterCourseType == t,
                          label: Text(t!.toUpperCase(), style: const TextStyle(fontSize: 12)),
                          onSelected: (val) => setState(() {
                            _filterCourseType = val ? t : null;
                            _applyFilter();
                          }),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],

                // 3. Formato Corso
                if (formats.isNotEmpty) ...[
                  const Text(
                    'FORMATO',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      FilterChip(
                        selected: _filterFormat == null,
                        label: const Text('Tutti', style: TextStyle(fontSize: 12)),
                        onSelected: (_) => setState(() {
                          _filterFormat = null;
                          _applyFilter();
                        }),
                      ),
                      ...formats.map(
                        (f) => FilterChip(
                          selected: _filterFormat == f,
                          label: Text(f!, style: const TextStyle(fontSize: 12)),
                          onSelected: (val) => setState(() {
                            _filterFormat = val ? f : null;
                            _applyFilter();
                          }),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],

                // 4. Data Inizio
                const Text(
                  'DATA INIZIO CORSO',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.5),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildDatePickerField(
                        label: 'Da',
                        value: _startDateFrom,
                        onChanged: (d) => setState(() {
                          _startDateFrom = d;
                          _applyFilter();
                        }),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildDatePickerField(
                        label: 'A',
                        value: _startDateTo,
                        onChanged: (d) => setState(() {
                          _startDateTo = d;
                          _applyFilter();
                        }),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 5. Data Ultima Modifica
                const Text(
                  'ULTIMA MODIFICA',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.5),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildDatePickerField(
                        label: 'Da',
                        value: _modifiedFrom,
                        onChanged: (d) => setState(() {
                          _modifiedFrom = d;
                          _applyFilter();
                        }),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildDatePickerField(
                        label: 'A',
                        value: _modifiedTo,
                        onChanged: (d) => setState(() {
                          _modifiedTo = d;
                          _applyFilter();
                        }),
                      ),
                    ),
                  ],
                ),
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
                      foregroundColor: Colors.red.shade700,
                      side: BorderSide(color: Colors.red.shade200),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Azzera filtri'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => _isAdvancedFiltersOpen = false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Chiudi'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentButton({required String label, required bool isSelected, required VoidCallback onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryBlue : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppTheme.primaryBlue : Colors.grey.shade300,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickerField({required String label, required DateTime? value, required ValueChanged<DateTime?> onChanged}) {
    final fmt = DateFormat('dd/MM/yy');
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          onChanged(picked);
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                Text(
                  value != null ? fmt.format(value) : 'Seleziona',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: value != null ? FontWeight.w600 : FontWeight.normal,
                    color: value != null ? Colors.black87 : Colors.grey.shade400,
                  ),
                ),
              ],
            ),
            if (value != null)
              InkWell(
                onTap: () => onChanged(null),
                child: const Icon(Icons.close, size: 14, color: Colors.grey),
              )
            else
              const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // --- Modale Dettaglio Corso ---
  void _showCourseDetailModal(Course c) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          clipBehavior: Clip.antiAlias,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680, maxHeight: 720),
            child: Column(
              children: [
                // Header Modale
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
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
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                        ),
                        child: const Center(
                          child: Icon(Icons.school_rounded, color: Colors.white, size: 24),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              c.fullname ?? 'Senza Titolo',
                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Shortname: ${c.shortname ?? '-'} | ID: #${c.id}',
                              style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.8)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: c.isVisible ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          c.isVisible ? 'VISIBILE' : 'NASCOSTO',
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),

                // Contenuto Scrollabile a Card
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      // Card Informazioni Anagrafiche
                      _buildModalSectionCard(
                        title: 'INFORMAZIONI GENERALI',
                        icon: Icons.info_outline_rounded,
                        children: [
                          _buildModalDetailRow('Titolo Completo (Fullname)', c.fullname ?? '-'),
                          _buildModalDetailRow('Nome Visualizzato (Displayname)', c.displayname ?? '-'),
                          _buildModalDetailRow('Nome Breve (Shortname)', c.shortname ?? '-'),
                          _buildModalDetailRow('Codice Identificativo (IDNumber)', c.idnumber?.isNotEmpty == true ? c.idnumber! : '-'),
                          _buildModalDetailRow('Categoria ID', '${c.categoryid ?? 0} (Ordine: ${c.categorysortorder ?? 0})'),
                          _buildModalDetailRow('Formato del Corso', c.format ?? '-'),
                          if (c.courseType != null)
                            _buildModalDetailRow('Tipologia di Erogazione', c.courseType!.toUpperCase()),
                          _buildModalDetailRow('Lingua', c.lang?.isNotEmpty == true ? c.lang! : 'Predefinita di sistema'),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Card Date e Tempistiche
                      _buildModalSectionCard(
                        title: 'DATE & TEMPISTICHE',
                        icon: Icons.event_note_rounded,
                        children: [
                          _buildModalDetailRow(
                            'Data Inizio',
                            c.startDateTime != null ? DateFormat('dd/MM/yyyy HH:mm').format(c.startDateTime!) : 'Non impostata',
                          ),
                          _buildModalDetailRow(
                            'Data Fine',
                            c.endDateTime != null ? DateFormat('dd/MM/yyyy HH:mm').format(c.endDateTime!) : 'Non impostata',
                          ),
                          _buildModalDetailRow(
                            'Data Creazione',
                            c.timecreatedDate != null ? DateFormat('dd/MM/yyyy HH:mm').format(c.timecreatedDate!) : 'N/D',
                          ),
                          _buildModalDetailRow(
                            'Ultima Modifica',
                            c.timemodifiedDate != null ? DateFormat('dd/MM/yyyy HH:mm').format(c.timemodifiedDate!) : 'N/D',
                          ),
                          _buildModalDetailRow(
                            'Ultimo Sync Locale',
                            c.lastSyncedAt != null ? DateFormat('dd/MM/yyyy HH:mm').format(c.lastSyncedAt!) : 'N/D',
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Card Parametri Corso
                      _buildModalSectionCard(
                        title: 'PARAMETRI & OPZIONI DI SISTEMA',
                        icon: Icons.settings_suggest_outlined,
                        children: [
                          _buildModalDetailRow('Numero Sezioni (numsections)', '${c.numsections ?? 0}'),
                          _buildModalDetailRow('Visualizza Voti (showgrades)', c.showgrades == 1 ? 'Sì' : 'No'),
                          _buildModalDetailRow('Visualizza Report (showreports)', c.showreports == 1 ? 'Sì' : 'No'),
                          _buildModalDetailRow('Notizie Recenti (newsitems)', '${c.newsitems ?? 0}'),
                          _buildModalDetailRow('Dimensione Massima Upload (maxbytes)', '${c.maxbytes ?? 0} bytes'),
                          _buildModalDetailRow('Tracciamento Completamento', c.enablecompletion == 1 ? 'Abilitato' : 'Disabilitato'),
                          _buildModalDetailRow('Modalità Gruppo (groupmode)', '${c.groupmode ?? 0}'),
                        ],
                      ),

                      // Card Opzioni Formato
                      if (c.courseformatoptions != null && c.courseformatoptions!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildModalSectionCard(
                          title: 'OPZIONI FORMATO AGGIUNTIVE',
                          icon: Icons.tune_rounded,
                          children: c.courseformatoptions!.map((opt) {
                            return _buildModalDetailRow(opt.name ?? 'Opzione', '${opt.value ?? '-'}');
                          }).toList(),
                        ),
                      ],

                      // Card Campi Personalizzati (Custom Fields)
                      if (c.customfields != null && c.customfields!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildModalSectionCard(
                          title: 'CAMPI PERSONALIZZATI (CUSTOM FIELDS)',
                          icon: Icons.dashboard_customize_outlined,
                          children: c.customfields!.map((cf) {
                            final val = cf.value?.isNotEmpty == true ? cf.value! : (cf.valueraw?.isNotEmpty == true ? cf.valueraw! : 'Non valorizzato');
                            return _buildModalDetailRow('${cf.name ?? cf.shortname ?? "Campo"} (${cf.type ?? "testo"})', val);
                          }).toList(),
                        ),
                      ],

                      // Card Riassunto (Summary)
                      if (c.cleanSummary.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildModalSectionCard(
                          title: 'DESCRIZIONE / RIASSUNTO',
                          icon: Icons.description_outlined,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                c.cleanSummary,
                                style: TextStyle(fontSize: 13, height: 1.5, color: Colors.grey.shade800),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // Footer Modale
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Chiudi'),
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

  Widget _buildModalSectionCard({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppTheme.primaryBlue),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue, letterSpacing: 0.5),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildModalDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade600),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
            ),
          ),
        ],
      ),
    );
  }
}
