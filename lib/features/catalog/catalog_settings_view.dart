import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import '../../core/db/isar_provider.dart';
import '../../core/theme/app_theme.dart';
import '../settings/providers/app_settings_provider.dart';
import '../sync/models/course.dart';
import 'models/course_catalog_item.dart';
import 'services/course_catalog_service.dart';
import 'data/default_course_catalog.dart';

class CatalogSettingsView extends ConsumerStatefulWidget {
  const CatalogSettingsView({super.key});

  @override
  ConsumerState<CatalogSettingsView> createState() => _CatalogSettingsViewState();
}

class _CatalogSettingsViewState extends ConsumerState<CatalogSettingsView> {
  List<CourseCatalogItem> _allItems = [];
  List<CourseCatalogItem> _filteredItems = [];
  List<Course> _moodleCourses = [];
  Map<int, Course> _moodleCoursesMap = {};

  bool _isLoading = true;
  bool _isImporting = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  StreamSubscription<void>? _catalogSub;
  StreamSubscription<void>? _coursesSub;

  int _sortColumnIndex = 1;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _loadData();
    final isar = ref.read(isarProvider);
    _catalogSub = isar.courseCatalogItems.watchLazy().listen((_) => _loadData());
    _coursesSub = isar.courses.watchLazy().listen((_) => _loadData());
  }

  @override
  void dispose() {
    _catalogSub?.cancel();
    _coursesSub?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final isar = ref.read(isarProvider);
      var items = await isar.courseCatalogItems.where().findAll();
      if (items.isEmpty) {
        await DefaultCourseCatalog.seedIfEmpty(isar);
        items = await isar.courseCatalogItems.where().findAll();
      }
      final courses = await isar.courses.where().findAll();

      final map = <int, Course>{};
      for (final c in courses) {
        map[c.id] = c;
      }

      if (mounted) {
        setState(() {
          _allItems = items;
          _moodleCourses = courses;
          _moodleCoursesMap = map;
          _isLoading = false;
          _applyFilter();
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _applyFilter() {
    final query = _searchQuery.trim().toLowerCase();
    List<CourseCatalogItem> filtered = _allItems.where((item) {
      if (query.isEmpty) return true;
      final code = (item.courseCode ?? '').toLowerCase();
      final path = (item.learningPath ?? '').toLowerCase();
      final title = (item.title ?? '').toLowerCase();
      final titleIt = (item.titleIt ?? '').toLowerCase();
      final cId = item.courseId?.toString() ?? '';
      final cShort = (item.courseShortname ?? '').toLowerCase();
      final cName = (_moodleCoursesMap[item.courseId]?.fullname ?? '').toLowerCase();

      return code.contains(query) ||
          path.contains(query) ||
          title.contains(query) ||
          titleIt.contains(query) ||
          cId.contains(query) ||
          cShort.contains(query) ||
          cName.contains(query);
    }).toList();

    _sortItems(filtered);

    setState(() {
      _filteredItems = filtered;
    });
  }

  void _sortItems(List<CourseCatalogItem> list) {
    list.sort((a, b) {
      int cmp = 0;
      switch (_sortColumnIndex) {
        case 1: // Codice
          cmp = (a.courseCode ?? '').compareTo(b.courseCode ?? '');
          break;
        case 2: // Titolo
          cmp = (a.title ?? '').compareTo(b.title ?? '');
          break;
        case 3: // Corso Moodle
          final nameA = _moodleCoursesMap[a.courseId]?.fullname ?? '';
          final nameB = _moodleCoursesMap[b.courseId]?.fullname ?? '';
          cmp = nameA.compareTo(nameB);
          break;
        case 4: // Durata
          cmp = (a.durationHours ?? 0.0).compareTo(b.durationHours ?? 0.0);
          break;
        case 5: // Studio
          cmp = (a.individualStudyHours ?? 0.0).compareTo(b.individualStudyHours ?? 0.0);
          break;
        case 6: // Totale
          cmp = a.totalHours.compareTo(b.totalHours);
          break;
        default:
          cmp = (a.courseCode ?? '').compareTo(b.courseCode ?? '');
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

  Future<void> _rematchWithMoodle() async {
    setState(() => _isImporting = true);
    try {
      final isar = ref.read(isarProvider);
      final count = await CourseCatalogService.rematchCatalogWithMoodle(isar);
      await _loadData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Abbinamento completato: $count corsi a catalogo associati a corsi Moodle.'),
            backgroundColor: const Color(0xFF16A34A),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore durante l\'abbinamento con Moodle: $e'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isImporting = false);
    }
  }

  Future<void> _importFromCustomFile() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (result == null || result.files.isEmpty) return;

      final file = result.files.first;
      setState(() => _isImporting = true);

      final isar = ref.read(isarProvider);
      final count = await CourseCatalogService.importCatalogFromExcel(
        isar,
        customBytes: file.bytes,
        customFilePath: file.path,
      );

      await ref.read(appSettingsProvider.notifier).updateCourseCatalogSyncDate(DateTime.now());
      await _loadData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File importato con successo: $count corsi aggiornati a catalogo!'),
            backgroundColor: const Color(0xFF16A34A),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore durante l\'importazione del file: $e'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isImporting = false);
    }
  }

  Future<void> _openEditDialog([CourseCatalogItem? existing]) async {
    final isEditing = existing != null;
    final codeCtrl = TextEditingController(text: existing?.courseCode ?? '');
    final pathCtrl = TextEditingController(text: existing?.learningPath ?? '');
    final titleCtrl = TextEditingController(text: existing?.title ?? '');
    final titleItCtrl = TextEditingController(text: existing?.titleIt ?? '');
    final durCtrl = TextEditingController(text: existing?.durationHours != null ? '${existing!.durationHours}' : '8.0');
    final studyCtrl = TextEditingController(text: existing?.individualStudyHours != null ? '${existing!.individualStudyHours}' : '2.0');
    final notesCtrl = TextEditingController(text: existing?.notes ?? '');

    int? selectedCourseId = existing?.courseId;
    String selectedCourseType = existing?.courseType ?? 'async';

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Container(
                width: 680,
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Dialog
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryBlue.withAlpha(20),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.menu_book_rounded, color: AppTheme.primaryBlue, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isEditing ? 'Modifica Corso a Catalogo' : 'Nuovo Corso a Catalogo',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Configura dati didattici, durate in ore e associazione al corso Moodle.',
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(ctx, false),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Divider(height: 1),
                      const SizedBox(height: 20),

                      // Riferimento Corso Moodle
                      const Text(
                        'COLLEGAMENTO CORSO MOODLE',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue, letterSpacing: 0.8),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<int?>(
                        initialValue: selectedCourseId,
                        isExpanded: true,
                        decoration: InputDecoration(
                          hintText: 'Seleziona un corso Moodle registrato...',
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                        items: [
                          const DropdownMenuItem<int?>(
                            value: null,
                            child: Text('Nessun corso Moodle collegato (solo catalogo)'),
                          ),
                          ..._moodleCourses.map((c) {
                            return DropdownMenuItem<int?>(
                              value: c.id,
                              child: Text(
                                '#${c.id} - ${c.fullname ?? c.shortname ?? "Senza Titolo"}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }),
                        ],
                        onChanged: (val) {
                          setDialogState(() {
                            selectedCourseId = val;
                            if (val != null && _moodleCoursesMap.containsKey(val)) {
                              final mc = _moodleCoursesMap[val]!;
                              if (titleCtrl.text.isEmpty) titleCtrl.text = mc.fullname ?? '';
                              if (selectedCourseType.isEmpty) selectedCourseType = mc.courseType ?? 'async';
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Codice e Percorso Didattico
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'CODICE CORSO (ES. 1.1, 1.1 ADV)',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue, letterSpacing: 0.8),
                                ),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: codeCtrl,
                                  decoration: InputDecoration(
                                    hintText: 'es. 1.1, 2.1 ADV',
                                    filled: true,
                                    fillColor: Colors.grey.shade50,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'PERCORSO FORMATIVO / MODULO',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue, letterSpacing: 0.8),
                                ),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: pathCtrl,
                                  decoration: InputDecoration(
                                    hintText: 'es. CYBERSECURITY BASIC Module I',
                                    filled: true,
                                    fillColor: Colors.grey.shade50,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Titolo Corso IT ed EN
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'TITOLO CORSO (INGLESE / UFFICIALE)',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue, letterSpacing: 0.8),
                                ),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: titleCtrl,
                                  maxLines: 2,
                                  decoration: InputDecoration(
                                    hintText: 'Titolo in lingua inglese...',
                                    filled: true,
                                    fillColor: Colors.grey.shade50,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'TITOLO CORSO (ITALIANO)',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue, letterSpacing: 0.8),
                                ),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: titleItCtrl,
                                  maxLines: 2,
                                  decoration: InputDecoration(
                                    hintText: 'Titolo in lingua italiana...',
                                    filled: true,
                                    fillColor: Colors.grey.shade50,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Durata Lezioni e Studio Individuale
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'DURATA CORSO (ORE LEZIONE/AULA)',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue, letterSpacing: 0.8),
                                ),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: durCtrl,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  decoration: InputDecoration(
                                    hintText: 'es. 8.0',
                                    suffixText: 'ore',
                                    filled: true,
                                    fillColor: Colors.grey.shade50,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'STUDIO INDIVIDUALE (ORE)',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue, letterSpacing: 0.8),
                                ),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: studyCtrl,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  decoration: InputDecoration(
                                    hintText: 'es. 2.0',
                                    suffixText: 'ore',
                                    filled: true,
                                    fillColor: Colors.grey.shade50,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Note
                      const Text(
                        'NOTE AGGIUNTIVE',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue, letterSpacing: 0.8),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: notesCtrl,
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText: 'Eventuali osservazioni didattiche o amministrative...',
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Azioni Footer Dialog
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text('Annulla'),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryBlue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            icon: const Icon(Icons.save_rounded, size: 18),
                            label: const Text('Salva nel Catalogo'),
                            onPressed: () async {
                              final code = codeCtrl.text.trim();
                              final dur = double.tryParse(durCtrl.text.trim()) ?? 0.0;
                              final study = double.tryParse(studyCtrl.text.trim()) ?? 0.0;

                              if (code.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Inserisci il codice del corso.'),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                                return;
                              }

                              final isar = ref.read(isarProvider);
                              final item = existing ?? CourseCatalogItem();
                              item.courseCode = code;
                              item.courseId = selectedCourseId;
                              item.courseShortname = selectedCourseId != null ? _moodleCoursesMap[selectedCourseId]?.shortname : null;
                              item.learningPath = pathCtrl.text.trim();
                              item.title = titleCtrl.text.trim();
                              item.titleIt = titleItCtrl.text.trim();
                              item.durationHours = dur;
                              item.individualStudyHours = study;
                              item.courseType = selectedCourseType;
                              item.notes = notesCtrl.text.trim();
                              item.updatedAt = DateTime.now();

                              await isar.writeTxn(() async {
                                await isar.courseCatalogItems.put(item);
                              });

                              if (context.mounted) {
                                Navigator.pop(ctx, true);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    if (saved == true) {
      await _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEditing ? 'Corso aggiornato con successo!' : 'Nuovo corso inserito nel catalogo!'),
            backgroundColor: const Color(0xFF16A34A),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _deleteItem(CourseCatalogItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Eliminare dal catalogo?'),
        content: Text('Sei sicuro di voler rimuovere il corso "${item.courseCode} - ${item.title ?? ""}" dal catalogo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annulla'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Elimina'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final isar = ref.read(isarProvider);
      await isar.writeTxn(() async {
        await isar.courseCatalogItems.delete(item.id);
      });
      await _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Corso rimosso dal catalogo.'),
            backgroundColor: Colors.grey,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Calcolo KPI riepilogativi
    final totalCourses = _allItems.length;
    final totalTrainingHours = _allItems.fold<double>(0.0, (acc, it) => acc + (it.durationHours ?? 0.0));
    final totalStudyHours = _allItems.fold<double>(0.0, (acc, it) => acc + (it.individualStudyHours ?? 0.0));
    final totalHoursAll = totalTrainingHours + totalStudyHours;
    final linkedCount = _allItems.where((it) => it.courseId != null && it.courseId! > 0).length;
    final upTo20HoursCount = _allItems.where((it) => it.isUpTo20Hours).length;
    final between20And40Count = _allItems.where((it) => it.isBetween20And40Hours).length;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KPI Summary Cards Responsive
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final int crossAxisCount;
                final double aspectRatio;
                if (width < 600) {
                  crossAxisCount = 1;
                  aspectRatio = 3.6;
                } else if (width < 1050) {
                  crossAxisCount = 2;
                  aspectRatio = 2.4;
                } else {
                  crossAxisCount = 4;
                  aspectRatio = 2.1;
                }

                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: aspectRatio,
                  children: [
                    _buildKpiCard(
                      title: 'CORSI A CATALOGO',
                      value: '$totalCourses',
                      subtitle: '$linkedCount abbinati a corsi Moodle',
                      icon: Icons.menu_book_rounded,
                      color: AppTheme.primaryBlue,
                    ),
                    _buildKpiCard(
                      title: 'ORE FORMAZIONE TOTALI',
                      value: '${totalTrainingHours.toStringAsFixed(0)}h',
                      subtitle: '+${totalStudyHours.toStringAsFixed(0)}h studio (${totalHoursAll.toStringAsFixed(0)}h tot)',
                      icon: Icons.timer_outlined,
                      color: const Color(0xFF0D9488),
                    ),
                    _buildKpiCard(
                      title: 'CORSI ≤ 20 ORE (KPI 6.1)',
                      value: '$upTo20HoursCount',
                      subtitle: 'DG-CNECT standard indicator 6.1',
                      icon: Icons.speed_rounded,
                      color: const Color(0xFF16A34A),
                    ),
                    _buildKpiCard(
                      title: 'CORSI 20 - 40 ORE (KPI 6.2)',
                      value: '$between20And40Count',
                      subtitle: 'DG-CNECT standard indicator 6.2',
                      icon: Icons.trending_up_rounded,
                      color: const Color(0xFF7C3AED),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),

            // Toolbar di Ricerca e Azioni con LayoutBuilder Responsive
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10, offset: const Offset(0, 2)),
                ],
              ),
              child: LayoutBuilder(
                builder: (context, barConstraints) {
                  final isNarrow = barConstraints.maxWidth < 880;

                  final searchField = TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Cerca per codice, titolo, percorso formativo o ID Moodle...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                  _applyFilter();
                                });
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                        _applyFilter();
                      });
                    },
                  );

                  final buttons = Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          side: const BorderSide(color: AppTheme.primaryBlue),
                        ),
                        icon: _isImporting
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.link_rounded, color: AppTheme.primaryBlue, size: 18),
                        label: const Text('Ri-associa a Moodle', style: TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold)),
                        onPressed: _isImporting ? null : _rematchWithMoodle,
                      ),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          side: BorderSide(color: Colors.grey.shade400),
                        ),
                        icon: const Icon(Icons.file_upload_outlined, size: 18, color: Colors.black87),
                        label: const Text('Importa da Excel...', style: TextStyle(color: Colors.black87)),
                        onPressed: _isImporting ? null : _importFromCustomFile,
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: const Icon(Icons.add_rounded, size: 20),
                        label: const Text('Nuovo Corso', style: TextStyle(fontWeight: FontWeight.bold)),
                        onPressed: () => _openEditDialog(),
                      ),
                    ],
                  );

                  if (isNarrow) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        searchField,
                        const SizedBox(height: 12),
                        buttons,
                      ],
                    );
                  }

                  return Row(
                    children: [
                      Expanded(child: searchField),
                      const SizedBox(width: 12),
                      buttons,
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Corsi Raggruppati per Percorso Didattico
            if (_filteredItems.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(48),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.menu_book_outlined, size: 48, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      Text(
                        _allItems.isEmpty
                            ? 'Nessun corso configurato nel catalogo.\nPremi "Incrocia Catalogo Asset" per importare le durate dal file Excel.'
                            : 'Nessun corso trovato per i criteri di ricerca impostati.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              )
            else
              ..._buildGroupedLearningPathSections(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildGroupedLearningPathSections() {
    final Map<String, List<CourseCatalogItem>> grouped = {};
    for (final item in _filteredItems) {
      final lp = (item.learningPath != null && item.learningPath!.trim().isNotEmpty)
          ? item.learningPath!.trim()
          : 'Altri Corsi / Non Assegnati';
      grouped.putIfAbsent(lp, () => []).add(item);
    }

    return grouped.entries.map((entry) {
      return _buildLearningPathGroupCard(
        pathTitle: entry.key,
        items: entry.value,
      );
    }).toList();
  }

  Widget _buildLearningPathGroupCard({
    required String pathTitle,
    required List<CourseCatalogItem> items,
  }) {
    final groupHours = items.fold<double>(0.0, (acc, it) => acc + (it.durationHours ?? 0.0));
    final groupStudyHours = items.fold<double>(0.0, (acc, it) => acc + (it.individualStudyHours ?? 0.0));
    final linkedCount = items.where((it) => it.courseId != null && it.courseId! > 0).length;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Group Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              color: const Color(0xFFF8FAFC),
              child: LayoutBuilder(
                builder: (context, headerConstraints) {
                  final isCompact = headerConstraints.maxWidth < 650;
                  final titleWidget = Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withAlpha(20),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.school_rounded, color: AppTheme.primaryBlue, size: 18),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          pathTitle,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryBlue,
                            letterSpacing: 0.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  );

                  final badges = Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withAlpha(15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.primaryBlue.withAlpha(40)),
                        ),
                        child: Text(
                          '${items.length} Corsi',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D9488).withAlpha(15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF0D9488).withAlpha(40)),
                        ),
                        child: Text(
                          '${groupHours.toStringAsFixed(0)}h aula',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0D9488)),
                        ),
                      ),
                      if (groupStudyHours > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(
                            '+${groupStudyHours.toStringAsFixed(0)}h studio',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
                          ),
                        ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: linkedCount == items.length
                              ? const Color(0xFF16A34A).withAlpha(15)
                              : Colors.orange.withAlpha(15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: linkedCount == items.length
                                ? const Color(0xFF16A34A).withAlpha(40)
                                : Colors.orange.withAlpha(40),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              linkedCount == items.length ? Icons.link_rounded : Icons.link_off_rounded,
                              size: 13,
                              color: linkedCount == items.length ? const Color(0xFF16A34A) : Colors.orange.shade800,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$linkedCount/${items.length} collegati Moodle',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: linkedCount == items.length ? const Color(0xFF16A34A) : Colors.orange.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );

                  if (isCompact) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        titleWidget,
                        const SizedBox(height: 10),
                        badges,
                      ],
                    );
                  }

                  return Row(
                    children: [
                      Expanded(child: titleWidget),
                      const SizedBox(width: 12),
                      badges,
                    ],
                  );
                },
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

            // Table of Courses in this Learning Path (Responsive horizontal scroll)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                sortColumnIndex: _sortColumnIndex,
                sortAscending: _sortAscending,
                headingRowColor: WidgetStateProperty.all(const Color(0xFFFAFAFA)),
                headingRowHeight: 44,
                dataRowMinHeight: 56,
                dataRowMaxHeight: 64,
                horizontalMargin: 16,
                columnSpacing: 20,
                columns: [
                  const DataColumn(label: Text('AZIONI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5))),
                  DataColumn(
                    label: const Text('CODICE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5)),
                    onSort: _onSort,
                  ),
                  DataColumn(
                    label: const Text('TITOLO CORSO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5)),
                    onSort: _onSort,
                  ),
                  DataColumn(
                    label: const Text('CORSO MOODLE COLLEGATO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5)),
                    onSort: _onSort,
                  ),
                  DataColumn(
                    label: const Text('DURATA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5)),
                    numeric: true,
                    onSort: _onSort,
                  ),
                  DataColumn(
                    label: const Text('STUDIO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5)),
                    numeric: true,
                    onSort: _onSort,
                  ),
                  DataColumn(
                    label: const Text('TOTALE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5)),
                    numeric: true,
                    onSort: _onSort,
                  ),
                ],
                rows: items.map((item) {
                  final moodleCourse = item.courseId != null ? _moodleCoursesMap[item.courseId] : null;
                  final isUpTo20 = item.isUpTo20Hours;

                  return DataRow(
                    cells: [
                      // Azioni
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, size: 18, color: AppTheme.primaryBlue),
                              tooltip: 'Modifica dati e durata',
                              onPressed: () => _openEditDialog(item),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete_outline_rounded, size: 18, color: Colors.red.shade400),
                              tooltip: 'Rimuovi dal catalogo',
                              onPressed: () => _deleteItem(item),
                            ),
                          ],
                        ),
                      ),
                      // Codice
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Text(
                            '#${item.courseCode ?? item.id}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'monospace', color: Color(0xFF334155)),
                          ),
                        ),
                      ),
                      // Titolo Corso
                      DataCell(
                        ConstrainedBox(
                          constraints: const BoxConstraints(minWidth: 260, maxWidth: 460),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                item.title ?? 'Senza Titolo',
                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (item.titleIt != null && item.titleIt!.isNotEmpty)
                                Text(
                                  item.titleIt!,
                                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontStyle: FontStyle.italic),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                      ),
                      // Corso Moodle Collegato
                      DataCell(
                        moodleCourse != null
                            ? Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF16A34A).withAlpha(15),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: const Color(0xFF16A34A).withAlpha(40)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.check_circle_outline, size: 14, color: Color(0xFF16A34A)),
                                    const SizedBox(width: 6),
                                    Text(
                                      '#${moodleCourse.id} - ${moodleCourse.shortname ?? ""}',
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF16A34A)),
                                    ),
                                  ],
                                ),
                              )
                            : InkWell(
                                onTap: () => _openEditDialog(item),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withAlpha(25),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.amber.shade300),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.link_off_rounded, size: 14, color: Colors.orange),
                                      SizedBox(width: 6),
                                      Text(
                                        'Non collegato (collega)',
                                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.orange),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                      // Durata Corso
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${(item.durationHours ?? 0.0).toStringAsFixed(0)}h',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.primaryBlue),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: isUpTo20 ? const Color(0xFF16A34A).withAlpha(15) : const Color(0xFF7C3AED).withAlpha(15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                isUpTo20 ? '≤20h' : '20-40h',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: isUpTo20 ? const Color(0xFF16A34A) : const Color(0xFF7C3AED),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Studio Individuale
                      DataCell(
                        Text(
                          '${(item.individualStudyHours ?? 0.0).toStringAsFixed(0)}h',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                        ),
                      ),
                      // Totale
                      DataCell(
                        Text(
                          '${item.totalHours.toStringAsFixed(0)}h',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade600, letterSpacing: 0.5),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color, height: 1.1),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
