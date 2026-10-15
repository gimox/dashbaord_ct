import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:isar_community/isar.dart';

import '../../core/db/isar_provider.dart';
import '../../core/theme/app_theme.dart';
import '../sync/models/badge_user.dart';
import '../sync/models/user.dart';
import 'services/badge_excel_exporter.dart';

class BadgesListView extends ConsumerStatefulWidget {
  const BadgesListView({super.key});

  @override
  ConsumerState<BadgesListView> createState() => _BadgesListViewState();
}

class _BadgesListViewState extends ConsumerState<BadgesListView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  List<BadgeUser> _allBadges = [];
  List<BadgeUser> _filteredBadges = [];

  bool _isLoading = true;
  bool _isExporting = false;
  bool _isAdvancedFiltersOpen = false;

  // Paginazione
  static const int _pageSize = 50;
  int _currentPage = 0;

  // Ordinamento: 1: Utente, 2: Badge, 3: Codice, 4: Data Emissione
  int _sortColumnIndex = 1;
  bool _sortAscending = true;

  // Filtri Avanzati
  final Set<String> _selectedBadgeNames = {};
  bool? _filterHasCode; // null: Tutti, true: Con codice, false: Senza codice
  DateTime? _issuedFrom;
  DateTime? _issuedTo;

  StreamSubscription<void>? _badgesSub;
  StreamSubscription<void>? _usersSub;
  Map<String, User> _usersByEmail = {};

  @override
  void initState() {
    super.initState();
    _loadBadges();
    final isar = ref.read(isarProvider);
    _badgesSub = isar.badgeUsers.watchLazy().listen((_) => _loadBadges());
    _usersSub = isar.users.watchLazy().listen((_) => _loadBadges());
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _badgesSub?.cancel();
    _usersSub?.cancel();
    _searchController.dispose();
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  Future<void> _loadBadges() async {
    final isar = ref.read(isarProvider);
    List<BadgeUser> list;
    final Map<String, User> usersMap = {};
    try {
      list = await isar.badgeUsers.where().findAll();
      final usersList = await isar.users.where().findAll();
      for (final u in usersList) {
        if (u.email != null && u.email!.trim().isNotEmpty) {
          usersMap[u.email!.trim().toLowerCase()] = u;
        }
      }
    } catch (e) {
      debugPrint('[BadgesListView] Errore lettura Isar: $e');
      try {
        await isar.writeTxn(() async => await isar.badgeUsers.clear());
      } catch (_) {}
      list = [];
    }
    if (mounted) {
      setState(() {
        _allBadges = list;
        _usersByEmail = usersMap;
        _isLoading = false;
        _applyFilter();
      });
    }
  }

  String _getUserFullName(BadgeUser b) {
    final u = _usersByEmail[b.email?.trim().toLowerCase()];
    if (u != null) {
      if (u.fullname != null && u.fullname!.trim().isNotEmpty) {
        return u.fullname!.trim();
      }
      final first = u.firstname ?? '';
      final last = u.lastname ?? '';
      final combined = '$first $last'.trim();
      if (combined.isNotEmpty) return combined;
    }
    return 'N/D';
  }

  String _getInitials(String name) {
    if (name.isEmpty || name == 'N/D') return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  Color _getAvatarColor(String email) {
    final hash = email.hashCode.abs();
    const colors = [
      Color(0xFF2563EB),
      Color(0xFF7C3AED),
      Color(0xFF059669),
      Color(0xFFD97706),
      Color(0xFFDC2626),
      Color(0xFF0891B2),
      Color(0xFF4F46E5),
    ];
    return colors[hash % colors.length];
  }

  void _onSearchChanged() {
    setState(() {
      _applyFilter();
    });
  }

  int get _totalPages => (_filteredBadges.isEmpty) ? 1 : ((_filteredBadges.length - 1) ~/ _pageSize) + 1;

  List<BadgeUser> get _paginatedBadges {
    final start = _currentPage * _pageSize;
    if (start >= _filteredBadges.length) return [];
    final end = (start + _pageSize < _filteredBadges.length) ? start + _pageSize : _filteredBadges.length;
    return _filteredBadges.sublist(start, end);
  }

  void _applyFilter() {
    final query = _searchController.text.trim().toLowerCase();
    _filteredBadges = _allBadges.where((b) {
      // 1. Ricerca generale
      if (query.isNotEmpty) {
        final badge = (b.badge ?? '').toLowerCase();
        final code = (b.code ?? '').toLowerCase();
        final email = (b.email ?? '').toLowerCase();
        final issued = (b.issuedOn ?? '').toLowerCase();
        final u = _usersByEmail[b.email?.trim().toLowerCase()];
        final userName = (u?.fullname ?? '${u?.firstname ?? ''} ${u?.lastname ?? ''}').toLowerCase();

        final matches = userName.contains(query) ||
            badge.contains(query) ||
            code.contains(query) ||
            email.contains(query) ||
            issued.contains(query);
        if (!matches) return false;
      }

      // 2. Filtro per nome Badge
      if (_selectedBadgeNames.isNotEmpty) {
        final name = b.badge ?? '';
        if (!_selectedBadgeNames.contains(name)) return false;
      }

      // 3. Filtro Presenza Codice
      if (_filterHasCode != null) {
        final hasCode = b.code != null && b.code!.trim().isNotEmpty;
        if (hasCode != _filterHasCode) return false;
      }

      // 4. Data Rilascio
      if (_issuedFrom != null || _issuedTo != null) {
        final date = b.issuedOnDate;
        if (date == null) return false;
        if (_issuedFrom != null && date.isBefore(_issuedFrom!)) return false;
        if (_issuedTo != null && date.isAfter(_issuedTo!.add(const Duration(days: 1)))) return false;
      }

      return true;
    }).toList();

    _currentPage = 0;
    _applySorting();
  }

  void _applySorting() {
    _filteredBadges.sort((a, b) {
      int cmp = 0;
      switch (_sortColumnIndex) {
        case 1:
          // Utente (Nome e Cognome)
          final nameA = _getUserFullName(a).toLowerCase();
          final nameB = _getUserFullName(b).toLowerCase();
          cmp = nameA.compareTo(nameB);
          break;
        case 2:
          cmp = (a.badge ?? '').toLowerCase().compareTo((b.badge ?? '').toLowerCase());
          break;
        case 3:
          cmp = (a.code ?? '').toLowerCase().compareTo((b.code ?? '').toLowerCase());
          break;
        case 4:
          final aDate = a.issuedOnDate ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bDate = b.issuedOnDate ?? DateTime.fromMillisecondsSinceEpoch(0);
          cmp = aDate.compareTo(bDate);
          break;
        default:
          cmp = 0;
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
    if (_selectedBadgeNames.isNotEmpty) count++;
    if (_filterHasCode != null) count++;
    if (_issuedFrom != null || _issuedTo != null) count++;
    return count;
  }

  void _clearAllFilters() {
    setState(() {
      _selectedBadgeNames.clear();
      _filterHasCode = null;
      _issuedFrom = null;
      _issuedTo = null;
      _applyFilter();
    });
  }

  Future<void> _exportToExcel() async {
    if (_filteredBadges.isEmpty || _isExporting) return;
    setState(() => _isExporting = true);
    try {
      final savedPath = await BadgeExcelExporter.exportBadges(_filteredBadges, _usersByEmail);
      if (mounted) {
        if (savedPath != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Esportazione Excel completata: $savedPath'),
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
            content: Text('Errore durante esportazione Excel: $e'),
            backgroundColor: AppTheme.accentRed,
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
      backgroundColor: AppTheme.background,
      floatingActionButton: _isAdvancedFiltersOpen
          ? null
          : Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: FloatingActionButton(
                shape: const CircleBorder(),
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
                tooltip: 'Esporta in Excel (${_filteredBadges.length} record)',
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
              // Area Principale
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(isCompact ? 16 : 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Barra Ricerca e Filtri Avanzati
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Cerca per titolo badge, codice, email o ID...',
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
                            if (_selectedBadgeNames.isNotEmpty)
                              _buildActiveFilterChip(
                                label: 'Badges: ${_selectedBadgeNames.length} selezionati',
                                onDeleted: () => setState(() {
                                  _selectedBadgeNames.clear();
                                  _applyFilter();
                                }),
                              ),
                            if (_filterHasCode != null)
                              _buildActiveFilterChip(
                                label: 'Codice: ${_filterHasCode! ? "Presente" : "Assente"}',
                                onDeleted: () => setState(() {
                                  _filterHasCode = null;
                                  _applyFilter();
                                }),
                              ),
                            if (_issuedFrom != null || _issuedTo != null)
                              _buildActiveFilterChip(
                                label: 'Rilascio: ${_issuedFrom != null ? DateFormat("dd/MM/yy").format(_issuedFrom!) : "Inizio"} ➔ ${_issuedTo != null ? DateFormat("dd/MM/yy").format(_issuedTo!) : "Oggi"}',
                                onDeleted: () => setState(() {
                                  _issuedFrom = null;
                                  _issuedTo = null;
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
                            : _filteredBadges.isEmpty
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
                                                      label: const Text('UTENTE', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, letterSpacing: 0.5)),
                                                      onSort: (col, asc) => _onSort(1, asc),
                                                    ),
                                                    DataColumn(
                                                      label: const Text('BADGE / CERTIFICAZIONE', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, letterSpacing: 0.5)),
                                                      onSort: (col, asc) => _onSort(2, asc),
                                                    ),
                                                    DataColumn(
                                                      label: const Text('CODICE', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, letterSpacing: 0.5)),
                                                      onSort: (col, asc) => _onSort(3, asc),
                                                    ),
                                                    DataColumn(
                                                      label: const Text('DATA RILASCIO', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, letterSpacing: 0.5)),
                                                      onSort: (col, asc) => _onSort(4, asc),
                                                    ),
                                                    const DataColumn(label: Text('ULTIMO SYNC', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, letterSpacing: 0.5))),
                                                  ],
                                                  rows: _paginatedBadges.map((b) {
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
                                                            onPressed: () => _showBadgeDetails(b),
                                                            tooltip: 'Dettagli Badge',
                                                          ),
                                                        ),
                                                        DataCell(
                                                          Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              CircleAvatar(
                                                                radius: 15,
                                                                backgroundColor: _getAvatarColor(b.email ?? ''),
                                                                child: Text(
                                                                  _getInitials(_getUserFullName(b)),
                                                                  style: const TextStyle(
                                                                    color: Colors.white,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 11,
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(width: 10),
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Text(
                                                                    _getUserFullName(b),
                                                                    style: const TextStyle(
                                                                      fontWeight: FontWeight.w600,
                                                                      fontSize: 13,
                                                                      color: AppTheme.primaryBlue,
                                                                    ),
                                                                  ),
                                                                  if (b.email != null && b.email!.isNotEmpty)
                                                                    Text(
                                                                      b.email!,
                                                                      style: TextStyle(
                                                                        fontSize: 11,
                                                                        color: Colors.grey.shade600,
                                                                      ),
                                                                    ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        DataCell(
                                                          Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              Container(
                                                                width: 32,
                                                                height: 32,
                                                                decoration: BoxDecoration(
                                                                  color: const Color(0xFFE11D48).withAlpha(18),
                                                                  shape: BoxShape.circle,
                                                                ),
                                                                child: const Icon(Icons.military_tech_rounded, size: 18, color: Color(0xFFE11D48)),
                                                              ),
                                                              const SizedBox(width: 10),
                                                              Text(
                                                                b.badge ?? 'Senza Nome',
                                                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        DataCell(
                                                          b.code != null && b.code!.isNotEmpty
                                                              ? Container(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.indigo.shade50,
                                                                    borderRadius: BorderRadius.circular(6),
                                                                    border: Border.all(color: Colors.indigo.shade200),
                                                                  ),
                                                                  child: Text(
                                                                    b.code!,
                                                                    style: TextStyle(
                                                                      fontFamily: 'monospace',
                                                                      fontSize: 11,
                                                                      fontWeight: FontWeight.bold,
                                                                      color: Colors.indigo.shade800,
                                                                    ),
                                                                  ),
                                                                )
                                                              : Text(
                                                                  'N/D',
                                                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                                                                ),
                                                        ),
                                                        DataCell(
                                                          Text(
                                                            b.issuedOnDate != null
                                                                ? DateFormat('dd/MM/yyyy HH:mm').format(b.issuedOnDate!)
                                                                : (b.issuedOn ?? 'N/D'),
                                                            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                                                          ),
                                                        ),
                                                        DataCell(
                                                          Text(
                                                            b.lastSyncedAt != null
                                                                ? DateFormat('dd/MM/yyyy HH:mm').format(b.lastSyncedAt!)
                                                                : 'N/D',
                                                            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
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

  Widget _buildActiveFilterChip({required String label, required VoidCallback onDeleted}) {
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
      deleteIcon: const Icon(Icons.close_rounded, size: 14),
      onDeleted: onDeleted,
      backgroundColor: AppTheme.primaryBlue.withAlpha(12),
      side: BorderSide(color: AppTheme.primaryBlue.withAlpha(50)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
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
            Icon(Icons.military_tech_outlined, size: 52, color: Colors.grey.shade400),
            const SizedBox(height: 14),
            const Text('Nessun badge trovato', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(
              _allBadges.isEmpty
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

        final totalFiltered = _filteredBadges.length;
        final startItem = totalFiltered == 0 ? 0 : (_currentPage * _pageSize) + 1;
        final endItem = math.min((_currentPage + 1) * _pageSize, totalFiltered);

        final textInfo = Text(
          totalFiltered == _allBadges.length
              ? 'Mostrati $startItem - $endItem di $totalFiltered badge'
              : 'Mostrati $startItem - $endItem di $totalFiltered (filtrati da ${_allBadges.length} totali)',
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

  Widget _buildAdvancedFiltersDrawer() {
    final availableBadgeNames = _allBadges
        .map((b) => b.badge ?? '')
        .where((s) => s.isNotEmpty)
        .toSet()
        .toList()
      ..sort();

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
              // 1. Filtro Badge Multi-Selezione
              const Text(
                'CERTIFICAZIONE / BADGE',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => _openBadgeSelectorModal(availableBadgeNames),
                icon: const Icon(Icons.military_tech_outlined, size: 18),
                label: Text(
                  _selectedBadgeNames.isEmpty
                      ? 'Tutti i badge (${availableBadgeNames.length})'
                      : '${_selectedBadgeNames.length} badge selezionati',
                  style: const TextStyle(fontSize: 13),
                ),
                style: OutlinedButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  side: BorderSide(
                    color: _selectedBadgeNames.isNotEmpty ? AppTheme.primaryBlue : Colors.grey.shade300,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              if (_selectedBadgeNames.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _selectedBadgeNames.map((name) {
                    return Chip(
                      label: Text(
                        name,
                        style: const TextStyle(fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      deleteIcon: const Icon(Icons.close_rounded, size: 12),
                      onDeleted: () => setState(() {
                        _selectedBadgeNames.remove(name);
                        _applyFilter();
                      }),
                      backgroundColor: Colors.grey.shade100,
                      side: BorderSide(color: Colors.grey.shade300),
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                    );
                  }).toList(),
                ),
              ],

              const SizedBox(height: 22),

              // 2. Filtro Presenza Codice (Pulsante a 3 segmenti)
              const Text(
                'PRESENZA CODICE',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildSegmentButton(
                    label: 'Tutti',
                    isSelected: _filterHasCode == null,
                    onTap: () => setState(() {
                      _filterHasCode = null;
                      _applyFilter();
                    }),
                  ),
                  const SizedBox(width: 6),
                  _buildSegmentButton(
                    label: 'Con Codice',
                    isSelected: _filterHasCode == true,
                    onTap: () => setState(() {
                      _filterHasCode = true;
                      _applyFilter();
                    }),
                  ),
                  const SizedBox(width: 6),
                  _buildSegmentButton(
                    label: 'Senza Codice',
                    isSelected: _filterHasCode == false,
                    onTap: () => setState(() {
                      _filterHasCode = false;
                      _applyFilter();
                    }),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              // 3. Range Data Rilascio (Issued On)
              const Text(
                'DATA DI RILASCIO',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildDatePickerField(
                      label: 'Da',
                      selectedDate: _issuedFrom,
                      onSelect: (d) => setState(() {
                        _issuedFrom = d;
                        _applyFilter();
                      }),
                      onClear: () => setState(() {
                        _issuedFrom = null;
                        _applyFilter();
                      }),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildDatePickerField(
                      label: 'A',
                      selectedDate: _issuedTo,
                      onSelect: (d) => setState(() {
                        _issuedTo = d;
                        _applyFilter();
                      }),
                      onClear: () => setState(() {
                        _issuedTo = null;
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
            color: Colors.grey.shade50,
            border: Border(top: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _activeFiltersCount > 0 ? _clearAllFilters : null,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    foregroundColor: AppTheme.accentRed,
                    side: BorderSide(
                      color: _activeFiltersCount > 0 ? AppTheme.accentRed : Colors.grey.shade300,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Chiudi', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSegmentButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryBlue : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppTheme.primaryBlue : Colors.grey.shade300,
            ),
          ),
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
    );
  }

  Widget _buildDatePickerField({
    required String label,
    required DateTime? selectedDate,
    required ValueChanged<DateTime> onSelect,
    required VoidCallback onClear,
  }) {
    return InkWell(
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? now,
          firstDate: DateTime(2015),
          lastDate: DateTime(now.year + 2),
        );
        if (picked != null) onSelect(picked);
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selectedDate != null ? AppTheme.primaryBlue : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 14,
              color: selectedDate != null ? AppTheme.primaryBlue : Colors.grey.shade500,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                selectedDate != null ? DateFormat('dd/MM/yy').format(selectedDate) : label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: selectedDate != null ? FontWeight.bold : FontWeight.normal,
                  color: selectedDate != null ? AppTheme.primaryBlue : Colors.grey.shade500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (selectedDate != null)
              GestureDetector(
                onTap: onClear,
                child: const Icon(Icons.close_rounded, size: 14, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }

  void _openBadgeSelectorModal(List<String> allBadges) {
    showDialog(
      context: context,
      builder: (context) {
        final tempSelected = Set<String>.from(_selectedBadgeNames);
        String searchQuery = '';

        return StatefulBuilder(
          builder: (context, setModalState) {
            final filteredList = allBadges
                .where((b) => b.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();

            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480, maxHeight: 580),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
                        ),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.military_tech_rounded, color: Colors.white, size: 20),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              'Seleziona Badge',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded, color: Colors.white70),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        onChanged: (v) => setModalState(() => searchQuery = v),
                        decoration: InputDecoration(
                          hintText: 'Cerca per titolo...',
                          prefixIcon: const Icon(Icons.search_rounded),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: () => setModalState(() => tempSelected.addAll(filteredList)),
                            child: const Text('Seleziona visibili', style: TextStyle(fontSize: 12)),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () => setModalState(() => tempSelected.clear()),
                            child: const Text('Deseleziona tutti', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final item = filteredList[index];
                          final isChecked = tempSelected.contains(item);
                          return CheckboxListTile(
                            dense: true,
                            value: isChecked,
                            title: Text(item, style: const TextStyle(fontSize: 13)),
                            onChanged: (val) {
                              setModalState(() {
                                if (val == true) {
                                  tempSelected.add(item);
                                } else {
                                  tempSelected.remove(item);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Annulla'),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _selectedBadgeNames.clear();
                                _selectedBadgeNames.addAll(tempSelected);
                                _applyFilter();
                              });
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryBlue,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Applica Selezione'),
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
      },
    );
  }

  void _showBadgeDetails(BadgeUser badge) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          clipBehavior: Clip.antiAlias,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 580),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header Modale
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(25),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withAlpha(50)),
                        ),
                        child: const Icon(Icons.military_tech_rounded, color: Color(0xFFFDA4AF), size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              badge.badge ?? 'Badge Utente',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'ID Record: #${badge.id}',
                              style: const TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'monospace'),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white70),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                // Contenuto Modale a Card
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      _buildDetailCard(
                        title: 'Certificazione & Codice',
                        icon: Icons.workspace_premium_outlined,
                        items: [
                          _buildDetailRow('Nome Badge', badge.badge ?? 'N/D'),
                          _buildDetailRow('Codice Certificato', badge.code ?? 'Non specificato', isCode: true),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildDetailCard(
                        title: 'Utente Assegnatario',
                        icon: Icons.person_outline_rounded,
                        items: [
                          _buildDetailRow('Nome e Cognome', _getUserFullName(badge)),
                          _buildDetailRow('Email Utente', badge.email ?? 'N/D'),
                          if (_usersByEmail[badge.email?.trim().toLowerCase()]?.username != null &&
                              _usersByEmail[badge.email?.trim().toLowerCase()]!.username!.isNotEmpty)
                            _buildDetailRow(
                              'Username',
                              _usersByEmail[badge.email?.trim().toLowerCase()]!.username!,
                            ),
                          if (_usersByEmail[badge.email?.trim().toLowerCase()]?.department != null &&
                              _usersByEmail[badge.email?.trim().toLowerCase()]!.department!.isNotEmpty)
                            _buildDetailRow(
                              'Dipartimento',
                              _usersByEmail[badge.email?.trim().toLowerCase()]!.department!,
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildDetailCard(
                        title: 'Dettagli Temporali & Sistema',
                        icon: Icons.access_time_rounded,
                        items: [
                          _buildDetailRow(
                            'Data Rilascio (Issued On)',
                            badge.issuedOnDate != null
                                ? DateFormat('dd/MM/yyyy HH:mm:ss').format(badge.issuedOnDate!)
                                : (badge.issuedOn ?? 'N/D'),
                          ),
                          _buildDetailRow(
                            'Ultimo Sync Isar',
                            badge.lastSyncedAt != null
                                ? DateFormat('dd/MM/yyyy HH:mm:ss').format(badge.lastSyncedAt!)
                                : 'N/D',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Footer Modale
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
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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

  Widget _buildDetailCard({
    required String title,
    required IconData icon,
    required List<Widget> items,
  }) {
    return Container(
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
              Icon(icon, size: 18, color: AppTheme.primaryBlue),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 8),
          ...items,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isCode = false}) {
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
              style: TextStyle(
                fontSize: 12,
                fontWeight: isCode ? FontWeight.bold : FontWeight.w600,
                fontFamily: isCode ? 'monospace' : null,
                color: isCode ? Colors.indigo.shade800 : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
