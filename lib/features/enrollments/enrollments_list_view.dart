import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:isar_community/isar.dart';

import '../../core/db/isar_provider.dart';
import '../../core/theme/app_theme.dart';
import '../sync/models/course.dart';
import '../sync/models/user.dart';
import '../sync/models/user_course_enrolled.dart';
import 'models/enrollment_item.dart';
import 'services/enrollments_excel_exporter.dart';

class EnrollmentsListView extends ConsumerStatefulWidget {
  const EnrollmentsListView({super.key});

  @override
  ConsumerState<EnrollmentsListView> createState() => _EnrollmentsListViewState();
}

class _EnrollmentsListViewState extends ConsumerState<EnrollmentsListView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  List<EnrollmentItem> _allItems = [];
  List<EnrollmentItem> _filteredItems = [];

  bool _isLoading = true;
  bool _isExporting = false;
  bool _isAdvancedFiltersOpen = false;

  // Paginazione
  static const int _pageSize = 50;
  int _currentPage = 0;

  // Ordinamento: 1: ID, 2: ID Utente, 3: Utente, 4: Email, 5: ID Corso, 6: Corso, 7: Codice, 8: Tipo Corso
  int _sortColumnIndex = 1;
  bool _sortAscending = true;

  // Filtri Avanzati
  String? _filterTipoCorso; // null: Tutti, oppure "async", "sync"
  String? _filterGenere; // null: Tutti, oppure "M", "F"
  int? _filterCourseId; // null: Tutti i corsi
  List<Course> _availableCourses = [];

  StreamSubscription<void>? _enrolledSub;
  StreamSubscription<void>? _coursesSub;
  StreamSubscription<void>? _usersSub;

  @override
  void initState() {
    super.initState();
    _loadData();

    final isar = ref.read(isarProvider);
    _enrolledSub = isar.userCourseEnrolleds.watchLazy().listen((_) => _loadData());
    _coursesSub = isar.courses.watchLazy().listen((_) => _loadData());
    _usersSub = isar.users.watchLazy().listen((_) => _loadData());

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _enrolledSub?.cancel();
    _coursesSub?.cancel();
    _usersSub?.cancel();
    _searchController.dispose();
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final isar = ref.read(isarProvider);
    List<UserCourseEnrolled> rawEnrolled = [];
    Map<int, User> usersMap = {};
    Map<int, Course> coursesMap = {};
    List<Course> coursesList = [];

    try {
      rawEnrolled = await isar.userCourseEnrolleds.where().findAll();
      final usersList = await isar.users.where().findAll();
      for (final u in usersList) {
        usersMap[u.id] = u;
      }
      coursesList = await isar.courses.where().findAll();
      for (final c in coursesList) {
        coursesMap[c.id] = c;
      }
    } catch (e) {
      debugPrint('[EnrollmentsListView] Errore lettura Isar: $e');
    }

    final List<EnrollmentItem> items = [];
    for (final e in rawEnrolled) {
      items.add(EnrollmentItem(
        enrolled: e,
        user: usersMap[e.userId],
        course: coursesMap[e.courseId],
      ));
    }

    if (mounted) {
      setState(() {
        _allItems = items;
        _availableCourses = coursesList;
        _isLoading = false;
        _applyFilters();
      });
    }
  }

  void _onSearchChanged() {
    setState(() {
      _applyFilters();
    });
  }

  void _applyFilters() {
    final query = _searchController.text.trim().toLowerCase();

    List<EnrollmentItem> temp = _allItems.where((item) {
      // 1. Ricerca testuale
      if (query.isNotEmpty) {
        final matchUser = item.userFullName.toLowerCase().contains(query);
        final matchUsername = item.username.toLowerCase().contains(query);
        final matchEmail = item.userEmail.toLowerCase().contains(query);
        final matchCourse = item.courseFullName.toLowerCase().contains(query);
        final matchCode = item.courseShortName.toLowerCase().contains(query);
        final matchIdNumber = item.courseIdNumber.toLowerCase().contains(query);
        final matchId = item.id.toString().contains(query);
        final matchUserId = item.userId.toString().contains(query);
        final matchCourseId = item.courseId.toString().contains(query);

        if (!matchUser &&
            !matchUsername &&
            !matchEmail &&
            !matchCourse &&
            !matchCode &&
            !matchIdNumber &&
            !matchId &&
            !matchUserId &&
            !matchCourseId) {
          return false;
        }
      }

      // 2. Filtro Tipo Corso
      if (_filterTipoCorso != null) {
        if (item.courseType.toLowerCase() != _filterTipoCorso!.toLowerCase()) {
          return false;
        }
      }

      // 3. Filtro Genere
      if (_filterGenere != null) {
        final g = (item.userGender ?? '').trim().toUpperCase();
        if (_filterGenere == 'M' && !(g == 'M' || g == 'UOMO' || g == 'MASCHIO')) {
          return false;
        }
        if (_filterGenere == 'F' && !(g == 'F' || g == 'DONNA' || g == 'FEMMINA')) {
          return false;
        }
      }

      // 4. Filtro Corso
      if (_filterCourseId != null) {
        if (item.courseId != _filterCourseId) {
          return false;
        }
      }

      return true;
    }).toList();

    _sortItems(temp);

    _filteredItems = temp;
    _currentPage = 0;
  }

  void _sortItems(List<EnrollmentItem> list) {
    list.sort((a, b) {
      int cmp = 0;
      switch (_sortColumnIndex) {
        case 1:
          cmp = a.id.compareTo(b.id);
          break;
        case 2:
          cmp = a.userId.compareTo(b.userId);
          break;
        case 3:
          cmp = a.userFullName.toLowerCase().compareTo(b.userFullName.toLowerCase());
          break;
        case 4:
          cmp = a.userEmail.toLowerCase().compareTo(b.userEmail.toLowerCase());
          break;
        case 5:
          cmp = a.courseId.compareTo(b.courseId);
          break;
        case 6:
          cmp = a.courseFullName.toLowerCase().compareTo(b.courseFullName.toLowerCase());
          break;
        case 7:
          cmp = a.courseShortName.toLowerCase().compareTo(b.courseShortName.toLowerCase());
          break;
        case 8:
          cmp = a.courseType.toLowerCase().compareTo(b.courseType.toLowerCase());
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
      _sortItems(_filteredItems);
    });
  }

  int get _totalPages => (_filteredItems.isEmpty) ? 1 : ((_filteredItems.length - 1) ~/ _pageSize) + 1;

  List<EnrollmentItem> get _paginatedItems {
    final start = _currentPage * _pageSize;
    if (start >= _filteredItems.length) return [];
    final end = (start + _pageSize < _filteredItems.length) ? start + _pageSize : _filteredItems.length;
    return _filteredItems.sublist(start, end);
  }

  int get _activeFiltersCount {
    int count = 0;
    if (_filterTipoCorso != null) count++;
    if (_filterGenere != null) count++;
    if (_filterCourseId != null) count++;
    return count;
  }

  void _clearAllFilters() {
    setState(() {
      _filterTipoCorso = null;
      _filterGenere = null;
      _filterCourseId = null;
      _searchController.clear();
      _applyFilters();
    });
  }

  Future<void> _exportToExcel() async {
    if (_filteredItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nessun record disponibile per l\'esportazione.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isExporting = true);
    try {
      final resultPath = await EnrollmentsExcelExporter.exportEnrollments(_filteredItems);
      if (mounted && resultPath != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text('Esportate con successo ${_filteredItems.length} iscrizioni in Excel!'),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF107C41),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore durante l\'esportazione Excel: $e'),
            backgroundColor: AppTheme.accentRed,
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
                backgroundColor: const Color(0xFF107C41),
                elevation: 4,
                tooltip: 'Esporta in Excel',
                onPressed: _isExporting ? null : _exportToExcel,
                child: _isExporting
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                      )
                    : const Icon(Icons.table_view_rounded, color: Colors.white, size: 26),
              ),
            ),
      body: Stack(
        children: [
          Row(
            children: [
              // Area Principale
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Barra Ricerca e Filtri
                      _buildSearchAndFilterBar(),
                      const SizedBox(height: 12),

                      // Chips Filtri Attivi
                      if (_activeFiltersCount > 0 || _searchController.text.isNotEmpty)
                        _buildActiveFilterChips(),

                      const SizedBox(height: 12),

                      // Tabella Dati o Empty State
                      Expanded(
                        child: _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(color: AppTheme.primaryBlue),
                              )
                            : _allItems.isEmpty
                                ? _buildEmptyInitialState()
                                : _filteredItems.isEmpty
                                    ? _buildEmptyFilteredState()
                                    : _buildDataTableCard(),
                      ),

                      const SizedBox(height: 12),

                      // Footer Responsive
                      _buildResponsiveFooter(),
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
                    child: SizedBox(
                      width: 340,
                      child: _buildAdvancedFiltersDrawer(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Search and Filters Bar ---
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(5),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cerca per utente, email, corso, codice o ID...',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13.5),
                prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.primaryBlue, size: 20),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          _applyFilters();
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: _isAdvancedFiltersOpen
              ? const SizedBox.shrink()
              : OutlinedButton.icon(
                  onPressed: () => setState(() => _isAdvancedFiltersOpen = true),
                  icon: Badge(
                    isLabelVisible: _activeFiltersCount > 0,
                    label: Text('$_activeFiltersCount'),
                    backgroundColor: AppTheme.primaryBlue,
                    child: const Icon(Icons.filter_list_rounded, size: 18),
                  ),
                  label: const Text('Filtri Avanzati', style: TextStyle(fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryBlue,
                    side: const BorderSide(color: AppTheme.primaryBlue),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (_searchController.text.isNotEmpty)
          _buildFilterChip(
            label: 'Testo: "${_searchController.text.trim()}"',
            onDeleted: () {
              _searchController.clear();
              _applyFilters();
            },
          ),
        if (_filterTipoCorso != null)
          _buildFilterChip(
            label: 'Tipo: ${_filterTipoCorso!.toUpperCase()}',
            onDeleted: () {
              setState(() {
                _filterTipoCorso = null;
                _applyFilters();
              });
            },
          ),
        if (_filterGenere != null)
          _buildFilterChip(
            label: 'Genere: ${_filterGenere == 'M' ? 'Uomo' : 'Donna'}',
            onDeleted: () {
              setState(() {
                _filterGenere = null;
                _applyFilters();
              });
            },
          ),
        if (_filterCourseId != null)
          _buildFilterChip(
            label: 'Corso: #$_filterCourseId',
            onDeleted: () {
              setState(() {
                _filterCourseId = null;
                _applyFilters();
              });
            },
          ),
        if (_activeFiltersCount > 1 || (_activeFiltersCount >= 1 && _searchController.text.isNotEmpty))
          TextButton(
            onPressed: _clearAllFilters,
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.accentRed,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
            child: const Text('Cancella tutti', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
      ],
    );
  }

  Widget _buildFilterChip({required String label, required VoidCallback onDeleted}) {
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      backgroundColor: AppTheme.primaryBlue.withAlpha(15),
      deleteIcon: const Icon(Icons.close_rounded, size: 15, color: AppTheme.primaryBlue),
      onDeleted: onDeleted,
      side: BorderSide(color: AppTheme.primaryBlue.withAlpha(50)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
    );
  }

  // --- Data Table Card ---
  Widget _buildDataTableCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(4),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Scrollbar(
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
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 1000),
                child: DataTable(
                  sortColumnIndex: _sortColumnIndex,
                  sortAscending: _sortAscending,
                  headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                  headingTextStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: Color(0xFF475569),
                    letterSpacing: 0.5,
                  ),
                  dataRowMinHeight: 52,
                  dataRowMaxHeight: 58,
                  dividerThickness: 1,
                  horizontalMargin: 16,
                  columnSpacing: 20,
                  columns: [
                    const DataColumn(
                      label: Text('AZIONI'),
                    ),
                    DataColumn(
                      label: const Text('ID'),
                      onSort: (col, asc) => _onSort(1, asc),
                    ),
                    DataColumn(
                      label: const Text('ID UTENTE'),
                      onSort: (col, asc) => _onSort(2, asc),
                    ),
                    DataColumn(
                      label: const Text('UTENTE'),
                      onSort: (col, asc) => _onSort(3, asc),
                    ),
                    DataColumn(
                      label: const Text('EMAIL'),
                      onSort: (col, asc) => _onSort(4, asc),
                    ),
                    DataColumn(
                      label: const Text('ID CORSO'),
                      onSort: (col, asc) => _onSort(5, asc),
                    ),
                    DataColumn(
                      label: const Text('CORSO'),
                      onSort: (col, asc) => _onSort(6, asc),
                    ),
                    DataColumn(
                      label: const Text('CODICE'),
                      onSort: (col, asc) => _onSort(7, asc),
                    ),
                    DataColumn(
                      label: const Text('TIPO'),
                      onSort: (col, asc) => _onSort(8, asc),
                    ),
                  ],
                  rows: _paginatedItems.map((item) {
                    return DataRow(
                      cells: [
                        // Colonna Azioni
                        DataCell(
                          Container(
                            decoration: BoxDecoration(
                              color: AppTheme.primaryBlue.withAlpha(15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.visibility_outlined, size: 18, color: AppTheme.primaryBlue),
                              tooltip: 'Dettagli Iscrizione',
                              onPressed: () => _showDetailModal(item),
                            ),
                          ),
                        ),

                        // Colonna ID Iscrizione
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '#${item.id}',
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Color(0xFF334155),
                              ),
                            ),
                          ),
                        ),

                        // Colonna ID Utente
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '#${item.userId}',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.blue.shade800,
                              ),
                            ),
                          ),
                        ),

                        // Cella Utente
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: _generateAvatarColor(item.userFullName),
                                child: Text(
                                  item.userFullName.isNotEmpty ? item.userFullName[0].toUpperCase() : 'U',
                                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 10),
                              ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 180),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      item.userFullName,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      '@${item.username}',
                                      style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Cella Email
                        DataCell(
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 180),
                            child: Text(
                              item.userEmail,
                              style: TextStyle(fontSize: 12.5, color: Colors.grey.shade700),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),

                        // Colonna ID Corso
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '#${item.courseId}',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.purple.shade800,
                              ),
                            ),
                          ),
                        ),

                        // Cella Corso
                        DataCell(
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 240),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  item.courseFullName,
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (item.courseIdNumber != '-')
                                  Text(
                                    'IDNumber: ${item.courseIdNumber}',
                                    style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          ),
                        ),

                        // Codice Corso
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item.courseShortName,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),

                        // Tipo Corso
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: item.courseType.toLowerCase() == 'async'
                                  ? Colors.teal.shade50
                                  : Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: 8,
                                  color: item.courseType.toLowerCase() == 'async'
                                      ? Colors.teal.shade700
                                      : Colors.blue.shade700,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  item.courseType.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: item.courseType.toLowerCase() == 'async'
                                        ? Colors.teal.shade900
                                        : Colors.blue.shade900,
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
    );
  }

  // --- Responsive Footer ---
  Widget _buildResponsiveFooter() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 560;

        final startItem = _filteredItems.isEmpty ? 0 : (_currentPage * _pageSize) + 1;
        final endItem = math.min((_currentPage + 1) * _pageSize, _filteredItems.length);

        final countText = _allItems.length == _filteredItems.length
            ? 'Mostrati $startItem - $endItem di ${_filteredItems.length} iscrizioni'
            : 'Mostrati $startItem - $endItem di ${_filteredItems.length} (filtrate da ${_allItems.length} totali)';

        final textWidget = Text(
          countText,
          style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
        );

        final controlsWidget = Row(
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                '${_currentPage + 1} / $_totalPages',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
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

        if (isCompact) {
          return Column(
            children: [
              textWidget,
              const SizedBox(height: 8),
              controlsWidget,
            ],
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            textWidget,
            controlsWidget,
          ],
        );
      },
    );
  }

  // --- Advanced Filters Drawer ---
  Widget _buildAdvancedFiltersDrawer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: Colors.grey.shade200)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 12,
            offset: const Offset(-2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Drawer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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
                  icon: const Icon(Icons.close_rounded, color: Colors.white70),
                  onPressed: () => setState(() => _isAdvancedFiltersOpen = false),
                  tooltip: 'Chiudi filtri',
                ),
              ],
            ),
          ),

          // Contenuto Filtri
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Filtro Tipo Corso
                const Text(
                  'TIPO CORSO',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569), letterSpacing: 0.5),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildSegmentButton(
                        label: 'Tutti',
                        isSelected: _filterTipoCorso == null,
                        onTap: () {
                          setState(() {
                            _filterTipoCorso = null;
                            _applyFilters();
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: _buildSegmentButton(
                        label: 'Async',
                        isSelected: _filterTipoCorso == 'async',
                        onTap: () {
                          setState(() {
                            _filterTipoCorso = 'async';
                            _applyFilters();
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: _buildSegmentButton(
                        label: 'Sync',
                        isSelected: _filterTipoCorso == 'sync',
                        onTap: () {
                          setState(() {
                            _filterTipoCorso = 'sync';
                            _applyFilters();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Filtro Genere
                const Text(
                  'GENERE UTENTE',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569), letterSpacing: 0.5),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildSegmentButton(
                        label: 'Tutti',
                        isSelected: _filterGenere == null,
                        onTap: () {
                          setState(() {
                            _filterGenere = null;
                            _applyFilters();
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: _buildSegmentButton(
                        label: 'Uomo',
                        isSelected: _filterGenere == 'M',
                        onTap: () {
                          setState(() {
                            _filterGenere = 'M';
                            _applyFilters();
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: _buildSegmentButton(
                        label: 'Donna',
                        isSelected: _filterGenere == 'F',
                        onTap: () {
                          setState(() {
                            _filterGenere = 'F';
                            _applyFilters();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Filtro per Corso
                const Text(
                  'FILTRA PER CORSO',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569), letterSpacing: 0.5),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int?>(
                      isExpanded: true,
                      value: _filterCourseId,
                      hint: const Text('Tutti i corsi', style: TextStyle(fontSize: 13)),
                      items: [
                        const DropdownMenuItem<int?>(
                          value: null,
                          child: Text('Tutti i corsi', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        ),
                        ..._availableCourses.map((c) {
                          return DropdownMenuItem<int?>(
                            value: c.id,
                            child: Text(
                              '#${c.id} - ${c.fullname ?? c.shortname ?? 'Corso'}',
                              style: const TextStyle(fontSize: 12.5),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }),
                      ],
                      onChanged: (val) {
                        setState(() {
                          _filterCourseId = val;
                          _applyFilters();
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Footer Drawer
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
                    onPressed: _activeFiltersCount > 0 ? _clearAllFilters : null,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.accentRed,
                      side: BorderSide(color: _activeFiltersCount > 0 ? AppTheme.accentRed : Colors.grey.shade300),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Azzera', style: TextStyle(fontWeight: FontWeight.bold)),
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

  Widget _buildSegmentButton({required String label, required bool isSelected, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryBlue : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? AppTheme.primaryBlue : Colors.grey.shade300),
        ),
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

  // --- Modale Dettaglio Entità ---
  void _showDetailModal(EnrollmentItem item) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          clipBehavior: Clip.antiAlias,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640, maxHeight: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Modale Istituzionale
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
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(25),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white30, width: 2),
                        ),
                        child: const Icon(Icons.how_to_reg_rounded, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'DETTAGLI ISCRIZIONE',
                              style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Iscrizione #${item.id}',
                              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white70),
                        onPressed: () => Navigator.of(context).pop(),
                        tooltip: 'Chiudi',
                      ),
                    ],
                  ),
                ),

                // Contenuto a schede/card
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card Anagrafica Utente
                        _buildModalCard(
                          title: 'ANAGRAFICA UTENTE (#${item.userId})',
                          icon: Icons.person_outline_rounded,
                          color: AppTheme.primaryBlue,
                          children: [
                            _buildModalRow('Nome Completo', item.userFullName),
                            _buildModalRow('Username', item.username),
                            _buildModalRow('Email', item.userEmail),
                            _buildModalRow('Genere', item.userGender ?? 'Non specificato'),
                            if (item.userDepartment != null)
                              _buildModalRow('Dipartimento', item.userDepartment!),
                            if (item.userInstitution != null)
                              _buildModalRow('Istituzione', item.userInstitution!),
                            if (item.userCity != null)
                              _buildModalRow('Città', item.userCity!),
                            _buildModalRow('Stato Account', item.isUserSuspended ? 'Sospeso' : 'Attivo'),
                          ],
                        ),
                        const SizedBox(height: 18),

                        // Card Dettagli Corso
                        _buildModalCard(
                          title: 'DETTAGLI CORSO (#${item.courseId})',
                          icon: Icons.school_outlined,
                          color: const Color(0xFF0D9488),
                          children: [
                            _buildModalRow('Titolo Completo', item.courseFullName),
                            _buildModalRow('Nome Breve', item.courseShortName),
                            _buildModalRow('Codice IDNumber', item.courseIdNumber),
                            if (item.courseCategoryId != null)
                              _buildModalRow('Categoria ID', '#${item.courseCategoryId}'),
                            _buildModalRow('Tipologia', item.courseType.toUpperCase()),
                            _buildModalRow('Visibilità nel catalogo', item.isCourseVisible ? 'Visibile' : 'Nascosto'),
                            if (item.courseStartDate != null)
                              _buildModalRow('Data Inizio', DateFormat('dd/MM/yyyy HH:mm').format(item.courseStartDate!)),
                            if (item.courseEndDate != null)
                              _buildModalRow('Data Fine', DateFormat('dd/MM/yyyy HH:mm').format(item.courseEndDate!)),
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
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(4),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: color.withAlpha(15),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: Row(
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color, letterSpacing: 0.5),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
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
            width: 160,
            child: Text(
              label,
              style: TextStyle(fontSize: 12.5, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
            ),
          ),
        ],
      ),
    );
  }

  // --- Empty States ---
  Widget _buildEmptyInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.how_to_reg_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text(
            'Nessuna iscrizione presente nel database locale',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
          ),
          const SizedBox(height: 8),
          Text(
            'Esegui una sincronizzazione dalla sezione Impostazioni -> Sync.',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyFilteredState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 56, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text(
            'Nessun risultato trovato con i filtri applicati',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: _clearAllFilters,
            child: const Text('Azzera tutti i filtri'),
          ),
        ],
      ),
    );
  }

  Color _generateAvatarColor(String seed) {
    final colors = [
      AppTheme.primaryBlue,
      const Color(0xFF0D9488),
      const Color(0xFFD97706),
      const Color(0xFF7C3AED),
      const Color(0xFF2563EB),
      const Color(0xFF059669),
      const Color(0xFFDC2626),
    ];
    if (seed.isEmpty) return colors[0];
    return colors[seed.codeUnitAt(0) % colors.length];
  }
}
