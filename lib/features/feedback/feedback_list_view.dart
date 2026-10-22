import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';

import '../../core/db/isar_provider.dart';
import '../../core/theme/app_theme.dart';
import '../sync/models/feedback_for_bi.dart';
import 'services/feedback_excel_exporter.dart';

class FeedbackListView extends ConsumerStatefulWidget {
  const FeedbackListView({super.key});

  @override
  ConsumerState<FeedbackListView> createState() => _FeedbackListViewState();
}

class _FeedbackListViewState extends ConsumerState<FeedbackListView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  List<FeedbackForBi> _allItems = [];
  List<FeedbackForBi> _filteredItems = [];

  bool _isLoading = true;
  bool _isExporting = false;
  bool _isAdvancedFiltersOpen = false;

  // Paginazione
  static const int _pageSize = 50;
  int _currentPage = 0;

  // Ordinamento: 1: ID, 2: ID Corso, 3: Corso, 4: Feedback, 5: Lingua, 6: HQ1, 7: HQ2, 8: HQ3, 9: HQ4, 10: Media
  int _sortColumnIndex = 1;
  bool _sortAscending = true;

  // Filtri Avanzati
  final Set<int> _selectedCourseIds = {};
  String? _filterLang; // null: Tutti, oppure "IT", "EN", ecc.
  bool? _filterHasText; // null: Tutti, true: Con testo, false: Senza testo
  int? _filterMinRating; // null: Tutti, oppure 3, 4, 5

  StreamSubscription<void>? _feedbackSub;

  @override
  void initState() {
    super.initState();
    _loadFeedback();
    final isar = ref.read(isarProvider);
    _feedbackSub = isar.feedbackForBis.watchLazy().listen((_) => _loadFeedback());
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _feedbackSub?.cancel();
    _searchController.dispose();
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  Future<void> _loadFeedback() async {
    final isar = ref.read(isarProvider);
    List<FeedbackForBi> list;
    try {
      list = await isar.feedbackForBis.where().findAll();
    } catch (e) {
      debugPrint('[FeedbackListView] Errore lettura Isar: $e');
      try {
        await isar.writeTxn(() async => await isar.feedbackForBis.clear());
      } catch (_) {}
      list = [];
    }
    if (mounted) {
      setState(() {
        _allItems = list;
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

    List<FeedbackForBi> results = _allItems.where((item) {
      // 1. Ricerca testuale
      if (query.isNotEmpty) {
        final idStr = item.id.toString();
        final courseIdStr = item.courseId?.toString() ?? '';
        final courseName = (item.courseName ?? '').toLowerCase();
        final feedbackName = (item.feedbackName ?? '').toLowerCase();
        final lang = (item.lang ?? '').toLowerCase();
        final text = (item.text ?? '').toLowerCase();

        final matches = idStr.contains(query) ||
            courseIdStr.contains(query) ||
            courseName.contains(query) ||
            feedbackName.contains(query) ||
            lang.contains(query) ||
            text.contains(query);

        if (!matches) return false;
      }

      // 2. Filtro Corso
      if (_selectedCourseIds.isNotEmpty) {
        if (item.courseId == null || !_selectedCourseIds.contains(item.courseId)) {
          return false;
        }
      }

      // 3. Filtro Lingua
      if (_filterLang != null) {
        if ((item.lang ?? '').toUpperCase() != _filterLang!.toUpperCase()) {
          return false;
        }
      }

      // 4. Filtro Presenza Testo (3 segmenti: Tutti / Con testo / Senza testo)
      if (_filterHasText != null) {
        final textVal = (item.text ?? '').trim().toLowerCase();
        final hasValidComment = textVal.isNotEmpty && textVal != 'no' && textVal != 'none' && textVal != 'n/a' && textVal != '-';
        if (_filterHasText! && !hasValidComment) return false;
        if (!_filterHasText! && hasValidComment) return false;
      }

      // 5. Filtro Punteggio Minimo Media HQ
      if (_filterMinRating != null) {
        final avg = _calculateAverage(item);
        if (avg == null || avg < _filterMinRating!) return false;
      }

      return true;
    }).toList();

    // Ordinamento
    results.sort((a, b) {
      int cmp = 0;
      switch (_sortColumnIndex) {
        case 1: // ID
          cmp = a.id.compareTo(b.id);
          break;
        case 2: // ID Corso
          cmp = (a.courseId ?? 0).compareTo(b.courseId ?? 0);
          break;
        case 3: // Corso
          cmp = (a.courseName ?? '').compareTo(b.courseName ?? '');
          break;
        case 4: // Feedback
          cmp = (a.feedbackName ?? '').compareTo(b.feedbackName ?? '');
          break;
        case 5: // Lingua
          cmp = (a.lang ?? '').compareTo(b.lang ?? '');
          break;
        case 6: // HQ1
          cmp = (a.hq1 ?? 0).compareTo(b.hq1 ?? 0);
          break;
        case 7: // HQ2
          cmp = (a.hq2 ?? 0).compareTo(b.hq2 ?? 0);
          break;
        case 8: // HQ3
          cmp = (a.hq3 ?? 0).compareTo(b.hq3 ?? 0);
          break;
        case 9: // HQ4
          cmp = (a.hq4 ?? 0).compareTo(b.hq4 ?? 0);
          break;
        case 10: // Media
          final avgA = _calculateAverage(a) ?? 0.0;
          final avgB = _calculateAverage(b) ?? 0.0;
          cmp = avgA.compareTo(avgB);
          break;
        default:
          cmp = a.id.compareTo(b.id);
      }
      return _sortAscending ? cmp : -cmp;
    });

    _filteredItems = results;
    _currentPage = 0;
  }

  double? _calculateAverage(FeedbackForBi item) {
    final validHqs = [item.hq1, item.hq2, item.hq3, item.hq4].whereType<int>().toList();
    if (validHqs.isEmpty) return null;
    return validHqs.reduce((a, b) => a + b) / validHqs.length;
  }

  void _onSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      _applyFilters();
    });
  }

  int get _activeFiltersCount {
    int count = 0;
    if (_selectedCourseIds.isNotEmpty) count++;
    if (_filterLang != null) count++;
    if (_filterHasText != null) count++;
    if (_filterMinRating != null) count++;
    return count;
  }

  void _clearAllFilters() {
    setState(() {
      _selectedCourseIds.clear();
      _filterLang = null;
      _filterHasText = null;
      _filterMinRating = null;
      _applyFilters();
    });
  }

  Future<void> _exportToExcel() async {
    if (_filteredItems.isEmpty || _isExporting) return;
    setState(() => _isExporting = true);
    try {
      final savedPath = await FeedbackExcelExporter.exportFeedback(_filteredItems);
      if (mounted && savedPath != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Esportazione Excel completata: $savedPath'),
            backgroundColor: Colors.green.shade700,
            behavior: SnackBarBehavior.floating,
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
      if (mounted) setState(() => _isExporting = false);
    }
  }

  int get _totalPages => (_filteredItems.length / _pageSize).ceil().clamp(1, 99999);

  List<FeedbackForBi> get _paginatedItems {
    final startIndex = _currentPage * _pageSize;
    if (startIndex >= _filteredItems.length) return [];
    final endIndex = math.min(startIndex + _pageSize, _filteredItems.length);
    return _filteredItems.sublist(startIndex, endIndex);
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
                tooltip: 'Esporta in Excel (${_filteredItems.length} feedback)',
                onPressed: _exportToExcel,
                child: _isExporting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.2),
                      )
                    : const Icon(Icons.table_view_rounded, size: 24),
              ),
            ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 700;

          return Row(
            children: [
              // Area Tabella Principale
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(isCompact ? 16 : 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Barra Ricerca e Pulsante Filtri
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Cerca per corso, ID, feedback, lingua o testo...',
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
                            if (_selectedCourseIds.isNotEmpty)
                              _buildActiveFilterChip(
                                label: 'Corsi: ${_selectedCourseIds.length} selezionati',
                                onDeleted: () => setState(() {
                                  _selectedCourseIds.clear();
                                  _applyFilters();
                                }),
                              ),
                            if (_filterLang != null)
                              _buildActiveFilterChip(
                                label: 'Lingua: $_filterLang',
                                onDeleted: () => setState(() {
                                  _filterLang = null;
                                  _applyFilters();
                                }),
                              ),
                            if (_filterHasText != null)
                              _buildActiveFilterChip(
                                label: 'Commento: ${_filterHasText! ? "Con testo" : "Senza testo"}',
                                onDeleted: () => setState(() {
                                  _filterHasText = null;
                                  _applyFilters();
                                }),
                              ),
                            if (_filterMinRating != null)
                              _buildActiveFilterChip(
                                label: 'Media HQ >= $_filterMinRating★',
                                onDeleted: () => setState(() {
                                  _filterMinRating = null;
                                  _applyFilters();
                                }),
                              ),
                            if (_activeFiltersCount > 1)
                              TextButton.icon(
                                onPressed: _clearAllFilters,
                                icon: const Icon(Icons.close_rounded, size: 16),
                                label: const Text('Cancella tutti', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 16),

                      // Tabella Dati Enterprise
                      Expanded(
                        child: _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: Colors.grey.shade200),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(5),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: _filteredItems.isEmpty
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
                                                      constraints: BoxConstraints(minWidth: constraints.maxWidth - 64),
                                                      child: DataTable(
                                                        border: null,
                                                        dividerThickness: 1,
                                                        headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                                                        headingRowHeight: 46,
                                                        dataRowMinHeight: 52,
                                                        dataRowMaxHeight: 58,
                                                        sortColumnIndex: _sortColumnIndex,
                                                        sortAscending: _sortAscending,
                                                        columns: [
                                                          const DataColumn(
                                                            label: Text(
                                                              'AZIONI',
                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5),
                                                            ),
                                                          ),
                                                          DataColumn(
                                                            label: const Text(
                                                              'ID',
                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5),
                                                            ),
                                                            onSort: _onSort,
                                                          ),
                                                          DataColumn(
                                                            label: const Text(
                                                              'CORSO',
                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5),
                                                            ),
                                                            onSort: _onSort,
                                                          ),
                                                          DataColumn(
                                                            label: const Text(
                                                              'NOME FEEDBACK',
                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5),
                                                            ),
                                                            onSort: _onSort,
                                                          ),
                                                          DataColumn(
                                                            label: const Text(
                                                              'LINGUA',
                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5),
                                                            ),
                                                            onSort: _onSort,
                                                          ),
                                                          DataColumn(
                                                            label: const Text(
                                                              'HQ1',
                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5),
                                                            ),
                                                            numeric: true,
                                                            onSort: _onSort,
                                                          ),
                                                          DataColumn(
                                                            label: const Text(
                                                              'HQ2',
                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5),
                                                            ),
                                                            numeric: true,
                                                            onSort: _onSort,
                                                          ),
                                                          DataColumn(
                                                            label: const Text(
                                                              'HQ3',
                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5),
                                                            ),
                                                            numeric: true,
                                                            onSort: _onSort,
                                                          ),
                                                          DataColumn(
                                                            label: const Text(
                                                              'HQ4',
                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5),
                                                            ),
                                                            numeric: true,
                                                            onSort: _onSort,
                                                          ),
                                                          DataColumn(
                                                            label: const Text(
                                                              'MEDIA HQ',
                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5),
                                                            ),
                                                            numeric: true,
                                                            onSort: _onSort,
                                                          ),
                                                          const DataColumn(
                                                            label: Text(
                                                              'COMMENTO TESTUALE',
                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5),
                                                            ),
                                                          ),
                                                        ],
                                                        rows: _paginatedItems.map((item) {
                                                          return _buildDataRow(item);
                                                        }).toList(),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Footer Paginazione
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF8FAFC),
                                              border: Border(top: BorderSide(color: Colors.grey.shade200)),
                                            ),
                                            child: _buildFooterPagination(),
                                          ),
                                        ],
                                      ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),

              // Drawer Laterale Filtri Avanzati (340px ↔ 0px)
              ClipRect(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.fastOutSlowIn,
                  width: _isAdvancedFiltersOpen ? 340 : 0,
                  child: OverflowBox(
                    minWidth: 340,
                    maxWidth: 340,
                    alignment: Alignment.topRight,
                    child: Container(
                      width: 340,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(left: BorderSide(color: Colors.grey.shade200)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(10),
                            blurRadius: 16,
                            offset: const Offset(-4, 0),
                          ),
                        ],
                      ),
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

  DataRow _buildDataRow(FeedbackForBi item) {
    final avg = _calculateAverage(item);
    final textVal = (item.text ?? '').trim();
    final hasValidComment = textVal.isNotEmpty && textVal.toLowerCase() != 'no' && textVal.toLowerCase() != 'none';

    return DataRow(
      cells: [
        // 0. Azioni (Dettaglio)
        DataCell(
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withAlpha(20),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.visibility_rounded, size: 16, color: AppTheme.primaryBlue),
            ),
            tooltip: 'Visualizza dettagli feedback',
            onPressed: () => _showDetailModal(item),
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
              '#${item.id}',
              style: TextStyle(fontFamily: 'monospace', fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
            ),
          ),
        ),
        // 2. Corso
        DataCell(
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 240),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.courseName ?? 'N/D',
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  item.courseId != null ? 'ID Corso: #${item.courseId}' : 'ID N/D',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ),
        // 3. Feedback
        DataCell(
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 180),
            child: Text(
              item.feedbackName ?? 'N/D',
              style: const TextStyle(fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        // 4. Lingua
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF0284C7).withAlpha(20),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFF0284C7).withAlpha(60)),
            ),
            child: Text(
              (item.lang ?? 'N/D').toUpperCase(),
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0284C7)),
            ),
          ),
        ),
        // 5. HQ1
        DataCell(_buildRatingPill(item.hq1)),
        // 6. HQ2
        DataCell(_buildRatingPill(item.hq2)),
        // 7. HQ3
        DataCell(_buildRatingPill(item.hq3)),
        // 8. HQ4
        DataCell(_buildRatingPill(item.hq4)),
        // 9. Media
        DataCell(
          avg != null
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _getRatingColor(avg.round()).withAlpha(25),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: _getRatingColor(avg.round()).withAlpha(80)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star_rounded, size: 14, color: _getRatingColor(avg.round())),
                      const SizedBox(width: 4),
                      Text(
                        avg.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _getRatingColor(avg.round()),
                        ),
                      ),
                    ],
                  ),
                )
              : const Text('-', style: TextStyle(color: Colors.grey)),
        ),
        // 10. Commento
        DataCell(
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 220),
            child: hasValidComment
                ? Tooltip(
                    message: textVal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.chat_bubble_outline_rounded, size: 15, color: AppTheme.primaryBlue),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            textVal,
                            style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  )
                : Text(
                    textVal.isEmpty ? 'Nessun testo' : textVal,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingPill(int? score) {
    if (score == null) return const Text('-', style: TextStyle(color: Colors.grey));
    final color = _getRatingColor(score);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Text(
        '$score',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }

  Color _getRatingColor(int score) {
    if (score >= 4) return Colors.green.shade700;
    if (score == 3) return Colors.amber.shade800;
    return Colors.red.shade700;
  }

  Widget _buildActiveFilterChip({required String label, required VoidCallback onDeleted}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withAlpha(20),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryBlue.withAlpha(60)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.primaryBlue)),
          const SizedBox(width: 4),
          InkWell(
            onTap: onDeleted,
            child: const Icon(Icons.close_rounded, size: 14, color: AppTheme.primaryBlue),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterPagination() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 560;

        final totalFiltered = _filteredItems.length;
        final startItem = totalFiltered == 0 ? 0 : (_currentPage * _pageSize) + 1;
        final endItem = math.min((_currentPage + 1) * _pageSize, totalFiltered);

        final textInfo = Text(
          totalFiltered == _allItems.length
              ? 'Mostrati $startItem - $endItem di $totalFiltered feedback'
              : 'Mostrati $startItem - $endItem di $totalFiltered (filtrati da ${_allItems.length} totali)',
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              textInfo,
              const SizedBox(height: 8),
              paginationControls,
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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.rate_review_outlined, size: 54, color: Colors.grey.shade300),
            const SizedBox(height: 14),
            Text(
              _allItems.isEmpty ? 'Nessun feedback presente in locale' : 'Nessun feedback corrisponde ai criteri',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 6),
            Text(
              _allItems.isEmpty
                  ? 'Esegui una sincronizzazione dalla sezione Sync per scaricare i dati.'
                  : 'Prova a modificare i filtri o la ricerca per visualizzare i risultati.',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedFiltersDrawer() {
    final availableCoursesMap = <int, String>{};
    final availableLangs = <String>{};

    for (final item in _allItems) {
      if (item.courseId != null) {
        availableCoursesMap[item.courseId!] = item.courseName ?? 'Corso #${item.courseId}';
      }
      if (item.lang != null && item.lang!.trim().isNotEmpty) {
        availableLangs.add(item.lang!.trim().toUpperCase());
      }
    }

    return Column(
      children: [
        // Header con gradiente istituzionale
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
            children: [
              const Icon(Icons.tune_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Filtri Avanzati',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              if (_activeFiltersCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.accentRed,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$_activeFiltersCount attivi',
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white70, size: 20),
                onPressed: () => setState(() => _isAdvancedFiltersOpen = false),
                tooltip: 'Chiudi filtri',
              ),
            ],
          ),
        ),

        // Contenuto Filtri
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              // 1. Filtro Corso (Multi-selezione)
              const Text(
                'CORSO FORMATIVO',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => _openCourseSelectorModal(availableCoursesMap),
                icon: const Icon(Icons.school_outlined, size: 18),
                label: Text(
                  _selectedCourseIds.isEmpty
                      ? 'Tutti i corsi (${availableCoursesMap.length})'
                      : '${_selectedCourseIds.length} corsi selezionati',
                  overflow: TextOverflow.ellipsis,
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              if (_selectedCourseIds.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _selectedCourseIds.map((id) {
                    final name = availableCoursesMap[id] ?? '#$id';
                    return Chip(
                      label: Text(name, style: const TextStyle(fontSize: 11)),
                      onDeleted: () => setState(() {
                        _selectedCourseIds.remove(id);
                        _applyFilters();
                      }),
                      deleteIconColor: Colors.grey.shade600,
                      backgroundColor: Colors.grey.shade100,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                    );
                  }).toList(),
                ),
              ],

              const SizedBox(height: 20),

              // 2. Filtro Lingua
              const Text(
                'LINGUA FEEDBACK',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('Tutte'),
                    selected: _filterLang == null,
                    onSelected: (val) => setState(() {
                      _filterLang = null;
                      _applyFilters();
                    }),
                  ),
                  for (final lang in availableLangs)
                    ChoiceChip(
                      label: Text(lang),
                      selected: _filterLang == lang,
                      onSelected: (val) => setState(() {
                        _filterLang = val ? lang : null;
                        _applyFilters();
                      }),
                    ),
                ],
              ),

              const SizedBox(height: 20),

              // 3. Filtro Commento Testuale a 3 segmenti [ Tutti ] [ Con testo ] [ Senza testo ]
              const Text(
                'COMMENTO TESTUALE',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5),
              ),
              const SizedBox(height: 8),
              SegmentedButton<bool?>(
                segments: const [
                  ButtonSegment<bool?>(value: null, label: Text('Tutti', style: TextStyle(fontSize: 12))),
                  ButtonSegment<bool?>(value: true, label: Text('Con testo', style: TextStyle(fontSize: 12))),
                  ButtonSegment<bool?>(value: false, label: Text('Senza testo', style: TextStyle(fontSize: 12))),
                ],
                selected: {_filterHasText},
                onSelectionChanged: (newVal) {
                  setState(() {
                    _filterHasText = newVal.first;
                    _applyFilters();
                  });
                },
              ),

              const SizedBox(height: 20),

              // 4. Filtro Punteggio Minimo HQ
              const Text(
                'PUNTEGGIO MINIMO MEDIA HQ',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('Tutti'),
                    selected: _filterMinRating == null,
                    onSelected: (val) => setState(() {
                      _filterMinRating = null;
                      _applyFilters();
                    }),
                  ),
                  ChoiceChip(
                    label: const Text('>= 3 ★'),
                    selected: _filterMinRating == 3,
                    onSelected: (val) => setState(() {
                      _filterMinRating = val ? 3 : null;
                      _applyFilters();
                    }),
                  ),
                  ChoiceChip(
                    label: const Text('>= 4 ★'),
                    selected: _filterMinRating == 4,
                    onSelected: (val) => setState(() {
                      _filterMinRating = val ? 4 : null;
                      _applyFilters();
                    }),
                  ),
                  ChoiceChip(
                    label: const Text('5 ★'),
                    selected: _filterMinRating == 5,
                    onSelected: (val) => setState(() {
                      _filterMinRating = val ? 5 : null;
                      _applyFilters();
                    }),
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
            color: const Color(0xFFF8FAFC),
            border: Border(top: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _activeFiltersCount > 0 ? _clearAllFilters : null,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Azzera filtri'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => setState(() => _isAdvancedFiltersOpen = false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Chiudi'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _openCourseSelectorModal(Map<int, String> coursesMap) {
    final searchCtrl = TextEditingController();
    final tempSelected = Set<int>.from(_selectedCourseIds);

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filterText = searchCtrl.text.toLowerCase().trim();
            final filteredEntries = coursesMap.entries.where((entry) {
              if (filterText.isEmpty) return true;
              return entry.value.toLowerCase().contains(filterText) || entry.key.toString().contains(filterText);
            }).toList();

            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              titlePadding: EdgeInsets.zero,
              title: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.school_outlined, color: Colors.white),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Seleziona Corsi',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white70),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
              ),
              content: SizedBox(
                width: 480,
                height: 400,
                child: Column(
                  children: [
                    TextField(
                      controller: searchCtrl,
                      decoration: InputDecoration(
                        hintText: 'Cerca corso per nome o ID...',
                        prefixIcon: const Icon(Icons.search_rounded),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      ),
                      onChanged: (_) => setModalState(() {}),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              for (final e in filteredEntries) {
                                tempSelected.add(e.key);
                              }
                            });
                          },
                          child: const Text('Seleziona visibili'),
                        ),
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              tempSelected.clear();
                            });
                          },
                          child: const Text('Deseleziona tutti'),
                        ),
                      ],
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredEntries.length,
                        itemBuilder: (context, idx) {
                          final item = filteredEntries[idx];
                          final isChecked = tempSelected.contains(item.key);
                          return CheckboxListTile(
                            value: isChecked,
                            title: Text(item.value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                            subtitle: Text('ID #${item.key}', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                            onChanged: (val) {
                              setModalState(() {
                                if (val == true) {
                                  tempSelected.add(item.key);
                                } else {
                                  tempSelected.remove(item.key);
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
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedCourseIds.clear();
                      _selectedCourseIds.addAll(tempSelected);
                      _applyFilters();
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

  void _showDetailModal(FeedbackForBi item) {
    final avg = _calculateAverage(item);

    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header istituzionale con icona
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(20),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.rate_review_rounded, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.feedbackName ?? 'Dettaglio Feedback',
                              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Record #${item.id} • Lingua: ${(item.lang ?? "N/D").toUpperCase()}',
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white70),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                ),

                // Contenuto a card
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Card Corso
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.school_rounded, color: AppTheme.primaryBlue, size: 28),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('CORSO ASSOCIATO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5)),
                                  const SizedBox(height: 2),
                                  Text(item.courseName ?? 'N/D', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                  Text('ID Corso: #${item.courseId ?? "N/D"}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Griglia Punteggi HQ
                      const Text(
                        'VALUTAZIONI DEL QUESTIONARIO (HQ1 - HQ4)',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5),
                      ),
                      const SizedBox(height: 10),

                      Row(
                        children: [
                          _buildScoreCard('HQ1', item.hq1),
                          const SizedBox(width: 10),
                          _buildScoreCard('HQ2', item.hq2),
                          const SizedBox(width: 10),
                          _buildScoreCard('HQ3', item.hq3),
                          const SizedBox(width: 10),
                          _buildScoreCard('HQ4', item.hq4),
                          const SizedBox(width: 10),
                          _buildScoreCard('Media', avg != null ? double.parse(avg.toStringAsFixed(1)) : null, isAvg: true),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // Card Commento Testuale
                      const Text(
                        'COMMENTO TESTUALE / SUGGERIMENTI',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Text(
                          (item.text != null && item.text!.trim().isNotEmpty) ? item.text! : 'Nessun commento testuale rilasciato.',
                          style: TextStyle(
                            fontSize: 13,
                            color: (item.text != null && item.text!.trim().isNotEmpty) ? Colors.grey.shade900 : Colors.grey.shade500,
                            fontStyle: (item.text != null && item.text!.trim().isNotEmpty) ? FontStyle.normal : FontStyle.italic,
                          ),
                        ),
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

  Widget _buildScoreCard(String label, num? score, {bool isAvg = false}) {
    final color = score != null ? _getRatingColor(score.round()) : Colors.grey;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isAvg ? color.withAlpha(20) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isAvg ? color.withAlpha(80) : Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isAvg ? color : Colors.grey.shade700)),
            const SizedBox(height: 4),
            Text(
              score != null ? '$score' : '-',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
