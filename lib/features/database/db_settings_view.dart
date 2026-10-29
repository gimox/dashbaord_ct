import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/db/isar_provider.dart';
import '../../core/theme/app_theme.dart';
import '../exclusions/models/course_exclusion.dart';
import '../settings/models/app_settings.dart';
import '../settings/providers/app_settings_provider.dart';
import '../sync/models/badge_user.dart';
import '../sync/models/category.dart';
import '../sync/models/course.dart';
import '../sync/models/course_info.dart';
import '../sync/models/merge_webex_user.dart';
import '../sync/models/stat_mdl.dart';
import '../sync/models/user.dart';
import '../sync/models/user_course_enrolled.dart';
import '../sync/models/feedback_for_bi.dart';
import '../catalog/models/course_catalog_item.dart';

class DbSettingsView extends ConsumerStatefulWidget {
  const DbSettingsView({super.key});

  @override
  ConsumerState<DbSettingsView> createState() => _DbSettingsViewState();
}

class _DbSettingsViewState extends ConsumerState<DbSettingsView> {
  int _usersCount = 0;
  int _categoriesCount = 0;
  int _coursesCount = 0;
  int _badgesUsersCount = 0;
  int _courseInfoCount = 0;
  int _mergeWebexUsersCount = 0;
  int _statMdlCount = 0;
  int _userCourseEnrolledCount = 0;
  int _courseExclusionsCount = 0;
  int _feedbackForBiCount = 0;
  int _courseCatalogCount = 0;
  int _settingsCount = 0;
  bool _isLoading = false;
  StreamSubscription<void>? _usersSub;
  StreamSubscription<void>? _categoriesSub;
  StreamSubscription<void>? _coursesSub;
  StreamSubscription<void>? _badgesUsersSub;
  StreamSubscription<void>? _courseInfoSub;
  StreamSubscription<void>? _mergeWebexUsersSub;
  StreamSubscription<void>? _statMdlSub;
  StreamSubscription<void>? _userCourseEnrolledSub;
  StreamSubscription<void>? _courseExclusionsSub;
  StreamSubscription<void>? _feedbackForBiSub;
  StreamSubscription<void>? _courseCatalogSub;
  StreamSubscription<void>? _settingsSub;

  @override
  void initState() {
    super.initState();
    _refreshCounts();
    final isar = ref.read(isarProvider);
    _usersSub = isar.users.watchLazy().listen((_) {
      _refreshCounts();
    });
    _categoriesSub = isar.categories.watchLazy().listen((_) {
      _refreshCounts();
    });
    _coursesSub = isar.courses.watchLazy().listen((_) {
      _refreshCounts();
    });
    _badgesUsersSub = isar.badgeUsers.watchLazy().listen((_) {
      _refreshCounts();
    });
    _courseInfoSub = isar.courseInfos.watchLazy().listen((_) {
      _refreshCounts();
    });
    _mergeWebexUsersSub = isar.mergeWebexUsers.watchLazy().listen((_) {
      _refreshCounts();
    });
    _statMdlSub = isar.statMdls.watchLazy().listen((_) {
      _refreshCounts();
    });
    _userCourseEnrolledSub = isar.userCourseEnrolleds.watchLazy().listen((_) {
      _refreshCounts();
    });
    _courseExclusionsSub = isar.courseExclusions.watchLazy().listen((_) {
      _refreshCounts();
    });
    _feedbackForBiSub = isar.feedbackForBis.watchLazy().listen((_) {
      _refreshCounts();
    });
    _courseCatalogSub = isar.courseCatalogItems.watchLazy().listen((_) {
      _refreshCounts();
    });
    _settingsSub = isar.appSettings.watchLazy().listen((_) {
      _refreshCounts();
    });
  }

  @override
  void dispose() {
    _usersSub?.cancel();
    _categoriesSub?.cancel();
    _coursesSub?.cancel();
    _badgesUsersSub?.cancel();
    _courseInfoSub?.cancel();
    _mergeWebexUsersSub?.cancel();
    _statMdlSub?.cancel();
    _userCourseEnrolledSub?.cancel();
    _courseExclusionsSub?.cancel();
    _feedbackForBiSub?.cancel();
    _courseCatalogSub?.cancel();
    _settingsSub?.cancel();
    super.dispose();
  }

  Future<void> _refreshCounts() async {
    final isar = ref.read(isarProvider);
    final users = await isar.users.count();
    final categories = await isar.categories.count();
    final courses = await isar.courses.count();
    final badgesUsers = await isar.badgeUsers.count();
    final courseInfo = await isar.courseInfos.count();
    final mergeWebexUsers = await isar.mergeWebexUsers.count();
    final statMdl = await isar.statMdls.count();
    final userCourseEnrolled = await isar.userCourseEnrolleds.count();
    final courseExclusions = await isar.courseExclusions.count();
    final feedbackForBi = await isar.feedbackForBis.count();
    final courseCatalog = await isar.courseCatalogItems.count();
    final settings = await isar.appSettings.count();
    if (mounted) {
      setState(() {
        _usersCount = users;
        _categoriesCount = categories;
        _coursesCount = courses;
        _badgesUsersCount = badgesUsers;
        _courseInfoCount = courseInfo;
        _mergeWebexUsersCount = mergeWebexUsers;
        _statMdlCount = statMdl;
        _userCourseEnrolledCount = userCourseEnrolled;
        _courseExclusionsCount = courseExclusions;
        _feedbackForBiCount = feedbackForBi;
        _courseCatalogCount = courseCatalog;
        _settingsCount = settings;
      });
    }
  }

  Future<void> _clearUsersTable() async {
    final confirmed = await _showConfirmDialog(
      title: 'Resettare tabella Users?',
      content: 'Tutti i record degli utenti memorizzati nel database locale verranno eliminati permanentemente.',
    );
    if (!confirmed) return;

    setState(() => _isLoading = true);
    try {
      final isar = ref.read(isarProvider);
      await isar.writeTxn(() async {
        await isar.users.clear();
      });
      await ref.read(appSettingsProvider.notifier).updateUsersSyncDate(DateTime.fromMillisecondsSinceEpoch(0));
      await _refreshCounts();
      _showSuccessSnack('Tabella Users svuotata con successo.');
    } catch (e) {
      _showErrorSnack('Errore durante lo svuotamento: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _clearCategoriesTable() async {
    final confirmed = await _showConfirmDialog(
      title: 'Resettare tabella Categories?',
      content: 'Tutte le categorie memorizzate nel database locale verranno eliminate permanentemente.',
    );
    if (!confirmed) return;

    setState(() => _isLoading = true);
    try {
      final isar = ref.read(isarProvider);
      await isar.writeTxn(() async {
        await isar.categories.clear();
      });
      await ref.read(appSettingsProvider.notifier).updateCategoriesSyncDate(DateTime.fromMillisecondsSinceEpoch(0));
      await _refreshCounts();
      _showSuccessSnack('Tabella Categories svuotata con successo.');
    } catch (e) {
      _showErrorSnack('Errore durante lo svuotamento: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _clearCoursesTable() async {
    final confirmed = await _showConfirmDialog(
      title: 'Resettare tabella Courses?',
      content: 'Tutti i corsi memorizzati nel database locale verranno eliminati permanentemente.',
    );
    if (!confirmed) return;

    setState(() => _isLoading = true);
    try {
      final isar = ref.read(isarProvider);
      await isar.writeTxn(() async {
        await isar.courses.clear();
      });
      await ref.read(appSettingsProvider.notifier).updateCoursesSyncDate(DateTime.fromMillisecondsSinceEpoch(0));
      await _refreshCounts();
      _showSuccessSnack('Tabella Courses svuotata con successo.');
    } catch (e) {
      _showErrorSnack('Errore durante lo svuotamento: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _clearBadgesUsersTable() async {
    final confirmed = await _showConfirmDialog(
      title: 'Resettare tabella Badges Users?',
      content: 'Tutti i record dei badge utenti memorizzati nel database locale verranno eliminati permanentemente.',
    );
    if (!confirmed) return;

    setState(() => _isLoading = true);
    try {
      final isar = ref.read(isarProvider);
      await isar.writeTxn(() async {
        await isar.badgeUsers.clear();
      });
      await ref.read(appSettingsProvider.notifier).updateBadgesUsersSyncDate(DateTime.fromMillisecondsSinceEpoch(0));
      await _refreshCounts();
      _showSuccessSnack('Tabella Badges Users svuotata con successo.');
    } catch (e) {
      _showErrorSnack('Errore durante lo svuotamento: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _clearCourseInfoTable() async {
    final confirmed = await _showConfirmDialog(
      title: 'Resettare tabella Course Info?',
      content: 'Tutte le informazioni su sezioni e moduli didattici memorizzate nel database locale verranno eliminate permanentemente.',
    );
    if (!confirmed) return;

    setState(() => _isLoading = true);
    try {
      final isar = ref.read(isarProvider);
      await isar.writeTxn(() async {
        await isar.courseInfos.clear();
      });
      await ref.read(appSettingsProvider.notifier).updateCourseInfoSyncDate(DateTime.fromMillisecondsSinceEpoch(0));
      await _refreshCounts();
      _showSuccessSnack('Tabella Course Info svuotata con successo.');
    } catch (e) {
      _showErrorSnack('Errore durante lo svuotamento: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _clearMergeWebexUsersTable() async {
    final confirmed = await _showConfirmDialog(
      title: 'Resettare tabella Merge Webex Users?',
      content: 'Tutte le sessioni Webex memorizzate nel database locale verranno eliminate permanentemente.',
    );
    if (!confirmed) return;

    setState(() => _isLoading = true);
    try {
      final isar = ref.read(isarProvider);
      await isar.writeTxn(() async {
        await isar.mergeWebexUsers.clear();
      });
      await ref.read(appSettingsProvider.notifier).updateMergeWebexUsersSyncDate(DateTime.fromMillisecondsSinceEpoch(0));
      await _refreshCounts();
      _showSuccessSnack('Tabella Merge Webex Users svuotata con successo.');
    } catch (e) {
      _showErrorSnack('Errore durante lo svuotamento: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _clearStatMdlTable() async {
    final confirmed = await _showConfirmDialog(
      title: 'Resettare tabella Stat Moduli (stat_mdl)?',
      content: 'Tutte le statistiche dei moduli memorizzate nel database locale verranno eliminate permanentemente.',
    );
    if (!confirmed) return;

    setState(() => _isLoading = true);
    try {
      final isar = ref.read(isarProvider);
      await isar.writeTxn(() async {
        await isar.statMdls.clear();
      });
      await ref.read(appSettingsProvider.notifier).updateStatMdlSyncDate(DateTime.fromMillisecondsSinceEpoch(0));
      await _refreshCounts();
      _showSuccessSnack('Tabella Stat Moduli svuotata con successo.');
    } catch (e) {
      _showErrorSnack('Errore durante lo svuotamento: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _clearUserCourseEnrolledTable() async {
    final confirmed = await _showConfirmDialog(
      title: 'Resettare tabella Iscrizioni (user_course_enrolled)?',
      content: 'Tutte le iscrizioni degli utenti ai corsi memorizzate nel database locale verranno eliminate permanentemente.',
    );
    if (!confirmed) return;

    setState(() => _isLoading = true);
    try {
      final isar = ref.read(isarProvider);
      await isar.writeTxn(() async {
        await isar.userCourseEnrolleds.clear();
      });
      await ref.read(appSettingsProvider.notifier).updateUserCourseEnrolledSyncDate(DateTime.fromMillisecondsSinceEpoch(0));
      await _refreshCounts();
      _showSuccessSnack('Tabella Iscrizioni svuotata con successo.');
    } catch (e) {
      _showErrorSnack('Errore durante lo svuotamento: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _clearSettingsTable() async {
    final confirmed = await _showConfirmDialog(
      title: 'Resettare impostazioni applicative?',
      content: 'Tutti i parametri (Proxy, credenziali API, stato sync) verranno ripristinati ai valori di fabbrica predefiniti.',
    );
    if (!confirmed) return;

    setState(() => _isLoading = true);
    try {
      final isar = ref.read(isarProvider);
      final initial = AppSettings();
      await isar.writeTxn(() async {
        await isar.appSettings.clear();
        await isar.appSettings.put(initial);
      });
      ref.invalidate(appSettingsProvider);
      await _refreshCounts();
      _showSuccessSnack('Tabella AppSettings ripristinata ai valori predefiniti.');
    } catch (e) {
      _showErrorSnack('Errore durante il reset: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _clearCourseExclusionsTable() async {
    final confirmed = await _showConfirmDialog(
      title: 'Resettare tabella Esclusioni Corsi?',
      content: 'Tutti gli ID dei corsi esclusi memorizzati nel database locale verranno eliminati permanentemente.',
    );
    if (!confirmed) return;

    setState(() => _isLoading = true);
    try {
      final isar = ref.read(isarProvider);
      await isar.writeTxn(() async {
        await isar.courseExclusions.clear();
      });
      await _refreshCounts();
      _showSuccessSnack('Tabella Esclusioni Corsi svuotata con successo.');
    } catch (e) {
      _showErrorSnack('Errore durante lo svuotamento: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _clearFeedbackForBiTable() async {
    final confirmed = await _showConfirmDialog(
      title: 'Resettare tabella Feedback for BI?',
      content: 'Tutti i feedback per BI memorizzati nel database locale verranno eliminati permanentemente.',
    );
    if (!confirmed) return;

    setState(() => _isLoading = true);
    try {
      final isar = ref.read(isarProvider);
      await isar.writeTxn(() async {
        await isar.feedbackForBis.clear();
      });
      await ref.read(appSettingsProvider.notifier).updateFeedbackForBiSyncDate(DateTime.fromMillisecondsSinceEpoch(0));
      await _refreshCounts();
      _showSuccessSnack('Tabella Feedback for BI svuotata con successo.');
    } catch (e) {
      _showErrorSnack('Errore durante lo svuotamento: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _clearCourseCatalogTable() async {
    final confirmed = await _showConfirmDialog(
      title: 'Resettare tabella Catalogo Corsi?',
      content: 'Tutte le voci del catalogo con relative durate e mappature memorizzate nel database locale verranno eliminate permanentemente.',
    );
    if (!confirmed) return;

    setState(() => _isLoading = true);
    try {
      final isar = ref.read(isarProvider);
      await isar.writeTxn(() async {
        await isar.courseCatalogItems.clear();
      });
      await ref.read(appSettingsProvider.notifier).updateCourseCatalogSyncDate(DateTime.fromMillisecondsSinceEpoch(0));
      await _refreshCounts();
      _showSuccessSnack('Tabella Catalogo Corsi svuotata con successo.');
    } catch (e) {
      _showErrorSnack('Errore durante lo svuotamento: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _clearAllTables() async {
    final confirmed = await _showConfirmDialog(
      title: 'Eseguire Reset Completo del Database?',
      content: 'Questa operazione svuoterà TUTTE le tabelle (Users, Categories, Courses, Badges Users, Course Info, Merge Webex Users, Stat Moduli, Iscrizioni, Esclusioni, Feedback for BI, Catalogo Corsi e AppSettings). Tutti i dati locali andranno persi.',
      isDestructive: true,
    );
    if (!confirmed) return;

    setState(() => _isLoading = true);
    try {
      final isar = ref.read(isarProvider);
      await isar.writeTxn(() async {
        await isar.users.clear();
        await isar.categories.clear();
        await isar.courses.clear();
        await isar.badgeUsers.clear();
        await isar.courseInfos.clear();
        await isar.mergeWebexUsers.clear();
        await isar.statMdls.clear();
        await isar.userCourseEnrolleds.clear();
        await isar.courseExclusions.clear();
        await isar.feedbackForBis.clear();
        await isar.courseCatalogItems.clear();
        await isar.appSettings.clear();
        await isar.appSettings.put(AppSettings());
      });
      ref.invalidate(appSettingsProvider);
      await _refreshCounts();
      _showSuccessSnack('Reset completo eseguito con successo su tutte le tabelle.');
    } catch (e) {
      _showErrorSnack('Errore durante il reset completo: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<bool> _showConfirmDialog({
    required String title,
    required String content,
    bool isDestructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                isDestructive ? Icons.warning_amber_rounded : Icons.help_outline_rounded,
                color: isDestructive ? Colors.red.shade700 : AppTheme.primaryBlue,
              ),
              const SizedBox(width: 10),
              Flexible(child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            ],
          ),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Annulla'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDestructive ? Colors.red.shade700 : AppTheme.primaryBlue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Conferma Reset', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  void _showSuccessSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Riascolta eventuali cambi in AppSettings (es. reset o sync completati)
    ref.listen(appSettingsProvider, (_, __) => _refreshCounts());

    final totalRecords = _usersCount +
        _categoriesCount +
        _coursesCount +
        _badgesUsersCount +
        _courseInfoCount +
        _mergeWebexUsersCount +
        _statMdlCount +
        _userCourseEnrolledCount +
        _courseExclusionsCount +
        _feedbackForBiCount +
        _courseCatalogCount +
        _settingsCount;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.refresh_rounded),
                    onPressed: _isLoading ? null : _refreshCounts,
                    tooltip: 'Ricarica contatori',
                  ),
                ),
                const SizedBox(height: 12),

                // Card Riepilogo Globale
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue.withAlpha(20),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.dns_rounded, color: AppTheme.primaryBlue, size: 30),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'STATO DATABASE ISAR',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue, letterSpacing: 1.0),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '12 tabelle gestite • $totalRecords record totali memorizzati',
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: _isLoading ? null : _clearAllTables,
                          icon: const Icon(Icons.delete_forever_rounded, color: Colors.red),
                          label: const Text('Reset Completo DB', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Lista Tabelle (Lista di Card)
                const Text(
                  'TABELLE REGISTRATE',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue, letterSpacing: 1.0),
                ),
                const SizedBox(height: 12),

                _buildTablesListView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTablesListView() {
    return Column(
      children: [
        _buildTableListItem(
          icon: Icons.people_alt_outlined,
          iconColor: AppTheme.primaryBlue,
          name: 'Users',
          schema: 'UserSchema',
          count: _usersCount,
          description: 'Utenti sincronizzati dal server API (attributi anagrafici e campi personalizzati)',
          actionLabel: 'Svuota Tabella',
          actionIcon: Icons.cleaning_services_outlined,
          actionColor: Colors.red.shade700,
          actionBorderColor: Colors.red.shade200,
          onAction: _clearUsersTable,
        ),
        const SizedBox(height: 12),
        _buildTableListItem(
          icon: Icons.category_outlined,
          iconColor: const Color(0xFF0284C7),
          name: 'Categories',
          schema: 'CategorySchema',
          count: _categoriesCount,
          description: 'Categorie di corsi sincronizzate dal server API (struttura gerarchica, moduli e visibilità)',
          actionLabel: 'Svuota Tabella',
          actionIcon: Icons.cleaning_services_outlined,
          actionColor: Colors.red.shade700,
          actionBorderColor: Colors.red.shade200,
          onAction: _clearCategoriesTable,
        ),
        const SizedBox(height: 12),
        _buildTableListItem(
          icon: Icons.school_outlined,
          iconColor: const Color(0xFF0D9488),
          name: 'Courses',
          schema: 'CourseSchema',
          count: _coursesCount,
          description: 'Corsi formativi, moduli didattici, impostazioni di tracciamento e campi personalizzati',
          actionLabel: 'Svuota Tabella',
          actionIcon: Icons.cleaning_services_outlined,
          actionColor: Colors.red.shade700,
          actionBorderColor: Colors.red.shade200,
          onAction: _clearCoursesTable,
        ),
        const SizedBox(height: 12),
        _buildTableListItem(
          icon: Icons.military_tech_outlined,
          iconColor: const Color(0xFFE11D48),
          name: 'Badges Users',
          schema: 'BadgeUserSchema',
          count: _badgesUsersCount,
          description: 'Assegnazioni badge e certificazioni agli utenti con codice, data di rilascio ed email',
          actionLabel: 'Svuota Tabella',
          actionIcon: Icons.cleaning_services_outlined,
          actionColor: Colors.red.shade700,
          actionBorderColor: Colors.red.shade200,
          onAction: _clearBadgesUsersTable,
        ),
        const SizedBox(height: 12),
        _buildTableListItem(
          icon: Icons.layers_outlined,
          iconColor: const Color(0xFF8B5CF6),
          name: 'Course Info',
          schema: 'CourseInfoSchema',
          count: _courseInfoCount,
          description: 'Sezioni e moduli didattici di dettaglio dei corsi (forum, risorse, attività e tracciamento)',
          actionLabel: 'Svuota Tabella',
          actionIcon: Icons.cleaning_services_outlined,
          actionColor: Colors.red.shade700,
          actionBorderColor: Colors.red.shade200,
          onAction: _clearCourseInfoTable,
        ),
        const SizedBox(height: 12),
        _buildTableListItem(
          icon: Icons.video_camera_front_outlined,
          iconColor: const Color(0xFF0284C7),
          name: 'Merge Webex Users',
          schema: 'MergeWebexUserSchema',
          count: _mergeWebexUsersCount,
          description: 'Sessioni e partecipanti Webex aggregati con corsi Moodle, metriche VoIP/video e completamento',
          actionLabel: 'Svuota Tabella',
          actionIcon: Icons.cleaning_services_outlined,
          actionColor: Colors.red.shade700,
          actionBorderColor: Colors.red.shade200,
          onAction: _clearMergeWebexUsersTable,
        ),
        const SizedBox(height: 12),
        _buildTableListItem(
          icon: Icons.analytics_outlined,
          iconColor: const Color(0xFFD97706),
          name: 'Stat Moduli (stat_mdl)',
          schema: 'StatMdlSchema',
          count: _statMdlCount,
          description: 'Statistiche e avanzamento moduli per utente e corso (SCORM, test, accessi e completamenti)',
          actionLabel: 'Svuota Tabella',
          actionIcon: Icons.cleaning_services_outlined,
          actionColor: Colors.red.shade700,
          actionBorderColor: Colors.red.shade200,
          onAction: _clearStatMdlTable,
        ),
        const SizedBox(height: 12),
        _buildTableListItem(
          icon: Icons.how_to_reg_outlined,
          iconColor: const Color(0xFF4F46E5),
          name: 'Iscrizioni Utenti (user_course_enrolled)',
          schema: 'UserCourseEnrolledSchema',
          count: _userCourseEnrolledCount,
          description: 'Elenco ufficiale associazioni utente-corso (course_id, user_id)',
          actionLabel: 'Svuota Tabella',
          actionIcon: Icons.cleaning_services_outlined,
          actionColor: Colors.red.shade700,
          actionBorderColor: Colors.red.shade200,
          onAction: _clearUserCourseEnrolledTable,
        ),
        const SizedBox(height: 12),
        _buildTableListItem(
          icon: Icons.rate_review_outlined,
          iconColor: const Color(0xFF0EA5E9),
          name: 'Feedback for BI (feedback_for_bi)',
          schema: 'FeedbackForBiSchema',
          count: _feedbackForBiCount,
          description: 'Feedback e valutazioni dei corsi per BI (HQ1-HQ4, commenti testuali, corso e lingua)',
          actionLabel: 'Svuota Tabella',
          actionIcon: Icons.cleaning_services_outlined,
          actionColor: Colors.red.shade700,
          actionBorderColor: Colors.red.shade200,
          onAction: _clearFeedbackForBiTable,
        ),
        const SizedBox(height: 12),
        _buildTableListItem(
          icon: Icons.block_flipped,
          iconColor: const Color(0xFFF97316),
          name: 'Esclusioni Corsi',
          schema: 'CourseExclusionSchema',
          count: _courseExclusionsCount,
          description: 'ID dei corsi formativi esclusi dai conteggi e dalla reportistica',
          actionLabel: 'Svuota Tabella',
          actionIcon: Icons.cleaning_services_outlined,
          actionColor: Colors.red.shade700,
          actionBorderColor: Colors.red.shade200,
          onAction: _clearCourseExclusionsTable,
        ),
        const SizedBox(height: 12),
        _buildTableListItem(
          icon: Icons.menu_book_outlined,
          iconColor: const Color(0xFF0284C7),
          name: 'Catalogo Corsi & Durate',
          schema: 'CourseCatalogItemSchema',
          count: _courseCatalogCount,
          description: 'Catalogo percorsi formativi, codici corso, durata in ore didattiche, studio individuale e mappature Moodle',
          actionLabel: 'Svuota Tabella',
          actionIcon: Icons.cleaning_services_outlined,
          actionColor: Colors.red.shade700,
          actionBorderColor: Colors.red.shade200,
          onAction: _clearCourseCatalogTable,
        ),
        const SizedBox(height: 12),
        _buildTableListItem(
          icon: Icons.settings_suggest_outlined,
          iconColor: const Color(0xFF475569),
          name: 'AppSettings',
          schema: 'AppSettingsSchema',
          count: _settingsCount,
          description: 'Singleton parametri di sistema (proxy aziendale, credenziali API, timestamp sincronizzazione)',
          actionLabel: 'Ripristina Default',
          actionIcon: Icons.restore_rounded,
          actionColor: Colors.orange.shade800,
          actionBorderColor: Colors.orange.shade300,
          onAction: _clearSettingsTable,
        ),
      ],
    );
  }

  Widget _buildTableListItem({
    required IconData icon,
    required Color iconColor,
    required String name,
    required String schema,
    required int count,
    required String description,
    required String actionLabel,
    required IconData actionIcon,
    required Color actionColor,
    required Color actionBorderColor,
    required VoidCallback onAction,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 620;

          final iconWidget = Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          );

          final detailsWidget = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Text(
                      schema,
                      style: const TextStyle(fontSize: 11, fontFamily: 'monospace', color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withAlpha(16),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$count record',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.3),
              ),
            ],
          );

          final buttonWidget = OutlinedButton.icon(
            onPressed: _isLoading ? null : onAction,
            icon: Icon(actionIcon, size: 16, color: actionColor),
            label: Text(actionLabel, style: TextStyle(color: actionColor, fontWeight: FontWeight.bold, fontSize: 13)),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: actionBorderColor),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          );

          if (isCompact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    iconWidget,
                    const SizedBox(width: 14),
                    Expanded(child: detailsWidget),
                  ],
                ),
                const SizedBox(height: 14),
                Align(
                  alignment: Alignment.centerRight,
                  child: buttonWidget,
                ),
              ],
            );
          }

          return Row(
            children: [
              iconWidget,
              const SizedBox(width: 16),
              Expanded(child: detailsWidget),
              const SizedBox(width: 16),
              buttonWidget,
            ],
          );
        },
      ),
    );
  }
}
