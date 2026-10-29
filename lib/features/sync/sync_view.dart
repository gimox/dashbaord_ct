import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:universal_io/universal_io.dart';
import '../../core/db/isar_provider.dart';
import '../../core/theme/app_theme.dart';
import '../settings/providers/app_settings_provider.dart';
import 'models/badge_user.dart';
import 'models/category.dart';
import 'models/course.dart';
import 'models/course_info.dart';
import 'models/merge_webex_user.dart';
import 'models/stat_mdl.dart';
import 'models/user.dart';
import 'models/user_course_enrolled.dart';
import 'models/feedback_for_bi.dart';
import '../catalog/models/course_catalog_item.dart';
import '../catalog/services/course_catalog_service.dart';

class SyncSettingsView extends ConsumerStatefulWidget {
  const SyncSettingsView({super.key});

  @override
  ConsumerState<SyncSettingsView> createState() => _SyncSettingsViewState();
}

class _SyncSettingsViewState extends ConsumerState<SyncSettingsView> {
  bool _isSyncing = false;
  int _localUsersCount = 0;
  String? _syncErrorMessage;
  String? _syncSuccessMessage;
  StreamSubscription<void>? _usersSub;

  bool _isCategoriesSyncing = false;
  int _localCategoriesCount = 0;
  String? _categoriesSyncErrorMessage;
  String? _categoriesSyncSuccessMessage;
  StreamSubscription<void>? _categoriesSub;

  bool _isCoursesSyncing = false;
  int _localCoursesCount = 0;
  String? _coursesSyncErrorMessage;
  String? _coursesSyncSuccessMessage;
  StreamSubscription<void>? _coursesSub;

  bool _isBadgesUsersSyncing = false;
  int _localBadgesUsersCount = 0;
  String? _badgesUsersSyncErrorMessage;
  String? _badgesUsersSyncSuccessMessage;
  StreamSubscription<void>? _badgesUsersSub;

  bool _isCourseInfoSyncing = false;
  int _localCourseInfoCount = 0;
  String? _courseInfoSyncErrorMessage;
  String? _courseInfoSyncSuccessMessage;
  StreamSubscription<void>? _courseInfoSub;

  bool _isMergeWebexUsersSyncing = false;
  int _localMergeWebexUsersCount = 0;
  String? _mergeWebexUsersSyncErrorMessage;
  String? _mergeWebexUsersSyncSuccessMessage;
  StreamSubscription<void>? _mergeWebexUsersSub;

  bool _isStatMdlSyncing = false;
  int _localStatMdlCount = 0;
  String? _statMdlSyncErrorMessage;
  String? _statMdlSyncSuccessMessage;
  StreamSubscription<void>? _statMdlSub;

  bool _isUserCourseEnrolledSyncing = false;
  int _localUserCourseEnrolledCount = 0;
  String? _userCourseEnrolledSyncErrorMessage;
  String? _userCourseEnrolledSyncSuccessMessage;
  StreamSubscription<void>? _userCourseEnrolledSub;

  bool _isFeedbackForBiSyncing = false;
  int _localFeedbackForBiCount = 0;
  String? _feedbackForBiSyncErrorMessage;
  String? _feedbackForBiSyncSuccessMessage;
  StreamSubscription<void>? _feedbackForBiSub;

  bool _isCourseCatalogSyncing = false;
  int _localCourseCatalogCount = 0;
  String? _courseCatalogSyncErrorMessage;
  String? _courseCatalogSyncSuccessMessage;
  StreamSubscription<void>? _courseCatalogSub;

  @override
  void initState() {
    super.initState();
    _refreshLocalCount();
    final isar = ref.read(isarProvider);
    _usersSub = isar.users.watchLazy().listen((_) {
      _refreshLocalCount();
    });
    _categoriesSub = isar.categories.watchLazy().listen((_) {
      _refreshLocalCount();
    });
    _coursesSub = isar.courses.watchLazy().listen((_) {
      _refreshLocalCount();
    });
    _badgesUsersSub = isar.badgeUsers.watchLazy().listen((_) {
      _refreshLocalCount();
    });
    _courseInfoSub = isar.courseInfos.watchLazy().listen((_) {
      _refreshLocalCount();
    });
    _mergeWebexUsersSub = isar.mergeWebexUsers.watchLazy().listen((_) {
      _refreshLocalCount();
    });
    _statMdlSub = isar.statMdls.watchLazy().listen((_) {
      _refreshLocalCount();
    });
    _userCourseEnrolledSub = isar.userCourseEnrolleds.watchLazy().listen((_) {
      _refreshLocalCount();
    });
    _feedbackForBiSub = isar.feedbackForBis.watchLazy().listen((_) {
      _refreshLocalCount();
    });
    _courseCatalogSub = isar.courseCatalogItems.watchLazy().listen((_) {
      _refreshLocalCount();
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
    _feedbackForBiSub?.cancel();
    _courseCatalogSub?.cancel();
    super.dispose();
  }

  Future<void> _refreshLocalCount() async {
    final isar = ref.read(isarProvider);
    final count = await isar.users.count();
    final catCount = await isar.categories.count();
    final courseCount = await isar.courses.count();
    final badgesUsersCount = await isar.badgeUsers.count();
    final courseInfoCount = await isar.courseInfos.count();
    final mergeWebexUsersCount = await isar.mergeWebexUsers.count();
    final statMdlCount = await isar.statMdls.count();
    final userCourseEnrolledCount = await isar.userCourseEnrolleds.count();
    final feedbackForBiCount = await isar.feedbackForBis.count();
    final courseCatalogCount = await isar.courseCatalogItems.count();
    if (mounted) {
      setState(() {
        _localUsersCount = count;
        _localCategoriesCount = catCount;
        _localCoursesCount = courseCount;
        _localBadgesUsersCount = badgesUsersCount;
        _localCourseInfoCount = courseInfoCount;
        _localMergeWebexUsersCount = mergeWebexUsersCount;
        _localStatMdlCount = statMdlCount;
        _localUserCourseEnrolledCount = userCourseEnrolledCount;
        _localFeedbackForBiCount = feedbackForBiCount;
        _localCourseCatalogCount = courseCatalogCount;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(appSettingsProvider);
    final lastSyncText = settings.lastUsersSyncDate != null &&
            settings.lastUsersSyncDate!.millisecondsSinceEpoch > 0
        ? DateFormat('dd/MM/yyyy HH:mm:ss').format(settings.lastUsersSyncDate!)
        : 'Mai eseguito';
    final lastCategoriesSyncText = settings.lastCategoriesSyncDate != null &&
            settings.lastCategoriesSyncDate!.millisecondsSinceEpoch > 0
        ? DateFormat('dd/MM/yyyy HH:mm:ss').format(settings.lastCategoriesSyncDate!)
        : 'Mai eseguito';
    final lastCoursesSyncText = settings.lastCoursesSyncDate != null &&
            settings.lastCoursesSyncDate!.millisecondsSinceEpoch > 0
        ? DateFormat('dd/MM/yyyy HH:mm:ss').format(settings.lastCoursesSyncDate!)
        : 'Mai eseguito';
    final lastBadgesUsersSyncText = settings.lastBadgesUsersSyncDate != null &&
            settings.lastBadgesUsersSyncDate!.millisecondsSinceEpoch > 0
        ? DateFormat('dd/MM/yyyy HH:mm:ss').format(settings.lastBadgesUsersSyncDate!)
        : 'Mai eseguito';
    final lastCourseInfoSyncText = settings.lastCourseInfoSyncDate != null &&
            settings.lastCourseInfoSyncDate!.millisecondsSinceEpoch > 0
        ? DateFormat('dd/MM/yyyy HH:mm:ss').format(settings.lastCourseInfoSyncDate!)
        : 'Mai eseguito';
    final lastMergeWebexUsersSyncText = settings.lastMergeWebexUsersSyncDate != null &&
            settings.lastMergeWebexUsersSyncDate!.millisecondsSinceEpoch > 0
        ? DateFormat('dd/MM/yyyy HH:mm:ss').format(settings.lastMergeWebexUsersSyncDate!)
        : 'Mai eseguito';
    final lastStatMdlSyncText = settings.lastStatMdlSyncDate != null &&
            settings.lastStatMdlSyncDate!.millisecondsSinceEpoch > 0
        ? DateFormat('dd/MM/yyyy HH:mm:ss').format(settings.lastStatMdlSyncDate!)
        : 'Mai eseguito';
    final lastUserCourseEnrolledSyncText = settings.lastUserCourseEnrolledSyncDate != null &&
            settings.lastUserCourseEnrolledSyncDate!.millisecondsSinceEpoch > 0
        ? DateFormat('dd/MM/yyyy HH:mm:ss').format(settings.lastUserCourseEnrolledSyncDate!)
        : 'Mai eseguito';
    final lastFeedbackForBiSyncText = settings.lastFeedbackForBiSyncDate != null &&
            settings.lastFeedbackForBiSyncDate!.millisecondsSinceEpoch > 0
        ? DateFormat('dd/MM/yyyy HH:mm:ss').format(settings.lastFeedbackForBiSyncDate!)
        : 'Mai eseguito';
    final lastCourseCatalogSyncText = settings.lastCourseCatalogSyncDate != null &&
            settings.lastCourseCatalogSyncDate!.millisecondsSinceEpoch > 0
        ? DateFormat('dd/MM/yyyy HH:mm:ss').format(settings.lastCourseCatalogSyncDate!)
        : 'Mai eseguito';

    final totalRecords = _localUsersCount +
        _localCategoriesCount +
        _localCoursesCount +
        _localBadgesUsersCount +
        _localCourseInfoCount +
        _localMergeWebexUsersCount +
        _localStatMdlCount +
        _localUserCourseEnrolledCount +
        _localFeedbackForBiCount +
        _localCourseCatalogCount;
    final isAnySyncing = _isSyncing ||
        _isCategoriesSyncing ||
        _isCoursesSyncing ||
        _isBadgesUsersSyncing ||
        _isCourseInfoSyncing ||
        _isMergeWebexUsersSyncing ||
        _isStatMdlSyncing ||
        _isUserCourseEnrolledSyncing ||
        _isFeedbackForBiSyncing ||
        _isCourseCatalogSyncing;

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
                    onPressed: isAnySyncing ? null : _refreshLocalCount,
                    tooltip: 'Ricarica metriche locali',
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
                          child: const Icon(Icons.sync_alt_rounded, color: AppTheme.primaryBlue, size: 30),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'STATO SINCRONIZZAZIONE',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue, letterSpacing: 1.0),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '9 collezioni API collegate • $totalRecords record totali in locale',
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: isAnySyncing ? null : _syncAll,
                          icon: isAnySyncing
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : const Icon(Icons.sync_rounded),
                          label: Text(
                            isAnySyncing ? 'Sincronizzazione...' : 'Sincronizza Tutti',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryBlue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Lista Collezioni Sincronizzabili
                const Text(
                  'COLLEZIONI DISPONIBILI',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue, letterSpacing: 1.0),
                ),
                const SizedBox(height: 12),

                _buildSyncListItem(
                  icon: Icons.people_alt_outlined,
                  iconColor: AppTheme.primaryBlue,
                  title: 'Utenti (Users)',
                  endpoint: '/users',
                  description: 'Scarica l\'elenco utenti completo con attributi anagrafici, ruoli e customfields.',
                  lastSyncText: lastSyncText,
                  localCountText: '$_localUsersCount utenti',
                  isSyncing: _isSyncing,
                  onSync: _syncUsers,
                  errorMessage: _syncErrorMessage,
                  successMessage: _syncSuccessMessage,
                ),
                const SizedBox(height: 14),

                _buildSyncListItem(
                  icon: Icons.category_outlined,
                  iconColor: const Color(0xFF0284C7),
                  title: 'Categorie Corsi (Categories)',
                  endpoint: '/categories',
                  description: 'Scarica le categorie di corsi con moduli, descrizioni, immagini e gerarchia.',
                  lastSyncText: lastCategoriesSyncText,
                  localCountText: '$_localCategoriesCount categorie',
                  isSyncing: _isCategoriesSyncing,
                  onSync: _syncCategories,
                  errorMessage: _categoriesSyncErrorMessage,
                  successMessage: _categoriesSyncSuccessMessage,
                ),
                const SizedBox(height: 14),

                _buildSyncListItem(
                  icon: Icons.school_outlined,
                  iconColor: const Color(0xFF0D9488),
                  title: 'Corsi (Courses)',
                  endpoint: '/courses',
                  description: 'Scarica i corsi con moduli didattici, opzioni formato, tracciamento e custom fields.',
                  lastSyncText: lastCoursesSyncText,
                  localCountText: '$_localCoursesCount corsi',
                  isSyncing: _isCoursesSyncing,
                  onSync: _syncCourses,
                  errorMessage: _coursesSyncErrorMessage,
                  successMessage: _coursesSyncSuccessMessage,
                ),
                const SizedBox(height: 14),

                _buildSyncListItem(
                  icon: Icons.military_tech_outlined,
                  iconColor: const Color(0xFFE11D48),
                  title: 'Badges Utenti (Badges Users)',
                  endpoint: '/badges_users',
                  description: 'Scarica i badge e le certificazioni assegnate agli utenti con codice, email e data rilascio.',
                  lastSyncText: lastBadgesUsersSyncText,
                  localCountText: '$_localBadgesUsersCount badge assegnati',
                  isSyncing: _isBadgesUsersSyncing,
                  onSync: _syncBadgesUsers,
                  errorMessage: _badgesUsersSyncErrorMessage,
                  successMessage: _badgesUsersSyncSuccessMessage,
                ),
                const SizedBox(height: 14),

                _buildSyncListItem(
                  icon: Icons.layers_outlined,
                  iconColor: const Color(0xFF8B5CF6),
                  title: 'Course Info (Sezioni & Moduli)',
                  endpoint: '/course_info',
                  description: 'Scarica sezioni e moduli didattici dettagliati (forum, quiz, attività e tracking).',
                  lastSyncText: lastCourseInfoSyncText,
                  localCountText: '$_localCourseInfoCount sezioni',
                  isSyncing: _isCourseInfoSyncing,
                  onSync: _syncCourseInfo,
                  errorMessage: _courseInfoSyncErrorMessage,
                  successMessage: _courseInfoSyncSuccessMessage,
                ),
                const SizedBox(height: 14),

                _buildSyncListItem(
                  icon: Icons.video_camera_front_outlined,
                  iconColor: const Color(0xFF0284C7),
                  title: 'Sessioni Webex (Merge Webex Users)',
                  endpoint: '/merge_webex_users',
                  description: 'Scarica le sessioni e i partecipanti Webex associati a corsi, presenze e statistiche VoIP/video.',
                  lastSyncText: lastMergeWebexUsersSyncText,
                  localCountText: '$_localMergeWebexUsersCount sessioni',
                  isSyncing: _isMergeWebexUsersSyncing,
                  onSync: _syncMergeWebexUsers,
                  errorMessage: _mergeWebexUsersSyncErrorMessage,
                  successMessage: _mergeWebexUsersSyncSuccessMessage,
                ),
                const SizedBox(height: 14),

                _buildSyncListItem(
                  icon: Icons.analytics_outlined,
                  iconColor: const Color(0xFFD97706),
                  title: 'Statistiche Moduli (stat_mdl)',
                  endpoint: '/stat_mdl',
                  description: 'Scarica le statistiche dei moduli didattici, tracking SCORM/test e completamenti utenti.',
                  lastSyncText: lastStatMdlSyncText,
                  localCountText: '$_localStatMdlCount statistiche',
                  isSyncing: _isStatMdlSyncing,
                  onSync: _syncStatMdl,
                  errorMessage: _statMdlSyncErrorMessage,
                  successMessage: _statMdlSyncSuccessMessage,
                ),
                const SizedBox(height: 14),

                _buildSyncListItem(
                  icon: Icons.how_to_reg_outlined,
                  iconColor: const Color(0xFF0D9488),
                  title: 'Iscrizioni Corsi (user_course_enrolled)',
                  endpoint: '/user_course_enrolled',
                  description: 'Scarica le associazioni dirette tra utenti e corsi (coppie course_id e user_id).',
                  lastSyncText: lastUserCourseEnrolledSyncText,
                  localCountText: '$_localUserCourseEnrolledCount iscrizioni',
                  isSyncing: _isUserCourseEnrolledSyncing,
                  onSync: _syncUserCourseEnrolled,
                  errorMessage: _userCourseEnrolledSyncErrorMessage,
                  successMessage: _userCourseEnrolledSyncSuccessMessage,
                ),
                const SizedBox(height: 14),

                _buildSyncListItem(
                  icon: Icons.rate_review_outlined,
                  iconColor: const Color(0xFF0EA5E9),
                  title: 'Feedback for BI (feedback_for_bi)',
                  endpoint: '/feedback_for_bi',
                  description: 'Scarica i feedback e le valutazioni dei corsi per BI (HQ1-HQ4, commenti e lingua).',
                  lastSyncText: lastFeedbackForBiSyncText,
                  localCountText: '$_localFeedbackForBiCount feedback',
                  isSyncing: _isFeedbackForBiSyncing,
                  onSync: _syncFeedbackForBi,
                  errorMessage: _feedbackForBiSyncErrorMessage,
                  successMessage: _feedbackForBiSyncSuccessMessage,
                ),
                const SizedBox(height: 14),

                _buildSyncListItem(
                  icon: Icons.menu_book_outlined,
                  iconColor: const Color(0xFF0284C7),
                  title: 'Catalogo Corsi & Durata Ore',
                  endpoint: 'File Excel Catalogo / Asset',
                  description: 'Sincronizza e incrocia il catalogo corsi dal file Excel predefinito (o importato) associando durate in ore e studio individuale ai corsi Moodle.',
                  lastSyncText: lastCourseCatalogSyncText,
                  localCountText: '$_localCourseCatalogCount corsi a catalogo',
                  isSyncing: _isCourseCatalogSyncing,
                  onSync: _syncCourseCatalog,
                  errorMessage: _courseCatalogSyncErrorMessage,
                  successMessage: _courseCatalogSyncSuccessMessage,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSyncListItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String endpoint,
    required String description,
    required String lastSyncText,
    required String localCountText,
    required bool isSyncing,
    required VoidCallback onSync,
    String? errorMessage,
    String? successMessage,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 620;

              final infoSection = Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: iconColor.withAlpha(20),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: iconColor, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              title,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Text(
                                endpoint,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontFamily: 'monospace',
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          runSpacing: 6,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppTheme.background,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.access_time_rounded, size: 14, color: Colors.grey.shade600),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Ultimo sync: $lastSyncText',
                                    style: TextStyle(fontSize: 12, color: Colors.grey.shade800, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppTheme.background,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.storage_rounded, size: 14, color: Colors.grey.shade600),
                                  const SizedBox(width: 6),
                                  Text(
                                    localCountText,
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: iconColor),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );

              final actionButton = ElevatedButton.icon(
                onPressed: isSyncing ? null : onSync,
                icon: isSyncing
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Icon(Icons.sync_rounded, size: 18),
                label: Text(
                  isSyncing ? 'Sincronizzazione...' : 'Sincronizza',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: iconColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              );

              if (isCompact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    infoSection,
                    const SizedBox(height: 16),
                    SizedBox(width: double.infinity, child: actionButton),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(child: infoSection),
                  const SizedBox(width: 20),
                  actionButton,
                ],
              );
            },
          ),

          // Banner Messaggi di Esito
          if (errorMessage != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline_rounded, color: Colors.red.shade700, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      errorMessage,
                      style: TextStyle(color: Colors.red.shade900, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (successMessage != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline_rounded, color: Colors.green.shade700, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      successMessage,
                      style: TextStyle(color: Colors.green.shade900, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _syncAll() async {
    await _syncUsers();
    await _syncCategories();
    await _syncCourses();
    await _syncBadgesUsers();
    await _syncCourseInfo();
    await _syncMergeWebexUsers();
    await _syncStatMdl();
    await _syncUserCourseEnrolled();
    await _syncFeedbackForBi();
  }

  Future<void> _syncUsers() async {
    final settings = ref.read(appSettingsProvider);
    final baseUrl = settings.apiBaseUrl.trim();
    final username = settings.apiUsername.trim();
    final password = settings.apiPassword;

    if (baseUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Configura prima il Base URL nel menu Impostazioni -> API SERVER.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isSyncing = true;
      _syncErrorMessage = null;
      _syncSuccessMessage = null;
    });

    try {
      String fullUrl = baseUrl;
      if (!fullUrl.endsWith('/')) {
        fullUrl += '/users';
      } else {
        fullUrl += 'users';
      }

      final uri = Uri.parse(fullUrl);
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 30);

      if (settings.bypassSslVerification) {
        client.badCertificateCallback = (cert, host, port) => true;
      }

      final request = await client.getUrl(uri);

      if (username.isNotEmpty || password.isNotEmpty) {
        final credentials = base64Encode(utf8.encode('$username:$password'));
        request.headers.set(HttpHeaders.authorizationHeader, 'Basic $credentials');
      }

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(responseBody);
        List<dynamic> usersJsonList = [];

        if (decoded is List) {
          usersJsonList = decoded;
        } else if (decoded is Map) {
          final map = Map<String, dynamic>.from(decoded);
          if (map.containsKey('username')) {
            usersJsonList = [map];
          } else if (map['users'] is List) {
            usersJsonList = map['users'] as List;
          } else if (map['data'] is List) {
            usersJsonList = map['data'] as List;
          } else if (map['elements'] is List) {
            usersJsonList = map['elements'] as List;
          } else if (map['records'] is List) {
            usersJsonList = map['records'] as List;
          } else if (map['results'] is List) {
            usersJsonList = map['results'] as List;
          } else {
            for (final v in map.values) {
              if (v is List && v.isNotEmpty && v.first is Map) {
                usersJsonList = v;
                break;
              }
            }
          }
        }

        final List<User> usersList = [];
        for (final item in usersJsonList) {
          if (item is Map) {
            try {
              usersList.add(User.fromJson(Map<String, dynamic>.from(item)));
            } catch (e) {
              debugPrint('[Sync Users] Errore parsing user: $e');
            }
          }
        }

        if (usersList.isEmpty) {
          setState(() {
            _syncErrorMessage = 'Nessun record utente valido estratto dalla risposta del server.\n'
                'Risposta ricevuta: ${responseBody.length > 250 ? '${responseBody.substring(0, 250)}...' : responseBody}';
          });
          return;
        }

        final isar = ref.read(isarProvider);
        await isar.writeTxn(() async {
          await isar.users.putAll(usersList);
        });

        final now = DateTime.now();
        await ref.read(appSettingsProvider.notifier).updateUsersSyncDate(now);
        await _refreshLocalCount();

        setState(() {
          _syncSuccessMessage = 'Sincronizzazione completata con successo: ${usersList.length} utenti salvati nel database!';
        });
      } else {
        setState(() {
          _syncErrorMessage = 'Risposta HTTP ${response.statusCode}: $responseBody';
        });
      }
    } catch (e) {
      setState(() {
        _syncErrorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() => _isSyncing = false);
      }
    }
  }

  Future<void> _syncCategories() async {
    final settings = ref.read(appSettingsProvider);
    final baseUrl = settings.apiBaseUrl.trim();
    final username = settings.apiUsername.trim();
    final password = settings.apiPassword;

    if (baseUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Configura prima il Base URL nel menu Impostazioni -> API SERVER.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isCategoriesSyncing = true;
      _categoriesSyncErrorMessage = null;
      _categoriesSyncSuccessMessage = null;
    });

    try {
      String fullUrl = baseUrl;
      if (!fullUrl.endsWith('/')) {
        fullUrl += '/categories';
      } else {
        fullUrl += 'categories';
      }

      final uri = Uri.parse(fullUrl);
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 30);

      if (settings.bypassSslVerification) {
        client.badCertificateCallback = (cert, host, port) => true;
      }

      final request = await client.getUrl(uri);

      if (username.isNotEmpty || password.isNotEmpty) {
        final credentials = base64Encode(utf8.encode('$username:$password'));
        request.headers.set(HttpHeaders.authorizationHeader, 'Basic $credentials');
      }

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(responseBody);
        List<dynamic> categoriesJsonList = [];

        if (decoded is List) {
          categoriesJsonList = decoded;
        } else if (decoded is Map) {
          final map = Map<String, dynamic>.from(decoded);
          if (map.containsKey('name') || map.containsKey('idnumber')) {
            categoriesJsonList = [map];
          } else if (map['categories'] is List) {
            categoriesJsonList = map['categories'] as List;
          } else if (map['data'] is List) {
            categoriesJsonList = map['data'] as List;
          } else if (map['elements'] is List) {
            categoriesJsonList = map['elements'] as List;
          } else if (map['records'] is List) {
            categoriesJsonList = map['records'] as List;
          } else if (map['results'] is List) {
            categoriesJsonList = map['results'] as List;
          } else {
            for (final v in map.values) {
              if (v is List && v.isNotEmpty && v.first is Map) {
                categoriesJsonList = v;
                break;
              }
            }
          }
        }

        final List<Category> categoriesList = [];
        for (final item in categoriesJsonList) {
          if (item is Map) {
            try {
              categoriesList.add(Category.fromJson(Map<String, dynamic>.from(item)));
            } catch (e) {
              debugPrint('[Sync Categories] Errore parsing item: $e');
            }
          }
        }

        if (categoriesList.isEmpty) {
          setState(() {
            _categoriesSyncErrorMessage = 'Nessuna categoria valida estratta dalla risposta del server.\n'
                'Risposta ricevuta: ${responseBody.length > 250 ? '${responseBody.substring(0, 250)}...' : responseBody}';
          });
          return;
        }

        final isar = ref.read(isarProvider);
        await isar.writeTxn(() async {
          await isar.categories.putAll(categoriesList);
        });

        final now = DateTime.now();
        await ref.read(appSettingsProvider.notifier).updateCategoriesSyncDate(now);
        await _refreshLocalCount();

        setState(() {
          _categoriesSyncSuccessMessage = 'Sincronizzazione completata con successo: ${categoriesList.length} categorie salvate nel database!';
        });
      } else {
        setState(() {
          _categoriesSyncErrorMessage = 'Risposta HTTP ${response.statusCode}: $responseBody';
        });
      }
    } catch (e) {
      setState(() {
        _categoriesSyncErrorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() => _isCategoriesSyncing = false);
      }
    }
  }

  Future<void> _syncCourses() async {
    final settings = ref.read(appSettingsProvider);
    final baseUrl = settings.apiBaseUrl.trim();
    final username = settings.apiUsername.trim();
    final password = settings.apiPassword;

    if (baseUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Configura prima il Base URL nel menu Impostazioni -> API SERVER.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isCoursesSyncing = true;
      _coursesSyncErrorMessage = null;
      _coursesSyncSuccessMessage = null;
    });

    try {
      String fullUrl = baseUrl;
      if (!fullUrl.endsWith('/')) {
        fullUrl += '/courses';
      } else {
        fullUrl += 'courses';
      }

      final uri = Uri.parse(fullUrl);
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 30);

      if (settings.bypassSslVerification) {
        client.badCertificateCallback = (cert, host, port) => true;
      }

      final request = await client.getUrl(uri);

      if (username.isNotEmpty || password.isNotEmpty) {
        final credentials = base64Encode(utf8.encode('$username:$password'));
        request.headers.set(HttpHeaders.authorizationHeader, 'Basic $credentials');
      }

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(responseBody);
        List<dynamic> coursesJsonList = [];

        if (decoded is List) {
          coursesJsonList = decoded;
        } else if (decoded is Map) {
          final map = Map<String, dynamic>.from(decoded);
          if (map.containsKey('shortname') || map.containsKey('fullname')) {
            coursesJsonList = [map];
          } else if (map['courses'] is List) {
            coursesJsonList = map['courses'] as List;
          } else if (map['data'] is List) {
            coursesJsonList = map['data'] as List;
          } else if (map['elements'] is List) {
            coursesJsonList = map['elements'] as List;
          } else if (map['records'] is List) {
            coursesJsonList = map['records'] as List;
          } else if (map['results'] is List) {
            coursesJsonList = map['results'] as List;
          } else {
            for (final v in map.values) {
              if (v is List && v.isNotEmpty && v.first is Map) {
                coursesJsonList = v;
                break;
              }
            }
          }
        }

        final List<Course> coursesList = [];
        for (final item in coursesJsonList) {
          if (item is Map) {
            try {
              coursesList.add(Course.fromJson(Map<String, dynamic>.from(item)));
            } catch (e) {
              debugPrint('[Sync Courses] Errore parsing item: $e');
            }
          }
        }

        if (coursesList.isEmpty) {
          setState(() {
            _coursesSyncErrorMessage = 'Nessun corso valido estratto dalla risposta del server.\n'
                'Risposta ricevuta: ${responseBody.length > 250 ? '${responseBody.substring(0, 250)}...' : responseBody}';
          });
          return;
        }

        final isar = ref.read(isarProvider);
        await isar.writeTxn(() async {
          await isar.courses.putAll(coursesList);
        });

        final now = DateTime.now();
        await ref.read(appSettingsProvider.notifier).updateCoursesSyncDate(now);
        await _refreshLocalCount();

        setState(() {
          _coursesSyncSuccessMessage = 'Sincronizzazione completata con successo: ${coursesList.length} corsi salvati nel database!';
        });
      } else {
        setState(() {
          _coursesSyncErrorMessage = 'Risposta HTTP ${response.statusCode}: $responseBody';
        });
      }
    } catch (e) {
      setState(() {
        _coursesSyncErrorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() => _isCoursesSyncing = false);
      }
    }
  }

  Future<void> _syncBadgesUsers() async {
    final settings = ref.read(appSettingsProvider);
    final baseUrl = settings.apiBaseUrl.trim();
    final username = settings.apiUsername.trim();
    final password = settings.apiPassword;

    if (baseUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Configura prima il Base URL nel menu Impostazioni -> API SERVER.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isBadgesUsersSyncing = true;
      _badgesUsersSyncErrorMessage = null;
      _badgesUsersSyncSuccessMessage = null;
    });

    try {
      var fullUrl = baseUrl;
      if (!fullUrl.endsWith('/')) {
        fullUrl += '/badges_users';
      } else {
        fullUrl += 'badges_users';
      }

      final uri = Uri.parse(fullUrl);
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 30);

      if (settings.bypassSslVerification) {
        client.badCertificateCallback = (cert, host, port) => true;
      }

      final request = await client.getUrl(uri);

      if (username.isNotEmpty || password.isNotEmpty) {
        final credentials = base64Encode(utf8.encode('$username:$password'));
        request.headers.set(HttpHeaders.authorizationHeader, 'Basic $credentials');
      }

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(responseBody);
        List<dynamic> badgesJsonList = [];

        if (decoded is List) {
          badgesJsonList = decoded;
        } else if (decoded is Map) {
          final map = Map<String, dynamic>.from(decoded);
          if (map.containsKey('badge') || map.containsKey('code')) {
            badgesJsonList = [map];
          } else if (map['badges_users'] is List) {
            badgesJsonList = map['badges_users'] as List;
          } else if (map['badges'] is List) {
            badgesJsonList = map['badges'] as List;
          } else if (map['data'] is List) {
            badgesJsonList = map['data'] as List;
          } else if (map['elements'] is List) {
            badgesJsonList = map['elements'] as List;
          } else if (map['records'] is List) {
            badgesJsonList = map['records'] as List;
          } else if (map['results'] is List) {
            badgesJsonList = map['results'] as List;
          } else {
            for (final v in map.values) {
              if (v is List && v.isNotEmpty && v.first is Map) {
                badgesJsonList = v;
                break;
              }
            }
          }
        }

        final List<BadgeUser> badgesList = [];
        for (final item in badgesJsonList) {
          if (item is Map) {
            try {
              badgesList.add(BadgeUser.fromJson(Map<String, dynamic>.from(item)));
            } catch (e) {
              debugPrint('[Sync BadgesUsers] Errore parsing item: $e');
            }
          }
        }

        if (badgesList.isEmpty) {
          setState(() {
            _badgesUsersSyncErrorMessage = 'Nessun badge utente valido estratto dalla risposta del server.\n'
                'Risposta ricevuta: ${responseBody.length > 250 ? '${responseBody.substring(0, 250)}...' : responseBody}';
          });
          return;
        }

        final isar = ref.read(isarProvider);
        await isar.writeTxn(() async {
          await isar.badgeUsers.putAll(badgesList);
        });

        final now = DateTime.now();
        await ref.read(appSettingsProvider.notifier).updateBadgesUsersSyncDate(now);
        await _refreshLocalCount();

        setState(() {
          _badgesUsersSyncSuccessMessage = 'Sincronizzazione completata con successo: ${badgesList.length} badge utenti salvati nel database!';
        });
      } else {
        setState(() {
          _badgesUsersSyncErrorMessage = 'Risposta HTTP ${response.statusCode}: $responseBody';
        });
      }
    } catch (e) {
      setState(() {
        _badgesUsersSyncErrorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() => _isBadgesUsersSyncing = false);
      }
    }
  }

  Future<void> _syncCourseInfo() async {
    final settings = ref.read(appSettingsProvider);
    final baseUrl = settings.apiBaseUrl.trim();
    final username = settings.apiUsername.trim();
    final password = settings.apiPassword;

    if (baseUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Configura prima il Base URL nel menu Impostazioni -> API SERVER.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isCourseInfoSyncing = true;
      _courseInfoSyncErrorMessage = null;
      _courseInfoSyncSuccessMessage = null;
    });

    try {
      String fullUrl = baseUrl;
      if (!fullUrl.endsWith('/')) {
        fullUrl += '/course_info';
      } else {
        fullUrl += 'course_info';
      }

      final uri = Uri.parse(fullUrl);
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 30);

      if (settings.bypassSslVerification) {
        client.badCertificateCallback = (cert, host, port) => true;
      }

      final request = await client.getUrl(uri);

      if (username.isNotEmpty || password.isNotEmpty) {
        final credentials = base64Encode(utf8.encode('$username:$password'));
        request.headers.set(HttpHeaders.authorizationHeader, 'Basic $credentials');
      }

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(responseBody);
        final List<CourseInfo> courseInfoList = [];

        if (decoded is Map) {
          final map = Map<String, dynamic>.from(decoded);
          bool hasCourseIdKeys = false;

          // Gestione formato chiave-corso: {"1": [{id: 320, ...}, {id: 12, ...}], "2": [...]}
          for (final entry in map.entries) {
            final keyCourseId = int.tryParse(entry.key);
            if (entry.value is List) {
              final list = entry.value as List;
              for (final item in list) {
                if (item is Map) {
                  try {
                    courseInfoList.add(CourseInfo.fromJson(
                      Map<String, dynamic>.from(item),
                      courseId: keyCourseId,
                    ));
                    hasCourseIdKeys = true;
                  } catch (e) {
                    debugPrint('[Sync CourseInfo] Errore parsing item: $e');
                  }
                }
              }
            }
          }

          // Fallback per risposte standard
          if (!hasCourseIdKeys) {
            List<dynamic> rawList = [];
            if (map.containsKey('name') || map.containsKey('section') || map.containsKey('modules')) {
              rawList = [map];
            } else if (map['course_info'] is List) {
              rawList = map['course_info'] as List;
            } else if (map['sections'] is List) {
              rawList = map['sections'] as List;
            } else if (map['data'] is List) {
              rawList = map['data'] as List;
            } else if (map['elements'] is List) {
              rawList = map['elements'] as List;
            } else if (map['records'] is List) {
              rawList = map['records'] as List;
            } else if (map['results'] is List) {
              rawList = map['results'] as List;
            }
            for (final item in rawList) {
              if (item is Map) {
                try {
                  courseInfoList.add(CourseInfo.fromJson(Map<String, dynamic>.from(item)));
                } catch (e) {
                  debugPrint('[Sync CourseInfo] Errore parsing item: $e');
                }
              }
            }
          }
        } else if (decoded is List) {
          for (final item in decoded) {
            if (item is Map) {
              try {
                courseInfoList.add(CourseInfo.fromJson(Map<String, dynamic>.from(item)));
              } catch (e) {
                debugPrint('[Sync CourseInfo] Errore parsing item: $e');
              }
            }
          }
        }

        if (courseInfoList.isEmpty) {
          setState(() {
            _courseInfoSyncErrorMessage = 'Nessuna informazione corso valida estratta dalla risposta del server.\n'
                'Risposta ricevuta: ${responseBody.length > 250 ? '${responseBody.substring(0, 250)}...' : responseBody}';
          });
          return;
        }

        final isar = ref.read(isarProvider);
        await isar.writeTxn(() async {
          await isar.courseInfos.putAll(courseInfoList);
        });

        final now = DateTime.now();
        await ref.read(appSettingsProvider.notifier).updateCourseInfoSyncDate(now);
        await _refreshLocalCount();

        setState(() {
          _courseInfoSyncSuccessMessage = 'Sincronizzazione completata con successo: ${courseInfoList.length} sezioni/record Course Info salvati nel database!';
        });
      } else {
        setState(() {
          _courseInfoSyncErrorMessage = 'Risposta HTTP ${response.statusCode}: $responseBody';
        });
      }
    } catch (e) {
      setState(() {
        _courseInfoSyncErrorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() => _isCourseInfoSyncing = false);
      }
    }
  }

  Future<void> _syncMergeWebexUsers() async {
    final settings = ref.read(appSettingsProvider);
    final baseUrl = settings.apiBaseUrl.trim();
    final username = settings.apiUsername.trim();
    final password = settings.apiPassword;

    if (baseUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Configura prima il Base URL nel menu Impostazioni -> API SERVER.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isMergeWebexUsersSyncing = true;
      _mergeWebexUsersSyncErrorMessage = null;
      _mergeWebexUsersSyncSuccessMessage = null;
    });

    try {
      String fullUrl = baseUrl;
      if (!fullUrl.endsWith('/')) {
        fullUrl += '/merge_webex_users';
      } else {
        fullUrl += 'merge_webex_users';
      }

      final uri = Uri.parse(fullUrl);
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 45);

      if (settings.bypassSslVerification) {
        client.badCertificateCallback = (cert, host, port) => true;
      }

      final request = await client.getUrl(uri);

      if (username.isNotEmpty || password.isNotEmpty) {
        final credentials = base64Encode(utf8.encode('$username:$password'));
        request.headers.set(HttpHeaders.authorizationHeader, 'Basic $credentials');
      }

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(responseBody);
        List<dynamic> rawList = [];

        if (decoded is List) {
          rawList = decoded;
        } else if (decoded is Map) {
          final map = Map<String, dynamic>.from(decoded);
          if (map.containsKey('MEETING_NUMBER') || map.containsKey('USER_NAME') || map.containsKey('EMAIL')) {
            rawList = [map];
          } else if (map['merge_webex_users'] is List) {
            rawList = map['merge_webex_users'] as List;
          } else if (map['webex_users'] is List) {
            rawList = map['webex_users'] as List;
          } else if (map['elements'] is List) {
            rawList = map['elements'] as List;
          } else if (map['data'] is List) {
            rawList = map['data'] as List;
          } else if (map['records'] is List) {
            rawList = map['records'] as List;
          } else if (map['results'] is List) {
            rawList = map['results'] as List;
          }
        }

        final List<MergeWebexUser> webexUsers = [];
        for (final item in rawList) {
          if (item is Map) {
            try {
              webexUsers.add(MergeWebexUser.fromJson(Map<String, dynamic>.from(item)));
            } catch (e) {
              debugPrint('[Sync MergeWebexUser] Errore parsing item: $e');
            }
          }
        }

        if (webexUsers.isEmpty) {
          setState(() {
            _mergeWebexUsersSyncErrorMessage = 'Nessuna sessione Webex valida estratta dalla risposta del server.\n'
                'Risposta ricevuta: ${responseBody.length > 250 ? '${responseBody.substring(0, 250)}...' : responseBody}';
          });
          return;
        }

        final isar = ref.read(isarProvider);
        await isar.writeTxn(() async {
          await isar.mergeWebexUsers.putAll(webexUsers);
        });

        final now = DateTime.now();
        await ref.read(appSettingsProvider.notifier).updateMergeWebexUsersSyncDate(now);
        await _refreshLocalCount();

        setState(() {
          _mergeWebexUsersSyncSuccessMessage =
              'Sincronizzazione completata con successo: ${webexUsers.length} sessioni Webex salvate nel database!';
        });
      } else {
        setState(() {
          _mergeWebexUsersSyncErrorMessage = 'Risposta HTTP ${response.statusCode}: $responseBody';
        });
      }
    } catch (e) {
      setState(() {
        _mergeWebexUsersSyncErrorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() => _isMergeWebexUsersSyncing = false);
      }
    }
  }

  Future<void> _syncStatMdl() async {
    final settings = ref.read(appSettingsProvider);
    final baseUrl = settings.apiBaseUrl.trim();
    final username = settings.apiUsername.trim();
    final password = settings.apiPassword;

    if (baseUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Configura prima il Base URL nel menu Impostazioni -> API SERVER.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isStatMdlSyncing = true;
      _statMdlSyncErrorMessage = null;
      _statMdlSyncSuccessMessage = null;
    });

    try {
      String fullUrl = baseUrl;
      if (!fullUrl.endsWith('/')) {
        fullUrl += '/stat_mdl';
      } else {
        fullUrl += 'stat_mdl';
      }

      final uri = Uri.parse(fullUrl);
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 45);

      if (settings.bypassSslVerification) {
        client.badCertificateCallback = (cert, host, port) => true;
      }

      final request = await client.getUrl(uri);

      if (username.isNotEmpty || password.isNotEmpty) {
        final credentials = base64Encode(utf8.encode('$username:$password'));
        request.headers.set(HttpHeaders.authorizationHeader, 'Basic $credentials');
      }

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(responseBody);
        List<dynamic> rawList = [];

        if (decoded is List) {
          rawList = decoded;
        } else if (decoded is Map) {
          final map = Map<String, dynamic>.from(decoded);
          if (map.containsKey('id') || map.containsKey('username') || map.containsKey('id_modulo')) {
            rawList = [map];
          } else if (map['stat_mdl'] is List) {
            rawList = map['stat_mdl'] as List;
          } else if (map['stat_modules'] is List) {
            rawList = map['stat_modules'] as List;
          } else if (map['elements'] is List) {
            rawList = map['elements'] as List;
          } else if (map['data'] is List) {
            rawList = map['data'] as List;
          } else if (map['records'] is List) {
            rawList = map['records'] as List;
          } else if (map['results'] is List) {
            rawList = map['results'] as List;
          }
        }

        final List<StatMdl> statMdlList = [];
        for (final item in rawList) {
          if (item is Map) {
            try {
              statMdlList.add(StatMdl.fromJson(Map<String, dynamic>.from(item)));
            } catch (e) {
              debugPrint('[Sync StatMdl] Errore parsing item: $e');
            }
          }
        }

        if (statMdlList.isEmpty) {
          setState(() {
            _statMdlSyncErrorMessage = 'Nessuna statistica modulo valida estratta dalla risposta del server.\n'
                'Risposta ricevuta: ${responseBody.length > 250 ? '${responseBody.substring(0, 250)}...' : responseBody}';
          });
          return;
        }

        final isar = ref.read(isarProvider);
        await isar.writeTxn(() async {
          await isar.statMdls.putAll(statMdlList);
        });

        final now = DateTime.now();
        await ref.read(appSettingsProvider.notifier).updateStatMdlSyncDate(now);
        await _refreshLocalCount();

        setState(() {
          _statMdlSyncSuccessMessage =
              'Sincronizzazione completata con successo: ${statMdlList.length} statistiche moduli salvate nel database!';
        });
      } else {
        setState(() {
          _statMdlSyncErrorMessage = 'Risposta HTTP ${response.statusCode}: $responseBody';
        });
      }
    } catch (e) {
      setState(() {
        _statMdlSyncErrorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() => _isStatMdlSyncing = false);
      }
    }
  }

  Future<void> _syncUserCourseEnrolled() async {
    final settings = ref.read(appSettingsProvider);
    final baseUrl = settings.apiBaseUrl.trim();
    final username = settings.apiUsername.trim();
    final password = settings.apiPassword;

    if (baseUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Configura prima il Base URL nel menu Impostazioni -> API SERVER.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isUserCourseEnrolledSyncing = true;
      _userCourseEnrolledSyncErrorMessage = null;
      _userCourseEnrolledSyncSuccessMessage = null;
    });

    try {
      String fullUrl = baseUrl;
      if (!fullUrl.endsWith('/')) {
        fullUrl += '/user_course_enrolled';
      } else {
        fullUrl += 'user_course_enrolled';
      }

      final uri = Uri.parse(fullUrl);
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 45);

      if (settings.bypassSslVerification) {
        client.badCertificateCallback = (cert, host, port) => true;
      }

      final request = await client.getUrl(uri);

      if (username.isNotEmpty || password.isNotEmpty) {
        final credentials = base64Encode(utf8.encode('$username:$password'));
        request.headers.set(HttpHeaders.authorizationHeader, 'Basic $credentials');
      }

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final dynamic decoded = jsonDecode(responseBody);
        List<dynamic> rawList = [];

        if (decoded is List) {
          rawList = decoded;
        } else if (decoded is Map<String, dynamic>) {
          final map = decoded;
          if (map['user_course_enrolled'] is List) {
            rawList = map['user_course_enrolled'] as List;
          } else if (map['elements'] is List) {
            rawList = map['elements'] as List;
          } else if (map['data'] is List) {
            rawList = map['data'] as List;
          } else if (map['records'] is List) {
            rawList = map['records'] as List;
          } else if (map['results'] is List) {
            rawList = map['results'] as List;
          }
        }

        final List<UserCourseEnrolled> enrolledList = [];
        for (final item in rawList) {
          if (item is Map) {
            try {
              enrolledList.add(UserCourseEnrolled.fromJson(Map<String, dynamic>.from(item)));
            } catch (e) {
              debugPrint('[Sync UserCourseEnrolled] Errore parsing item: $e');
            }
          }
        }

        if (enrolledList.isEmpty) {
          setState(() {
            _userCourseEnrolledSyncErrorMessage =
                'Nessuna iscrizione corso valida estratta dalla risposta del server.\n'
                'Risposta ricevuta: ${responseBody.length > 250 ? '${responseBody.substring(0, 250)}...' : responseBody}';
          });
          return;
        }

        final isar = ref.read(isarProvider);
        await isar.writeTxn(() async {
          await isar.userCourseEnrolleds.putAll(enrolledList);
        });

        final now = DateTime.now();
        await ref.read(appSettingsProvider.notifier).updateUserCourseEnrolledSyncDate(now);
        await _refreshLocalCount();

        setState(() {
          _userCourseEnrolledSyncSuccessMessage =
              'Sincronizzazione completata con successo: ${enrolledList.length} iscrizioni salvate nel database!';
        });
      } else {
        setState(() {
          _userCourseEnrolledSyncErrorMessage = 'Risposta HTTP ${response.statusCode}: $responseBody';
        });
      }
    } catch (e) {
      setState(() {
        _userCourseEnrolledSyncErrorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() => _isUserCourseEnrolledSyncing = false);
      }
    }
  }

  Future<void> _syncFeedbackForBi() async {
    final settings = ref.read(appSettingsProvider);
    final baseUrl = settings.apiBaseUrl.trim();
    final username = settings.apiUsername.trim();
    final password = settings.apiPassword;

    if (baseUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Configura prima il Base URL nel menu Impostazioni -> API SERVER.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isFeedbackForBiSyncing = true;
      _feedbackForBiSyncErrorMessage = null;
      _feedbackForBiSyncSuccessMessage = null;
    });

    try {
      String fullUrl = baseUrl;
      if (!fullUrl.endsWith('/')) {
        fullUrl += '/feedback_for_bi';
      } else {
        fullUrl += 'feedback_for_bi';
      }

      final uri = Uri.parse(fullUrl);
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 45);

      if (settings.bypassSslVerification) {
        client.badCertificateCallback = (cert, host, port) => true;
      }

      final request = await client.getUrl(uri);

      if (username.isNotEmpty || password.isNotEmpty) {
        final credentials = base64Encode(utf8.encode('$username:$password'));
        request.headers.set(HttpHeaders.authorizationHeader, 'Basic $credentials');
      }

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final dynamic decoded = jsonDecode(responseBody);
        List<dynamic> rawList = [];

        if (decoded is List) {
          rawList = decoded;
        } else if (decoded is Map) {
          final map = decoded;
          if (map['feed'] is List) {
            rawList = map['feed'] as List;
          } else if (map['feedback_for_bi'] is List) {
            rawList = map['feedback_for_bi'] as List;
          } else if (map['elements'] is List) {
            rawList = map['elements'] as List;
          } else if (map['data'] is List) {
            rawList = map['data'] as List;
          } else if (map['records'] is List) {
            rawList = map['records'] as List;
          } else if (map['results'] is List) {
            rawList = map['results'] as List;
          }
        }

        final List<FeedbackForBi> feedbackList = [];
        for (final item in rawList) {
          if (item is Map) {
            try {
              feedbackList.add(FeedbackForBi.fromJson(Map<String, dynamic>.from(item)));
            } catch (e) {
              debugPrint('[Sync FeedbackForBi] Errore parsing item: $e');
            }
          }
        }

        if (feedbackList.isEmpty) {
          setState(() {
            _feedbackForBiSyncErrorMessage =
                'Nessun feedback valido estratto dalla risposta del server.\n'
                'Risposta ricevuta: ${responseBody.length > 250 ? '${responseBody.substring(0, 250)}...' : responseBody}';
          });
          return;
        }

        final isar = ref.read(isarProvider);
        await isar.writeTxn(() async {
          await isar.feedbackForBis.clear();
          await isar.feedbackForBis.putAll(feedbackList);
        });

        final now = DateTime.now();
        await ref.read(appSettingsProvider.notifier).updateFeedbackForBiSyncDate(now);
        await _refreshLocalCount();

        setState(() {
          _feedbackForBiSyncSuccessMessage =
              'Sincronizzazione completata con successo: ${feedbackList.length} feedback salvati nel database!';
        });
      } else {
        setState(() {
          _feedbackForBiSyncErrorMessage = 'Risposta HTTP ${response.statusCode}: $responseBody';
        });
      }
    } catch (e) {
      setState(() {
        _feedbackForBiSyncErrorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() => _isFeedbackForBiSyncing = false);
      }
    }
  }

  Future<void> _syncCourseCatalog() async {
    setState(() {
      _isCourseCatalogSyncing = true;
      _courseCatalogSyncErrorMessage = null;
      _courseCatalogSyncSuccessMessage = null;
    });

    try {
      final isar = ref.read(isarProvider);
      final count = await CourseCatalogService.importCatalogFromExcel(isar);
      await ref.read(appSettingsProvider.notifier).updateCourseCatalogSyncDate(DateTime.now());
      await _refreshLocalCount();

      setState(() {
        _courseCatalogSyncSuccessMessage =
            'Sincronizzazione completata con successo: $count corsi a catalogo aggiornati con relative durate e mappature Moodle!';
      });
    } catch (e) {
      setState(() {
        _courseCatalogSyncErrorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() => _isCourseCatalogSyncing = false);
      }
    }
  }
}


