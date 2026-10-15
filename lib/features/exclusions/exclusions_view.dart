import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:isar_community/isar.dart';
import '../../core/db/isar_provider.dart';
import '../../core/theme/app_theme.dart';
import '../sync/models/course.dart';
import '../sync/models/course_info.dart';
import '../sync/models/stat_mdl.dart';
import 'models/course_exclusion.dart';

class ExclusionsView extends ConsumerStatefulWidget {
  const ExclusionsView({super.key});

  @override
  ConsumerState<ExclusionsView> createState() => _ExclusionsViewState();
}

class _CourseIdEntry {
  final TextEditingController controller;
  final FocusNode focusNode;
  String? matchedCourseName;

  _CourseIdEntry()
      : controller = TextEditingController(),
        focusNode = FocusNode();

  void dispose() {
    controller.dispose();
    focusNode.dispose();
  }
}

class _ExclusionsViewState extends ConsumerState<ExclusionsView> {
  final List<_CourseIdEntry> _newEntries = [];
  List<CourseExclusion> _savedExclusions = [];
  Map<int, String> _coursesNameMap = {};
  bool _isLoading = true;
  bool _isSaving = false;
  StreamSubscription<void>? _exclusionsSub;
  StreamSubscription<void>? _statsSub;
  StreamSubscription<void>? _coursesSub;
  StreamSubscription<void>? _courseInfoSub;
  static const List<int> defaultExcludedIds = [124, 123, 1];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Inizializza con almeno una riga vuota
    _addNewEntry();
    _loadData();

    final isar = ref.read(isarProvider);
    _exclusionsSub = isar.courseExclusions.watchLazy().listen((_) => _loadData());
    _statsSub = isar.statMdls.watchLazy().listen((_) => _loadData());
    _coursesSub = isar.courses.watchLazy().listen((_) => _loadData());
    _courseInfoSub = isar.courseInfos.watchLazy().listen((_) => _loadData());
  }

  @override
  void dispose() {
    _exclusionsSub?.cancel();
    _statsSub?.cancel();
    _coursesSub?.cancel();
    _courseInfoSub?.cancel();
    for (final entry in _newEntries) {
      entry.dispose();
    }
    super.dispose();
  }

  void _addNewEntry() {
    setState(() {
      final entry = _CourseIdEntry();
      entry.controller.addListener(() {
        _checkCourseName(entry);
      });
      _newEntries.add(entry);
    });
  }

  void _removeEntry(int index) {
    if (_newEntries.length <= 1) {
      _newEntries[0].controller.clear();
      setState(() {
        _newEntries[0].matchedCourseName = null;
      });
      return;
    }
    setState(() {
      final removed = _newEntries.removeAt(index);
      removed.dispose();
    });
  }

  void _checkCourseName(_CourseIdEntry entry) {
    final text = entry.controller.text.trim();
    final id = int.tryParse(text);
    if (id != null && _coursesNameMap.containsKey(id)) {
      if (entry.matchedCourseName != _coursesNameMap[id]) {
        setState(() {
          entry.matchedCourseName = _coursesNameMap[id];
        });
      }
    } else {
      if (entry.matchedCourseName != null) {
        setState(() {
          entry.matchedCourseName = null;
        });
      }
    }
  }

  Future<void> _loadData() async {
    try {
      final isar = ref.read(isarProvider);
      var exclusions = await isar.courseExclusions.where().findAll();
      if (exclusions.isEmpty) {
        final now = DateTime.now();
        final defaultItems = defaultExcludedIds.map((id) => CourseExclusion()
          ..courseId = id
          ..createdAt = now,
        ).toList();
        await isar.writeTxn(() async {
          await isar.courseExclusions.putAll(defaultItems);
        });
        exclusions = await isar.courseExclusions.where().findAll();
      }
      final courses = await isar.courses.where().findAll();
      final stats = await isar.statMdls.where().findAll();
      final courseInfos = await isar.courseInfos.where().findAll();

      int? extractPrefix(String? shortname) {
        if (shortname == null) return null;
        final match = RegExp(r'^(\d+)').firstMatch(shortname.trim());
        if (match != null) {
          return int.tryParse(match.group(1)!);
        }
        return null;
      }

      final map = <int, String>{};

      // 1. Da StatMdl (corsi didattici effettivi completati o frequentati dagli utenti)
      for (final s in stats) {
        final cId = s.idCorso;
        if (cId != null && cId > 0) {
          final name = (s.nomeCorso?.trim().isNotEmpty == true)
              ? s.nomeCorso!.trim()
              : (s.shorthNomeCorso?.trim().isNotEmpty == true ? s.shorthNomeCorso!.trim() : null);
          if (name != null) {
            map[cId] = name;
          }
          final prefix = extractPrefix(s.shorthNomeCorso);
          if (prefix != null && name != null) {
            map.putIfAbsent(prefix, () => name);
          }
        }
      }

      // 2. Da CourseInfo (sezioni o informazioni corsi aggiuntive)
      for (final ci in courseInfos) {
        final cId = ci.courseId;
        if (cId != null && cId > 0 && ci.name?.trim().isNotEmpty == true) {
          map.putIfAbsent(cId, () => ci.name!.trim());
        }
      }

      // 3. Da Course (corsi da API principale)
      for (final c in courses) {
        final name = (c.fullname?.trim().isNotEmpty == true)
            ? c.fullname!.trim()
            : (c.shortname?.trim().isNotEmpty == true ? c.shortname!.trim() : null);
        if (name != null) {
          map[c.id] = name;
        }
        final prefix = extractPrefix(c.shortname);
        if (prefix != null && name != null) {
          map.putIfAbsent(prefix, () => name);
        }
      }

      // Aggiornamento retroattivo per esclusioni già salvate prive di nome o non aggiornate
      bool needsUpdate = false;
      for (final item in exclusions) {
        if ((item.courseName == null ||
                item.courseName!.trim().isEmpty ||
                item.courseName == 'Nome non disponibile') &&
            map.containsKey(item.courseId)) {
          item.courseName = map[item.courseId];
          needsUpdate = true;
        }
      }
      if (needsUpdate) {
        await isar.writeTxn(() async {
          await isar.courseExclusions.putAll(exclusions);
        });
      }

      if (mounted) {
        setState(() {
          _savedExclusions = exclusions..sort((a, b) => b.createdAt?.compareTo(a.createdAt ?? DateTime.now()) ?? 0);
          _coursesNameMap = map;
          _isLoading = false;
        });

        // Aggiorna anteprime dei campi aperti
        for (final entry in _newEntries) {
          _checkCourseName(entry);
        }
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveExclusions() async {
    final isar = ref.read(isarProvider);

    final idsToSave = <int>{};
    for (final entry in _newEntries) {
      final text = entry.controller.text.trim();
      final id = int.tryParse(text);
      if (id != null && id > 0) {
        idsToSave.add(id);
      }
    }

    if (idsToSave.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Inserisci almeno un ID Corso valido (numero intero positivo).'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      final now = DateTime.now();
      final List<CourseExclusion> items = [];

      for (final id in idsToSave) {
        final existing = await isar.courseExclusions.where().courseIdEqualTo(id).findFirst();
        final item = existing ?? CourseExclusion();
        item.courseId = id;
        item.courseName = _coursesNameMap[id];
        item.createdAt = item.createdAt ?? now;
        items.add(item);
      }

      await isar.writeTxn(() async {
        await isar.courseExclusions.putAll(items);
      });

      // Pulisci le righe di inserimento e lascia una riga vuota
      for (final entry in _newEntries) {
        entry.dispose();
      }
      _newEntries.clear();
      _addNewEntry();

      await _loadData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${items.length} ID Corso salvati con successo nelle esclusioni.'),
            backgroundColor: const Color(0xFF16A34A),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore durante il salvataggio: $e'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _deleteExclusion(CourseExclusion item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminare esclusione?'),
        content: Text('Rimuovere il corso con ID #${item.courseId} dalle esclusioni?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annulla')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Elimina'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final isar = ref.read(isarProvider);
      await isar.writeTxn(() async {
        await isar.courseExclusions.delete(item.id);
      });
      await _loadData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Corso ID #${item.courseId} rimosso dalle esclusioni.'),
            backgroundColor: const Color(0xFF16A34A),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore durante l\'eliminazione: $e'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _deleteAllExclusions() async {
    if (_savedExclusions.isEmpty) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminare TUTTE le esclusioni?'),
        content: const Text('Tutti i corsi attualmente esclusi verranno ripristinati e conteggiati normalmente.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annulla')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Elimina Tutti'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final isar = ref.read(isarProvider);
      await isar.writeTxn(() async {
        await isar.courseExclusions.clear();
      });
      await _loadData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tutte le esclusioni corsi sono state eliminate.'),
            backgroundColor: Color(0xFF16A34A),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore: $e'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _restoreDefaultExclusions() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ripristinare esclusioni predefinite?'),
        content: const Text(
          'Verranno impostati come corsi esclusi i valori predefiniti: 124, 123 e 1.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annulla'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppTheme.primaryBlue),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Ripristina'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final isar = ref.read(isarProvider);
      final now = DateTime.now();
      final items = defaultExcludedIds.map((id) => CourseExclusion()
        ..courseId = id
        ..courseName = _coursesNameMap[id]
        ..createdAt = now,
      ).toList();

      await isar.writeTxn(() async {
        await isar.courseExclusions.putAll(items);
      });
      await _loadData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Esclusioni predefinite (124, 123, 1) ripristinate con successo.'),
            backgroundColor: Color(0xFF16A34A),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore: $e'),
            backgroundColor: Colors.red.shade700,
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

    final filteredList = _savedExclusions.where((item) {
      if (_searchQuery.trim().isEmpty) return true;
      final q = _searchQuery.toLowerCase().trim();
      final idStr = item.courseId.toString();
      final name = (item.courseName ?? _coursesNameMap[item.courseId] ?? '').toLowerCase();
      return idStr.contains(q) || name.contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sezione Inserimento ID Corsi
                _buildCoursesCard(),
                const SizedBox(height: 28),

                // Sezione Corsi Attualmente Esclusi
                _buildSavedExclusionsSection(filteredList),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCoursesCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(6),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card Corsi
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withAlpha(15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.school_outlined, color: AppTheme.primaryBlue, size: 22),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Corsi',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryBlue,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Inserisci uno o più ID corso da escludere dalle metriche, avanzamenti didattici e report.',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  '${_savedExclusions.length} esclusi',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 20),

          // Lista Campi ID Corso Dinamici
          Text(
            'CAMPI ID CORSO DA AGGIUNGERE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 12),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _newEntries.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final entry = _newEntries[index];
              final isExisting = int.tryParse(entry.controller.text.trim()) != null &&
                  _savedExclusions.any((e) => e.courseId == int.tryParse(entry.controller.text.trim()));

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      '#${index + 1}',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: entry.controller,
                      focusNode: entry.focusNode,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        hintText: 'Es. 104',
                        labelText: 'ID corso',
                        prefixIcon: const Icon(Icons.tag_rounded, size: 18),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        errorText: isExisting ? 'Già presente nelle esclusioni' : null,
                      ),
                    ),
                  ),
                  if (entry.matchedCourseName != null) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFBBF7D0)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle_rounded, size: 16, color: Color(0xFF16A34A)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                entry.matchedCourseName!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF166534),
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                      Icons.remove_circle_outline_rounded,
                      color: Colors.red.shade400,
                      size: 20,
                    ),
                    tooltip: 'Rimuovi riga',
                    onPressed: () => _removeEntry(index),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 16),

          // Tasti Azione: Aggiungi Campo e Salva
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              OutlinedButton.icon(
                onPressed: _addNewEntry,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Aggiungi campo ID corso'),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppTheme.primaryBlue.withAlpha(120)),
                  foregroundColor: AppTheme.primaryBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                ),
              ),
              FilledButton.icon(
                onPressed: _isSaving ? null : _saveExclusions,
                icon: _isSaving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.save_rounded, size: 18),
                label: Text(
                  _isSaving ? 'Salvataggio...' : 'Salva nel Database',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSavedExclusionsSection(List<CourseExclusion> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(6),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Corsi Attualmente Esclusi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${_savedExclusions.length} corsi memorizzati nel database locale Isar',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: _restoreDefaultExclusions,
                    icon: const Icon(Icons.settings_backup_restore_rounded, size: 18, color: AppTheme.primaryBlue),
                    label: const Text('Ripristina Default (124, 123, 1)', style: TextStyle(color: AppTheme.primaryBlue)),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppTheme.primaryBlue.withAlpha(120)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    ),
                  ),
                  if (_savedExclusions.isNotEmpty)
                    OutlinedButton.icon(
                      onPressed: _deleteAllExclusions,
                      icon: const Icon(Icons.delete_sweep_rounded, size: 18, color: Colors.red),
                      label: const Text('Elimina Tutti', style: TextStyle(color: Colors.red)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Barra di ricerca tra gli esclusi
          if (_savedExclusions.length > 3) ...[
            TextField(
              decoration: InputDecoration(
                hintText: 'Cerca per ID o nome del corso...',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
            const SizedBox(height: 16),
          ],

          if (items.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 36),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Icon(Icons.check_circle_outline_rounded, size: 40, color: Colors.grey.shade400),
                  const SizedBox(height: 10),
                  Text(
                    _savedExclusions.isEmpty
                        ? 'Nessun corso escluso. Tutti i corsi a catalogo sono inclusi.'
                        : 'Nessun corso corrispondente alla ricerca.',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = items[index];
                final courseName = item.courseName ?? _coursesNameMap[item.courseId] ?? 'Nome non disponibile';
                final dateStr = item.createdAt != null
                    ? DateFormat('dd/MM/yyyy HH:mm').format(item.createdAt!)
                    : '-';

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      // Badge ID
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFFCA5A5)),
                        ),
                        child: Text(
                          'ID #${item.courseId}',
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Color(0xFFB91C1C),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Nome Corso e Data
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              courseName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E293B),
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Escluso il $dateStr',
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      ),

                      // Tasto Elimina Singolo
                      IconButton(
                        icon: Icon(Icons.delete_outline_rounded, color: Colors.red.shade600, size: 20),
                        tooltip: 'Elimina esclusione',
                        onPressed: () => _deleteExclusion(item),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
