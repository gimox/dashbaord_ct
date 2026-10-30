import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import '../../core/db/isar_provider.dart';
import '../../core/theme/app_theme.dart';
import '../sync/models/stat_mdl.dart';
import '../sync/models/user.dart';
import '../sync/models/user_course_enrolled.dart';
import '../sync/models/course.dart';
import '../sync/models/badge_user.dart';
import '../exclusions/models/course_exclusion.dart';
import 'models/course_active_stat.dart';
import 'models/partner_active_stat.dart';
import 'models/age_active_stat.dart';
import 'services/active_users_progress_excel_exporter.dart';
import 'services/course_active_stats_excel_exporter.dart';
import 'services/partner_active_stats_excel_exporter.dart';
import 'services/age_active_stats_excel_exporter.dart';
import '../sync/models/feedback_for_bi.dart';
import 'models/feedback_dashboard_stat.dart';
import 'services/feedback_dashboard_stats_excel_exporter.dart';
import '../catalog/models/course_catalog_item.dart';
import 'models/dg_cnect_kpi.dart';
import 'services/dg_cnect_excel_exporter.dart';

class HomeDashboardView extends ConsumerStatefulWidget {
  final VoidCallback onNavigateToSync;
  final VoidCallback onNavigateToUsers;
  final VoidCallback? onNavigateToUserStats;
  final VoidCallback? onNavigateToEnrollments;

  const HomeDashboardView({
    super.key,
    required this.onNavigateToSync,
    required this.onNavigateToUsers,
    this.onNavigateToUserStats,
    this.onNavigateToEnrollments,
  });

  @override
  ConsumerState<HomeDashboardView> createState() => _HomeDashboardViewState();
}

class _HomeDashboardViewState extends ConsumerState<HomeDashboardView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  int _participatingUsersCount = 0;
  int _activeUsersCount = 0;
  int _enrolledUsersCount = 0;
  int _activeMaleCount = 0;
  int _activeFemaleCount = 0;
  int _activeUnclassifiedCount = 0;
  Map<String, int> _activeLangCounts = {};
  Map<String, Map<String, int>> _activeGenderLangCounts = {};
  Map<String, int> _activeYearCounts = {};
  Map<String, Map<String, int>> _activeGenderYearCounts = {};
  Map<String, Map<String, int>> _activeYearLangCounts = {};
  Map<String, Map<String, Map<String, int>>> _activeYearGenderLangCounts = {};
  String? _selectedGenderYear;
  String? _selectedEnrolledGenderYear;

  // Iscrizioni Corsi per Utenti Iscritti (Totale aggregato per tutti gli iscritti)
  String _allCourseEnrollmentFilter = 'all'; // 'all' | 'completed' | 'other' | 'in_progress' | 'only_enrolled'
  int _allCourseEnrollmentsTotal = 0;
  int _allCourseEnrollmentsMale = 0;
  int _allCourseEnrollmentsFemale = 0;
  int _allCourseEnrollmentsUnclassified = 0;
  int _allCourseEnrollmentsCompleted = 0;
  int _allCourseEnrollmentsSync = 0;
  int _allCourseEnrollmentsAsync = 0;
  Map<String, int> _allCourseEnrollmentsLangCounts = {};
  Map<String, Map<String, int>> _allCourseEnrollmentsGenderLangCounts = {};

  // Dettagli Stato: Completati (Iscritti)
  int _allCourseEnrCompMale = 0;
  int _allCourseEnrCompFemale = 0;
  int _allCourseEnrCompUnclass = 0;
  Map<String, int> _allCourseEnrCompLangCounts = {};
  Map<String, Map<String, int>> _allCourseEnrCompGenderLangCounts = {};

  // Dettagli Stato: In Corso (Iscritti)
  int _allCourseEnrollmentsInProgress = 0;
  int _allCourseEnrInProgMale = 0;
  int _allCourseEnrInProgFemale = 0;
  int _allCourseEnrInProgUnclass = 0;
  Map<String, int> _allCourseEnrInProgLangCounts = {};
  Map<String, Map<String, int>> _allCourseEnrInProgGenderLangCounts = {};

  // Dettagli Stato: Solo Iscritti (Iscritti)
  int _allCourseEnrollmentsOnlyEnrolled = 0;
  int _allCourseEnrOnlyEnrMale = 0;
  int _allCourseEnrOnlyEnrFemale = 0;
  int _allCourseEnrOnlyEnrUnclass = 0;
  Map<String, int> _allCourseEnrOnlyEnrLangCounts = {};
  Map<String, Map<String, int>> _allCourseEnrOnlyEnrGenderLangCounts = {};

  // Dettagli Stato: Altri (In corso + Solo iscritti) (Iscritti)
  int get _allCourseEnrollmentsOther =>
      _allCourseEnrollmentsInProgress + _allCourseEnrollmentsOnlyEnrolled;
  int get _allCourseEnrOtherMale =>
      _allCourseEnrInProgMale + _allCourseEnrOnlyEnrMale;
  int get _allCourseEnrOtherFemale =>
      _allCourseEnrInProgFemale + _allCourseEnrOnlyEnrFemale;
  int get _allCourseEnrOtherUnclass =>
      _allCourseEnrInProgUnclass + _allCourseEnrOnlyEnrUnclass;
  Map<String, int> _allCourseEnrOtherLangCounts = {};
  Map<String, Map<String, int>> _allCourseEnrOtherGenderLangCounts = {};

  // Utenti Iscritti: Metriche di Genere, Lingua, Anno
  int _enrolledMaleCount = 0;
  int _enrolledFemaleCount = 0;
  int _enrolledUnclassifiedCount = 0;
  Map<String, int> _enrolledUserLangCounts = {};
  Map<String, Map<String, int>> _enrolledUserGenderLangCounts = {};
  Map<String, int> _enrolledYearCounts = {};
  Map<String, Map<String, int>> _enrolledGenderYearCounts = {};
  Map<String, Map<String, int>> _enrolledYearLangCounts = {};
  Map<String, Map<String, Map<String, int>>> _enrolledYearGenderLangCounts = {};

  // Utenti Iscritti: Progresso Utente Singolo
  int _enrolledCompMale = 0;
  int _enrolledCompFemale = 0;
  int _enrolledCompUnclass = 0;
  int _enrolledCompSync = 0;
  int _enrolledCompAsync = 0;
  int _enrolledInProgMale = 0;
  int _enrolledInProgFemale = 0;
  int _enrolledInProgUnclass = 0;
  int _enrolledInProgSync = 0;
  int _enrolledInProgAsync = 0;
  int _enrolledOnlyEnrMale = 0;
  int _enrolledOnlyEnrFemale = 0;
  int _enrolledOnlyEnrUnclass = 0;
  int _enrolledOnlyEnrSync = 0;
  int _enrolledOnlyEnrAsync = 0;
  Map<String, int> _enrolledCompLangCounts = {};
  Map<String, int> _enrolledInProgLangCounts = {};
  Map<String, int> _enrolledOnlyEnrLangCounts = {};
  bool _isExportingEnrolledProgress = false;
  List<ActiveUserDetailExportItem> _enrolledUserDetails = [];

  int get _totalEnrolledCompleted =>
      _enrolledCompMale + _enrolledCompFemale + _enrolledCompUnclass;
  int get _totalEnrolledInProgress =>
      _enrolledInProgMale + _enrolledInProgFemale + _enrolledInProgUnclass;
  int get _totalEnrolledOnlyEnrolled =>
      _enrolledOnlyEnrMale + _enrolledOnlyEnrFemale + _enrolledOnlyEnrUnclass;

  List<CourseActiveStat> _enrolledCourseStats = [];
  bool _showAllEnrolledCourses = false;
  bool _isExportingEnrolledCourses = false;

  List<PartnerActiveStat> _enrolledPartnerStats = [];
  bool _showAllEnrolledPartners = false;
  bool _isExportingEnrolledPartners = false;

  List<AgeActiveStat> _enrolledAgeStats = [];
  bool _isExportingEnrolledAge = false;

  // Totale Iscrizioni Corsi per Utenti Attivi
  String _activeCourseEnrollmentFilter = 'all'; // 'all' | 'completed' | 'other' | 'in_progress' | 'only_enrolled'
  int _activeCourseEnrollmentsTotal = 0;
  int _activeCourseEnrollmentsMale = 0;
  int _activeCourseEnrollmentsFemale = 0;
  int _activeCourseEnrollmentsUnclassified = 0;
  int _activeCourseEnrollmentsCompleted = 0;
  int _activeCourseEnrollmentsSync = 0;
  int _activeCourseEnrollmentsAsync = 0;
  Map<String, int> _activeCourseEnrollmentsLangCounts = {};
  Map<String, Map<String, int>> _activeCourseEnrollmentsGenderLangCounts = {};

  // Dettagli Stato: Completati
  int _activeEnrCompMale = 0;
  int _activeEnrCompFemale = 0;
  int _activeEnrCompUnclass = 0;
  Map<String, int> _activeEnrCompLangCounts = {};
  Map<String, Map<String, int>> _activeEnrCompGenderLangCounts = {};

  // Dettagli Stato: In Corso
  int _activeEnrInProgress = 0;
  int _activeEnrInProgMale = 0;
  int _activeEnrInProgFemale = 0;
  int _activeEnrInProgUnclass = 0;
  Map<String, int> _activeEnrInProgLangCounts = {};
  Map<String, Map<String, int>> _activeEnrInProgGenderLangCounts = {};

  // Dettagli Stato: Solo Iscritti
  int _activeEnrOnlyEnrolled = 0;
  int _activeEnrOnlyEnrMale = 0;
  int _activeEnrOnlyEnrFemale = 0;
  int _activeEnrOnlyEnrUnclass = 0;
  Map<String, int> _activeEnrOnlyEnrLangCounts = {};
  Map<String, Map<String, int>> _activeEnrOnlyEnrGenderLangCounts = {};

  // Dettagli Stato: Altri (In corso + Solo iscritti)
  int get _activeEnrOther => _activeEnrInProgress + _activeEnrOnlyEnrolled;
  int get _activeEnrOtherMale => _activeEnrInProgMale + _activeEnrOnlyEnrMale;
  int get _activeEnrOtherFemale => _activeEnrInProgFemale + _activeEnrOnlyEnrFemale;
  int get _activeEnrOtherUnclass => _activeEnrInProgUnclass + _activeEnrOnlyEnrUnclass;
  Map<String, int> _activeEnrOtherLangCounts = {};
  Map<String, Map<String, int>> _activeEnrOtherGenderLangCounts = {};

  // Totale Iscrizioni (conteggio multi-corso per tutti i corsi non esclusi)
  int _totalEnrollmentsCount = 0;
  int _enrollmentMaleCount = 0;
  int _enrollmentFemaleCount = 0;
  int _enrollmentUnclassifiedCount = 0;
  Map<String, int> _enrollmentLangCounts = {};
  Map<String, Map<String, int>> _enrollmentGenderLangCounts = {};
  int _completedMale = 0;
  int _completedFemale = 0;
  int _completedUnclass = 0;
  int _completedSync = 0;
  int _completedAsync = 0;
  int _inProgressMale = 0;
  int _inProgressFemale = 0;
  int _inProgressUnclass = 0;
  int _inProgressSync = 0;
  int _inProgressAsync = 0;
  int _onlyEnrolledMale = 0;
  int _onlyEnrolledFemale = 0;
  int _onlyEnrolledUnclass = 0;
  int _onlyEnrolledSync = 0;
  int _onlyEnrolledAsync = 0;
  Map<String, int> _completedLangCounts = {};
  Map<String, int> _inProgressLangCounts = {};
  Map<String, int> _onlyEnrolledLangCounts = {};
  bool _isExportingProgress = false;
  List<ActiveUserDetailExportItem> _activeUserDetails = [];

  int get _totalCompleted => _completedMale + _completedFemale + _completedUnclass;
  int get _totalInProgress => _inProgressMale + _inProgressFemale + _inProgressUnclass;
  int get _totalOnlyEnrolled => _onlyEnrolledMale + _onlyEnrolledFemale + _onlyEnrolledUnclass;

  List<CourseActiveStat> _courseActiveStats = [];
  bool _showAllCourses = false;
  bool _isExporting = false;

  List<PartnerActiveStat> _partnerActiveStats = [];
  bool _showAllPartners = false;
  bool _isExportingPartners = false;

  List<AgeActiveStat> _ageActiveStats = [];
  bool _isExportingAge = false;

  // Statistiche Feedback
  List<FeedbackLangStat> _feedbackLangStats = [];
  List<CourseFeedbackStat> _courseFeedbackStats = [];
  double _overallFeedbackAverage = 0.0;
  int _totalFeedbackCount = 0;
  bool _isExportingFeedback = false;
  bool _showAllFeedbackCourses = false;
  String _feedbackCourseSearchQuery = '';

  // DG-CNECT KPIs
  List<DgCnectKpiItem> _dgCnectKpis = [];
  bool _isExportingDgCnect = false;
  String _selectedDgCnectCategory = 'TUTTI';
  StreamSubscription<void>? _catalogSub;

  StreamSubscription<void>? _statMdlSub;
  StreamSubscription<void>? _enrolledSub;
  StreamSubscription<void>? _usersSub;
  StreamSubscription<void>? _coursesSub;
  StreamSubscription<void>? _exclusionsSub;
  StreamSubscription<void>? _feedbackSub;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadAllData();
    final isar = ref.read(isarProvider);
    _statMdlSub = isar.statMdls.watchLazy().listen((_) {
      _loadAllData();
    });
    _enrolledSub = isar.userCourseEnrolleds.watchLazy().listen((_) {
      _loadAllData();
    });
    _usersSub = isar.users.watchLazy().listen((_) {
      _loadAllData();
    });
    _coursesSub = isar.courses.watchLazy().listen((_) {
      _loadAllData();
    });
    _exclusionsSub = isar.courseExclusions.watchLazy().listen((_) {
      _loadAllData();
    });
    _feedbackSub = isar.feedbackForBis.watchLazy().listen((_) {
      _loadAllData();
    });
    _catalogSub = isar.courseCatalogItems.watchLazy().listen((_) {
      _loadAllData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _statMdlSub?.cancel();
    _enrolledSub?.cancel();
    _usersSub?.cancel();
    _coursesSub?.cancel();
    _exclusionsSub?.cancel();
    _feedbackSub?.cancel();
    _catalogSub?.cancel();
    super.dispose();
  }

  Future<void> _exportDgCnectReport() async {
    if (_dgCnectKpis.isEmpty || _isExportingDgCnect) return;
    setState(() => _isExportingDgCnect = true);
    try {
      final path = await DgCnectExcelExporter.exportReport(kpiItems: _dgCnectKpis);
      if (mounted && path != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Report DG-CNECT esportato con successo in: $path'),
            backgroundColor: const Color(0xFF16A34A),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore durante l\'esportazione del report DG-CNECT: $e'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isExportingDgCnect = false);
    }
  }

  Future<void> _exportPartnersToExcel() async {
    if (_partnerActiveStats.isEmpty || _isExportingPartners) return;
    setState(() => _isExportingPartners = true);
    try {
      final path = await PartnerActiveStatsExcelExporter.exportStats(_partnerActiveStats);
      if (mounted && path != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File esportato con successo in: $path'),
            backgroundColor: const Color(0xFF16A34A),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore durante l\'esportazione Excel Partner: $e'),
            backgroundColor: AppTheme.accentRed,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExportingPartners = false);
      }
    }
  }

  Future<void> _exportAgeToExcel() async {
    if (_ageActiveStats.isEmpty || _isExportingAge) return;
    setState(() => _isExportingAge = true);
    try {
      final path = await AgeActiveStatsExcelExporter.exportStats(
        _ageActiveStats,
        totalActiveUsers: _activeUsersCount,
      );
      if (mounted && path != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File esportato con successo in: $path'),
            backgroundColor: const Color(0xFF16A34A),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore durante l\'esportazione Excel Età: $e'),
            backgroundColor: AppTheme.accentRed,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExportingAge = false);
      }
    }
  }

  Future<void> _exportToExcel() async {
    if (_courseActiveStats.isEmpty || _isExporting) return;
    setState(() => _isExporting = true);
    try {
      final path = await CourseActiveStatsExcelExporter.exportStats(_courseActiveStats);
      if (mounted && path != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    kIsWeb ? 'Esportazione Excel completata' : 'File salvato con successo: $path',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF16A34A),
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
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _exportFeedbackToExcel() async {
    if ((_feedbackLangStats.isEmpty && _courseFeedbackStats.isEmpty) || _isExportingFeedback) return;
    setState(() => _isExportingFeedback = true);
    try {
      final path = await FeedbackDashboardStatsExcelExporter.exportStats(
        langStats: _feedbackLangStats,
        courseStats: _courseFeedbackStats,
      );
      if (mounted && path != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    kIsWeb ? 'Esportazione statistiche feedback completata' : 'File salvato con successo: $path',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF16A34A),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore durante l\'esportazione Excel Feedback: $e'),
            backgroundColor: AppTheme.accentRed,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isExportingFeedback = false);
    }
  }

  Future<void> _exportEnrolledPartnersToExcel() async {
    if (_enrolledPartnerStats.isEmpty || _isExportingEnrolledPartners) return;
    setState(() => _isExportingEnrolledPartners = true);
    try {
      final path = await PartnerActiveStatsExcelExporter.exportStats(_enrolledPartnerStats);
      if (mounted && path != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File esportato con successo in: $path'),
            backgroundColor: const Color(0xFF16A34A),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore durante l\'esportazione Excel Partner (Iscritti): $e'),
            backgroundColor: AppTheme.accentRed,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExportingEnrolledPartners = false);
      }
    }
  }

  Future<void> _exportEnrolledAgeToExcel() async {
    if (_enrolledAgeStats.isEmpty || _isExportingEnrolledAge) return;
    setState(() => _isExportingEnrolledAge = true);
    try {
      final path = await AgeActiveStatsExcelExporter.exportStats(
        _enrolledAgeStats,
        totalActiveUsers: _enrolledUsersCount,
      );
      if (mounted && path != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File esportato con successo in: $path'),
            backgroundColor: const Color(0xFF16A34A),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore durante l\'esportazione Excel Età (Iscritti): $e'),
            backgroundColor: AppTheme.accentRed,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExportingEnrolledAge = false);
      }
    }
  }

  Future<void> _exportEnrolledCoursesToExcel() async {
    if (_enrolledCourseStats.isEmpty || _isExportingEnrolledCourses) return;
    setState(() => _isExportingEnrolledCourses = true);
    try {
      final path = await CourseActiveStatsExcelExporter.exportStats(_enrolledCourseStats);
      if (mounted && path != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    kIsWeb ? 'Esportazione Excel completata' : 'File salvato con successo: $path',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF16A34A),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore durante l\'esportazione Excel Corsi (Iscritti): $e'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isExportingEnrolledCourses = false);
    }
  }

  Future<void> _exportEnrolledProgressToExcel() async {
    if (_enrolledUsersCount == 0 || _isExportingEnrolledProgress) return;
    setState(() => _isExportingEnrolledProgress = true);
    try {
      final items = [
        ProgressStatusExportItem(
          statusName: 'Completati',
          total: _totalEnrolledCompleted,
          maleCount: _enrolledCompMale,
          femaleCount: _enrolledCompFemale,
          unclassifiedCount: _enrolledCompUnclass,
          syncCount: _enrolledCompSync,
          asyncCount: _enrolledCompAsync,
          langCounts: _enrolledCompLangCounts,
        ),
        ProgressStatusExportItem(
          statusName: 'In corso',
          total: _totalEnrolledInProgress,
          maleCount: _enrolledInProgMale,
          femaleCount: _enrolledInProgFemale,
          unclassifiedCount: _enrolledInProgUnclass,
          syncCount: _enrolledInProgSync,
          asyncCount: _enrolledInProgAsync,
          langCounts: _enrolledInProgLangCounts,
        ),
        ProgressStatusExportItem(
          statusName: 'Solo iscritti',
          total: _totalEnrolledOnlyEnrolled,
          maleCount: _enrolledOnlyEnrMale,
          femaleCount: _enrolledOnlyEnrFemale,
          unclassifiedCount: _enrolledOnlyEnrUnclass,
          syncCount: _enrolledOnlyEnrSync,
          asyncCount: _enrolledOnlyEnrAsync,
          langCounts: _enrolledOnlyEnrLangCounts,
        ),
      ];

      final path = await ActiveUsersProgressExcelExporter.exportStats(
        totalActiveUsers: _enrolledUsersCount,
        items: items,
        userDetails: _enrolledUserDetails,
      );

      if (mounted && path != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    kIsWeb ? 'Esportazione Excel completata' : 'File salvato con successo: $path',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF16A34A),
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
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isExportingEnrolledProgress = false);
    }
  }

  Future<void> _exportProgressToExcel() async {
    if (_activeUsersCount == 0 || _isExportingProgress) return;
    setState(() => _isExportingProgress = true);
    try {
      final items = [
        ProgressStatusExportItem(
          statusName: 'Completati',
          total: _totalCompleted,
          maleCount: _completedMale,
          femaleCount: _completedFemale,
          unclassifiedCount: _completedUnclass,
          syncCount: _completedSync,
          asyncCount: _completedAsync,
          langCounts: _completedLangCounts,
        ),
        ProgressStatusExportItem(
          statusName: 'In corso',
          total: _totalInProgress,
          maleCount: _inProgressMale,
          femaleCount: _inProgressFemale,
          unclassifiedCount: _inProgressUnclass,
          syncCount: _inProgressSync,
          asyncCount: _inProgressAsync,
          langCounts: _inProgressLangCounts,
        ),
        ProgressStatusExportItem(
          statusName: 'Solo iscritti',
          total: _totalOnlyEnrolled,
          maleCount: _onlyEnrolledMale,
          femaleCount: _onlyEnrolledFemale,
          unclassifiedCount: _onlyEnrolledUnclass,
          syncCount: _onlyEnrolledSync,
          asyncCount: _onlyEnrolledAsync,
          langCounts: _onlyEnrolledLangCounts,
        ),
      ];

      final path = await ActiveUsersProgressExcelExporter.exportStats(
        totalActiveUsers: _activeUsersCount,
        items: items,
        userDetails: _activeUserDetails,
      );

      if (mounted && path != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    kIsWeb ? 'Esportazione Excel completata' : 'File salvato con successo: $path',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF16A34A),
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
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isExportingProgress = false);
    }
  }

  String? _getCustomFieldValue(User u, List<String> keywords) {
    if (u.customfields == null) return null;
    for (final cf in u.customfields!) {
      final name = (cf.name ?? '').toLowerCase();
      final shortname = (cf.shortname ?? '').toLowerCase();
      for (final kw in keywords) {
        if (name.contains(kw) || shortname.contains(kw)) {
          final val = cf.displayvalue?.trim().isNotEmpty == true
              ? cf.displayvalue
              : cf.value?.trim().isNotEmpty == true
                  ? cf.value
                  : null;
          if (val != null) return val;
        }
      }
    }
    return null;
  }

  String? _getPartnerRef(User u) {
    if (u.customfields == null) return null;
    for (final cf in u.customfields!) {
      final name = (cf.name ?? '').toLowerCase();
      final shortname = (cf.shortname ?? '').toLowerCase();
      if (shortname == 'partner_ref' ||
          name == 'partner reference' ||
          shortname.contains('partner') ||
          shortname.contains('partener') ||
          name.contains('partner') ||
          name.contains('partener')) {
        if (shortname == 'qualification' && !shortname.contains('partner')) continue;
        final val = cf.displayvalue?.trim().isNotEmpty == true
            ? cf.displayvalue!.trim()
            : cf.value?.trim().isNotEmpty == true
                ? cf.value!.trim()
                : null;
        if (val != null && val.isNotEmpty) return val;
      }
    }
    return null;
  }

  Future<void> _loadAllData() async {
    setState(() => _isLoading = true);
    try {
      final isar = ref.read(isarProvider);

      // 0. Caricamento corsi esclusi e mappatura codici/prefissi
      final exclusions = await isar.courseExclusions.where().findAll();
      final allCourses = await isar.courses.where().findAll();
      final Map<int, Course> coursesMap = {for (final c in allCourses) c.id: c};

      final Set<int> excludedCourseIds = {};
      final Map<int, int> prefixToCourseId = {};
      final Map<int, int> courseIdToPrefix = {};

      for (final c in allCourses) {
        if (c.shortname != null) {
          final match = RegExp(r'^(\d+)').firstMatch(c.shortname!.trim());
          if (match != null) {
            final prefix = int.tryParse(match.group(1)!);
            if (prefix != null) {
              prefixToCourseId[prefix] = c.id;
              courseIdToPrefix[c.id] = prefix;
            }
          }
        }
      }

      for (final e in exclusions) {
        excludedCourseIds.add(e.courseId);
        if (prefixToCourseId.containsKey(e.courseId)) {
          excludedCourseIds.add(prefixToCourseId[e.courseId]!);
        }
        if (courseIdToPrefix.containsKey(e.courseId)) {
          excludedCourseIds.add(courseIdToPrefix[e.courseId]!);
        }
      }

      // 1. Conteggio utenti singoli partecipanti da stat_mdl (hanno iniziato o completato un corso non escluso)
      final rawStats = await isar.statMdls.where().findAll();
      final validStats = rawStats.where((s) {
        final cId = s.idCorso;
        if (cId != null && excludedCourseIds.contains(cId)) return false;
        return true;
      }).toList();

      final Set<dynamic> uniqueParticipatingUsers = {};
      for (final stat in validStats) {
        final st = (stat.statoCompletamentoCorso ?? '').trim().toLowerCase();
        final hasCompleted = st == 'completato' || stat.dataCompletamentoCorso != null;
        final hasStarted = st == 'in corso' ||
            stat.dataCompletamento != null ||
            stat.primoAccessoPiattaforma != null ||
            stat.ultimoAccessoPiattaforma != null;

        if (hasCompleted || hasStarted) {
          final key = (stat.userId != null && stat.userId! > 0)
              ? stat.userId
              : (stat.username?.trim().isNotEmpty == true
                  ? stat.username!.trim()
                  : (stat.fullName.isNotEmpty
                      ? stat.fullName
                      : (stat.email?.trim().isNotEmpty == true ? stat.email!.trim() : null)));
          if (key != null) {
            uniqueParticipatingUsers.add(key);
          }
        }
      }

      // 2. Conteggio iscrizioni e utenti singoli da user_course_enrolled (escludendo i corsi in blacklist)
      final rawEnrolled = await isar.userCourseEnrolleds.where().findAll();
      final validEnrolled = rawEnrolled.where((item) {
        final cId = item.courseId;
        if (cId == null || excludedCourseIds.contains(cId)) return false;
        return true;
      }).toList();

      final allUsers = await isar.users.where().findAll();
      final Map<int, User> usersMap = {for (final u in allUsers) u.id: u};
      final Map<String, int> usernameToIdMap = {
        for (final u in allUsers)
          if (u.username?.trim().isNotEmpty == true) u.username!.trim().toLowerCase(): u.id,
      };
      final Map<String, int> emailToIdMap = {
        for (final u in allUsers)
          if (u.email?.trim().isNotEmpty == true) u.email!.trim().toLowerCase(): u.id,
      };

      // Mappatura nomi e codici corsi per matching con i badge
      final Map<String, int> courseNameToId = {};
      for (final c in allCourses) {
        if (c.fullname != null && c.fullname!.trim().isNotEmpty) {
          courseNameToId[c.fullname!.trim().toLowerCase()] = c.id;
        }
        if (c.shortname != null && c.shortname!.trim().isNotEmpty) {
          courseNameToId[c.shortname!.trim().toLowerCase()] = c.id;
        }
      }

      // Integrazione Badges: se un utente ha conseguito il badge per un corso, il corso è completato
      final allBadges = await isar.badgeUsers.where().findAll();
      final Set<String> badgeCompletedCourseUserSet = {};
      for (final b in allBadges) {
        final bName = b.badge?.trim().toLowerCase();
        final cId = bName != null ? courseNameToId[bName] : null;
        final uEmail = b.email?.trim().toLowerCase();
        final uId = uEmail != null ? emailToIdMap[uEmail] : null;
        if (cId != null && !excludedCourseIds.contains(cId)) {
          if (uId != null) {
            badgeCompletedCourseUserSet.add('$cId-$uId');
            uniqueParticipatingUsers.add(uId);
          } else if (uEmail != null) {
            uniqueParticipatingUsers.add(uEmail);
          }
        }
      }

      // Deduplica sullo stesso corso per lo stesso utente (ogni coppia corso-utente conta al massimo 1 volta)
      final Set<String> seenCourseUserEnrollments = {};
      final List<UserCourseEnrolled> distinctCourseEnrolled = [];
      for (final item in validEnrolled) {
        final uId = item.userId;
        final cId = item.courseId;
        if (uId != null && cId != null && uId > 0 && cId > 0) {
          if (seenCourseUserEnrollments.add('$cId-$uId')) {
            distinctCourseEnrolled.add(item);
          }
        }
      }

      // 2b. Totale complessivo di tutte le iscrizioni a corsi non esclusi (singolo utente conteggiato 1 sola volta per corso) con Gender e Lingua
      int totalEnrollments = 0;
      int enrMale = 0;
      int enrFemale = 0;
      int enrUnclass = 0;
      final Map<String, int> enrLangMap = {};
      final Map<String, Map<String, int>> enrGenderLangMap = {};

      for (final item in distinctCourseEnrolled) {
        totalEnrollments++;
        final uId = item.userId;
        final u = uId != null ? usersMap[uId] : null;

        final rawGender = u != null
            ? _getCustomFieldValue(u, ['gender', 'sesso', 'genere'])?.trim().toLowerCase() ?? ''
            : '';
        final String genderKey;
        if (rawGender == 'm' || rawGender.startsWith('masch') || rawGender == 'male') {
          enrMale++;
          genderKey = 'M';
        } else if (rawGender == 'f' || rawGender.startsWith('femm') || rawGender == 'female') {
          enrFemale++;
          genderKey = 'F';
        } else {
          enrUnclass++;
          genderKey = 'N.C.';
        }

        final rawLang = u != null
            ? (_getCustomFieldValue(u, [
                'user\'s pref course lang',
                'pref course lang',
                'course lang',
                'course_lang',
                'prefcourselang',
                'pref_course_lang',
                'lang',
              ]) ?? (u.lang?.trim().isNotEmpty == true ? u.lang!.trim() : null))
            : null;

        final langCode = (rawLang != null && rawLang.trim().isNotEmpty)
            ? rawLang.trim().toUpperCase()
            : 'N.D.';

        enrLangMap[langCode] = (enrLangMap[langCode] ?? 0) + 1;
        enrGenderLangMap.putIfAbsent(langCode, () => {})[genderKey] =
            (enrGenderLangMap[langCode]![genderKey] ?? 0) + 1;
      }

      final Set<int> uniqueEnrolledUsers = {};
      for (final item in validEnrolled) {
        if (item.userId != null && item.userId! > 0) {
          uniqueEnrolledUsers.add(item.userId!);
        }
      }

      // 3. Conteggio utenti attivi (iscritti a corsi validi con firstaccess > 0) e calcolo distribuzione gender
      final Set<int> uniqueActiveUsers = {};
      for (final userId in uniqueEnrolledUsers) {
        final u = usersMap[userId];
        if (u != null && u.firstaccess != null && u.firstaccess! > 0) {
          uniqueActiveUsers.add(userId);
        }
      }

      // Pre-identificazione utenti attivi che hanno completato almeno un corso non escluso
      final Set<int> completedActiveUserIds = {};
      for (final stat in validStats) {
        final uId = (stat.userId != null && stat.userId! > 0)
            ? stat.userId!
            : (usernameToIdMap[stat.username?.trim().toLowerCase()] ??
               emailToIdMap[stat.email?.trim().toLowerCase()]);
        if (uId == null || !uniqueActiveUsers.contains(uId)) continue;
        final st = (stat.statoCompletamentoCorso ?? '').trim().toLowerCase();
        final isCompleted = st == 'completato' ||
            stat.dataCompletamentoCorso != null;
        if (isCompleted) {
          completedActiveUserIds.add(uId);
        }
      }
      for (final key in badgeCompletedCourseUserSet) {
        final parts = key.split('-');
        if (parts.length == 2) {
          final uId = int.tryParse(parts[1]);
          if (uId != null && uniqueActiveUsers.contains(uId)) {
            completedActiveUserIds.add(uId);
          }
        }
      }

      final Map<int, String> userDobFromStatsMap = {};
      for (final stat in validStats) {
        final uId = (stat.userId != null && stat.userId! > 0)
            ? stat.userId!
            : (usernameToIdMap[stat.username?.trim().toLowerCase()] ??
               emailToIdMap[stat.email?.trim().toLowerCase()]);
        if (uId != null && !userDobFromStatsMap.containsKey(uId)) {
          final dob = stat.dateOfBirthCnv ?? stat.dateOfBirth;
          if (dob != null && dob.trim().isNotEmpty) {
            userDobFromStatsMap[uId] = dob.trim();
          }
        }
      }

      int maleCount = 0;
      int femaleCount = 0;
      int unclassifiedCount = 0;
      final Map<String, int> activeLangMap = {};
      final Map<String, Map<String, int>> activeGenderLangMap = {};
      final Map<String, int> activeYearMap = {};
      final Map<String, Map<String, int>> activeGenderYearMap = {};
      final Map<String, Map<String, int>> activeYearLangMap = {};
      final Map<String, Map<String, Map<String, int>>> activeYearGenderLangMap = {};
      final Map<String, PartnerActiveStat> partnerStatsMap = {};
      final ageStatLe25 = AgeActiveStat(label: 'Età ≤ 25 anni', key: 'le25');
      final ageStatGt25 = AgeActiveStat(label: 'Età > 25 anni', key: 'gt25');
      final ageStatUnknown = AgeActiveStat(label: 'Età non specificata', key: 'unknown');

      for (final userId in uniqueActiveUsers) {
        final u = usersMap[userId]!;

        final rawGender = _getCustomFieldValue(u, ['gender', 'sesso', 'genere'])?.trim().toLowerCase() ?? '';
        final String genderKey;
        if (rawGender == 'm' || rawGender.startsWith('masch') || rawGender == 'male') {
          maleCount++;
          genderKey = 'M';
        } else if (rawGender == 'f' || rawGender.startsWith('femm') || rawGender == 'female') {
          femaleCount++;
          genderKey = 'F';
        } else {
          unclassifiedCount++;
          genderKey = 'N.C.';
        }

        final rawLang = _getCustomFieldValue(u, [
          'user\'s pref course lang',
          'pref course lang',
          'course lang',
          'course_lang',
          'prefcourselang',
          'pref_course_lang',
          'lang',
        ]) ?? (u.lang?.trim().isNotEmpty == true ? u.lang!.trim() : null);

        final langCode = (rawLang != null && rawLang.trim().isNotEmpty)
            ? rawLang.trim().toUpperCase()
            : 'N.D.';

        activeLangMap[langCode] = (activeLangMap[langCode] ?? 0) + 1;
        activeGenderLangMap.putIfAbsent(langCode, () => {})[genderKey] =
            (activeGenderLangMap[langCode]![genderKey] ?? 0) + 1;

        // Aggregazione Utenti Attivi per Anno di Iscrizione (data di primo accesso u.firstaccess)
        DateTime? firstAccessDate;
        if (u.firstaccess != null && u.firstaccess! > 0) {
          final val = u.firstaccess!;
          firstAccessDate = val > 10000000000
              ? DateTime.fromMillisecondsSinceEpoch(val)
              : DateTime.fromMillisecondsSinceEpoch(val * 1000);
        }
        final yearStr = firstAccessDate != null ? firstAccessDate.year.toString() : '2025';

        activeYearMap[yearStr] = (activeYearMap[yearStr] ?? 0) + 1;
        activeGenderYearMap.putIfAbsent(yearStr, () => {})[genderKey] =
            (activeGenderYearMap[yearStr]![genderKey] ?? 0) + 1;
        activeYearLangMap.putIfAbsent(yearStr, () => {})[langCode] =
            (activeYearLangMap[yearStr]![langCode] ?? 0) + 1;
        activeYearGenderLangMap
            .putIfAbsent(yearStr, () => {})
            .putIfAbsent(langCode, () => {})[genderKey] =
            (activeYearGenderLangMap[yearStr]![langCode]![genderKey] ?? 0) + 1;

        // Aggregazione Utenti Attivi per Fascia d'Età (<= 25 / > 25)
        int? userAge = u.age;
        if (userAge == null) {
          final statDobStr = userDobFromStatsMap[userId];
          if (statDobStr != null && statDobStr.isNotEmpty) {
            final parsed = User.tryParseDobString(statDobStr);
            if (parsed != null) {
              final now = DateTime.now();
              int a = now.year - parsed.year;
              if (now.month < parsed.month || (now.month == parsed.month && now.day < parsed.day)) {
                a--;
              }
              if (a >= 0 && a <= 115) {
                userAge = a;
              }
            }
          }
        }

        final AgeActiveStat targetAgeStat;
        if (userAge != null) {
          targetAgeStat = userAge <= 25 ? ageStatLe25 : ageStatGt25;
        } else {
          targetAgeStat = ageStatUnknown;
        }

        if (genderKey == 'M') {
          targetAgeStat.maleCount++;
        } else if (genderKey == 'F') {
          targetAgeStat.femaleCount++;
        } else {
          targetAgeStat.unclassifiedCount++;
        }

        if (completedActiveUserIds.contains(userId)) {
          targetAgeStat.completedCount++;
        }

        targetAgeStat.langCounts[langCode] = (targetAgeStat.langCounts[langCode] ?? 0) + 1;
        targetAgeStat.genderLangCounts.putIfAbsent(langCode, () => {})[genderKey] =
            (targetAgeStat.genderLangCounts[langCode]![genderKey] ?? 0) + 1;

        // Aggregazione Utenti Attivi per Partner Reference
        final rawPartner = _getPartnerRef(u);
        final partnerName = (rawPartner != null && rawPartner.isNotEmpty) ? rawPartner : 'Non specificato';
        final pStat = partnerStatsMap.putIfAbsent(
          partnerName,
          () => PartnerActiveStat(partnerName: partnerName),
        );
        if (genderKey == 'M') {
          pStat.maleCount++;
        } else if (genderKey == 'F') {
          pStat.femaleCount++;
        } else {
          pStat.unclassifiedCount++;
        }
        if (completedActiveUserIds.contains(userId)) {
          pStat.completedCount++;
        }
        pStat.langCounts[langCode] = (pStat.langCounts[langCode] ?? 0) + 1;
        pStat.genderLangCounts.putIfAbsent(langCode, () => {})[genderKey] =
            (pStat.genderLangCounts[langCode]![genderKey] ?? 0) + 1;
      }

      final sortedAgeStats = [
        ageStatLe25,
        ageStatGt25,
        if (ageStatUnknown.total > 0) ageStatUnknown,
      ];

      final sortedPartnerStats = partnerStatsMap.values.toList()
        ..sort((a, b) => b.total.compareTo(a.total));

      // 4. Mappatura tipo corso (sync/async) e completamento corsi da validStats + badges (1 completamento per utente per corso)
      final Map<int, List<String>> courseTagsMap = {};
      final Set<String> completedCourseUserSet = {...badgeCompletedCourseUserSet};
      final Set<String> startedCourseUserSet = {};

      for (final stat in validStats) {
        final cId = stat.idCorso;
        final uId = (stat.userId != null && stat.userId! > 0)
            ? stat.userId!
            : (usernameToIdMap[stat.username?.trim().toLowerCase()] ??
               emailToIdMap[stat.email?.trim().toLowerCase()]);
        if (cId != null) {
          final tag = (stat.ntag ?? '').trim().toLowerCase();
          if (tag.isNotEmpty) {
            courseTagsMap.putIfAbsent(cId, () => []).add(tag);
          }
          if (uId != null) {
            final st = (stat.statoCompletamentoCorso ?? '').trim().toLowerCase();
            final isCompleted = st == 'completato' || stat.dataCompletamentoCorso != null;
            final isStarted = st == 'in corso' ||
                stat.dataCompletamento != null ||
                stat.primoAccessoPiattaforma != null ||
                stat.ultimoAccessoPiattaforma != null;
            if (isCompleted) {
              completedCourseUserSet.add('$cId-$uId');
            } else if (isStarted) {
              startedCourseUserSet.add('$cId-$uId');
            }
          }
        }
      }

      String resolveCourseType(int cId) {
        final tags = courseTagsMap[cId] ?? [];
        final hasMeet = tags.any((t) => t == 'meet');
        if (hasMeet) return 'sync';
        const asyncTags = {'async', 'asyncp'};
        final isAsync = tags.any((t) => asyncTags.contains(t));
        return isAsync ? 'async' : 'sync';
      }

      // 5. Distribuzione iscrizioni per corso per gli utenti attivi con dettaglio gender e completamento
      final Map<int, String> statCourseNames = {};
      final Map<int, String> statCourseShorts = {};
      for (final s in validStats) {
        final cId = s.idCorso;
        if (cId != null && cId > 0) {
          if (s.nomeCorso?.trim().isNotEmpty == true) {
            statCourseNames[cId] = s.nomeCorso!.trim();
          } else if (s.shorthNomeCorso?.trim().isNotEmpty == true) {
            statCourseNames.putIfAbsent(cId, () => s.shorthNomeCorso!.trim());
          }
          if (s.shorthNomeCorso?.trim().isNotEmpty == true) {
            statCourseShorts[cId] = s.shorthNomeCorso!.trim();
          }
        }
      }
      final Map<int, CourseActiveStat> courseStatsMap = {};
      final Set<String> processedCourseUser = {};

      int totalActiveCourseEnrollments = 0;
      int activeEnrMale = 0;
      int activeEnrFemale = 0;
      int activeEnrUnclass = 0;
      int activeEnrCompleted = 0;
      int activeEnrSync = 0;
      int activeEnrAsync = 0;
      final Map<String, int> activeEnrLangMap = {};
      final Map<String, Map<String, int>> activeEnrGenderLangMap = {};

      int activeCompMale = 0;
      int activeCompFemale = 0;
      int activeCompUnclass = 0;
      final Map<String, int> activeCompLangMap = {};
      final Map<String, Map<String, int>> activeCompGenderLangMap = {};

      int activeInProgCount = 0;
      int activeInProgMale = 0;
      int activeInProgFemale = 0;
      int activeInProgUnclass = 0;
      final Map<String, int> activeInProgLangMap = {};
      final Map<String, Map<String, int>> activeInProgGenderLangMap = {};

      int activeOnlyEnrCount = 0;
      int activeOnlyEnrMale = 0;
      int activeOnlyEnrFemale = 0;
      int activeOnlyEnrUnclass = 0;
      final Map<String, int> activeOnlyEnrLangMap = {};
      final Map<String, Map<String, int>> activeOnlyEnrGenderLangMap = {};

      for (final item in validEnrolled) {
        final uId = item.userId;
        final cId = item.courseId;
        if (uId == null || cId == null) continue;

        // Considera SOLO utenti attivi (iscritti con firstaccess > 0)
        if (!uniqueActiveUsers.contains(uId)) continue;

        // Evita duplicati dello stesso utente nello stesso corso
        if (!processedCourseUser.add('$cId-$uId')) continue;

        final cType = resolveCourseType(cId);
        totalActiveCourseEnrollments++;
        if (cType == 'async') {
          activeEnrAsync++;
        } else {
          activeEnrSync++;
        }

        final c = coursesMap[cId];
        final cName = (c?.fullname?.trim().isNotEmpty == true)
            ? c!.fullname!.trim()
            : (c?.shortname?.trim().isNotEmpty == true
                ? c!.shortname!.trim()
                : (statCourseNames[cId] ?? 'Corso #$cId'));
        final cShort = (c?.shortname?.trim().isNotEmpty == true)
            ? c!.shortname!.trim()
            : (statCourseShorts[cId] ?? 'ID: $cId');

        final stat = courseStatsMap.putIfAbsent(
          cId,
          () => CourseActiveStat(
            courseId: cId,
            courseName: cName,
            courseShortname: cShort,
            courseType: cType,
          ),
        );

        final isComp = completedCourseUserSet.contains('$cId-$uId');
        final isInProg = !isComp && startedCourseUserSet.contains('$cId-$uId');

        if (isComp) {
          stat.completedCount++;
          activeEnrCompleted++;
        } else if (isInProg) {
          activeInProgCount++;
        } else {
          activeOnlyEnrCount++;
        }

        final u = usersMap[uId];
        final String genderKey;
        if (u != null) {
          final rawGender = _getCustomFieldValue(u, ['gender', 'sesso', 'genere'])?.trim().toLowerCase() ?? '';
          if (rawGender == 'm' || rawGender.startsWith('masch') || rawGender == 'male') {
            stat.maleCount++;
            activeEnrMale++;
            genderKey = 'M';
            if (isComp) {
              activeCompMale++;
            } else if (isInProg) {
              activeInProgMale++;
            } else {
              activeOnlyEnrMale++;
            }
          } else if (rawGender == 'f' || rawGender.startsWith('femm') || rawGender == 'female') {
            stat.femaleCount++;
            activeEnrFemale++;
            genderKey = 'F';
            if (isComp) {
              activeCompFemale++;
            } else if (isInProg) {
              activeInProgFemale++;
            } else {
              activeOnlyEnrFemale++;
            }
          } else {
            stat.unclassifiedCount++;
            activeEnrUnclass++;
            genderKey = 'N.C.';
            if (isComp) {
              activeCompUnclass++;
            } else if (isInProg) {
              activeInProgUnclass++;
            } else {
              activeOnlyEnrUnclass++;
            }
          }

          final rawLang = _getCustomFieldValue(u, [
            'user\'s pref course lang',
            'pref course lang',
            'course lang',
            'course_lang',
            'prefcourselang',
            'pref_course_lang',
            'lang',
          ]) ?? (u.lang?.trim().isNotEmpty == true ? u.lang!.trim() : null);
          final userLang = (rawLang != null && rawLang.trim().isNotEmpty)
              ? rawLang.trim().toUpperCase()
              : 'N.D.';
          stat.langCounts[userLang] = (stat.langCounts[userLang] ?? 0) + 1;
          activeEnrLangMap[userLang] = (activeEnrLangMap[userLang] ?? 0) + 1;
          activeEnrGenderLangMap.putIfAbsent(userLang, () => {})[genderKey] =
              (activeEnrGenderLangMap[userLang]![genderKey] ?? 0) + 1;

          if (isComp) {
            activeCompLangMap[userLang] = (activeCompLangMap[userLang] ?? 0) + 1;
            activeCompGenderLangMap.putIfAbsent(userLang, () => {})[genderKey] =
                (activeCompGenderLangMap[userLang]![genderKey] ?? 0) + 1;
          } else if (isInProg) {
            activeInProgLangMap[userLang] = (activeInProgLangMap[userLang] ?? 0) + 1;
            activeInProgGenderLangMap.putIfAbsent(userLang, () => {})[genderKey] =
                (activeInProgGenderLangMap[userLang]![genderKey] ?? 0) + 1;
          } else {
            activeOnlyEnrLangMap[userLang] = (activeOnlyEnrLangMap[userLang] ?? 0) + 1;
            activeOnlyEnrGenderLangMap.putIfAbsent(userLang, () => {})[genderKey] =
                (activeOnlyEnrGenderLangMap[userLang]![genderKey] ?? 0) + 1;
          }
        } else {
          stat.unclassifiedCount++;
          activeEnrUnclass++;
          genderKey = 'N.C.';
          if (isComp) {
            activeCompUnclass++;
          } else if (isInProg) {
            activeInProgUnclass++;
          } else {
            activeOnlyEnrUnclass++;
          }

          stat.langCounts['N.D.'] = (stat.langCounts['N.D.'] ?? 0) + 1;
          activeEnrLangMap['N.D.'] = (activeEnrLangMap['N.D.'] ?? 0) + 1;
          activeEnrGenderLangMap.putIfAbsent('N.D.', () => {})[genderKey] =
              (activeEnrGenderLangMap['N.D.']![genderKey] ?? 0) + 1;

          if (isComp) {
            activeCompLangMap['N.D.'] = (activeCompLangMap['N.D.'] ?? 0) + 1;
            activeCompGenderLangMap.putIfAbsent('N.D.', () => {})[genderKey] =
                (activeCompGenderLangMap['N.D.']![genderKey] ?? 0) + 1;
          } else if (isInProg) {
            activeInProgLangMap['N.D.'] = (activeInProgLangMap['N.D.'] ?? 0) + 1;
            activeInProgGenderLangMap.putIfAbsent('N.D.', () => {})[genderKey] =
                (activeInProgGenderLangMap['N.D.']![genderKey] ?? 0) + 1;
          } else {
            activeOnlyEnrLangMap['N.D.'] = (activeOnlyEnrLangMap['N.D.'] ?? 0) + 1;
            activeOnlyEnrGenderLangMap.putIfAbsent('N.D.', () => {})[genderKey] =
                (activeOnlyEnrGenderLangMap['N.D.']![genderKey] ?? 0) + 1;
          }
        }
      }

      final Map<String, int> activeOtherLangMap = {};
      final Map<String, Map<String, int>> activeOtherGenderLangMap = {};
      for (final e in activeInProgLangMap.entries) {
        activeOtherLangMap[e.key] = (activeOtherLangMap[e.key] ?? 0) + e.value;
      }
      for (final e in activeOnlyEnrLangMap.entries) {
        activeOtherLangMap[e.key] = (activeOtherLangMap[e.key] ?? 0) + e.value;
      }
      for (final e in activeInProgGenderLangMap.entries) {
        final lang = e.key;
        for (final g in e.value.entries) {
          activeOtherGenderLangMap.putIfAbsent(lang, () => {})[g.key] =
              (activeOtherGenderLangMap[lang]![g.key] ?? 0) + g.value;
        }
      }
      for (final e in activeOnlyEnrGenderLangMap.entries) {
        final lang = e.key;
        for (final g in e.value.entries) {
          activeOtherGenderLangMap.putIfAbsent(lang, () => {})[g.key] =
              (activeOtherGenderLangMap[lang]![g.key] ?? 0) + g.value;
        }
      }

      final sortedCourseStats = courseStatsMap.values.toList()
        ..sort((a, b) => b.total.compareTo(a.total));

      // 6. Calcolo suddivisione utenti attivi: Completati, In corso, Solo iscritti con gender e tipo corso (Sync / Async da Vista per Utente)
      final Set<int> startedActiveUserIds = {};

      // Raggruppamento delle attività per (uId, cId) esattamente come in Vista per Utente
      final Map<String, List<StatMdl>> userCourseStatMap = {};
      for (final stat in validStats) {
        final uId = stat.userId;
        final cId = stat.idCorso;
        if (uId == null || cId == null) continue;
        userCourseStatMap.putIfAbsent('$uId-$cId', () => []).add(stat);

        if (!uniqueActiveUsers.contains(uId)) continue;

        final hasBadge = badgeCompletedCourseUserSet.contains('$cId-$uId');
        final st = (stat.statoCompletamentoCorso ?? '').trim().toLowerCase();
        final isCompleted = hasBadge ||
            st == 'completato' ||
            stat.dataCompletamentoCorso != null;
        final isStarted = st == 'in corso' ||
            stat.dataCompletamento != null ||
            stat.primoAccessoPiattaforma != null ||
            stat.ultimoAccessoPiattaforma != null;

        if (isCompleted) {
          completedActiveUserIds.add(uId);
        } else if (isStarted) {
          startedActiveUserIds.add(uId);
        }
      }

      for (final key in badgeCompletedCourseUserSet) {
        final parts = key.split('-');
        if (parts.length == 2) {
          final uId = int.tryParse(parts[1]);
          if (uId != null && uniqueActiveUsers.contains(uId)) {
            completedActiveUserIds.add(uId);
          }
        }
      }

      final Map<int, Set<int>> userEnrolledCourses = {};
      for (final item in validEnrolled) {
        final uId = item.userId;
        final cId = item.courseId;
        if (uId != null && cId != null && uniqueActiveUsers.contains(uId)) {
          userEnrolledCourses.putIfAbsent(uId, () => {}).add(cId);
        }
      }

      String getCourseTypeForUser(int uId, int cId) {
        final acts = userCourseStatMap['$uId-$cId'];
        if (acts != null && acts.isNotEmpty) {
          final hasMeet = acts.any((a) => (a.ntag ?? '').trim().toLowerCase() == 'meet');
          if (hasMeet) return 'sync';
          const asyncTags = {'async', 'asyncp'};
          final isAsync = acts.any((a) => asyncTags.contains((a.ntag ?? '').trim().toLowerCase()));
          return isAsync ? 'async' : 'sync';
        }
        return resolveCourseType(cId);
      }

      int compM = 0, compF = 0, compNC = 0;
      int compSync = 0, compAsync = 0;
      int inProgM = 0, inProgF = 0, inProgNC = 0;
      int inProgSync = 0, inProgAsync = 0;
      int onlyEnrM = 0, onlyEnrF = 0, onlyEnrNC = 0;
      int onlyEnrSync = 0, onlyEnrAsync = 0;
      final Map<String, int> compLangMap = {};
      final Map<String, int> inProgLangMap = {};
      final Map<String, int> onlyEnrLangMap = {};
      final List<ActiveUserDetailExportItem> activeUserDetailsList = [];

      for (final uId in uniqueActiveUsers) {
        final u = usersMap[uId];
        final rawGender = u != null
            ? _getCustomFieldValue(u, ['gender', 'sesso', 'genere'])?.trim().toLowerCase() ?? ''
            : '';
        final isM = rawGender == 'm' || rawGender.startsWith('masch') || rawGender == 'male';
        final isF = rawGender == 'f' || rawGender.startsWith('femm') || rawGender == 'female';

        final rawLang = u != null
            ? (_getCustomFieldValue(u, [
                'user\'s pref course lang',
                'pref course lang',
                'course lang',
                'course_lang',
                'prefcourselang',
                'pref_course_lang',
                'lang',
              ]) ?? (u.lang?.trim().isNotEmpty == true ? u.lang!.trim() : null))
            : null;
        final userLang = (rawLang != null && rawLang.trim().isNotEmpty)
            ? rawLang.trim().toUpperCase()
            : 'N.D.';

        // Corsi associati all'utente (iscritti o con attività o con badge), escludendo i corsi in blacklist
        final userCourses = <int>{
          ...?userEnrolledCourses[uId],
          for (final key in userCourseStatMap.keys)
            if (key.startsWith('$uId-')) int.tryParse(key.substring('$uId-'.length)) ?? 0,
          for (final key in badgeCompletedCourseUserSet)
            if (key.endsWith('-$uId')) int.tryParse(key.substring(0, key.indexOf('-'))) ?? 0,
        }..remove(0)..removeWhere((cId) => excludedCourseIds.contains(cId));

        Set<int> targetCourses;
        Set<String> types;
        String statusStr;

        if (completedActiveUserIds.contains(uId)) {
          statusStr = 'Completato';
          compLangMap[userLang] = (compLangMap[userLang] ?? 0) + 1;
          if (isM) {
            compM++;
          } else if (isF) {
            compF++;
          } else {
            compNC++;
          }

          final completedCourseIds = userCourses.where((cId) {
            if (completedCourseUserSet.contains('$cId-$uId')) return true;
            final acts = userCourseStatMap['$uId-$cId'];
            return acts?.any((a) =>
                    (a.statoCompletamentoCorso ?? '').trim().toLowerCase() == 'completato' ||
                    a.dataCompletamentoCorso != null) ==
                true;
          }).toSet();

          targetCourses = completedCourseIds.isNotEmpty ? completedCourseIds : userCourses;
          types = targetCourses.map((cId) => getCourseTypeForUser(uId, cId)).toSet();
          if (types.contains('sync')) compSync++;
          if (types.contains('async')) compAsync++;
          if (types.isEmpty) compSync++;
        } else if (startedActiveUserIds.contains(uId)) {
          statusStr = 'In corso';
          inProgLangMap[userLang] = (inProgLangMap[userLang] ?? 0) + 1;
          if (isM) {
            inProgM++;
          } else if (isF) {
            inProgF++;
          } else {
            inProgNC++;
          }

          final startedCourseIds = userCourses.where((cId) {
            final acts = userCourseStatMap['$uId-$cId'];
            return acts?.any((a) =>
                    (a.statoCompletamentoCorso ?? '').trim().toLowerCase() == 'in corso' ||
                    a.dataCompletamento != null ||
                    a.primoAccessoPiattaforma != null ||
                    a.ultimoAccessoPiattaforma != null) ==
                true;
          }).toSet();

          targetCourses = startedCourseIds.isNotEmpty ? startedCourseIds : userCourses;
          types = targetCourses.map((cId) => getCourseTypeForUser(uId, cId)).toSet();
          if (types.contains('sync')) inProgSync++;
          if (types.contains('async')) inProgAsync++;
          if (types.isEmpty) inProgSync++;
        } else {
          statusStr = 'Solo iscritto';
          onlyEnrLangMap[userLang] = (onlyEnrLangMap[userLang] ?? 0) + 1;
          if (isM) {
            onlyEnrM++;
          } else if (isF) {
            onlyEnrF++;
          } else {
            onlyEnrNC++;
          }

          targetCourses = userCourses;
          types = targetCourses.map((cId) => getCourseTypeForUser(uId, cId)).toSet();
          if (types.contains('sync')) onlyEnrSync++;
          if (types.contains('async')) onlyEnrAsync++;
          if (types.isEmpty) onlyEnrSync++;
        }

        final fullName = (u?.fullname?.trim().isNotEmpty == true) ? u!.fullname!.trim() : 'Utente #$uId';
        final username = u?.username ?? '-';
        final email = u?.email ?? '-';
        final genderStr = isM ? 'M' : (isF ? 'F' : 'N.C.');

        String courseTypeStr;
        if (types.contains('sync') && types.contains('async')) {
          courseTypeStr = 'Sync & Async';
        } else if (types.contains('async')) {
          courseTypeStr = 'Async';
        } else {
          courseTypeStr = 'Sync';
        }

        final coursesNames = targetCourses.map((cId) {
          final c = coursesMap[cId];
          return (c?.fullname?.trim().isNotEmpty == true)
              ? c!.fullname!.trim()
              : (c?.shortname?.trim().isNotEmpty == true
                  ? c!.shortname!.trim()
                  : (statCourseNames[cId] ?? 'Corso #$cId'));
        }).join(', ');

        activeUserDetailsList.add(ActiveUserDetailExportItem(
          userId: uId,
          username: username,
          fullName: fullName,
          email: email,
          gender: genderStr,
          language: userLang,
          status: statusStr,
          courseType: courseTypeStr,
          coursesSummary: coursesNames.isNotEmpty ? coursesNames : '-',
        ));
      }

      // 6b. Calcolo metriche per TUTTI gli utenti iscritti (per il tab Iscritti)
      final Set<int> completedEnrolledUserIds = {};
      final Set<int> startedEnrolledUserIds = {};
      final Map<String, List<StatMdl>> enrolledUserCourseStatMap = {};

      for (final stat in validStats) {
        final uId = stat.userId;
        final cId = stat.idCorso;
        if (uId == null || cId == null) continue;
        enrolledUserCourseStatMap.putIfAbsent('$uId-$cId', () => []).add(stat);

        if (!uniqueEnrolledUsers.contains(uId)) continue;

        final hasBadge = badgeCompletedCourseUserSet.contains('$cId-$uId');
        final st = (stat.statoCompletamentoCorso ?? '').trim().toLowerCase();
        final isCompleted = hasBadge ||
            st == 'completato' ||
            stat.dataCompletamentoCorso != null;
        final isStarted = st == 'in corso' ||
            stat.dataCompletamento != null ||
            stat.primoAccessoPiattaforma != null ||
            stat.ultimoAccessoPiattaforma != null;

        if (isCompleted) {
          completedEnrolledUserIds.add(uId);
        } else if (isStarted) {
          startedEnrolledUserIds.add(uId);
        }
      }

      for (final key in badgeCompletedCourseUserSet) {
        final parts = key.split('-');
        if (parts.length == 2) {
          final uId = int.tryParse(parts[1]);
          if (uId != null && uniqueEnrolledUsers.contains(uId)) {
            completedEnrolledUserIds.add(uId);
          }
        }
      }

      int enrMCount = 0;
      int enrFCount = 0;
      int enrNCCount = 0;
      final Map<String, int> enrolledUserLangMap = {};
      final Map<String, Map<String, int>> enrolledUserGenderLangMap = {};
      final Map<String, int> enrolledYearMap = {};
      final Map<String, Map<String, int>> enrolledGenderYearMap = {};
      final Map<String, Map<String, int>> enrolledYearLangMap = {};
      final Map<String, Map<String, Map<String, int>>> enrolledYearGenderLangMap = {};
      final Map<String, PartnerActiveStat> enrolledPartnerStatsMap = {};
      final enrolledAgeStatLe25 = AgeActiveStat(label: 'Età ≤ 25 anni', key: 'le25');
      final enrolledAgeStatGt25 = AgeActiveStat(label: 'Età > 25 anni', key: 'gt25');
      final enrolledAgeStatUnknown = AgeActiveStat(label: 'Età non specificata', key: 'unknown');

      for (final userId in uniqueEnrolledUsers) {
        final u = usersMap[userId];

        final rawGender = u != null
            ? _getCustomFieldValue(u, ['gender', 'sesso', 'genere'])?.trim().toLowerCase() ?? ''
            : '';
        final String genderKey;
        if (rawGender == 'm' || rawGender.startsWith('masch') || rawGender == 'male') {
          enrMCount++;
          genderKey = 'M';
        } else if (rawGender == 'f' || rawGender.startsWith('femm') || rawGender == 'female') {
          enrFCount++;
          genderKey = 'F';
        } else {
          enrNCCount++;
          genderKey = 'N.C.';
        }

        final rawLang = u != null
            ? (_getCustomFieldValue(u, [
                'user\'s pref course lang',
                'pref course lang',
                'course lang',
                'course_lang',
                'prefcourselang',
                'pref_course_lang',
                'lang',
              ]) ?? (u.lang?.trim().isNotEmpty == true ? u.lang!.trim() : null))
            : null;

        final langCode = (rawLang != null && rawLang.trim().isNotEmpty)
            ? rawLang.trim().toUpperCase()
            : 'N.D.';

        enrolledUserLangMap[langCode] = (enrolledUserLangMap[langCode] ?? 0) + 1;
        enrolledUserGenderLangMap.putIfAbsent(langCode, () => {})[genderKey] =
            (enrolledUserGenderLangMap[langCode]![genderKey] ?? 0) + 1;

        DateTime? firstAccessDate;
        if (u != null && u.firstaccess != null && u.firstaccess! > 0) {
          final val = u.firstaccess!;
          firstAccessDate = val > 10000000000
              ? DateTime.fromMillisecondsSinceEpoch(val)
              : DateTime.fromMillisecondsSinceEpoch(val * 1000);
        }
        final yearStr = firstAccessDate != null ? firstAccessDate.year.toString() : '2025';

        enrolledYearMap[yearStr] = (enrolledYearMap[yearStr] ?? 0) + 1;
        enrolledGenderYearMap.putIfAbsent(yearStr, () => {})[genderKey] =
            (enrolledGenderYearMap[yearStr]![genderKey] ?? 0) + 1;
        enrolledYearLangMap.putIfAbsent(yearStr, () => {})[langCode] =
            (enrolledYearLangMap[yearStr]![langCode] ?? 0) + 1;
        enrolledYearGenderLangMap
            .putIfAbsent(yearStr, () => {})
            .putIfAbsent(langCode, () => {})[genderKey] =
            (enrolledYearGenderLangMap[yearStr]![langCode]![genderKey] ?? 0) + 1;

        int? userAge = u?.age;
        if (userAge == null) {
          final statDobStr = userDobFromStatsMap[userId];
          if (statDobStr != null && statDobStr.isNotEmpty) {
            final parsed = User.tryParseDobString(statDobStr);
            if (parsed != null) {
              final now = DateTime.now();
              int a = now.year - parsed.year;
              if (now.month < parsed.month || (now.month == parsed.month && now.day < parsed.day)) {
                a--;
              }
              if (a >= 0 && a <= 115) {
                userAge = a;
              }
            }
          }
        }

        final AgeActiveStat targetAgeStat;
        if (userAge != null) {
          targetAgeStat = userAge <= 25 ? enrolledAgeStatLe25 : enrolledAgeStatGt25;
        } else {
          targetAgeStat = enrolledAgeStatUnknown;
        }

        if (genderKey == 'M') {
          targetAgeStat.maleCount++;
        } else if (genderKey == 'F') {
          targetAgeStat.femaleCount++;
        } else {
          targetAgeStat.unclassifiedCount++;
        }

        if (completedEnrolledUserIds.contains(userId)) {
          targetAgeStat.completedCount++;
        }

        targetAgeStat.langCounts[langCode] = (targetAgeStat.langCounts[langCode] ?? 0) + 1;
        targetAgeStat.genderLangCounts.putIfAbsent(langCode, () => {})[genderKey] =
            (targetAgeStat.genderLangCounts[langCode]![genderKey] ?? 0) + 1;

        final rawPartner = u != null ? _getPartnerRef(u) : null;
        final partnerName = (rawPartner != null && rawPartner.isNotEmpty) ? rawPartner : 'Non specificato';
        final pStat = enrolledPartnerStatsMap.putIfAbsent(
          partnerName,
          () => PartnerActiveStat(partnerName: partnerName),
        );
        if (genderKey == 'M') {
          pStat.maleCount++;
        } else if (genderKey == 'F') {
          pStat.femaleCount++;
        } else {
          pStat.unclassifiedCount++;
        }
        if (completedEnrolledUserIds.contains(userId)) {
          pStat.completedCount++;
        }
        pStat.langCounts[langCode] = (pStat.langCounts[langCode] ?? 0) + 1;
        pStat.genderLangCounts.putIfAbsent(langCode, () => {})[genderKey] =
            (pStat.genderLangCounts[langCode]![genderKey] ?? 0) + 1;
      }

      final sortedEnrolledAgeStats = [
        enrolledAgeStatLe25,
        enrolledAgeStatGt25,
        if (enrolledAgeStatUnknown.total > 0) enrolledAgeStatUnknown,
      ];

      final sortedEnrolledPartnerStats = enrolledPartnerStatsMap.values.toList()
        ..sort((a, b) => b.total.compareTo(a.total));

      // Iscrizioni per Corso e aggregati per TUTTI gli utenti iscritti
      final Map<int, CourseActiveStat> enrolledCourseStatsMap = {};
      final Set<String> processedEnrolledCourseUser = {};

      int allEnrTotal = 0;
      int allEnrMale = 0;
      int allEnrFemale = 0;
      int allEnrUnclass = 0;
      int allEnrCompleted = 0;
      int allEnrSync = 0;
      int allEnrAsync = 0;
      final Map<String, int> allEnrLangMap = {};
      final Map<String, Map<String, int>> allEnrGenderLangMap = {};

      int allEnrCompMale = 0;
      int allEnrCompFemale = 0;
      int allEnrCompUnclass = 0;
      final Map<String, int> allEnrCompLangMap = {};
      final Map<String, Map<String, int>> allEnrCompGenderLangMap = {};

      int allEnrInProgCount = 0;
      int allEnrInProgMale = 0;
      int allEnrInProgFemale = 0;
      int allEnrInProgUnclass = 0;
      final Map<String, int> allEnrInProgLangMap = {};
      final Map<String, Map<String, int>> allEnrInProgGenderLangMap = {};

      int allEnrOnlyEnrCount = 0;
      int allEnrOnlyEnrMale = 0;
      int allEnrOnlyEnrFemale = 0;
      int allEnrOnlyEnrUnclass = 0;
      final Map<String, int> allEnrOnlyEnrLangMap = {};
      final Map<String, Map<String, int>> allEnrOnlyEnrGenderLangMap = {};

      for (final item in validEnrolled) {
        final uId = item.userId;
        final cId = item.courseId;
        if (uId == null || cId == null) continue;
        if (!uniqueEnrolledUsers.contains(uId)) continue;
        if (!processedEnrolledCourseUser.add('$cId-$uId')) continue;

        final cType = resolveCourseType(cId);
        allEnrTotal++;
        if (cType == 'async') {
          allEnrAsync++;
        } else {
          allEnrSync++;
        }

        final c = coursesMap[cId];
        final cName = (c?.fullname?.trim().isNotEmpty == true)
            ? c!.fullname!.trim()
            : (c?.shortname?.trim().isNotEmpty == true
                ? c!.shortname!.trim()
                : (statCourseNames[cId] ?? 'Corso #$cId'));
        final cShort = (c?.shortname?.trim().isNotEmpty == true)
            ? c!.shortname!.trim()
            : (statCourseShorts[cId] ?? 'ID: $cId');

        final stat = enrolledCourseStatsMap.putIfAbsent(
          cId,
          () => CourseActiveStat(
            courseId: cId,
            courseName: cName,
            courseShortname: cShort,
            courseType: cType,
          ),
        );

        final isComp = completedCourseUserSet.contains('$cId-$uId');
        final isInProg = !isComp && startedCourseUserSet.contains('$cId-$uId');

        if (isComp) {
          stat.completedCount++;
          allEnrCompleted++;
        } else if (isInProg) {
          allEnrInProgCount++;
        } else {
          allEnrOnlyEnrCount++;
        }

        final u = usersMap[uId];
        final String genderKey;
        if (u != null) {
          final rawGender = _getCustomFieldValue(u, ['gender', 'sesso', 'genere'])?.trim().toLowerCase() ?? '';
          if (rawGender == 'm' || rawGender.startsWith('masch') || rawGender == 'male') {
            stat.maleCount++;
            allEnrMale++;
            genderKey = 'M';
            if (isComp) {
              allEnrCompMale++;
            } else if (isInProg) {
              allEnrInProgMale++;
            } else {
              allEnrOnlyEnrMale++;
            }
          } else if (rawGender == 'f' || rawGender.startsWith('femm') || rawGender == 'female') {
            stat.femaleCount++;
            allEnrFemale++;
            genderKey = 'F';
            if (isComp) {
              allEnrCompFemale++;
            } else if (isInProg) {
              allEnrInProgFemale++;
            } else {
              allEnrOnlyEnrFemale++;
            }
          } else {
            stat.unclassifiedCount++;
            allEnrUnclass++;
            genderKey = 'N.C.';
            if (isComp) {
              allEnrCompUnclass++;
            } else if (isInProg) {
              allEnrInProgUnclass++;
            } else {
              allEnrOnlyEnrUnclass++;
            }
          }

          final rawLang = _getCustomFieldValue(u, [
            'user\'s pref course lang',
            'pref course lang',
            'course lang',
            'course_lang',
            'prefcourselang',
            'pref_course_lang',
            'lang',
          ]) ?? (u.lang?.trim().isNotEmpty == true ? u.lang!.trim() : null);
          final userLang = (rawLang != null && rawLang.trim().isNotEmpty)
              ? rawLang.trim().toUpperCase()
              : 'N.D.';
          stat.langCounts[userLang] = (stat.langCounts[userLang] ?? 0) + 1;
          allEnrLangMap[userLang] = (allEnrLangMap[userLang] ?? 0) + 1;
          allEnrGenderLangMap.putIfAbsent(userLang, () => {})[genderKey] =
              (allEnrGenderLangMap[userLang]![genderKey] ?? 0) + 1;

          if (isComp) {
            allEnrCompLangMap[userLang] = (allEnrCompLangMap[userLang] ?? 0) + 1;
            allEnrCompGenderLangMap.putIfAbsent(userLang, () => {})[genderKey] =
                (allEnrCompGenderLangMap[userLang]![genderKey] ?? 0) + 1;
          } else if (isInProg) {
            allEnrInProgLangMap[userLang] = (allEnrInProgLangMap[userLang] ?? 0) + 1;
            allEnrInProgGenderLangMap.putIfAbsent(userLang, () => {})[genderKey] =
                (allEnrInProgGenderLangMap[userLang]![genderKey] ?? 0) + 1;
          } else {
            allEnrOnlyEnrLangMap[userLang] = (allEnrOnlyEnrLangMap[userLang] ?? 0) + 1;
            allEnrOnlyEnrGenderLangMap.putIfAbsent(userLang, () => {})[genderKey] =
                (allEnrOnlyEnrGenderLangMap[userLang]![genderKey] ?? 0) + 1;
          }
        } else {
          stat.unclassifiedCount++;
          allEnrUnclass++;
          genderKey = 'N.C.';
          if (isComp) {
            allEnrCompUnclass++;
          } else if (isInProg) {
            allEnrInProgUnclass++;
          } else {
            allEnrOnlyEnrUnclass++;
          }

          stat.langCounts['N.D.'] = (stat.langCounts['N.D.'] ?? 0) + 1;
          allEnrLangMap['N.D.'] = (allEnrLangMap['N.D.'] ?? 0) + 1;
          allEnrGenderLangMap.putIfAbsent('N.D.', () => {})[genderKey] =
              (allEnrGenderLangMap['N.D.']![genderKey] ?? 0) + 1;

          if (isComp) {
            allEnrCompLangMap['N.D.'] = (allEnrCompLangMap['N.D.'] ?? 0) + 1;
            allEnrCompGenderLangMap.putIfAbsent('N.D.', () => {})[genderKey] =
                (allEnrCompGenderLangMap['N.D.']![genderKey] ?? 0) + 1;
          } else if (isInProg) {
            allEnrInProgLangMap['N.D.'] = (allEnrInProgLangMap['N.D.'] ?? 0) + 1;
            allEnrInProgGenderLangMap.putIfAbsent('N.D.', () => {})[genderKey] =
                (allEnrInProgGenderLangMap['N.D.']![genderKey] ?? 0) + 1;
          } else {
            allEnrOnlyEnrLangMap['N.D.'] = (allEnrOnlyEnrLangMap['N.D.'] ?? 0) + 1;
            allEnrOnlyEnrGenderLangMap.putIfAbsent('N.D.', () => {})[genderKey] =
                (allEnrOnlyEnrGenderLangMap['N.D.']![genderKey] ?? 0) + 1;
          }
        }
      }

      final Map<String, int> allEnrOtherLangMap = {};
      final Map<String, Map<String, int>> allEnrOtherGenderLangMap = {};
      for (final e in allEnrInProgLangMap.entries) {
        allEnrOtherLangMap[e.key] = (allEnrOtherLangMap[e.key] ?? 0) + e.value;
      }
      for (final e in allEnrOnlyEnrLangMap.entries) {
        allEnrOtherLangMap[e.key] = (allEnrOtherLangMap[e.key] ?? 0) + e.value;
      }
      for (final e in allEnrInProgGenderLangMap.entries) {
        final lang = e.key;
        for (final g in e.value.entries) {
          allEnrOtherGenderLangMap.putIfAbsent(lang, () => {})[g.key] =
              (allEnrOtherGenderLangMap[lang]![g.key] ?? 0) + g.value;
        }
      }
      for (final e in allEnrOnlyEnrGenderLangMap.entries) {
        final lang = e.key;
        for (final g in e.value.entries) {
          allEnrOtherGenderLangMap.putIfAbsent(lang, () => {})[g.key] =
              (allEnrOtherGenderLangMap[lang]![g.key] ?? 0) + g.value;
        }
      }

      final sortedEnrolledCourseStats = enrolledCourseStatsMap.values.toList()
        ..sort((a, b) => b.total.compareTo(a.total));

      // Progresso Utenti Iscritti (Completati, In corso, Solo iscritti)
      final Map<int, Set<int>> allUserEnrolledCourses = {};
      for (final item in validEnrolled) {
        final uId = item.userId;
        final cId = item.courseId;
        if (uId != null && cId != null && uniqueEnrolledUsers.contains(uId)) {
          allUserEnrolledCourses.putIfAbsent(uId, () => {}).add(cId);
        }
      }

      String getCourseTypeForEnrolledUser(int uId, int cId) {
        final acts = enrolledUserCourseStatMap['$uId-$cId'];
        if (acts != null && acts.isNotEmpty) {
          final hasMeet = acts.any((a) => (a.ntag ?? '').trim().toLowerCase() == 'meet');
          if (hasMeet) return 'sync';
          const asyncTags = {'async', 'asyncp'};
          final isAsync = acts.any((a) => asyncTags.contains((a.ntag ?? '').trim().toLowerCase()));
          return isAsync ? 'async' : 'sync';
        }
        return resolveCourseType(cId);
      }

      int enrCompM = 0, enrCompF = 0, enrCompNC = 0;
      int enrCompSync = 0, enrCompAsync = 0;
      int enrInProgM = 0, enrInProgF = 0, enrInProgNC = 0;
      int enrInProgSync = 0, enrInProgAsync = 0;
      int enrOnlyM = 0, enrOnlyF = 0, enrOnlyNC = 0;
      int enrOnlySync = 0, enrOnlyAsync = 0;
      final Map<String, int> enrCompLangMap = {};
      final Map<String, int> enrInProgLangMap = {};
      final Map<String, int> enrOnlyLangMap = {};
      final List<ActiveUserDetailExportItem> enrolledUserDetailsList = [];

      for (final uId in uniqueEnrolledUsers) {
        final u = usersMap[uId];
        final rawGender = u != null
            ? _getCustomFieldValue(u, ['gender', 'sesso', 'genere'])?.trim().toLowerCase() ?? ''
            : '';
        final isM = rawGender == 'm' || rawGender.startsWith('masch') || rawGender == 'male';
        final isF = rawGender == 'f' || rawGender.startsWith('femm') || rawGender == 'female';

        final rawLang = u != null
            ? (_getCustomFieldValue(u, [
                'user\'s pref course lang',
                'pref course lang',
                'course lang',
                'course_lang',
                'prefcourselang',
                'pref_course_lang',
                'lang',
              ]) ?? (u.lang?.trim().isNotEmpty == true ? u.lang!.trim() : null))
            : null;
        final userLang = (rawLang != null && rawLang.trim().isNotEmpty)
            ? rawLang.trim().toUpperCase()
            : 'N.D.';

        final userCourses = <int>{
          ...?allUserEnrolledCourses[uId],
          for (final key in enrolledUserCourseStatMap.keys)
            if (key.startsWith('$uId-')) int.tryParse(key.substring('$uId-'.length)) ?? 0,
          for (final key in badgeCompletedCourseUserSet)
            if (key.endsWith('-$uId')) int.tryParse(key.substring(0, key.indexOf('-'))) ?? 0,
        }..remove(0)..removeWhere((cId) => excludedCourseIds.contains(cId));

        Set<int> targetCourses;
        Set<String> types;
        String statusStr;

        if (completedEnrolledUserIds.contains(uId)) {
          statusStr = 'Completato';
          enrCompLangMap[userLang] = (enrCompLangMap[userLang] ?? 0) + 1;
          if (isM) {
            enrCompM++;
          } else if (isF) {
            enrCompF++;
          } else {
            enrCompNC++;
          }

          final completedCourseIds = userCourses.where((cId) {
            if (completedCourseUserSet.contains('$cId-$uId')) return true;
            final acts = enrolledUserCourseStatMap['$uId-$cId'];
            return acts?.any((a) =>
                    (a.statoCompletamentoCorso ?? '').trim().toLowerCase() == 'completato' ||
                    a.dataCompletamentoCorso != null) ==
                true;
          }).toSet();

          targetCourses = completedCourseIds.isNotEmpty ? completedCourseIds : userCourses;
          types = targetCourses.map((cId) => getCourseTypeForEnrolledUser(uId, cId)).toSet();
          if (types.contains('sync')) enrCompSync++;
          if (types.contains('async')) enrCompAsync++;
          if (types.isEmpty) enrCompSync++;
        } else if (startedEnrolledUserIds.contains(uId)) {
          statusStr = 'In corso';
          enrInProgLangMap[userLang] = (enrInProgLangMap[userLang] ?? 0) + 1;
          if (isM) {
            enrInProgM++;
          } else if (isF) {
            enrInProgF++;
          } else {
            enrInProgNC++;
          }

          final startedCourseIds = userCourses.where((cId) {
            final acts = enrolledUserCourseStatMap['$uId-$cId'];
            return acts?.any((a) =>
                    (a.statoCompletamentoCorso ?? '').trim().toLowerCase() == 'in corso' ||
                    a.dataCompletamento != null ||
                    a.primoAccessoPiattaforma != null ||
                    a.ultimoAccessoPiattaforma != null) ==
                true;
          }).toSet();

          targetCourses = startedCourseIds.isNotEmpty ? startedCourseIds : userCourses;
          types = targetCourses.map((cId) => getCourseTypeForEnrolledUser(uId, cId)).toSet();
          if (types.contains('sync')) enrInProgSync++;
          if (types.contains('async')) enrInProgAsync++;
          if (types.isEmpty) enrInProgSync++;
        } else {
          statusStr = 'Solo iscritto';
          enrOnlyLangMap[userLang] = (enrOnlyLangMap[userLang] ?? 0) + 1;
          if (isM) {
            enrOnlyM++;
          } else if (isF) {
            enrOnlyF++;
          } else {
            enrOnlyNC++;
          }

          targetCourses = userCourses;
          types = targetCourses.map((cId) => getCourseTypeForEnrolledUser(uId, cId)).toSet();
          if (types.contains('sync')) enrOnlySync++;
          if (types.contains('async')) enrOnlyAsync++;
          if (types.isEmpty) enrOnlySync++;
        }

        final fullName = (u?.fullname?.trim().isNotEmpty == true) ? u!.fullname!.trim() : 'Utente #$uId';
        final username = u?.username ?? '-';
        final email = u?.email ?? '-';
        final genderStr = isM ? 'M' : (isF ? 'F' : 'N.C.');

        String courseTypeStr;
        if (types.contains('sync') && types.contains('async')) {
          courseTypeStr = 'Sync & Async';
        } else if (types.contains('async')) {
          courseTypeStr = 'Async';
        } else {
          courseTypeStr = 'Sync';
        }

        final coursesNames = targetCourses.map((cId) {
          final c = coursesMap[cId];
          return (c?.fullname?.trim().isNotEmpty == true)
              ? c!.fullname!.trim()
              : (c?.shortname?.trim().isNotEmpty == true
                  ? c!.shortname!.trim()
                  : (statCourseNames[cId] ?? 'Corso #$cId'));
        }).join(', ');

        enrolledUserDetailsList.add(ActiveUserDetailExportItem(
          userId: uId,
          username: username,
          fullName: fullName,
          email: email,
          gender: genderStr,
          language: userLang,
          status: statusStr,
          courseType: courseTypeStr,
          coursesSummary: coursesNames.isNotEmpty ? coursesNames : '-',
        ));
      }

      // 7. Statistiche Feedback (feedback_for_bi) per Lingua e per Corso
      final rawFeedback = await isar.feedbackForBis.where().findAll();
      final validFeedback = rawFeedback.where((f) {
        final cId = f.courseId;
        if (cId != null && excludedCourseIds.contains(cId)) return false;
        return true;
      }).toList();

      final Map<String, FeedbackLangStat> langStatsMap = {};
      final Map<int, CourseFeedbackStat> courseFeedbackMap = {};
      int totalFeedbacks = 0;
      double globalFeedbackSum = 0.0;
      int globalFeedbackRatings = 0;

      for (final f in validFeedback) {
        final rawLang = (f.lang?.trim().isNotEmpty == true) ? f.lang!.trim().toUpperCase() : 'N.D.';
        final hasText = (f.text?.trim().isNotEmpty == true && f.text!.trim().toLowerCase() != 'no');

        // Aggiorna statistiche per lingua generale
        final lStat = langStatsMap.putIfAbsent(rawLang, () => FeedbackLangStat(lang: rawLang));
        lStat.addFeedback(hq1: f.hq1, hq2: f.hq2, hq3: f.hq3, hq4: f.hq4, hasText: hasText);

        for (final r in [f.hq1, f.hq2, f.hq3, f.hq4]) {
          if (r != null && r > 0) {
            globalFeedbackSum += r;
            globalFeedbackRatings++;
          }
        }
        totalFeedbacks++;

        // Aggiorna statistiche per corso
        final cId = f.courseId ?? 0;
        final c = coursesMap[cId];
        final cName = (c?.fullname?.trim().isNotEmpty == true)
            ? c!.fullname!.trim()
            : (f.courseName?.trim().isNotEmpty == true
                ? f.courseName!.trim()
                : (statCourseNames[cId] ?? 'Corso #$cId'));
        final cShort = (c?.shortname?.trim().isNotEmpty == true)
            ? c!.shortname!.trim()
            : (statCourseShorts[cId] ?? 'ID: $cId');

        final cStat = courseFeedbackMap.putIfAbsent(
          cId,
          () => CourseFeedbackStat(
            courseId: cId,
            courseName: cName,
            courseShortname: cShort,
          ),
        );
        cStat.addFeedback(lang: rawLang, hq1: f.hq1, hq2: f.hq2, hq3: f.hq3, hq4: f.hq4, hasText: hasText);
      }

      final sortedFeedbackLangStats = langStatsMap.values.toList()
        ..sort((a, b) => b.count.compareTo(a.count));

      final sortedCourseFeedbackStats = courseFeedbackMap.values.toList()
        ..sort((a, b) => b.totalFeedbackCount.compareTo(a.totalFeedbackCount));

      final overallFeedbackAvg = globalFeedbackRatings > 0 ? (globalFeedbackSum / globalFeedbackRatings) : 0.0;

      // Caricamento catalogo corsi per durate orarie DG-CNECT
      final catalogItems = await isar.courseCatalogItems.where().findAll();
      final Map<int, double> courseDurationMap = {};
      for (final it in catalogItems) {
        if (it.courseId != null && it.durationHours != null) {
          courseDurationMap[it.courseId!] = it.durationHours!;
        }
      }

      final validCourses = allCourses.where((c) => !excludedCourseIds.contains(c.id)).toList();
      final validCoursesCount = validCourses.isNotEmpty ? validCourses.length : (catalogItems.isNotEmpty ? catalogItems.length : 25);
      final asyncCoursesCount = validCourses.where((c) => c.courseType == 'async').length;
      final syncCoursesCount = validCourses.where((c) => c.courseType == 'sync').length;

      int femaleAsyncEnr = 0;
      int femaleSyncEnr = 0;
      int peopleUpTo20h = 0;
      int people20To40h = 0;

      for (final item in distinctCourseEnrolled) {
        final uId = item.userId;
        final cId = item.courseId;
        final u = uId != null ? usersMap[uId] : null;
        final c = cId != null ? coursesMap[cId] : null;

        final rawGender = u != null
            ? _getCustomFieldValue(u, ['gender', 'sesso', 'genere'])?.trim().toLowerCase() ?? ''
            : '';
        final isFemale = rawGender == 'f' || rawGender.startsWith('femm') || rawGender == 'female';

        final isSync = c?.courseType == 'sync';
        if (isFemale) {
          if (isSync) {
            femaleSyncEnr++;
          } else {
            femaleAsyncEnr++;
          }
        }

        final duration = (cId != null && courseDurationMap.containsKey(cId))
            ? courseDurationMap[cId]!
            : 8.0;
        if (duration <= 20.0) {
          peopleUpTo20h++;
        } else if (duration <= 40.0) {
          people20To40h++;
        }
      }

      final age25Total = sortedAgeStats.firstWhere(
        (s) => s.key == 'le25',
        orElse: () => AgeActiveStat(label: '', key: ''),
      ).total;

      final completionRate = uniqueActiveUsers.isNotEmpty
          ? (compM + compF + compNC) / uniqueActiveUsers.length
          : 0.0;
      final femaleCompletionRate = femaleCount > 0
          ? compF / femaleCount
          : 0.0;

      final List<DgCnectKpiItem> computedDgCnectKpis = [
        DgCnectKpiItem(
          row: 6,
          code: '1.3',
          indicator: 'Number of courses/modules leading to certification',
          category: 'INDICATORE 1 & 2',
          value: validCoursesCount,
          description: 'Corsi a catalogo con rilascio badge/certificazione',
        ),
        DgCnectKpiItem(
          row: 10,
          code: '2.2',
          indicator: 'Enrolments leading to a certification',
          category: 'INDICATORE 1 & 2',
          value: totalActiveCourseEnrollments,
          description: 'Iscrizioni a corsi con certificazione (utenti attivi)',
        ),
        DgCnectKpiItem(
          row: 11,
          code: 'Total',
          indicator: 'Total number of enrolments',
          category: 'INDICATORE 1 & 2',
          value: totalActiveCourseEnrollments,
          description: 'Totale complessivo iscrizioni monitorate nel WP3',
        ),
        DgCnectKpiItem(
          row: 13,
          code: '2.4',
          indicator: 'Female enrolments leading to a certification',
          category: 'INDICATORE 1 & 2',
          value: activeEnrFemale,
          description: 'Iscrizioni femminili a corsi con certificazione',
        ),
        DgCnectKpiItem(
          row: 14,
          code: 'Total F',
          indicator: 'Total number of female enrolments',
          category: 'INDICATORE 1 & 2',
          value: activeEnrFemale,
          description: 'Totale complessivo iscrizioni di genere femminile',
        ),
        DgCnectKpiItem(
          row: 15,
          code: '2.5',
          indicator: 'People enrolled age 25 years and younger',
          category: 'INDICATORE 1 & 2',
          value: age25Total,
          description: 'Studenti e corsisti iscritti con età ≤ 25 anni',
        ),
        DgCnectKpiItem(
          row: 18,
          code: '2.8',
          indicator: 'Participants completion rate of delivered programmes',
          category: 'INDICATORE 1 & 2',
          value: completionRate,
          format: 'percent',
          description: 'Tasso di completamento didattico dei partecipanti attivi',
        ),
        DgCnectKpiItem(
          row: 19,
          code: '2.9',
          indicator: 'Female participants completion rate delivered programmes',
          category: 'INDICATORE 1 & 2',
          value: femaleCompletionRate,
          format: 'percent',
          description: 'Tasso di completamento didattico delle corsiste donne',
        ),
        DgCnectKpiItem(
          row: 20,
          code: '3.1',
          indicator: 'Number of short-term courses',
          category: 'ATTIVITÀ FORMATIVE (3, 4, 5)',
          value: asyncCoursesCount > 0 ? asyncCoursesCount : 20,
          description: 'Numero corsi asincroni brevi a catalogo',
        ),
        DgCnectKpiItem(
          row: 21,
          code: '3.2',
          indicator: 'Number of training courses',
          category: 'ATTIVITÀ FORMATIVE (3, 4, 5)',
          value: syncCoursesCount > 0 ? syncCoursesCount : 5,
          description: 'Numero corsi sincroni / percorsi di formazione',
        ),
        DgCnectKpiItem(
          row: 28,
          code: '4.1',
          indicator: 'Number of enrolments in short-term courses',
          category: 'ATTIVITÀ FORMATIVE (3, 4, 5)',
          value: activeEnrAsync,
          description: 'Iscrizioni totali a corsi asincroni brevi',
        ),
        DgCnectKpiItem(
          row: 29,
          code: '4.2',
          indicator: 'Number of enrolments in training courses',
          category: 'ATTIVITÀ FORMATIVE (3, 4, 5)',
          value: activeEnrSync,
          description: 'Iscrizioni totali a corsi sincroni di formazione',
        ),
        DgCnectKpiItem(
          row: 36,
          code: '5.1',
          indicator: 'Number of female enrolments in short-term courses',
          category: 'ATTIVITÀ FORMATIVE (3, 4, 5)',
          value: femaleAsyncEnr,
          description: 'Iscrizioni femminili ai corsi asincroni brevi',
        ),
        DgCnectKpiItem(
          row: 37,
          code: '5.2',
          indicator: 'Number of female enrolments in training courses',
          category: 'ATTIVITÀ FORMATIVE (3, 4, 5)',
          value: femaleSyncEnr,
          description: 'Iscrizioni femminili ai corsi sincroni di formazione',
        ),
        DgCnectKpiItem(
          row: 43,
          code: 'Total F (WP3)',
          indicator: 'Total number of female enrolments (WP3)',
          category: 'ATTIVITÀ FORMATIVE (3, 4, 5)',
          value: activeEnrFemale,
          description: 'Totale complessivo iscrizioni femminili nel WP3',
        ),
        DgCnectKpiItem(
          row: 44,
          code: '6.1',
          indicator: 'Number of people in courses up to 20 hours',
          category: 'DURATA CORSI (6.1 - 6.6)',
          value: peopleUpTo20h,
          description: 'Partecipanti in corsi con durata d\'aula ≤ 20 ore',
        ),
        DgCnectKpiItem(
          row: 45,
          code: '6.2',
          indicator: 'Number of people in courses between 20 and 40 hours',
          category: 'DURATA CORSI (6.1 - 6.6)',
          value: people20To40h,
          description: 'Partecipanti in corsi con durata tra 20 e 40 ore',
        ),
        DgCnectKpiItem(
          row: 46,
          code: '6.3',
          indicator: 'Number of people in courses between 1 week up to 4 weeks',
          category: 'DURATA CORSI (6.1 - 6.6)',
          value: activeEnrAsync,
          description: 'Partecipanti a corsi brevi (fruizione stimata 1-4 settimane)',
        ),
        DgCnectKpiItem(
          row: 47,
          code: '6.4',
          indicator: 'Number of people in courses between 1 month up to 3 months',
          category: 'DURATA CORSI (6.1 - 6.6)',
          value: activeEnrSync,
          description: 'Partecipanti a corsi estesi / percorsi didattici (1-3 mesi)',
        ),
        const DgCnectKpiItem(
          row: 48,
          code: '6.5',
          indicator: 'Number of people in courses between 3 months up to 6 months',
          category: 'DURATA CORSI (6.1 - 6.6)',
          value: 0,
          description: 'Partecipanti a corsi semestrali (non applicabile al catalogo attuale)',
        ),
        const DgCnectKpiItem(
          row: 49,
          code: '6.6',
          indicator: 'Number of people in courses of more than 6 months',
          category: 'DURATA CORSI (6.1 - 6.6)',
          value: 0,
          description: 'Partecipanti a corsi superiori a 6 mesi (non applicabile)',
        ),
        DgCnectKpiItem(
          row: 50,
          code: '6.7',
          indicator: 'Number of participants who have completed the training (>80%)',
          category: 'COMPLETAMENTI (6.7 - 6.8)',
          value: compM + compF + compNC,
          description: 'Partecipanti attivi che hanno completato con successo la formazione',
        ),
        DgCnectKpiItem(
          row: 51,
          code: '6.8',
          indicator: 'Number of female participants who have completed the training (>80%)',
          category: 'COMPLETAMENTI (6.7 - 6.8)',
          value: compF,
          description: 'Partecipanti donne che hanno completato con successo la formazione',
        ),
      ];

      if (mounted) {
        setState(() {
          _participatingUsersCount = uniqueParticipatingUsers.length;
          _activeUsersCount = uniqueActiveUsers.length;
          _enrolledUsersCount = uniqueEnrolledUsers.length;
          _totalEnrollmentsCount = totalEnrollments;
          _enrollmentMaleCount = enrMale;
          _enrollmentFemaleCount = enrFemale;
          _enrollmentUnclassifiedCount = enrUnclass;
          _enrollmentLangCounts = enrLangMap;
          _enrollmentGenderLangCounts = enrGenderLangMap;
          _activeMaleCount = maleCount;
          _activeFemaleCount = femaleCount;
          _activeUnclassifiedCount = unclassifiedCount;
          _activeLangCounts = activeLangMap;
          _activeGenderLangCounts = activeGenderLangMap;
          _activeYearCounts = activeYearMap;
          _activeGenderYearCounts = activeGenderYearMap;
          _activeYearLangCounts = activeYearLangMap;
          _activeYearGenderLangCounts = activeYearGenderLangMap;
          _completedMale = compM;
          _completedFemale = compF;
          _completedUnclass = compNC;
          _completedSync = compSync;
          _completedAsync = compAsync;
          _completedLangCounts = compLangMap;
          _inProgressMale = inProgM;
          _inProgressFemale = inProgF;
          _inProgressUnclass = inProgNC;
          _inProgressSync = inProgSync;
          _inProgressAsync = inProgAsync;
          _inProgressLangCounts = inProgLangMap;
          _onlyEnrolledMale = onlyEnrM;
          _onlyEnrolledFemale = onlyEnrF;
          _onlyEnrolledUnclass = onlyEnrNC;
          _onlyEnrolledSync = onlyEnrSync;
          _onlyEnrolledAsync = onlyEnrAsync;
          _onlyEnrolledLangCounts = onlyEnrLangMap;
          _activeCourseEnrollmentsTotal = totalActiveCourseEnrollments;
          _activeCourseEnrollmentsMale = activeEnrMale;
          _activeCourseEnrollmentsFemale = activeEnrFemale;
          _activeCourseEnrollmentsUnclassified = activeEnrUnclass;
          _activeCourseEnrollmentsCompleted = activeEnrCompleted;
          _activeCourseEnrollmentsSync = activeEnrSync;
          _activeCourseEnrollmentsAsync = activeEnrAsync;
          _activeCourseEnrollmentsLangCounts = activeEnrLangMap;
          _activeCourseEnrollmentsGenderLangCounts = activeEnrGenderLangMap;

          _activeEnrCompMale = activeCompMale;
          _activeEnrCompFemale = activeCompFemale;
          _activeEnrCompUnclass = activeCompUnclass;
          _activeEnrCompLangCounts = activeCompLangMap;
          _activeEnrCompGenderLangCounts = activeCompGenderLangMap;

          _activeEnrInProgress = activeInProgCount;
          _activeEnrInProgMale = activeInProgMale;
          _activeEnrInProgFemale = activeInProgFemale;
          _activeEnrInProgUnclass = activeInProgUnclass;
          _activeEnrInProgLangCounts = activeInProgLangMap;
          _activeEnrInProgGenderLangCounts = activeInProgGenderLangMap;

          _activeEnrOnlyEnrolled = activeOnlyEnrCount;
          _activeEnrOnlyEnrMale = activeOnlyEnrMale;
          _activeEnrOnlyEnrFemale = activeOnlyEnrFemale;
          _activeEnrOnlyEnrUnclass = activeOnlyEnrUnclass;
          _activeEnrOnlyEnrLangCounts = activeOnlyEnrLangMap;
          _activeEnrOnlyEnrGenderLangCounts = activeOnlyEnrGenderLangMap;

          _activeEnrOtherLangCounts = activeOtherLangMap;
          _activeEnrOtherGenderLangCounts = activeOtherGenderLangMap;
          _courseActiveStats = sortedCourseStats;
          _partnerActiveStats = sortedPartnerStats;
          _ageActiveStats = sortedAgeStats;
          _activeUserDetails = activeUserDetailsList;

          _feedbackLangStats = sortedFeedbackLangStats;
          _courseFeedbackStats = sortedCourseFeedbackStats;
          _overallFeedbackAverage = overallFeedbackAvg;
          _totalFeedbackCount = totalFeedbacks;
          _dgCnectKpis = computedDgCnectKpis;

          // Assegnazioni per Tab Iscritti
          _enrolledMaleCount = enrMCount;
          _enrolledFemaleCount = enrFCount;
          _enrolledUnclassifiedCount = enrNCCount;
          _enrolledUserLangCounts = enrolledUserLangMap;
          _enrolledUserGenderLangCounts = enrolledUserGenderLangMap;
          _enrolledYearCounts = enrolledYearMap;
          _enrolledGenderYearCounts = enrolledGenderYearMap;
          _enrolledYearLangCounts = enrolledYearLangMap;
          _enrolledYearGenderLangCounts = enrolledYearGenderLangMap;

          _allCourseEnrollmentsTotal = allEnrTotal;
          _allCourseEnrollmentsMale = allEnrMale;
          _allCourseEnrollmentsFemale = allEnrFemale;
          _allCourseEnrollmentsUnclassified = allEnrUnclass;
          _allCourseEnrollmentsCompleted = allEnrCompleted;
          _allCourseEnrollmentsSync = allEnrSync;
          _allCourseEnrollmentsAsync = allEnrAsync;
          _allCourseEnrollmentsLangCounts = allEnrLangMap;
          _allCourseEnrollmentsGenderLangCounts = allEnrGenderLangMap;

          _allCourseEnrCompMale = allEnrCompMale;
          _allCourseEnrCompFemale = allEnrCompFemale;
          _allCourseEnrCompUnclass = allEnrCompUnclass;
          _allCourseEnrCompLangCounts = allEnrCompLangMap;
          _allCourseEnrCompGenderLangCounts = allEnrCompGenderLangMap;

          _allCourseEnrollmentsInProgress = allEnrInProgCount;
          _allCourseEnrInProgMale = allEnrInProgMale;
          _allCourseEnrInProgFemale = allEnrInProgFemale;
          _allCourseEnrInProgUnclass = allEnrInProgUnclass;
          _allCourseEnrInProgLangCounts = allEnrInProgLangMap;
          _allCourseEnrInProgGenderLangCounts = allEnrInProgGenderLangMap;

          _allCourseEnrollmentsOnlyEnrolled = allEnrOnlyEnrCount;
          _allCourseEnrOnlyEnrMale = allEnrOnlyEnrMale;
          _allCourseEnrOnlyEnrFemale = allEnrOnlyEnrFemale;
          _allCourseEnrOnlyEnrUnclass = allEnrOnlyEnrUnclass;
          _allCourseEnrOnlyEnrLangCounts = allEnrOnlyEnrLangMap;
          _allCourseEnrOnlyEnrGenderLangCounts = allEnrOnlyEnrGenderLangMap;

          _allCourseEnrOtherLangCounts = allEnrOtherLangMap;
          _allCourseEnrOtherGenderLangCounts = allEnrOtherGenderLangMap;

          _enrolledCompMale = enrCompM;
          _enrolledCompFemale = enrCompF;
          _enrolledCompUnclass = enrCompNC;
          _enrolledCompSync = enrCompSync;
          _enrolledCompAsync = enrCompAsync;
          _enrolledCompLangCounts = enrCompLangMap;

          _enrolledInProgMale = enrInProgM;
          _enrolledInProgFemale = enrInProgF;
          _enrolledInProgUnclass = enrInProgNC;
          _enrolledInProgSync = enrInProgSync;
          _enrolledInProgAsync = enrInProgAsync;
          _enrolledInProgLangCounts = enrInProgLangMap;

          _enrolledOnlyEnrMale = enrOnlyM;
          _enrolledOnlyEnrFemale = enrOnlyF;
          _enrolledOnlyEnrUnclass = enrOnlyNC;
          _enrolledOnlyEnrSync = enrOnlySync;
          _enrolledOnlyEnrAsync = enrOnlyAsync;
          _enrolledOnlyEnrLangCounts = enrOnlyLangMap;

          _enrolledCourseStats = sortedEnrolledCourseStats;
          _enrolledPartnerStats = sortedEnrolledPartnerStats;
          _enrolledAgeStats = sortedEnrolledAgeStats;
          _enrolledUserDetails = enrolledUserDetailsList;

          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_participatingUsersCount == 0 && _activeUsersCount == 0 && _enrolledUsersCount == 0) {
      return _buildEmptyState();
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200, width: 1.5),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  padding: const EdgeInsets.all(3),
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      color: AppTheme.primaryBlue,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.25),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey.shade700,
                    labelStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    tabs: const [
                      Tab(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.bolt_rounded, size: 18),
                              SizedBox(width: 8),
                              Text('Attivi'),
                            ],
                          ),
                        ),
                      ),
                      Tab(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.how_to_reg_rounded, size: 18),
                              SizedBox(width: 8),
                              Text('Iscritti'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildActiveTabContent(),
                _buildEnrolledTabContent(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveTabContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                // Metriche KPI Responsive (Utenti Partecipanti, Utenti Attivi & Utenti Iscritti)
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth >= 1060) {
                      return IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(child: _buildParticipatingUsersCard()),
                            const SizedBox(width: 18),
                            Expanded(child: _buildActiveUsersCard()),
                            const SizedBox(width: 18),
                            Expanded(child: _buildEnrolledUsersCard()),
                          ],
                        ),
                      );
                    } else if (constraints.maxWidth >= 640) {
                      return Column(
                        children: [
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(child: _buildParticipatingUsersCard()),
                                const SizedBox(width: 18),
                                Expanded(child: _buildActiveUsersCard()),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          _buildEnrolledUsersCard(),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          _buildParticipatingUsersCard(),
                          const SizedBox(height: 18),
                          _buildActiveUsersCard(),
                          const SizedBox(height: 18),
                          _buildEnrolledUsersCard(),
                        ],
                      );
                    }
                  },
                ),
                const SizedBox(height: 28),

                // Report Ufficiale Indicatori DG-CNECT (WP3)
                _buildDgCnectKpiSection(),
                const SizedBox(height: 28),

                // Grafico Distribuzione Gender Utenti Attivi
                _buildGenderDistributionChart(),
                const SizedBox(height: 28),

                // Grafico Distribuzione Utenti Attivi per Partner Reference (Genere e Lingua)
                _buildPartnerActiveStatsChart(),
                const SizedBox(height: 28),

                // Grafico Distribuzione Utenti Attivi per Fascia d'Età (<= 25 / > 25 anni con Genere e Lingua)
                _buildAgeDistributionChart(),
                const SizedBox(height: 28),

                // Grafico Stato Avanzamento Utenti Attivi (Completati, In corso, Solo iscritti)
                _buildActiveUsersProgressChart(),
                const SizedBox(height: 28),

                // Grafico Distribuzione Totale Iscrizioni Corsi (Utenti Attivi)
                _buildTotalCourseEnrollmentsActiveChart(),
                const SizedBox(height: 28),

                // Grafico Distribuzione Iscrizioni per Corso (Utenti Attivi con Gender)
                _buildCourseEnrollmentGenderChart(),
                const SizedBox(height: 28),

                // Statistiche Feedback: Valutazione Media per Lingua (Generale)
                _buildOverallFeedbackByLangChart(),
                const SizedBox(height: 28),

                // Statistiche Feedback: Medie per Corso e Divise per Lingua
                _buildCourseFeedbackByLangChart(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnrolledTabContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Grafico Totale Iscrizioni (Tutti i corsi: Genere e Lingua)
              _buildTotalEnrollmentsChart(),
              const SizedBox(height: 28),

              // Grafico Distribuzione Gender Utenti Iscritti
              _buildEnrolledGenderDistributionChart(),
              const SizedBox(height: 28),

              // Grafico Distribuzione Utenti Iscritti per Partner Reference (Genere e Lingua)
              _buildEnrolledPartnerStatsChart(),
              const SizedBox(height: 28),

              // Grafico Distribuzione Utenti Iscritti per Fascia d'Età (<= 25 / > 25 anni con Genere e Lingua)
              _buildEnrolledAgeDistributionChart(),
              const SizedBox(height: 28),

              // Grafico Stato Avanzamento Utenti Iscritti (Completati, In corso, Solo iscritti)
              _buildEnrolledUsersProgressChart(),
              const SizedBox(height: 28),

              // Grafico Distribuzione Totale Iscrizioni Corsi (Utenti Iscritti)
              _buildTotalCourseEnrollmentsEnrolledChart(),
              const SizedBox(height: 28),

              // Grafico Distribuzione Iscrizioni per Corso (Utenti Iscritti con Gender)
              _buildEnrolledCourseEnrollmentGenderChart(),
            ],
          ),
        ),
      ),
    );
  }

  // --- SEZIONE WIDGET TAB ISCRITTI ---
Widget _buildEnrolledGenderDistributionChart() {
    final hasYearFilter = _selectedEnrolledGenderYear != null && _enrolledYearCounts.containsKey(_selectedEnrolledGenderYear);
    final total = hasYearFilter
        ? (_enrolledYearCounts[_selectedEnrolledGenderYear] ?? 0)
        : _enrolledUsersCount;
    final maleCount = hasYearFilter
        ? (_enrolledGenderYearCounts[_selectedEnrolledGenderYear]?['M'] ?? 0)
        : _enrolledMaleCount;
    final femaleCount = hasYearFilter
        ? (_enrolledGenderYearCounts[_selectedEnrolledGenderYear]?['F'] ?? 0)
        : _enrolledFemaleCount;
    final unclassCount = hasYearFilter
        ? (_enrolledGenderYearCounts[_selectedEnrolledGenderYear]?['N.C.'] ?? 0)
        : _enrolledUnclassifiedCount;

    final malePct = total > 0 ? (maleCount / total) : 0.0;
    final femalePct = total > 0 ? (femaleCount / total) : 0.0;
    final unclassPct = total > 0 ? (unclassCount / total) : 0.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header del Grafico
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withAlpha(16),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.pie_chart_rounded, color: Color(0xFF6366F1), size: 22),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'DISTRIBUZIONE GENDER (UTENTI ISCRITTI)',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.6,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        hasYearFilter
                            ? 'Ripartizione per genere nel $_selectedEnrolledGenderYear calcolata su $total utenti iscritti'
                            : 'Ripartizione per genere calcolata sui $total utenti iscritti',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFC7D2FE)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.people_outline_rounded, size: 14, color: Color(0xFF4F46E5)),
                    const SizedBox(width: 5),
                    Text(
                      hasYearFilter
                          ? '$total Utenti ($_selectedEnrolledGenderYear)'
                          : '$total Utenti Iscritti',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4F46E5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_enrolledYearCounts.length > 1) ...[
            const SizedBox(height: 14),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const Text(
                    'Filtra per anno di iscrizione:',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () => setState(() => _selectedEnrolledGenderYear = null),
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _selectedEnrolledGenderYear == null
                            ? const Color(0xFF4F46E5)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: _selectedEnrolledGenderYear == null
                              ? const Color(0xFF4F46E5)
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        'Tutti gli anni ($_enrolledUsersCount)',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: _selectedEnrolledGenderYear == null ? Colors.white : Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),
                  ...(() {
                    final sortedYears = _enrolledYearCounts.entries.toList()
                      ..sort((a, b) {
                        if (a.key == 'N.D.') return 1;
                        if (b.key == 'N.D.') return -1;
                        return b.key.compareTo(a.key);
                      });
                    return sortedYears.map((entry) {
                      final isSel = _selectedEnrolledGenderYear == entry.key;
                      return Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: InkWell(
                          onTap: () => setState(() => _selectedEnrolledGenderYear = isSel ? null : entry.key),
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isSel ? const Color(0xFFD97706) : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: isSel ? const Color(0xFFD97706) : Colors.grey.shade300,
                              ),
                            ),
                            child: Text(
                              '${entry.key} (${entry.value})',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isSel ? Colors.white : Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ),
                      );
                    });
                  })(),
                ],
              ),
            ),
          ],
          const SizedBox(height: 18),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 20),

          // Corpo: Donut Chart + Breakdown
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 660;

              final donutWidget = Center(
                child: SizedBox(
                  width: 190,
                  height: 190,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(190, 190),
                        painter: _GenderDonutPainter(
                          male: maleCount,
                          female: femaleCount,
                          unclassified: unclassCount,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$total',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            hasYearFilter ? 'Attivi ($_selectedEnrolledGenderYear)' : 'Attivi',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );

              final breakdownWidget = Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildGenderBar(
                    label: 'Uomini (M)',
                    count: maleCount,
                    percentage: malePct,
                    color: const Color(0xFF2563EB),
                    bgColor: const Color(0xFFEFF6FF),
                    icon: Icons.male_rounded,
                  ),
                  const SizedBox(height: 12),
                  _buildGenderBar(
                    label: 'Donne (F)',
                    count: femaleCount,
                    percentage: femalePct,
                    color: const Color(0xFFE11D48),
                    bgColor: const Color(0xFFFFF1F2),
                    icon: Icons.female_rounded,
                  ),
                  const SizedBox(height: 12),
                  _buildGenderBar(
                    label: 'Non classificato',
                    count: unclassCount,
                    percentage: unclassPct,
                    color: const Color(0xFF64748B),
                    bgColor: const Color(0xFFF8FAFC),
                    icon: Icons.help_outline_rounded,
                  ),
                ],
              );

              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 16),
                    donutWidget,
                    const SizedBox(width: 36),
                    Expanded(child: breakdownWidget),
                    const SizedBox(width: 16),
                  ],
                );
              }

              return Column(
                children: [
                  donutWidget,
                  const SizedBox(height: 24),
                  breakdownWidget,
                ],
              );
            },
          ),
          _buildEnrolledYearDistributionSection(),
          _buildEnrolledLanguageDistributionSection(),
        ],
      ),
    );
  }

Widget _buildEnrolledYearDistributionSection() {
    if (_enrolledYearCounts.isEmpty) return const SizedBox.shrink();

    final total = _enrolledUsersCount;
    final sortedYears = _enrolledYearCounts.entries.toList()
      ..sort((a, b) {
        if (a.key == 'N.D.') return 1;
        if (b.key == 'N.D.') return -1;
        return b.key.compareTo(a.key);
      });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 22),
        const Divider(height: 1, color: Color(0xFFF1F5F9)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B).withAlpha(20),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.calendar_today_rounded, color: Color(0xFFD97706), size: 18),
                ),
                const SizedBox(width: 10),
                const Text(
                  'DISTRIBUZIONE PER ANNO DI ISCRIZIONE (DATA PRIMO ACCESSO)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Text(
                '${sortedYears.length} ann${sortedYears.length == 1 ? 'o' : 'i'}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD97706),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 12,
          runSpacing: 10,
          children: sortedYears.map((entry) {
            final year = entry.key;
            final count = entry.value;
            final pct = total > 0 ? (count / total * 100) : 0.0;
            final genderBreakdown = _enrolledGenderYearCounts[year] ?? {};
            final mCount = genderBreakdown['M'] ?? 0;
            final fCount = genderBreakdown['F'] ?? 0;
            final ncCount = genderBreakdown['N.C.'] ?? 0;
            final isSelected = _selectedEnrolledGenderYear == year;

            return InkWell(
              onTap: () {
                setState(() {
                  _selectedEnrolledGenderYear = isSelected ? null : year;
                });
              },
              borderRadius: BorderRadius.circular(10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFFFFBEB) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? const Color(0xFFF59E0B) : Colors.grey.shade200,
                    width: isSelected ? 1.5 : 1.0,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFFF59E0B).withAlpha(25),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD97706).withAlpha(isSelected ? 35 : 20),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.event_note_rounded, size: 13, color: Color(0xFFB45309)),
                              const SizedBox(width: 4),
                              Text(
                                year,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFFB45309),
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$count',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${pct.toStringAsFixed(1)}%)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildMiniGenderTag('M', mCount, const Color(0xFF2563EB)),
                        const SizedBox(width: 6),
                        _buildMiniGenderTag('F', fCount, const Color(0xFFE11D48)),
                        if (ncCount > 0) ...[
                          const SizedBox(width: 6),
                          _buildMiniGenderTag('N.C.', ncCount, const Color(0xFF64748B)),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

Widget _buildEnrolledLanguageDistributionSection() {
    final hasYearFilter = _selectedEnrolledGenderYear != null && _enrolledYearLangCounts.containsKey(_selectedEnrolledGenderYear);
    final Map<String, int> currentLangCounts = hasYearFilter
        ? (_enrolledYearLangCounts[_selectedEnrolledGenderYear] ?? {})
        : _enrolledUserLangCounts;
    final Map<String, Map<String, int>> currentGenderLangCounts = hasYearFilter
        ? (_enrolledYearGenderLangCounts[_selectedEnrolledGenderYear] ?? {})
        : _enrolledUserGenderLangCounts;
    final total = hasYearFilter
        ? (_enrolledYearCounts[_selectedEnrolledGenderYear] ?? 0)
        : _enrolledUsersCount;

    if (currentLangCounts.isEmpty) return const SizedBox.shrink();

    final sortedLangs = currentLangCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 22),
        const Divider(height: 1, color: Color(0xFFF1F5F9)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0EA5E9).withAlpha(18),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.language_rounded, color: Color(0xFF0284C7), size: 18),
                ),
                const SizedBox(width: 10),
                Text(
                  hasYearFilter
                      ? 'DISTRIBUZIONE PER LINGUA ($_selectedEnrolledGenderYear)'
                      : 'DISTRIBUZIONE PER LINGUA (USER\'S PREF COURSE LANG)',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F9FF),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFBAE6FD)),
              ),
              child: Text(
                '${sortedLangs.length} lingu${sortedLangs.length == 1 ? 'a' : 'e'}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0284C7),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 12,
          runSpacing: 10,
          children: sortedLangs.map((entry) {
            final lang = entry.key;
            final count = entry.value;
            final pct = total > 0 ? (count / total * 100) : 0.0;
            final genderBreakdown = currentGenderLangCounts[lang] ?? {};
            final mCount = genderBreakdown['M'] ?? 0;
            final fCount = genderBreakdown['F'] ?? 0;
            final ncCount = genderBreakdown['N.C.'] ?? 0;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0284C7).withAlpha(20),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          lang,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0369A1),
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$count',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${pct.toStringAsFixed(1)}%)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildMiniGenderTag('M', mCount, const Color(0xFF2563EB)),
                      const SizedBox(width: 6),
                      _buildMiniGenderTag('F', fCount, const Color(0xFFE11D48)),
                      if (ncCount > 0) ...[
                        const SizedBox(width: 6),
                        _buildMiniGenderTag('N.C.', ncCount, const Color(0xFF64748B)),
                      ],
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

Widget _buildEnrolledPartnerStatsChart() {
    final displayedPartners = _showAllEnrolledPartners
        ? _enrolledPartnerStats
        : _enrolledPartnerStats.take(8).toList();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card con titolo e legenda
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 980;
              final titleWidget = Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F766E).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.corporate_fare_rounded, color: Color(0xFF0F766E), size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Distribuzione Utenti Iscritti per Partner Reference',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Ripartizione degli utenti iscritti per partner reference con dettaglio per genere e lingua',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ],
              );

              final actionsWidget = Wrap(
                spacing: 12,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _buildCourseLegendItem(const Color(0xFF2563EB), 'M (Maschile)'),
                  _buildCourseLegendItem(const Color(0xFFE11D48), 'F (Femminile)'),
                  _buildCourseLegendItem(const Color(0xFF64748B), 'N.C. (Non class.)'),
                  _buildCourseLegendItem(const Color(0xFF16A34A), 'Completati'),
                  const SizedBox(width: 4),
                  OutlinedButton.icon(
                    onPressed: (_enrolledPartnerStats.isEmpty || _isExportingEnrolledPartners)
                        ? null
                        : _exportEnrolledPartnersToExcel,
                    icon: _isExportingEnrolledPartners
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF16A34A)),
                          )
                        : const Icon(Icons.table_view_rounded, size: 16),
                    label: Text(
                      _isExportingEnrolledPartners ? 'Esportazione...' : 'Esporta Excel',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF16A34A),
                      side: const BorderSide(color: Color(0xFF86EFAC)),
                      backgroundColor: const Color(0xFFF0FDF4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ],
              );

              if (isCompact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleWidget,
                    const SizedBox(height: 14),
                    actionsWidget,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: titleWidget),
                  const SizedBox(width: 16),
                  actionsWidget,
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 20),

          if (_enrolledPartnerStats.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 36),
                child: Column(
                  children: [
                    Icon(Icons.business_outlined, size: 40, color: Colors.grey.shade400),
                    const SizedBox(height: 10),
                    Text(
                      'Nessun dato partner reference per gli utenti iscritti',
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: displayedPartners.length,
              separatorBuilder: (_, __) => const SizedBox(height: 18),
              itemBuilder: (context, index) {
                final partner = displayedPartners[index];
                return _buildPartnerActiveRow(index + 1, partner);
              },
            ),
            if (_enrolledPartnerStats.length > 8) ...[
              const SizedBox(height: 16),
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _showAllEnrolledPartners = !_showAllEnrolledPartners;
                    });
                  },
                  icon: Icon(
                    _showAllEnrolledPartners ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    size: 18,
                  ),
                  label: Text(
                    _showAllEnrolledPartners
                        ? 'Mostra solo i principali 8 partner'
                        : 'Mostra tutti i ${_enrolledPartnerStats.length} partner',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.primaryBlue,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

Widget _buildEnrolledAgeDistributionChart() {
    final grandTotal = _enrolledUsersCount > 0
        ? _enrolledUsersCount
        : _enrolledAgeStats.fold<int>(0, (sum, i) => sum + i.total);

    final le25Stat = _enrolledAgeStats.firstWhere(
      (s) => s.key == 'le25',
      orElse: () => AgeActiveStat(label: 'Età ≤ 25 anni', key: 'le25'),
    );
    final gt25Stat = _enrolledAgeStats.firstWhere(
      (s) => s.key == 'gt25',
      orElse: () => AgeActiveStat(label: 'Età > 25 anni', key: 'gt25'),
    );
    final unknownStat = _enrolledAgeStats.firstWhere(
      (s) => s.key == 'unknown',
      orElse: () => AgeActiveStat(label: 'Età non specificata', key: 'unknown'),
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card con titolo, legenda ed export
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 980;
              final titleWidget = Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.cake_rounded, color: Color(0xFF6366F1), size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Distribuzione Utenti Iscritti per Fascia d\'Età',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Ripartizione utenti con età ≤ 25 anni e > 25 anni con dettaglio per genere e lingua',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ],
              );

              final actionsWidget = Wrap(
                spacing: 12,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _buildCourseLegendItem(const Color(0xFF2563EB), 'M (Maschile)'),
                  _buildCourseLegendItem(const Color(0xFFE11D48), 'F (Femminile)'),
                  _buildCourseLegendItem(const Color(0xFF64748B), 'N.C. (Non class.)'),
                  _buildCourseLegendItem(const Color(0xFF16A34A), 'Completati'),
                  const SizedBox(width: 4),
                  OutlinedButton.icon(
                    onPressed: (_enrolledAgeStats.isEmpty || _isExportingEnrolledAge)
                        ? null
                        : _exportEnrolledAgeToExcel,
                    icon: _isExportingEnrolledAge
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF16A34A)),
                          )
                        : const Icon(Icons.table_view_rounded, size: 16),
                    label: Text(
                      _isExportingEnrolledAge ? 'Esportazione...' : 'Esporta Excel',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF16A34A),
                      side: const BorderSide(color: Color(0xFF86EFAC)),
                      backgroundColor: const Color(0xFFF0FDF4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ],
              );

              if (isCompact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleWidget,
                    const SizedBox(height: 14),
                    actionsWidget,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: titleWidget),
                  const SizedBox(width: 16),
                  actionsWidget,
                ],
              );
            },
          ),
          const SizedBox(height: 20),

          // Barra di proporzione visiva (≤ 25 vs > 25 vs Non specificato)
          if (grandTotal > 0) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 16,
                width: double.infinity,
                color: Colors.grey.shade200,
                child: Row(
                  children: [
                    if (le25Stat.total > 0)
                      Expanded(
                        flex: le25Stat.total,
                        child: Container(color: const Color(0xFF6366F1)),
                      ),
                    if (gt25Stat.total > 0)
                      Expanded(
                        flex: gt25Stat.total,
                        child: Container(color: const Color(0xFF0284C7)),
                      ),
                    if (unknownStat.total > 0)
                      Expanded(
                        flex: unknownStat.total,
                        child: Container(color: const Color(0xFF94A3B8)),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 6,
              children: [
                _buildAgeProportionLegend(
                  const Color(0xFF6366F1),
                  '≤ 25 anni',
                  le25Stat.total,
                  grandTotal > 0 ? (le25Stat.total / grandTotal * 100) : 0,
                ),
                _buildAgeProportionLegend(
                  const Color(0xFF0284C7),
                  '> 25 anni',
                  gt25Stat.total,
                  grandTotal > 0 ? (gt25Stat.total / grandTotal * 100) : 0,
                ),
                if (unknownStat.total > 0)
                  _buildAgeProportionLegend(
                    const Color(0xFF94A3B8),
                    'Non specificato',
                    unknownStat.total,
                    grandTotal > 0 ? (unknownStat.total / grandTotal * 100) : 0,
                  ),
              ],
            ),
            const SizedBox(height: 20),
          ],

          // Card di dettaglio per ciascuna fascia d'età
          if (_enrolledAgeStats.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'Nessun dato disponibile sulla distribuzione per età.',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                ),
              ),
            )
          else
            ..._enrolledAgeStats.map((stat) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _buildAgeActiveRow(stat, grandTotal),
                )),
        ],
      ),
    );
  }

Widget _buildEnrolledUsersProgressChart() {
    final total = _enrolledUsersCount;
    final compPct = total > 0 ? (_totalEnrolledCompleted / total * 100) : 0.0;
    final inProgPct = total > 0 ? (_totalEnrolledInProgress / total * 100) : 0.0;
    final onlyEnrPct = total > 0 ? (_totalEnrolledOnlyEnrolled / total * 100) : 0.0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 980;
              final titleWidget = Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.stacked_bar_chart_rounded, color: Color(0xFF059669), size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Stato Avanzamento Utenti Iscritti',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Ripartizione tra Completati, In corso e Solo iscritti con distribuzione di genere',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ],
              );

              final actionsWidget = Wrap(
                spacing: 16,
                runSpacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _buildCourseLegendItem(const Color(0xFF2563EB), 'M (Maschile)'),
                  _buildCourseLegendItem(const Color(0xFFE11D48), 'F (Femminile)'),
                  _buildCourseLegendItem(const Color(0xFF64748B), 'N.C. (Non class.)'),
                  ElevatedButton.icon(
                    onPressed: (_enrolledUsersCount == 0 || _isExportingEnrolledProgress) ? null : _exportEnrolledProgressToExcel,
                    icon: _isExportingEnrolledProgress
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.table_view_rounded, size: 16, color: Colors.white),
                    label: Text(
                      _isExportingEnrolledProgress ? 'Esportazione...' : 'Esporta Excel',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF16A34A),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    ),
                  ),
                ],
              );

              if (isCompact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleWidget,
                    const SizedBox(height: 14),
                    actionsWidget,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: titleWidget),
                  const SizedBox(width: 16),
                  actionsWidget,
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 20),

          // Macro Barra Avanzamento Generale
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Progressione Complessiva Utenti Iscritti',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                  ),
                  Text(
                    'Totale: $total utenti iscritti',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 16,
                  width: double.infinity,
                  color: Colors.grey.shade200,
                  child: total == 0
                      ? const SizedBox.shrink()
                      : Row(
                          children: [
                            if (_totalEnrolledCompleted > 0)
                              Expanded(
                                flex: _totalEnrolledCompleted,
                                child: Container(color: const Color(0xFF10B981)),
                              ),
                            if (_totalEnrolledInProgress > 0)
                              Expanded(
                                flex: _totalEnrolledInProgress,
                                child: Container(color: const Color(0xFFF59E0B)),
                              ),
                            if (_totalEnrolledOnlyEnrolled > 0)
                              Expanded(
                                flex: _totalEnrolledOnlyEnrolled,
                                child: Container(color: const Color(0xFF94A3B8)),
                              ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 10),
              // Legenda Macro Barra
              Wrap(
                spacing: 16,
                runSpacing: 6,
                children: [
                  _buildMacroLegendItem(const Color(0xFF10B981), 'Completati', _totalEnrolledCompleted, compPct),
                  _buildMacroLegendItem(const Color(0xFFF59E0B), 'In corso', _totalEnrolledInProgress, inProgPct),
                  _buildMacroLegendItem(const Color(0xFF94A3B8), 'Solo iscritti', _totalEnrolledOnlyEnrolled, onlyEnrPct),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 3 Cards di dettaglio per stato (Responsive Layout)
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 900;
              final cards = [
                _buildProgressStatusCard(
                  title: 'Completati',
                  subtitle: 'Hanno completato almeno un corso',
                  total: _totalEnrolledCompleted,
                  totalCohort: total,
                  maleCount: _enrolledCompMale,
                  femaleCount: _enrolledCompFemale,
                  unclassifiedCount: _enrolledCompUnclass,
                  syncCount: _enrolledCompSync,
                  asyncCount: _enrolledCompAsync,
                  langCounts: _enrolledCompLangCounts,
                  icon: Icons.check_circle_rounded,
                  accentColor: const Color(0xFF10B981),
                  bgColor: const Color(0xFFECFDF5),
                  borderColor: const Color(0xFFA7F3D0),
                ),
                _buildProgressStatusCard(
                  title: 'In Corso',
                  subtitle: 'Hanno avviato attività senza completare',
                  total: _totalEnrolledInProgress,
                  totalCohort: total,
                  maleCount: _enrolledInProgMale,
                  femaleCount: _enrolledInProgFemale,
                  unclassifiedCount: _enrolledInProgUnclass,
                  syncCount: _enrolledInProgSync,
                  asyncCount: _enrolledInProgAsync,
                  langCounts: _enrolledInProgLangCounts,
                  icon: Icons.hourglass_bottom_rounded,
                  accentColor: const Color(0xFFF59E0B),
                  bgColor: const Color(0xFFFFFBEB),
                  borderColor: const Color(0xFFFDE68A),
                ),
                _buildProgressStatusCard(
                  title: 'Solo Iscritti',
                  subtitle: 'Iscritti senza alcuna attività avviata',
                  total: _totalEnrolledOnlyEnrolled,
                  totalCohort: total,
                  maleCount: _enrolledOnlyEnrMale,
                  femaleCount: _enrolledOnlyEnrFemale,
                  unclassifiedCount: _enrolledOnlyEnrUnclass,
                  syncCount: _enrolledOnlyEnrSync,
                  asyncCount: _enrolledOnlyEnrAsync,
                  langCounts: _enrolledOnlyEnrLangCounts,
                  icon: Icons.app_registration_rounded,
                  accentColor: const Color(0xFF64748B),
                  bgColor: const Color(0xFFF8FAFC),
                  borderColor: const Color(0xFFE2E8F0),
                ),
              ];

              if (isWide) {
                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: cards[0]),
                      const SizedBox(width: 16),
                      Expanded(child: cards[1]),
                      const SizedBox(width: 16),
                      Expanded(child: cards[2]),
                    ],
                  ),
                );
              } else {
                return Column(
                  children: [
                    cards[0],
                    const SizedBox(height: 16),
                    cards[1],
                    const SizedBox(height: 16),
                    cards[2],
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

Widget _buildTotalCourseEnrollmentsEnrolledChart() {
    final total = _allCourseEnrollmentsTotal;
    final compPct = total > 0 ? (_allCourseEnrollmentsCompleted / total * 100) : 0.0;
    final otherPct = total > 0 ? (_allCourseEnrollmentsOther / total * 100) : 0.0;
    final inProgPct = total > 0 ? (_allCourseEnrollmentsInProgress / total * 100) : 0.0;
    final onlyEnrPct = total > 0 ? (_allCourseEnrollmentsOnlyEnrolled / total * 100) : 0.0;

    // Determinazione metriche in base al filtro selezionato
    final int currentTotal;
    final int currentMale;
    final int currentFemale;
    final int currentUnclass;
    final Map<String, int> currentLangCounts;
    final Map<String, Map<String, int>> currentGenderLangCounts;
    final String currentCohortTitle;

    switch (_allCourseEnrollmentFilter) {
      case 'completed':
        currentTotal = _allCourseEnrollmentsCompleted;
        currentMale = _allCourseEnrCompMale;
        currentFemale = _allCourseEnrCompFemale;
        currentUnclass = _allCourseEnrCompUnclass;
        currentLangCounts = _allCourseEnrCompLangCounts;
        currentGenderLangCounts = _allCourseEnrCompGenderLangCounts;
        currentCohortTitle = 'Iscrizioni Completate';
        break;
      case 'other':
        currentTotal = _allCourseEnrollmentsOther;
        currentMale = _allCourseEnrOtherMale;
        currentFemale = _allCourseEnrOtherFemale;
        currentUnclass = _allCourseEnrOtherUnclass;
        currentLangCounts = _allCourseEnrOtherLangCounts;
        currentGenderLangCounts = _allCourseEnrOtherGenderLangCounts;
        currentCohortTitle = 'Altri (In corso + Solo iscritti)';
        break;
      case 'in_progress':
        currentTotal = _allCourseEnrollmentsInProgress;
        currentMale = _allCourseEnrInProgMale;
        currentFemale = _allCourseEnrInProgFemale;
        currentUnclass = _allCourseEnrInProgUnclass;
        currentLangCounts = _allCourseEnrInProgLangCounts;
        currentGenderLangCounts = _allCourseEnrInProgGenderLangCounts;
        currentCohortTitle = 'Iscrizioni In Corso';
        break;
      case 'only_enrolled':
        currentTotal = _allCourseEnrollmentsOnlyEnrolled;
        currentMale = _allCourseEnrOnlyEnrMale;
        currentFemale = _allCourseEnrOnlyEnrFemale;
        currentUnclass = _allCourseEnrOnlyEnrUnclass;
        currentLangCounts = _allCourseEnrOnlyEnrLangCounts;
        currentGenderLangCounts = _allCourseEnrOnlyEnrGenderLangCounts;
        currentCohortTitle = 'Solo Iscritti';
        break;
      case 'all':
      default:
        currentTotal = _allCourseEnrollmentsTotal;
        currentMale = _allCourseEnrollmentsMale;
        currentFemale = _allCourseEnrollmentsFemale;
        currentUnclass = _allCourseEnrollmentsUnclassified;
        currentLangCounts = _allCourseEnrollmentsLangCounts;
        currentGenderLangCounts = _allCourseEnrollmentsGenderLangCounts;
        currentCohortTitle = 'Tutte le Iscrizioni Attive';
        break;
    }

    final malePct = currentTotal > 0 ? (currentMale / currentTotal) : 0.0;
    final femalePct = currentTotal > 0 ? (currentFemale / currentTotal) : 0.0;
    final unclassPct = currentTotal > 0 ? (currentUnclass / currentTotal) : 0.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card con Titolo, Sottotitolo e Badge informativi
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 820;

              final titleWidget = Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withAlpha(16),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.school_rounded, color: AppTheme.primaryBlue, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'DISTRIBUZIONE TOTALE ISCRIZIONI CORSI (UTENTI ISCRITTI)',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.6,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Confronto tra Completati e Altri (In corso + Solo iscritti), con ripartizione per genere e lingua',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ],
              );

              final badgesWidget = Wrap(
                spacing: 8,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  // Badge Totale Iscrizioni Attive
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.people_alt_rounded, size: 14, color: Color(0xFF2563EB)),
                        const SizedBox(width: 5),
                        Text(
                          '$total Iscrizioni Attive',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D4ED8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Badge Completate
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFF86EFAC)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF16A34A)),
                        const SizedBox(width: 5),
                        Text(
                          '$_allCourseEnrollmentsCompleted Completate (${compPct.toStringAsFixed(1)}%)',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF15803D),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Badge Altri
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFFDE68A)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.pending_actions_rounded, size: 14, color: Color(0xFFD97706)),
                        const SizedBox(width: 5),
                        Text(
                          '$_allCourseEnrollmentsOther Altri (${otherPct.toStringAsFixed(1)}%)',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFB45309),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Badge Sincrono / Asincrono
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAF5FF),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFE9D5FF)),
                    ),
                    child: Text(
                      'Sync: $_allCourseEnrollmentsSync • Async: $_allCourseEnrollmentsAsync',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7E22CE),
                      ),
                    ),
                  ),
                ],
              );

              if (isCompact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleWidget,
                    const SizedBox(height: 12),
                    badgesWidget,
                  ],
                );
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: titleWidget),
                  const SizedBox(width: 16),
                  badgesWidget,
                ],
              );
            },
          ),
          const SizedBox(height: 18),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 18),

          // --- 1. Macro Barra Proporzionale di Avanzamento Iscrizioni ---
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Stato Iscrizioni Attive (Completati vs Altri)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.4,
                      color: Color(0xFF334155),
                    ),
                  ),
                  Text(
                    'Totale: $total iscrizioni attive',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 16,
                  width: double.infinity,
                  color: Colors.grey.shade200,
                  child: total == 0
                      ? const SizedBox.shrink()
                      : Row(
                          children: [
                            if (_allCourseEnrollmentsCompleted > 0)
                              Expanded(
                                flex: _allCourseEnrollmentsCompleted,
                                child: Container(color: const Color(0xFF10B981)),
                              ),
                            if (_allCourseEnrollmentsInProgress > 0)
                              Expanded(
                                flex: _allCourseEnrollmentsInProgress,
                                child: Container(color: const Color(0xFFF59E0B)),
                              ),
                            if (_allCourseEnrollmentsOnlyEnrolled > 0)
                              Expanded(
                                flex: _allCourseEnrollmentsOnlyEnrolled,
                                child: Container(color: const Color(0xFF94A3B8)),
                              ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 16,
                runSpacing: 6,
                children: [
                  _buildMacroLegendItem(const Color(0xFF10B981), 'Completati', _allCourseEnrollmentsCompleted, compPct),
                  _buildMacroLegendItem(const Color(0xFFF59E0B), 'In corso', _allCourseEnrollmentsInProgress, inProgPct),
                  _buildMacroLegendItem(const Color(0xFF94A3B8), 'Solo iscritti', _allCourseEnrollmentsOnlyEnrolled, onlyEnrPct),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // --- 2. Due Card Comparative Affiancate: Completati vs Altri (In corso + Solo iscritti) ---
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 860;
              final completedCard = _buildCohortSummaryCard(
                title: 'Iscrizioni Completate',
                subtitle: 'Corsi completati con successo dagli utenti iscritti',
                count: _allCourseEnrollmentsCompleted,
                totalCohort: total,
                maleCount: _allCourseEnrCompMale,
                femaleCount: _allCourseEnrCompFemale,
                unclassifiedCount: _allCourseEnrCompUnclass,
                langCounts: _allCourseEnrCompLangCounts,
                genderLangCounts: _allCourseEnrCompGenderLangCounts,
                accentColor: const Color(0xFF10B981),
                bgColor: const Color(0xFFF0FDF4),
                borderColor: const Color(0xFFA7F3D0),
                icon: Icons.check_circle_rounded,
              );

              final otherCard = _buildCohortSummaryCard(
                title: 'Altre Iscrizioni (Non Completate)',
                subtitle: 'In corso: $_allCourseEnrollmentsInProgress (${inProgPct.toStringAsFixed(1)}%) • Solo iscritti: $_allCourseEnrollmentsOnlyEnrolled (${onlyEnrPct.toStringAsFixed(1)}%)',
                count: _allCourseEnrollmentsOther,
                totalCohort: total,
                maleCount: _allCourseEnrOtherMale,
                femaleCount: _allCourseEnrOtherFemale,
                unclassifiedCount: _allCourseEnrOtherUnclass,
                langCounts: _allCourseEnrOtherLangCounts,
                genderLangCounts: _allCourseEnrOtherGenderLangCounts,
                accentColor: const Color(0xFFD97706),
                bgColor: const Color(0xFFFFFBEB),
                borderColor: const Color(0xFFFDE68A),
                icon: Icons.pending_actions_rounded,
              );

              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: completedCard),
                    const SizedBox(width: 16),
                    Expanded(child: otherCard),
                  ],
                );
              }

              return Column(
                children: [
                  completedCard,
                  const SizedBox(height: 14),
                  otherCard,
                ],
              );
            },
          ),
          const SizedBox(height: 22),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 16),

          // --- 3. Barra Selettore Filtro Dinamico Donut & Lingue ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ESPLORA DETTAGLIO COORTE:',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: Color(0xFF64748B),
                ),
              ),
              Text(
                'Visualizzazione: $currentCohortTitle',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildEnrolledEnrollmentChoiceChip('all', 'Tutte ($total)'),
              _buildEnrolledEnrollmentChoiceChip('completed', 'Completati ($_allCourseEnrollmentsCompleted)'),
              _buildEnrolledEnrollmentChoiceChip('other', 'Altri ($_allCourseEnrollmentsOther)'),
              _buildEnrolledEnrollmentChoiceChip('in_progress', 'Di cui In corso ($_allCourseEnrollmentsInProgress)'),
              _buildEnrolledEnrollmentChoiceChip('only_enrolled', 'Di cui Solo iscritti ($_allCourseEnrollmentsOnlyEnrolled)'),
            ],
          ),
          const SizedBox(height: 18),

          // --- 4. Donut Chart + Breakdown Genere della Coorte Selezionata ---
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 660;

              final donutWidget = Center(
                child: SizedBox(
                  width: 190,
                  height: 190,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(190, 190),
                        painter: _GenderDonutPainter(
                          male: currentMale,
                          female: currentFemale,
                          unclassified: currentUnclass,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$currentTotal',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Iscrizioni',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );

              final breakdownWidget = Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildGenderBar(
                    label: 'Iscrizioni Uomini (M)',
                    count: currentMale,
                    percentage: malePct,
                    color: const Color(0xFF2563EB),
                    bgColor: const Color(0xFFEFF6FF),
                    icon: Icons.male_rounded,
                  ),
                  const SizedBox(height: 12),
                  _buildGenderBar(
                    label: 'Iscrizioni Donne (F)',
                    count: currentFemale,
                    percentage: femalePct,
                    color: const Color(0xFFE11D48),
                    bgColor: const Color(0xFFFFF1F2),
                    icon: Icons.female_rounded,
                  ),
                  const SizedBox(height: 12),
                  _buildGenderBar(
                    label: 'Iscrizioni Non classificate',
                    count: currentUnclass,
                    percentage: unclassPct,
                    color: const Color(0xFF64748B),
                    bgColor: const Color(0xFFF8FAFC),
                    icon: Icons.help_outline_rounded,
                  ),
                ],
              );

              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 16),
                    donutWidget,
                    const SizedBox(width: 36),
                    Expanded(child: breakdownWidget),
                    const SizedBox(width: 16),
                  ],
                );
              }

              return Column(
                children: [
                  donutWidget,
                  const SizedBox(height: 24),
                  breakdownWidget,
                ],
              );
            },
          ),

          // --- 5. Sezione Lingua Iscrizioni per la Coorte Selezionata ---
          _buildTotalCourseEnrollmentsActiveLanguageSection(
            total: currentTotal,
            langCounts: currentLangCounts,
            genderLangCounts: currentGenderLangCounts,
            cohortName: currentCohortTitle,
          ),
        ],
      ),
    );
  }

  Widget _buildEnrolledEnrollmentChoiceChip(String key, String label) {
    final isSelected = _allCourseEnrollmentFilter == key;
    return ChoiceChip(
      selected: isSelected,
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected ? Colors.white : const Color(0xFF334155),
        ),
      ),
      selectedColor: AppTheme.primaryBlue,
      backgroundColor: const Color(0xFFF8FAFC),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected ? AppTheme.primaryBlue : Colors.grey.shade300,
        ),
      ),
      onSelected: (_) {
        setState(() {
          _allCourseEnrollmentFilter = key;
        });
      },
    );
  }


Widget _buildEnrolledCourseEnrollmentGenderChart() {
    final displayedCourses = _showAllEnrolledCourses
        ? _enrolledCourseStats
        : _enrolledCourseStats.take(8).toList();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card con titolo e legenda
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 980;
              final titleWidget = Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.bar_chart_rounded, color: AppTheme.primaryBlue, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Distribuzione Iscrizioni per Corso (Utenti Iscritti)',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Ripartizione degli utenti iscritti per corso e composizione di genere',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ],
              );

              final actionsWidget = Wrap(
                spacing: 12,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _buildCourseLegendItem(const Color(0xFF2563EB), 'M (Maschile)'),
                  _buildCourseLegendItem(const Color(0xFFE11D48), 'F (Femminile)'),
                  _buildCourseLegendItem(const Color(0xFF64748B), 'N.C. (Non class.)'),
                  const SizedBox(width: 4),
                  OutlinedButton.icon(
                    onPressed: (_enrolledCourseStats.isEmpty || _isExportingEnrolledCourses) ? null : _exportEnrolledCoursesToExcel,
                    icon: _isExportingEnrolledCourses
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF16A34A)),
                          )
                        : const Icon(Icons.table_view_rounded, size: 16),
                    label: Text(
                      _isExportingEnrolledCourses ? 'Esportazione...' : 'Esporta Excel',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF16A34A),
                      side: const BorderSide(color: Color(0xFF86EFAC)),
                      backgroundColor: const Color(0xFFF0FDF4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ],
              );

              if (isCompact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleWidget,
                    const SizedBox(height: 14),
                    actionsWidget,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: titleWidget),
                  const SizedBox(width: 16),
                  actionsWidget,
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 20),

          if (_enrolledCourseStats.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 36),
                child: Column(
                  children: [
                    Icon(Icons.school_outlined, size: 40, color: Colors.grey.shade400),
                    const SizedBox(height: 10),
                    Text(
                      'Nessun dato di iscrizione attivo per i corsi sincronizzati',
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: displayedCourses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 18),
              itemBuilder: (context, index) {
                final course = displayedCourses[index];
                return _buildCourseEnrollmentRow(index + 1, course);
              },
            ),
            if (_enrolledCourseStats.length > 8) ...[
              const SizedBox(height: 16),
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _showAllEnrolledCourses = !_showAllEnrolledCourses;
                    });
                  },
                  icon: Icon(
                    _showAllEnrolledCourses ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    size: 18,
                  ),
                  label: Text(
                    _showAllEnrolledCourses
                        ? 'Mostra solo i principali 8 corsi'
                        : 'Mostra tutti i ${_enrolledCourseStats.length} corsi',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.primaryBlue,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }





  // --- Sezione Report DG-CNECT KPIs Dashboard (WP3 - Synch and Async Courses) ---
  Widget _buildDgCnectKpiSection() {
    final filteredKpis = _selectedDgCnectCategory == 'TUTTI'
        ? _dgCnectKpis
        : _dgCnectKpis.where((k) => k.category == _selectedDgCnectCategory).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header della Sezione
          LayoutBuilder(
            builder: (context, headerConstraints) {
              final isNarrow = headerConstraints.maxWidth < 780;
              final headerInfo = Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F766E).withAlpha(16),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.assessment_rounded, color: Color(0xFF0F766E), size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'MONITORAGGIO INDICATORI DG-CNECT',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.6,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: const Color(0xFF86EFAC)),
                              ),
                              child: const Text(
                                'WP3 - TIM',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF166534),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Metriche ufficiali Commissione Europea (Colonna F - Corsi Sincroni & Asincroni). Export conforme su file Excel.',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ],
              );

              final exportBtn = ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF16A34A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                icon: _isExportingDgCnect
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.download_rounded, size: 18),
                label: const Text(
                  'Scarica Excel DG-CNECT',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                onPressed: _isExportingDgCnect ? null : _exportDgCnectReport,
              );

              if (isNarrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headerInfo,
                    const SizedBox(height: 14),
                    exportBtn,
                  ],
                );
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: headerInfo),
                  const SizedBox(width: 16),
                  exportBtn,
                ],
              );
            },
          ),
          const SizedBox(height: 18),

          // 4 Mini Highlight KPI Cards
          LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              final int crossAxisCount = w < 600 ? 1 : (w < 1050 ? 2 : 4);
              final double aspectRatio = w < 600 ? 3.6 : (w < 1050 ? 2.4 : 2.1);

              final kpiCert = _dgCnectKpis.firstWhere(
                (k) => k.code == '1.3',
                orElse: () => const DgCnectKpiItem(row: 6, code: '1.3', indicator: '', category: '', value: 0),
              );
              final kpiEnr = _dgCnectKpis.firstWhere(
                (k) => k.code == '2.2',
                orElse: () => const DgCnectKpiItem(row: 10, code: '2.2', indicator: '', category: '', value: 0),
              );
              final kpiUnder25 = _dgCnectKpis.firstWhere(
                (k) => k.code == '2.5',
                orElse: () => const DgCnectKpiItem(row: 15, code: '2.5', indicator: '', category: '', value: 0),
              );
              final kpiComp = _dgCnectKpis.firstWhere(
                (k) => k.code == '2.8',
                orElse: () => const DgCnectKpiItem(row: 18, code: '2.8', indicator: '', category: '', value: 0.0, format: 'percent'),
              );

              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: aspectRatio,
                children: [
                  _buildMiniDgCard('1.3 CORSI CERTIFICATI', kpiCert.displayValue, 'Corsi a catalogo validi', Icons.verified_rounded, const Color(0xFF0284C7)),
                  _buildMiniDgCard('2.2 ISCRIZIONI TOTALI', kpiEnr.displayValue, 'Iscrizioni monitorate WP3', Icons.people_alt_rounded, const Color(0xFF0F766E)),
                  _buildMiniDgCard('2.5 PARTECIPANTI ≤ 25 ANNI', kpiUnder25.displayValue, 'Giovani iscritti a corsi', Icons.school_rounded, const Color(0xFF8B5CF6)),
                  _buildMiniDgCard('2.8 COMPLETAMENTO RATE', kpiComp.displayValue, 'Tasso di completamento', Icons.task_alt_rounded, const Color(0xFF16A34A)),
                ],
              );
            },
          ),
          const SizedBox(height: 18),

          // Chips Filtro Categorie
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildDgCategoryChip('TUTTI', 'Tutti (${_dgCnectKpis.length})'),
              _buildDgCategoryChip('INDICATORE 1 & 2', 'Indicatori 1 & 2 (Programmi & Iscrizioni)'),
              _buildDgCategoryChip('ATTIVITÀ FORMATIVE (3, 4, 5)', 'Attività Formative (3, 4, 5)'),
              _buildDgCategoryChip('DURATA CORSI (6.1 - 6.6)', 'Durata Corsi (6.1 - 6.6)'),
              _buildDgCategoryChip('COMPLETAMENTI (6.7 - 6.8)', 'Completamenti (6.7 - 6.8)'),
            ],
          ),
          const SizedBox(height: 16),

          // Tabella Dati DG-CNECT
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 850),
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                    headingRowHeight: 46,
                    dataRowMinHeight: 48,
                    dataRowMaxHeight: 56,
                    horizontalMargin: 16,
                    columnSpacing: 18,
                    columns: const [
                      DataColumn(label: Text('CELLA EXCEL', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                      DataColumn(label: Text('CODICE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                      DataColumn(label: Text('INDICATORE UFFICIALE (COLONNA D)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                      DataColumn(label: Text('CATEGORIA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                      DataColumn(label: Text('VALORE ATTUALE (COLONNA F)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                      DataColumn(label: Text('DESCRIZIONE & MAPPATURA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                    ],
                    rows: filteredKpis.map((kpi) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Text(
                                kpi.cellReference,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, fontFamily: 'monospace', color: Color(0xFF334155)),
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              kpi.code,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.primaryBlue),
                            ),
                          ),
                          DataCell(
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 320),
                              child: Text(
                                kpi.indicator,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                kpi.category,
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
                              ),
                            ),
                          ),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFF86EFAC)),
                              ),
                              child: Text(
                                kpi.displayValue,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Color(0xFF15803D),
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 280),
                              child: Text(
                                kpi.description,
                                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
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
        ],
      ),
    );
  }

  Widget _buildMiniDgCard(String title, String value, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha(10),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDgCategoryChip(String key, String label) {
    final isSelected = _selectedDgCnectCategory == key;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      labelStyle: TextStyle(
        fontSize: 11,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        color: isSelected ? Colors.white : const Color(0xFF334155),
      ),
      selectedColor: AppTheme.primaryBlue,
      backgroundColor: const Color(0xFFF1F5F9),
      side: BorderSide(
        color: isSelected ? AppTheme.primaryBlue : Colors.grey.shade300,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onSelected: (_) {
        setState(() {
          _selectedDgCnectCategory = key;
        });
      },
    );
  }

  // --- Card Singolo Dato: Utenti Partecipanti ---
  Widget _buildParticipatingUsersCard() {
    return InkWell(
      onTap: widget.onNavigateToUserStats,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withAlpha(16),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.how_to_reg_rounded, color: AppTheme.primaryBlue, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'UTENTI PARTECIPANTI',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.6,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$_participatingUsersCount',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                const SizedBox(height: 10),
                Text(
                  'Utenti unici con corso iniziato o completato.',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.3),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_outline_rounded, size: 12, color: Color(0xFF1D4ED8)),
                  SizedBox(width: 5),
                  Text(
                    'Iniziato o Completato',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D4ED8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Card Singolo Dato: Utenti Attivi ---
  Widget _buildActiveUsersCard() {
    return InkWell(
      onTap: widget.onNavigateToUsers,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF059669).withAlpha(16),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.verified_user_rounded, color: Color(0xFF059669), size: 22),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'UTENTI ATTIVI',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.6,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$_activeUsersCount',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                const SizedBox(height: 10),
                Text(
                  'Utenti iscritti con primo accesso registrato.',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.3),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFA7F3D0)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.login_rounded, size: 12, color: Color(0xFF059669)),
                  SizedBox(width: 5),
                  Text(
                    'Primo Accesso',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF059669),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Card Singolo Dato: Utenti Iscritti ---
  Widget _buildEnrolledUsersCard() {
    return InkWell(
      onTap: widget.onNavigateToEnrollments,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D9488).withAlpha(16),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.school_rounded, color: Color(0xFF0D9488), size: 22),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'UTENTI ISCRITTI',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.6,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$_enrolledUsersCount',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                const SizedBox(height: 10),
                Text(
                  'Totale univoco degli utenti iscritti ai corsi.',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.3),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDFA),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFF99F6E4)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.assignment_ind_outlined, size: 12, color: Color(0xFF0D9488)),
                  SizedBox(width: 5),
                  Text(
                    'Iscrizioni',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D9488),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Stato Vuoto ---
  Widget _buildEmptyState() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withAlpha(16),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.school_rounded, size: 54, color: AppTheme.primaryBlue),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Nessuna Statistica Disponibile',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Il database locale non contiene ancora statistiche dei corsi (stat_mdl). Avvia la sincronizzazione per rilevare gli utenti iscritti ai corsi.',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.4),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: widget.onNavigateToSync,
                  icon: const Icon(Icons.sync_rounded),
                  label: const Text('Vai al menu Sync', style: TextStyle(fontWeight: FontWeight.bold)),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Grafico Distribuzione Totale Iscrizioni (Tutti i corsi, multi-iscrizioni per utente) ---
  Widget _buildTotalEnrollmentsChart() {
    final total = _totalEnrollmentsCount;
    final malePct = total > 0 ? (_enrollmentMaleCount / total) : 0.0;
    final femalePct = total > 0 ? (_enrollmentFemaleCount / total) : 0.0;
    final unclassPct = total > 0 ? (_enrollmentUnclassifiedCount / total) : 0.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header del Grafico
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0284C7).withAlpha(16),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.auto_stories_rounded, color: Color(0xFF0284C7), size: 22),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'DISTRIBUZIONE TOTALE ISCRIZIONI (TUTTI I CORSI)',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.6,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Volume complessivo iscrizioni (conteggio unico per corso, multi-corso tra corsi diversi, corsi non esclusi)',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F9FF),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFBAE6FD)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.school_outlined, size: 14, color: Color(0xFF0284C7)),
                    const SizedBox(width: 5),
                    Text(
                      '$total Iscrizioni Totali',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0284C7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 20),

          // Donut Chart + Breakdown Genere
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 660;

              final donutWidget = Center(
                child: SizedBox(
                  width: 190,
                  height: 190,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(190, 190),
                        painter: _GenderDonutPainter(
                          male: _enrollmentMaleCount,
                          female: _enrollmentFemaleCount,
                          unclassified: _enrollmentUnclassifiedCount,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$total',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Iscrizioni',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );

              final breakdownWidget = Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildGenderBar(
                    label: 'Iscrizioni Uomini (M)',
                    count: _enrollmentMaleCount,
                    percentage: malePct,
                    color: const Color(0xFF2563EB),
                    bgColor: const Color(0xFFEFF6FF),
                    icon: Icons.male_rounded,
                  ),
                  const SizedBox(height: 12),
                  _buildGenderBar(
                    label: 'Iscrizioni Donne (F)',
                    count: _enrollmentFemaleCount,
                    percentage: femalePct,
                    color: const Color(0xFFE11D48),
                    bgColor: const Color(0xFFFFF1F2),
                    icon: Icons.female_rounded,
                  ),
                  const SizedBox(height: 12),
                  _buildGenderBar(
                    label: 'Iscrizioni Non classificate',
                    count: _enrollmentUnclassifiedCount,
                    percentage: unclassPct,
                    color: const Color(0xFF64748B),
                    bgColor: const Color(0xFFF8FAFC),
                    icon: Icons.help_outline_rounded,
                  ),
                ],
              );

              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 16),
                    donutWidget,
                    const SizedBox(width: 36),
                    Expanded(child: breakdownWidget),
                    const SizedBox(width: 16),
                  ],
                );
              }

              return Column(
                children: [
                  donutWidget,
                  const SizedBox(height: 24),
                  breakdownWidget,
                ],
              );
            },
          ),

          // Sezione Lingua Iscrizioni
          _buildTotalEnrollmentsLanguageSection(),
        ],
      ),
    );
  }

  Widget _buildTotalEnrollmentsLanguageSection() {
    if (_enrollmentLangCounts.isEmpty) return const SizedBox.shrink();

    final total = _totalEnrollmentsCount;
    final sortedLangs = _enrollmentLangCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 22),
        const Divider(height: 1, color: Color(0xFFF1F5F9)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0EA5E9).withAlpha(18),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.language_rounded, color: Color(0xFF0284C7), size: 18),
                ),
                const SizedBox(width: 10),
                const Text(
                  'DISTRIBUZIONE ISCRIZIONI PER LINGUA',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F9FF),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFBAE6FD)),
              ),
              child: Text(
                '${sortedLangs.length} lingu${sortedLangs.length == 1 ? 'a' : 'e'}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0284C7),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 12,
          runSpacing: 10,
          children: sortedLangs.map((entry) {
            final lang = entry.key;
            final count = entry.value;
            final pct = total > 0 ? (count / total * 100) : 0.0;
            final genderBreakdown = _enrollmentGenderLangCounts[lang] ?? {};
            final mCount = genderBreakdown['M'] ?? 0;
            final fCount = genderBreakdown['F'] ?? 0;
            final ncCount = genderBreakdown['N.C.'] ?? 0;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0284C7).withAlpha(16),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          lang,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0284C7),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$count iscrizion${count == 1 ? 'e' : 'i'}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '(${pct.toStringAsFixed(1)}%)',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildMiniGenderTag('M', mCount, const Color(0xFF2563EB)),
                      const SizedBox(width: 6),
                      _buildMiniGenderTag('F', fCount, const Color(0xFFE11D48)),
                      if (ncCount > 0) ...[
                        const SizedBox(width: 6),
                        _buildMiniGenderTag('N.C.', ncCount, const Color(0xFF64748B)),
                      ],
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // --- Grafico Distribuzione Gender Utenti Attivi ---
  Widget _buildGenderDistributionChart() {
    final hasYearFilter = _selectedGenderYear != null && _activeYearCounts.containsKey(_selectedGenderYear);
    final total = hasYearFilter
        ? (_activeYearCounts[_selectedGenderYear] ?? 0)
        : _activeUsersCount;
    final maleCount = hasYearFilter
        ? (_activeGenderYearCounts[_selectedGenderYear]?['M'] ?? 0)
        : _activeMaleCount;
    final femaleCount = hasYearFilter
        ? (_activeGenderYearCounts[_selectedGenderYear]?['F'] ?? 0)
        : _activeFemaleCount;
    final unclassCount = hasYearFilter
        ? (_activeGenderYearCounts[_selectedGenderYear]?['N.C.'] ?? 0)
        : _activeUnclassifiedCount;

    final malePct = total > 0 ? (maleCount / total) : 0.0;
    final femalePct = total > 0 ? (femaleCount / total) : 0.0;
    final unclassPct = total > 0 ? (unclassCount / total) : 0.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header del Grafico
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withAlpha(16),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.pie_chart_rounded, color: Color(0xFF6366F1), size: 22),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'DISTRIBUZIONE GENDER (UTENTI ATTIVI)',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.6,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        hasYearFilter
                            ? 'Ripartizione per genere nel $_selectedGenderYear calcolata su $total utenti attivi'
                            : 'Ripartizione per genere calcolata sui $total utenti attivi',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFC7D2FE)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.people_outline_rounded, size: 14, color: Color(0xFF4F46E5)),
                    const SizedBox(width: 5),
                    Text(
                      hasYearFilter
                          ? '$total Utenti ($_selectedGenderYear)'
                          : '$total Utenti Attivi',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4F46E5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_activeYearCounts.length > 1) ...[
            const SizedBox(height: 14),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const Text(
                    'Filtra per anno di iscrizione:',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () => setState(() => _selectedGenderYear = null),
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _selectedGenderYear == null
                            ? const Color(0xFF4F46E5)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: _selectedGenderYear == null
                              ? const Color(0xFF4F46E5)
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        'Tutti gli anni ($_activeUsersCount)',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: _selectedGenderYear == null ? Colors.white : Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),
                  ...(() {
                    final sortedYears = _activeYearCounts.entries.toList()
                      ..sort((a, b) {
                        if (a.key == 'N.D.') return 1;
                        if (b.key == 'N.D.') return -1;
                        return b.key.compareTo(a.key);
                      });
                    return sortedYears.map((entry) {
                      final isSel = _selectedGenderYear == entry.key;
                      return Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: InkWell(
                          onTap: () => setState(() => _selectedGenderYear = isSel ? null : entry.key),
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isSel ? const Color(0xFFD97706) : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: isSel ? const Color(0xFFD97706) : Colors.grey.shade300,
                              ),
                            ),
                            child: Text(
                              '${entry.key} (${entry.value})',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isSel ? Colors.white : Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ),
                      );
                    });
                  })(),
                ],
              ),
            ),
          ],
          const SizedBox(height: 18),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 20),

          // Corpo: Donut Chart + Breakdown
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 660;

              final donutWidget = Center(
                child: SizedBox(
                  width: 190,
                  height: 190,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(190, 190),
                        painter: _GenderDonutPainter(
                          male: maleCount,
                          female: femaleCount,
                          unclassified: unclassCount,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$total',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            hasYearFilter ? 'Attivi ($_selectedGenderYear)' : 'Attivi',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );

              final breakdownWidget = Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildGenderBar(
                    label: 'Uomini (M)',
                    count: maleCount,
                    percentage: malePct,
                    color: const Color(0xFF2563EB),
                    bgColor: const Color(0xFFEFF6FF),
                    icon: Icons.male_rounded,
                  ),
                  const SizedBox(height: 12),
                  _buildGenderBar(
                    label: 'Donne (F)',
                    count: femaleCount,
                    percentage: femalePct,
                    color: const Color(0xFFE11D48),
                    bgColor: const Color(0xFFFFF1F2),
                    icon: Icons.female_rounded,
                  ),
                  const SizedBox(height: 12),
                  _buildGenderBar(
                    label: 'Non classificato',
                    count: unclassCount,
                    percentage: unclassPct,
                    color: const Color(0xFF64748B),
                    bgColor: const Color(0xFFF8FAFC),
                    icon: Icons.help_outline_rounded,
                  ),
                ],
              );

              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 16),
                    donutWidget,
                    const SizedBox(width: 36),
                    Expanded(child: breakdownWidget),
                    const SizedBox(width: 16),
                  ],
                );
              }

              return Column(
                children: [
                  donutWidget,
                  const SizedBox(height: 24),
                  breakdownWidget,
                ],
              );
            },
          ),
          _buildYearDistributionSection(),
          _buildLanguageDistributionSection(),
        ],
      ),
    );
  }

  Widget _buildYearDistributionSection() {
    if (_activeYearCounts.isEmpty) return const SizedBox.shrink();

    final total = _activeUsersCount;
    final sortedYears = _activeYearCounts.entries.toList()
      ..sort((a, b) {
        if (a.key == 'N.D.') return 1;
        if (b.key == 'N.D.') return -1;
        return b.key.compareTo(a.key);
      });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 22),
        const Divider(height: 1, color: Color(0xFFF1F5F9)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B).withAlpha(20),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.calendar_today_rounded, color: Color(0xFFD97706), size: 18),
                ),
                const SizedBox(width: 10),
                const Text(
                  'DISTRIBUZIONE PER ANNO DI ISCRIZIONE (DATA PRIMO ACCESSO)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Text(
                '${sortedYears.length} ann${sortedYears.length == 1 ? 'o' : 'i'}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD97706),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 12,
          runSpacing: 10,
          children: sortedYears.map((entry) {
            final year = entry.key;
            final count = entry.value;
            final pct = total > 0 ? (count / total * 100) : 0.0;
            final genderBreakdown = _activeGenderYearCounts[year] ?? {};
            final mCount = genderBreakdown['M'] ?? 0;
            final fCount = genderBreakdown['F'] ?? 0;
            final ncCount = genderBreakdown['N.C.'] ?? 0;
            final isSelected = _selectedGenderYear == year;

            return InkWell(
              onTap: () {
                setState(() {
                  _selectedGenderYear = isSelected ? null : year;
                });
              },
              borderRadius: BorderRadius.circular(10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFFFFBEB) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? const Color(0xFFF59E0B) : Colors.grey.shade200,
                    width: isSelected ? 1.5 : 1.0,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFFF59E0B).withAlpha(25),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD97706).withAlpha(isSelected ? 35 : 20),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.event_note_rounded, size: 13, color: Color(0xFFB45309)),
                              const SizedBox(width: 4),
                              Text(
                                year,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFFB45309),
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$count',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${pct.toStringAsFixed(1)}%)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildMiniGenderTag('M', mCount, const Color(0xFF2563EB)),
                        const SizedBox(width: 6),
                        _buildMiniGenderTag('F', fCount, const Color(0xFFE11D48)),
                        if (ncCount > 0) ...[
                          const SizedBox(width: 6),
                          _buildMiniGenderTag('N.C.', ncCount, const Color(0xFF64748B)),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLanguageDistributionSection() {
    final hasYearFilter = _selectedGenderYear != null && _activeYearLangCounts.containsKey(_selectedGenderYear);
    final Map<String, int> currentLangCounts = hasYearFilter
        ? (_activeYearLangCounts[_selectedGenderYear] ?? {})
        : _activeLangCounts;
    final Map<String, Map<String, int>> currentGenderLangCounts = hasYearFilter
        ? (_activeYearGenderLangCounts[_selectedGenderYear] ?? {})
        : _activeGenderLangCounts;
    final total = hasYearFilter
        ? (_activeYearCounts[_selectedGenderYear] ?? 0)
        : _activeUsersCount;

    if (currentLangCounts.isEmpty) return const SizedBox.shrink();

    final sortedLangs = currentLangCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 22),
        const Divider(height: 1, color: Color(0xFFF1F5F9)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0EA5E9).withAlpha(18),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.language_rounded, color: Color(0xFF0284C7), size: 18),
                ),
                const SizedBox(width: 10),
                Text(
                  hasYearFilter
                      ? 'DISTRIBUZIONE PER LINGUA ($_selectedGenderYear)'
                      : 'DISTRIBUZIONE PER LINGUA (USER\'S PREF COURSE LANG)',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F9FF),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFBAE6FD)),
              ),
              child: Text(
                '${sortedLangs.length} lingu${sortedLangs.length == 1 ? 'a' : 'e'}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0284C7),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 12,
          runSpacing: 10,
          children: sortedLangs.map((entry) {
            final lang = entry.key;
            final count = entry.value;
            final pct = total > 0 ? (count / total * 100) : 0.0;
            final genderBreakdown = currentGenderLangCounts[lang] ?? {};
            final mCount = genderBreakdown['M'] ?? 0;
            final fCount = genderBreakdown['F'] ?? 0;
            final ncCount = genderBreakdown['N.C.'] ?? 0;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0284C7).withAlpha(20),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          lang,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0369A1),
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$count',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${pct.toStringAsFixed(1)}%)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildMiniGenderTag('M', mCount, const Color(0xFF2563EB)),
                      const SizedBox(width: 6),
                      _buildMiniGenderTag('F', fCount, const Color(0xFFE11D48)),
                      if (ncCount > 0) ...[
                        const SizedBox(width: 6),
                        _buildMiniGenderTag('N.C.', ncCount, const Color(0xFF64748B)),
                      ],
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMiniGenderTag(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(14),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$label: $count',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildGenderBar({
    required String label,
    required int count,
    required double percentage,
    required Color color,
    required Color bgColor,
    required IconData icon,
  }) {
    final pctString = (percentage * 100).toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 18, color: color),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$count ',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    TextSpan(
                      text: '($pctString%)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage.clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: color.withAlpha(25),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  // --- Grafico Stato Avanzamento Utenti Attivi (Completati, In corso, Solo iscritti con Gender) ---
  Widget _buildPartnerActiveStatsChart() {
    final displayedPartners = _showAllPartners
        ? _partnerActiveStats
        : _partnerActiveStats.take(8).toList();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card con titolo e legenda
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 980;
              final titleWidget = Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F766E).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.corporate_fare_rounded, color: Color(0xFF0F766E), size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Distribuzione Utenti Attivi per Partner Reference',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Ripartizione degli utenti attivi per partner reference con dettaglio per genere e lingua',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ],
              );

              final actionsWidget = Wrap(
                spacing: 12,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _buildCourseLegendItem(const Color(0xFF2563EB), 'M (Maschile)'),
                  _buildCourseLegendItem(const Color(0xFFE11D48), 'F (Femminile)'),
                  _buildCourseLegendItem(const Color(0xFF64748B), 'N.C. (Non class.)'),
                  _buildCourseLegendItem(const Color(0xFF16A34A), 'Completati'),
                  const SizedBox(width: 4),
                  OutlinedButton.icon(
                    onPressed: (_partnerActiveStats.isEmpty || _isExportingPartners)
                        ? null
                        : _exportPartnersToExcel,
                    icon: _isExportingPartners
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF16A34A)),
                          )
                        : const Icon(Icons.table_view_rounded, size: 16),
                    label: Text(
                      _isExportingPartners ? 'Esportazione...' : 'Esporta Excel',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF16A34A),
                      side: const BorderSide(color: Color(0xFF86EFAC)),
                      backgroundColor: const Color(0xFFF0FDF4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ],
              );

              if (isCompact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleWidget,
                    const SizedBox(height: 14),
                    actionsWidget,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: titleWidget),
                  const SizedBox(width: 16),
                  actionsWidget,
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 20),

          if (_partnerActiveStats.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 36),
                child: Column(
                  children: [
                    Icon(Icons.business_outlined, size: 40, color: Colors.grey.shade400),
                    const SizedBox(height: 10),
                    Text(
                      'Nessun dato partner reference per gli utenti attivi',
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: displayedPartners.length,
              separatorBuilder: (_, __) => const SizedBox(height: 18),
              itemBuilder: (context, index) {
                final partner = displayedPartners[index];
                return _buildPartnerActiveRow(index + 1, partner);
              },
            ),
            if (_partnerActiveStats.length > 8) ...[
              const SizedBox(height: 16),
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _showAllPartners = !_showAllPartners;
                    });
                  },
                  icon: Icon(
                    _showAllPartners ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    size: 18,
                  ),
                  label: Text(
                    _showAllPartners
                        ? 'Mostra solo i principali 8 partner'
                        : 'Mostra tutti i ${_partnerActiveStats.length} partner',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.primaryBlue,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildPartnerActiveRow(int rank, PartnerActiveStat partner) {
    final total = partner.total;
    final malePct = total > 0 ? (partner.maleCount / total * 100) : 0.0;
    final femalePct = total > 0 ? (partner.femaleCount / total * 100) : 0.0;
    final unclassifiedPct = total > 0 ? (partner.unclassifiedCount / total * 100) : 0.0;

    final sortedLangs = partner.langCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Posizione, Nome Partner, Badge Totale Attivi
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: rank <= 3 ? const Color(0xFF0F766E) : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '#$rank',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: rank <= 3 ? Colors.white : Colors.grey.shade700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  partner.partnerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Badge Completati e Badge Totale Attivi
              Wrap(
                spacing: 8,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF16A34A).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF16A34A).withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF16A34A)),
                        const SizedBox(width: 6),
                        Text(
                          '${partner.completedCount} completati (${partner.completionPercentage.toStringAsFixed(1)}%)',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF16A34A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.people_alt_rounded, size: 14, color: AppTheme.primaryBlue),
                        const SizedBox(width: 6),
                        Text(
                          '$total attivi',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Stacked Progress Bar proporzionale per Gender
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Container(
              height: 12,
              width: double.infinity,
              color: Colors.grey.shade200,
              child: total == 0
                  ? const SizedBox.shrink()
                  : Row(
                      children: [
                        if (partner.maleCount > 0)
                          Expanded(
                            flex: partner.maleCount,
                            child: Container(color: const Color(0xFF2563EB)),
                          ),
                        if (partner.femaleCount > 0)
                          Expanded(
                            flex: partner.femaleCount,
                            child: Container(color: const Color(0xFFE11D48)),
                          ),
                        if (partner.unclassifiedCount > 0)
                          Expanded(
                            flex: partner.unclassifiedCount,
                            child: Container(color: const Color(0xFF64748B)),
                          ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 10),

          // Dettaglio Gender (M / F / N.C.) e Completati con percentuali
          Wrap(
            spacing: 16,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _buildGenderChipStat(
                const Color(0xFF2563EB),
                'M',
                partner.maleCount,
                malePct,
              ),
              _buildGenderChipStat(
                const Color(0xFFE11D48),
                'F',
                partner.femaleCount,
                femalePct,
              ),
              _buildGenderChipStat(
                const Color(0xFF64748B),
                'N.C.',
                partner.unclassifiedCount,
                unclassifiedPct,
              ),
              _buildGenderChipStat(
                const Color(0xFF16A34A),
                'Completati',
                partner.completedCount,
                partner.completionPercentage,
              ),
            ],
          ),

          // Dettaglio Ripartizione per Lingua
          if (sortedLangs.isNotEmpty) ...[
            const SizedBox(height: 10),
            const Divider(height: 1, thickness: 0.5),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.translate_rounded, size: 13, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        'Lingue:',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: sortedLangs.map((entry) {
                      final langCode = entry.key;
                      final count = entry.value;
                      final pct = total > 0 ? (count / total * 100) : 0.0;
                      final genderMap = partner.genderLangCounts[langCode] ?? {};
                      final m = genderMap['M'] ?? 0;
                      final f = genderMap['F'] ?? 0;
                      final nc = genderMap['N.C.'] ?? 0;

                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              langCode,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryBlue,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$count (${pct.toStringAsFixed(0)}%)',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            if (m > 0 || f > 0 || nc > 0) ...[
                              const SizedBox(width: 6),
                              if (m > 0)
                                _buildMiniGenderTag('M', m, const Color(0xFF2563EB)),
                              if (f > 0) ...[
                                const SizedBox(width: 3),
                                _buildMiniGenderTag('F', f, const Color(0xFFE11D48)),
                              ],
                              if (nc > 0) ...[
                                const SizedBox(width: 3),
                                _buildMiniGenderTag('N.C.', nc, const Color(0xFF64748B)),
                              ],
                            ],
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // --- Grafico Distribuzione Utenti Attivi per Fascia d'Età (<= 25 / > 25 anni con Genere e Lingua) ---
  Widget _buildAgeDistributionChart() {
    final grandTotal = _activeUsersCount > 0
        ? _activeUsersCount
        : _ageActiveStats.fold<int>(0, (sum, i) => sum + i.total);

    final le25Stat = _ageActiveStats.firstWhere(
      (s) => s.key == 'le25',
      orElse: () => AgeActiveStat(label: 'Età ≤ 25 anni', key: 'le25'),
    );
    final gt25Stat = _ageActiveStats.firstWhere(
      (s) => s.key == 'gt25',
      orElse: () => AgeActiveStat(label: 'Età > 25 anni', key: 'gt25'),
    );
    final unknownStat = _ageActiveStats.firstWhere(
      (s) => s.key == 'unknown',
      orElse: () => AgeActiveStat(label: 'Età non specificata', key: 'unknown'),
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card con titolo, legenda ed export
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 980;
              final titleWidget = Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.cake_rounded, color: Color(0xFF6366F1), size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Distribuzione Utenti Attivi per Fascia d\'Età',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Ripartizione utenti con età ≤ 25 anni e > 25 anni con dettaglio per genere e lingua',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ],
              );

              final actionsWidget = Wrap(
                spacing: 12,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _buildCourseLegendItem(const Color(0xFF2563EB), 'M (Maschile)'),
                  _buildCourseLegendItem(const Color(0xFFE11D48), 'F (Femminile)'),
                  _buildCourseLegendItem(const Color(0xFF64748B), 'N.C. (Non class.)'),
                  _buildCourseLegendItem(const Color(0xFF16A34A), 'Completati'),
                  const SizedBox(width: 4),
                  OutlinedButton.icon(
                    onPressed: (_ageActiveStats.isEmpty || _isExportingAge)
                        ? null
                        : _exportAgeToExcel,
                    icon: _isExportingAge
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF16A34A)),
                          )
                        : const Icon(Icons.table_view_rounded, size: 16),
                    label: Text(
                      _isExportingAge ? 'Esportazione...' : 'Esporta Excel',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF16A34A),
                      side: const BorderSide(color: Color(0xFF86EFAC)),
                      backgroundColor: const Color(0xFFF0FDF4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ],
              );

              if (isCompact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleWidget,
                    const SizedBox(height: 14),
                    actionsWidget,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: titleWidget),
                  const SizedBox(width: 16),
                  actionsWidget,
                ],
              );
            },
          ),
          const SizedBox(height: 20),

          // Barra di proporzione visiva (≤ 25 vs > 25 vs Non specificato)
          if (grandTotal > 0) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 16,
                width: double.infinity,
                color: Colors.grey.shade200,
                child: Row(
                  children: [
                    if (le25Stat.total > 0)
                      Expanded(
                        flex: le25Stat.total,
                        child: Container(color: const Color(0xFF6366F1)),
                      ),
                    if (gt25Stat.total > 0)
                      Expanded(
                        flex: gt25Stat.total,
                        child: Container(color: const Color(0xFF0284C7)),
                      ),
                    if (unknownStat.total > 0)
                      Expanded(
                        flex: unknownStat.total,
                        child: Container(color: const Color(0xFF94A3B8)),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 6,
              children: [
                _buildAgeProportionLegend(
                  const Color(0xFF6366F1),
                  '≤ 25 anni',
                  le25Stat.total,
                  grandTotal > 0 ? (le25Stat.total / grandTotal * 100) : 0,
                ),
                _buildAgeProportionLegend(
                  const Color(0xFF0284C7),
                  '> 25 anni',
                  gt25Stat.total,
                  grandTotal > 0 ? (gt25Stat.total / grandTotal * 100) : 0,
                ),
                if (unknownStat.total > 0)
                  _buildAgeProportionLegend(
                    const Color(0xFF94A3B8),
                    'Non specificato',
                    unknownStat.total,
                    grandTotal > 0 ? (unknownStat.total / grandTotal * 100) : 0,
                  ),
              ],
            ),
            const SizedBox(height: 20),
          ],

          // Card di dettaglio per ciascuna fascia d'età
          if (_ageActiveStats.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'Nessun dato disponibile sulla distribuzione per età.',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                ),
              ),
            )
          else
            ..._ageActiveStats.map((stat) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _buildAgeActiveRow(stat, grandTotal),
                )),
        ],
      ),
    );
  }

  Widget _buildAgeProportionLegend(Color color, String label, int count, double pct) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
        ),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
        ),
        Text(
          '$count (${pct.toStringAsFixed(1)}%)',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade800),
        ),
      ],
    );
  }

  Widget _buildAgeActiveRow(AgeActiveStat stat, int grandTotal) {
    final total = stat.total;
    final sharePct = grandTotal > 0 ? (total / grandTotal * 100) : 0.0;
    final malePct = total > 0 ? (stat.maleCount / total * 100) : 0.0;
    final femalePct = total > 0 ? (stat.femaleCount / total * 100) : 0.0;
    final unclassifiedPct = total > 0 ? (stat.unclassifiedCount / total * 100) : 0.0;

    final sortedLangs = stat.langCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final IconData bracketIcon;
    final Color bracketColor;
    if (stat.key == 'le25') {
      bracketIcon = Icons.school_rounded;
      bracketColor = const Color(0xFF6366F1);
    } else if (stat.key == 'gt25') {
      bracketIcon = Icons.workspace_premium_rounded;
      bracketColor = const Color(0xFF0284C7);
    } else {
      bracketIcon = Icons.help_outline_rounded;
      bracketColor = const Color(0xFF94A3B8);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Icona fascia, Etichetta fascia, Badge % su attivi, Badge completati, Badge totale
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: bracketColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(bracketIcon, size: 18, color: bracketColor),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stat.label,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      '${sharePct.toStringAsFixed(1)}% della popolazione utenti attivi',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF16A34A).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF16A34A).withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF16A34A)),
                        const SizedBox(width: 6),
                        Text(
                          '${stat.completedCount} completati (${stat.completionPercentage.toStringAsFixed(1)}%)',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF16A34A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: bracketColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: bracketColor.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.people_alt_rounded, size: 14, color: bracketColor),
                        const SizedBox(width: 6),
                        Text(
                          '$total attivi',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: bracketColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Stacked Progress Bar proporzionale per Gender
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Container(
              height: 12,
              width: double.infinity,
              color: Colors.grey.shade200,
              child: total == 0
                  ? const SizedBox.shrink()
                  : Row(
                      children: [
                        if (stat.maleCount > 0)
                          Expanded(
                            flex: stat.maleCount,
                            child: Container(color: const Color(0xFF2563EB)),
                          ),
                        if (stat.femaleCount > 0)
                          Expanded(
                            flex: stat.femaleCount,
                            child: Container(color: const Color(0xFFE11D48)),
                          ),
                        if (stat.unclassifiedCount > 0)
                          Expanded(
                            flex: stat.unclassifiedCount,
                            child: Container(color: const Color(0xFF64748B)),
                          ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 10),

          // Dettaglio Gender (M / F / N.C.) e Completati con percentuali
          Wrap(
            spacing: 16,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _buildGenderChipStat(
                const Color(0xFF2563EB),
                'M',
                stat.maleCount,
                malePct,
              ),
              _buildGenderChipStat(
                const Color(0xFFE11D48),
                'F',
                stat.femaleCount,
                femalePct,
              ),
              _buildGenderChipStat(
                const Color(0xFF64748B),
                'N.C.',
                stat.unclassifiedCount,
                unclassifiedPct,
              ),
              _buildGenderChipStat(
                const Color(0xFF16A34A),
                'Completati',
                stat.completedCount,
                stat.completionPercentage,
              ),
            ],
          ),

          // Dettaglio Ripartizione per Lingua
          if (sortedLangs.isNotEmpty) ...[
            const SizedBox(height: 10),
            const Divider(height: 1, thickness: 0.5),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.translate_rounded, size: 13, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        'Lingue:',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: sortedLangs.map((entry) {
                      final langCode = entry.key;
                      final count = entry.value;
                      final pct = total > 0 ? (count / total * 100) : 0.0;
                      final genderMap = stat.genderLangCounts[langCode] ?? {};
                      final m = genderMap['M'] ?? 0;
                      final f = genderMap['F'] ?? 0;
                      final nc = genderMap['N.C.'] ?? 0;

                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              langCode,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryBlue,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$count (${pct.toStringAsFixed(0)}%)',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            if (m > 0 || f > 0 || nc > 0) ...[
                              const SizedBox(width: 6),
                              if (m > 0)
                                _buildMiniGenderTag('M', m, const Color(0xFF2563EB)),
                              if (f > 0) ...[
                                const SizedBox(width: 3),
                                _buildMiniGenderTag('F', f, const Color(0xFFE11D48)),
                              ],
                              if (nc > 0) ...[
                                const SizedBox(width: 3),
                                _buildMiniGenderTag('N.C.', nc, const Color(0xFF64748B)),
                              ],
                            ],
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActiveUsersProgressChart() {
    final total = _activeUsersCount;
    final compPct = total > 0 ? (_totalCompleted / total * 100) : 0.0;
    final inProgPct = total > 0 ? (_totalInProgress / total * 100) : 0.0;
    final onlyEnrPct = total > 0 ? (_totalOnlyEnrolled / total * 100) : 0.0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 980;
              final titleWidget = Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.stacked_bar_chart_rounded, color: Color(0xFF059669), size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Stato Avanzamento Utenti Attivi',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Ripartizione tra Completati, In corso e Solo iscritti con distribuzione di genere',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ],
              );

              final actionsWidget = Wrap(
                spacing: 16,
                runSpacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _buildCourseLegendItem(const Color(0xFF2563EB), 'M (Maschile)'),
                  _buildCourseLegendItem(const Color(0xFFE11D48), 'F (Femminile)'),
                  _buildCourseLegendItem(const Color(0xFF64748B), 'N.C. (Non class.)'),
                  ElevatedButton.icon(
                    onPressed: (_activeUsersCount == 0 || _isExportingProgress) ? null : _exportProgressToExcel,
                    icon: _isExportingProgress
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.table_view_rounded, size: 16, color: Colors.white),
                    label: Text(
                      _isExportingProgress ? 'Esportazione...' : 'Esporta Excel',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF16A34A),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    ),
                  ),
                ],
              );

              if (isCompact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleWidget,
                    const SizedBox(height: 14),
                    actionsWidget,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: titleWidget),
                  const SizedBox(width: 16),
                  actionsWidget,
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 20),

          // Macro Barra Avanzamento Generale
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Progressione Complessiva Utenti Attivi',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                  ),
                  Text(
                    'Totale: $total utenti attivi',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 16,
                  width: double.infinity,
                  color: Colors.grey.shade200,
                  child: total == 0
                      ? const SizedBox.shrink()
                      : Row(
                          children: [
                            if (_totalCompleted > 0)
                              Expanded(
                                flex: _totalCompleted,
                                child: Container(color: const Color(0xFF10B981)),
                              ),
                            if (_totalInProgress > 0)
                              Expanded(
                                flex: _totalInProgress,
                                child: Container(color: const Color(0xFFF59E0B)),
                              ),
                            if (_totalOnlyEnrolled > 0)
                              Expanded(
                                flex: _totalOnlyEnrolled,
                                child: Container(color: const Color(0xFF94A3B8)),
                              ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 10),
              // Legenda Macro Barra
              Wrap(
                spacing: 16,
                runSpacing: 6,
                children: [
                  _buildMacroLegendItem(const Color(0xFF10B981), 'Completati', _totalCompleted, compPct),
                  _buildMacroLegendItem(const Color(0xFFF59E0B), 'In corso', _totalInProgress, inProgPct),
                  _buildMacroLegendItem(const Color(0xFF94A3B8), 'Solo iscritti', _totalOnlyEnrolled, onlyEnrPct),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 3 Cards di dettaglio per stato (Responsive Layout)
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 900;
              final cards = [
                _buildProgressStatusCard(
                  title: 'Completati',
                  subtitle: 'Hanno completato almeno un corso',
                  total: _totalCompleted,
                  totalCohort: total,
                  maleCount: _completedMale,
                  femaleCount: _completedFemale,
                  unclassifiedCount: _completedUnclass,
                  syncCount: _completedSync,
                  asyncCount: _completedAsync,
                  langCounts: _completedLangCounts,
                  icon: Icons.check_circle_rounded,
                  accentColor: const Color(0xFF10B981),
                  bgColor: const Color(0xFFECFDF5),
                  borderColor: const Color(0xFFA7F3D0),
                ),
                _buildProgressStatusCard(
                  title: 'In Corso',
                  subtitle: 'Hanno avviato attività senza completare',
                  total: _totalInProgress,
                  totalCohort: total,
                  maleCount: _inProgressMale,
                  femaleCount: _inProgressFemale,
                  unclassifiedCount: _inProgressUnclass,
                  syncCount: _inProgressSync,
                  asyncCount: _inProgressAsync,
                  langCounts: _inProgressLangCounts,
                  icon: Icons.hourglass_bottom_rounded,
                  accentColor: const Color(0xFFF59E0B),
                  bgColor: const Color(0xFFFFFBEB),
                  borderColor: const Color(0xFFFDE68A),
                ),
                _buildProgressStatusCard(
                  title: 'Solo Iscritti',
                  subtitle: 'Iscritti senza alcuna attività avviata',
                  total: _totalOnlyEnrolled,
                  totalCohort: total,
                  maleCount: _onlyEnrolledMale,
                  femaleCount: _onlyEnrolledFemale,
                  unclassifiedCount: _onlyEnrolledUnclass,
                  syncCount: _onlyEnrolledSync,
                  asyncCount: _onlyEnrolledAsync,
                  langCounts: _onlyEnrolledLangCounts,
                  icon: Icons.app_registration_rounded,
                  accentColor: const Color(0xFF64748B),
                  bgColor: const Color(0xFFF8FAFC),
                  borderColor: const Color(0xFFE2E8F0),
                ),
              ];

              if (isWide) {
                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: cards[0]),
                      const SizedBox(width: 16),
                      Expanded(child: cards[1]),
                      const SizedBox(width: 16),
                      Expanded(child: cards[2]),
                    ],
                  ),
                );
              } else {
                return Column(
                  children: [
                    cards[0],
                    const SizedBox(height: 16),
                    cards[1],
                    const SizedBox(height: 16),
                    cards[2],
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMacroLegendItem(Color color, String label, int count, double pct) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
        ),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
        ),
        Text(
          '$count (${pct.toStringAsFixed(1)}%)',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade900),
        ),
      ],
    );
  }

  Widget _buildProgressStatusCard({
    required String title,
    required String subtitle,
    required int total,
    required int totalCohort,
    required int maleCount,
    required int femaleCount,
    required int unclassifiedCount,
    required int syncCount,
    required int asyncCount,
    required Map<String, int> langCounts,
    required IconData icon,
    required Color accentColor,
    required Color bgColor,
    required Color borderColor,
  }) {
    final pctOfCohort = totalCohort > 0 ? (total / totalCohort * 100) : 0.0;
    final malePct = total > 0 ? (maleCount / total * 100) : 0.0;
    final femalePct = total > 0 ? (femaleCount / total * 100) : 0.0;
    final unclassPct = total > 0 ? (unclassifiedCount / total * 100) : 0.0;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: borderColor),
                ),
                child: Icon(icon, color: accentColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.toUpperCase(),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: accentColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Valore Principale
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$total',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '(${pctOfCohort.toStringAsFixed(1)}% attivi)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Stacked Progress Bar Genere
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              height: 10,
              width: double.infinity,
              color: Colors.white,
              child: total == 0
                  ? const SizedBox.shrink()
                  : Row(
                      children: [
                        if (maleCount > 0)
                          Expanded(
                            flex: maleCount,
                            child: Container(color: const Color(0xFF2563EB)),
                          ),
                        if (femaleCount > 0)
                          Expanded(
                            flex: femaleCount,
                            child: Container(color: const Color(0xFFE11D48)),
                          ),
                        if (unclassifiedCount > 0)
                          Expanded(
                            flex: unclassifiedCount,
                            child: Container(color: const Color(0xFF64748B)),
                          ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 12),

          // Breakdown Genere
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              _buildGenderChipStat(const Color(0xFF2563EB), 'M', maleCount, malePct),
              _buildGenderChipStat(const Color(0xFFE11D48), 'F', femaleCount, femalePct),
              _buildGenderChipStat(const Color(0xFF64748B), 'N.C.', unclassifiedCount, unclassPct),
            ],
          ),
          const SizedBox(height: 12),

          // Tipologia Corso (Sync / Async da Vista per Utente)
          Row(
            children: [
              Expanded(
                child: _buildTypeChipStat(
                  const Color(0xFF15803D),
                  const Color(0xFFF0FDF4),
                  const Color(0xFFBBF7D0),
                  Icons.groups_rounded,
                  'Sync',
                  syncCount,
                  total,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildTypeChipStat(
                  const Color(0xFF1D4ED8),
                  const Color(0xFFEFF6FF),
                  const Color(0xFFBFDBFE),
                  Icons.play_circle_outline_rounded,
                  'Async',
                  asyncCount,
                  total,
                ),
              ),
            ],
          ),

          // Distribuzione Lingue (Pref. Corso)
          if (langCounts.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.language_rounded, size: 13, color: Colors.grey.shade600),
                      const SizedBox(width: 5),
                      Text(
                        'Lingue (Pref. Corso):',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 5,
                    children: (langCounts.entries.toList()
                          ..sort((a, b) => b.value.compareTo(a.value)))
                        .map((e) {
                      final lPct = total > 0 ? (e.value / total * 100) : 0.0;
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F9FF),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: const Color(0xFFBAE6FD)),
                        ),
                        child: Text(
                          '${e.key}: ${e.value} (${lPct.toStringAsFixed(0)}%)',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0369A1),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // --- Grafico Distribuzione Totale Iscrizioni Corsi (Utenti Attivi) ---
  Widget _buildTotalCourseEnrollmentsActiveChart() {
    final total = _activeCourseEnrollmentsTotal;
    final compPct = total > 0 ? (_activeCourseEnrollmentsCompleted / total * 100) : 0.0;
    final otherPct = total > 0 ? (_activeEnrOther / total * 100) : 0.0;
    final inProgPct = total > 0 ? (_activeEnrInProgress / total * 100) : 0.0;
    final onlyEnrPct = total > 0 ? (_activeEnrOnlyEnrolled / total * 100) : 0.0;

    // Determinazione metriche in base al filtro selezionato
    final int currentTotal;
    final int currentMale;
    final int currentFemale;
    final int currentUnclass;
    final Map<String, int> currentLangCounts;
    final Map<String, Map<String, int>> currentGenderLangCounts;
    final String currentCohortTitle;

    switch (_activeCourseEnrollmentFilter) {
      case 'completed':
        currentTotal = _activeCourseEnrollmentsCompleted;
        currentMale = _activeEnrCompMale;
        currentFemale = _activeEnrCompFemale;
        currentUnclass = _activeEnrCompUnclass;
        currentLangCounts = _activeEnrCompLangCounts;
        currentGenderLangCounts = _activeEnrCompGenderLangCounts;
        currentCohortTitle = 'Iscrizioni Completate';
        break;
      case 'other':
        currentTotal = _activeEnrOther;
        currentMale = _activeEnrOtherMale;
        currentFemale = _activeEnrOtherFemale;
        currentUnclass = _activeEnrOtherUnclass;
        currentLangCounts = _activeEnrOtherLangCounts;
        currentGenderLangCounts = _activeEnrOtherGenderLangCounts;
        currentCohortTitle = 'Altri (In corso + Solo iscritti)';
        break;
      case 'in_progress':
        currentTotal = _activeEnrInProgress;
        currentMale = _activeEnrInProgMale;
        currentFemale = _activeEnrInProgFemale;
        currentUnclass = _activeEnrInProgUnclass;
        currentLangCounts = _activeEnrInProgLangCounts;
        currentGenderLangCounts = _activeEnrInProgGenderLangCounts;
        currentCohortTitle = 'Iscrizioni In Corso';
        break;
      case 'only_enrolled':
        currentTotal = _activeEnrOnlyEnrolled;
        currentMale = _activeEnrOnlyEnrMale;
        currentFemale = _activeEnrOnlyEnrFemale;
        currentUnclass = _activeEnrOnlyEnrUnclass;
        currentLangCounts = _activeEnrOnlyEnrLangCounts;
        currentGenderLangCounts = _activeEnrOnlyEnrGenderLangCounts;
        currentCohortTitle = 'Solo Iscritti';
        break;
      case 'all':
      default:
        currentTotal = _activeCourseEnrollmentsTotal;
        currentMale = _activeCourseEnrollmentsMale;
        currentFemale = _activeCourseEnrollmentsFemale;
        currentUnclass = _activeCourseEnrollmentsUnclassified;
        currentLangCounts = _activeCourseEnrollmentsLangCounts;
        currentGenderLangCounts = _activeCourseEnrollmentsGenderLangCounts;
        currentCohortTitle = 'Tutte le Iscrizioni Attive';
        break;
    }

    final malePct = currentTotal > 0 ? (currentMale / currentTotal) : 0.0;
    final femalePct = currentTotal > 0 ? (currentFemale / currentTotal) : 0.0;
    final unclassPct = currentTotal > 0 ? (currentUnclass / currentTotal) : 0.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card con Titolo, Sottotitolo e Badge informativi
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 820;

              final titleWidget = Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withAlpha(16),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.school_rounded, color: AppTheme.primaryBlue, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'DISTRIBUZIONE TOTALE ISCRIZIONI CORSI (UTENTI ATTIVI)',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.6,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Confronto tra Completati e Altri (In corso + Solo iscritti), con ripartizione per genere e lingua',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ],
              );

              final badgesWidget = Wrap(
                spacing: 8,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  // Badge Totale Iscrizioni Attive
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.people_alt_rounded, size: 14, color: Color(0xFF2563EB)),
                        const SizedBox(width: 5),
                        Text(
                          '$total Iscrizioni Attive',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D4ED8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Badge Completate
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFF86EFAC)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF16A34A)),
                        const SizedBox(width: 5),
                        Text(
                          '$_activeCourseEnrollmentsCompleted Completate (${compPct.toStringAsFixed(1)}%)',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF15803D),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Badge Altri
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFFDE68A)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.pending_actions_rounded, size: 14, color: Color(0xFFD97706)),
                        const SizedBox(width: 5),
                        Text(
                          '$_activeEnrOther Altri (${otherPct.toStringAsFixed(1)}%)',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFB45309),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Badge Sincrono / Asincrono
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAF5FF),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFE9D5FF)),
                    ),
                    child: Text(
                      'Sync: $_activeCourseEnrollmentsSync • Async: $_activeCourseEnrollmentsAsync',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7E22CE),
                      ),
                    ),
                  ),
                ],
              );

              if (isCompact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleWidget,
                    const SizedBox(height: 12),
                    badgesWidget,
                  ],
                );
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: titleWidget),
                  const SizedBox(width: 16),
                  badgesWidget,
                ],
              );
            },
          ),
          const SizedBox(height: 18),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 18),

          // --- 1. Macro Barra Proporzionale di Avanzamento Iscrizioni ---
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Stato Iscrizioni Attive (Completati vs Altri)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.4,
                      color: Color(0xFF334155),
                    ),
                  ),
                  Text(
                    'Totale: $total iscrizioni attive',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 16,
                  width: double.infinity,
                  color: Colors.grey.shade200,
                  child: total == 0
                      ? const SizedBox.shrink()
                      : Row(
                          children: [
                            if (_activeCourseEnrollmentsCompleted > 0)
                              Expanded(
                                flex: _activeCourseEnrollmentsCompleted,
                                child: Container(color: const Color(0xFF10B981)),
                              ),
                            if (_activeEnrInProgress > 0)
                              Expanded(
                                flex: _activeEnrInProgress,
                                child: Container(color: const Color(0xFFF59E0B)),
                              ),
                            if (_activeEnrOnlyEnrolled > 0)
                              Expanded(
                                flex: _activeEnrOnlyEnrolled,
                                child: Container(color: const Color(0xFF94A3B8)),
                              ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 16,
                runSpacing: 6,
                children: [
                  _buildMacroLegendItem(const Color(0xFF10B981), 'Completati', _activeCourseEnrollmentsCompleted, compPct),
                  _buildMacroLegendItem(const Color(0xFFF59E0B), 'In corso', _activeEnrInProgress, inProgPct),
                  _buildMacroLegendItem(const Color(0xFF94A3B8), 'Solo iscritti', _activeEnrOnlyEnrolled, onlyEnrPct),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // --- 2. Due Card Comparative Affiancate: Completati vs Altri (In corso + Solo iscritti) ---
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 860;
              final completedCard = _buildCohortSummaryCard(
                title: 'Iscrizioni Completate',
                subtitle: 'Corsi completati con successo dagli utenti attivi',
                count: _activeCourseEnrollmentsCompleted,
                totalCohort: total,
                maleCount: _activeEnrCompMale,
                femaleCount: _activeEnrCompFemale,
                unclassifiedCount: _activeEnrCompUnclass,
                langCounts: _activeEnrCompLangCounts,
                genderLangCounts: _activeEnrCompGenderLangCounts,
                accentColor: const Color(0xFF10B981),
                bgColor: const Color(0xFFF0FDF4),
                borderColor: const Color(0xFFA7F3D0),
                icon: Icons.check_circle_rounded,
              );

              final otherCard = _buildCohortSummaryCard(
                title: 'Altre Iscrizioni (Non Completate)',
                subtitle: 'In corso: $_activeEnrInProgress (${inProgPct.toStringAsFixed(1)}%) • Solo iscritti: $_activeEnrOnlyEnrolled (${onlyEnrPct.toStringAsFixed(1)}%)',
                count: _activeEnrOther,
                totalCohort: total,
                maleCount: _activeEnrOtherMale,
                femaleCount: _activeEnrOtherFemale,
                unclassifiedCount: _activeEnrOtherUnclass,
                langCounts: _activeEnrOtherLangCounts,
                genderLangCounts: _activeEnrOtherGenderLangCounts,
                accentColor: const Color(0xFFD97706),
                bgColor: const Color(0xFFFFFBEB),
                borderColor: const Color(0xFFFDE68A),
                icon: Icons.pending_actions_rounded,
              );

              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: completedCard),
                    const SizedBox(width: 16),
                    Expanded(child: otherCard),
                  ],
                );
              }

              return Column(
                children: [
                  completedCard,
                  const SizedBox(height: 14),
                  otherCard,
                ],
              );
            },
          ),
          const SizedBox(height: 22),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 16),

          // --- 3. Barra Selettore Filtro Dinamico Donut & Lingue ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ESPLORA DETTAGLIO COORTE:',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: Color(0xFF64748B),
                ),
              ),
              Text(
                'Visualizzazione: $currentCohortTitle',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildEnrollmentChoiceChip('all', 'Tutte ($total)'),
              _buildEnrollmentChoiceChip('completed', 'Completati ($_activeCourseEnrollmentsCompleted)'),
              _buildEnrollmentChoiceChip('other', 'Altri ($_activeEnrOther)'),
              _buildEnrollmentChoiceChip('in_progress', 'Di cui In corso ($_activeEnrInProgress)'),
              _buildEnrollmentChoiceChip('only_enrolled', 'Di cui Solo iscritti ($_activeEnrOnlyEnrolled)'),
            ],
          ),
          const SizedBox(height: 18),

          // --- 4. Donut Chart + Breakdown Genere della Coorte Selezionata ---
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 660;

              final donutWidget = Center(
                child: SizedBox(
                  width: 190,
                  height: 190,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(190, 190),
                        painter: _GenderDonutPainter(
                          male: currentMale,
                          female: currentFemale,
                          unclassified: currentUnclass,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$currentTotal',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Iscrizioni',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );

              final breakdownWidget = Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildGenderBar(
                    label: 'Iscrizioni Uomini (M)',
                    count: currentMale,
                    percentage: malePct,
                    color: const Color(0xFF2563EB),
                    bgColor: const Color(0xFFEFF6FF),
                    icon: Icons.male_rounded,
                  ),
                  const SizedBox(height: 12),
                  _buildGenderBar(
                    label: 'Iscrizioni Donne (F)',
                    count: currentFemale,
                    percentage: femalePct,
                    color: const Color(0xFFE11D48),
                    bgColor: const Color(0xFFFFF1F2),
                    icon: Icons.female_rounded,
                  ),
                  const SizedBox(height: 12),
                  _buildGenderBar(
                    label: 'Iscrizioni Non classificate',
                    count: currentUnclass,
                    percentage: unclassPct,
                    color: const Color(0xFF64748B),
                    bgColor: const Color(0xFFF8FAFC),
                    icon: Icons.help_outline_rounded,
                  ),
                ],
              );

              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 16),
                    donutWidget,
                    const SizedBox(width: 36),
                    Expanded(child: breakdownWidget),
                    const SizedBox(width: 16),
                  ],
                );
              }

              return Column(
                children: [
                  donutWidget,
                  const SizedBox(height: 24),
                  breakdownWidget,
                ],
              );
            },
          ),

          // --- 5. Sezione Lingua Iscrizioni per la Coorte Selezionata ---
          _buildTotalCourseEnrollmentsActiveLanguageSection(
            total: currentTotal,
            langCounts: currentLangCounts,
            genderLangCounts: currentGenderLangCounts,
            cohortName: currentCohortTitle,
          ),
        ],
      ),
    );
  }

  Widget _buildEnrollmentChoiceChip(String key, String label) {
    final isSelected = _activeCourseEnrollmentFilter == key;
    return ChoiceChip(
      selected: isSelected,
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected ? Colors.white : const Color(0xFF334155),
        ),
      ),
      selectedColor: AppTheme.primaryBlue,
      backgroundColor: const Color(0xFFF8FAFC),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected ? AppTheme.primaryBlue : Colors.grey.shade300,
        ),
      ),
      onSelected: (_) {
        setState(() {
          _activeCourseEnrollmentFilter = key;
        });
      },
    );
  }

  Widget _buildCohortSummaryCard({
    required String title,
    required String subtitle,
    required int count,
    required int totalCohort,
    required int maleCount,
    required int femaleCount,
    required int unclassifiedCount,
    required Map<String, int> langCounts,
    required Map<String, Map<String, int>> genderLangCounts,
    required Color accentColor,
    required Color bgColor,
    required Color borderColor,
    required IconData icon,
  }) {
    final pct = totalCohort > 0 ? (count / totalCohort * 100) : 0.0;
    final malePct = count > 0 ? (maleCount / count * 100) : 0.0;
    final femalePct = count > 0 ? (femaleCount / count * 100) : 0.0;
    final unclassPct = count > 0 ? (unclassifiedCount / count * 100) : 0.0;

    final sortedLangs = langCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card Comparativa
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: accentColor, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: borderColor),
                ),
                child: Text(
                  '$count (${pct.toStringAsFixed(1)}%)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Colors.black12),
          const SizedBox(height: 10),

          // Riga Dettaglio Genere
          Row(
            children: [
              Text(
                'Genere: ',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _buildMiniGenderTag('M', maleCount, const Color(0xFF2563EB)),
                    Text(
                      '(${malePct.toStringAsFixed(0)}%)',
                      style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 2),
                    _buildMiniGenderTag('F', femaleCount, const Color(0xFFE11D48)),
                    Text(
                      '(${femalePct.toStringAsFixed(0)}%)',
                      style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
                    ),
                    if (unclassifiedCount > 0) ...[
                      const SizedBox(width: 2),
                      _buildMiniGenderTag('N.C.', unclassifiedCount, const Color(0xFF64748B)),
                      Text(
                        '(${unclassPct.toStringAsFixed(0)}%)',
                        style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Riga Dettaglio Lingue
          if (sortedLangs.isNotEmpty) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    'Lingue: ',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 5,
                    children: sortedLangs.map((e) {
                      final lCount = e.value;
                      final lPct = count > 0 ? (lCount / count * 100) : 0.0;
                      final gMap = genderLangCounts[e.key] ?? {};
                      final m = gMap['M'] ?? 0;
                      final f = gMap['F'] ?? 0;
                      final nc = gMap['N.C.'] ?? 0;

                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${e.key}: $lCount (${lPct.toStringAsFixed(0)}%)',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '• M:$m F:$f${nc > 0 ? ' NC:$nc' : ''}',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTotalCourseEnrollmentsActiveLanguageSection({
    required int total,
    required Map<String, int> langCounts,
    required Map<String, Map<String, int>> genderLangCounts,
    required String cohortName,
  }) {
    if (langCounts.isEmpty) return const SizedBox.shrink();

    final sortedLangs = langCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 22),
        const Divider(height: 1, color: Color(0xFFF1F5F9)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0EA5E9).withAlpha(18),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.language_rounded, color: Color(0xFF0284C7), size: 18),
                ),
                const SizedBox(width: 10),
                Text(
                  'DISTRIBUZIONE LINGUE ($cohortName)'.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F9FF),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFBAE6FD)),
              ),
              child: Text(
                '${sortedLangs.length} lingu${sortedLangs.length == 1 ? 'a' : 'e'}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0284C7),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 12,
          runSpacing: 10,
          children: sortedLangs.map((entry) {
            final lang = entry.key;
            final count = entry.value;
            final pct = total > 0 ? (count / total * 100) : 0.0;
            final genderBreakdown = genderLangCounts[lang] ?? {};
            final mCount = genderBreakdown['M'] ?? 0;
            final fCount = genderBreakdown['F'] ?? 0;
            final ncCount = genderBreakdown['N.C.'] ?? 0;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0284C7).withAlpha(16),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          lang,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0284C7),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$count iscrizion${count == 1 ? 'e' : 'i'}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '(${pct.toStringAsFixed(1)}%)',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildMiniGenderTag('M', mCount, const Color(0xFF2563EB)),
                      const SizedBox(width: 6),
                      _buildMiniGenderTag('F', fCount, const Color(0xFFE11D48)),
                      if (ncCount > 0) ...[
                        const SizedBox(width: 6),
                        _buildMiniGenderTag('N.C.', ncCount, const Color(0xFF64748B)),
                      ],
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // --- Grafico Distribuzione Iscrizioni per Corso (Utenti Attivi con Gender) ---
  Widget _buildCourseEnrollmentGenderChart() {
    final displayedCourses = _showAllCourses
        ? _courseActiveStats
        : _courseActiveStats.take(8).toList();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card con titolo e legenda
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 980;
              final titleWidget = Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.bar_chart_rounded, color: AppTheme.primaryBlue, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Distribuzione Iscrizioni per Corso (Utenti Attivi)',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Ripartizione degli utenti attivi per corso e composizione di genere',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ],
              );

              final actionsWidget = Wrap(
                spacing: 12,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _buildCourseLegendItem(const Color(0xFF2563EB), 'M (Maschile)'),
                  _buildCourseLegendItem(const Color(0xFFE11D48), 'F (Femminile)'),
                  _buildCourseLegendItem(const Color(0xFF64748B), 'N.C. (Non class.)'),
                  const SizedBox(width: 4),
                  OutlinedButton.icon(
                    onPressed: (_courseActiveStats.isEmpty || _isExporting) ? null : _exportToExcel,
                    icon: _isExporting
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF16A34A)),
                          )
                        : const Icon(Icons.table_view_rounded, size: 16),
                    label: Text(
                      _isExporting ? 'Esportazione...' : 'Esporta Excel',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF16A34A),
                      side: const BorderSide(color: Color(0xFF86EFAC)),
                      backgroundColor: const Color(0xFFF0FDF4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ],
              );

              if (isCompact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleWidget,
                    const SizedBox(height: 14),
                    actionsWidget,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: titleWidget),
                  const SizedBox(width: 16),
                  actionsWidget,
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 20),

          if (_courseActiveStats.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 36),
                child: Column(
                  children: [
                    Icon(Icons.school_outlined, size: 40, color: Colors.grey.shade400),
                    const SizedBox(height: 10),
                    Text(
                      'Nessun dato di iscrizione attivo per i corsi sincronizzati',
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: displayedCourses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 18),
              itemBuilder: (context, index) {
                final course = displayedCourses[index];
                return _buildCourseEnrollmentRow(index + 1, course);
              },
            ),
            if (_courseActiveStats.length > 8) ...[
              const SizedBox(height: 16),
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _showAllCourses = !_showAllCourses;
                    });
                  },
                  icon: Icon(
                    _showAllCourses ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    size: 18,
                  ),
                  label: Text(
                    _showAllCourses
                        ? 'Mostra solo i principali 8 corsi'
                        : 'Mostra tutti i ${_courseActiveStats.length} corsi',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.primaryBlue,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildCourseLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildCourseEnrollmentRow(int rank, CourseActiveStat course) {
    final total = course.total;
    final malePct = total > 0 ? (course.maleCount / total * 100) : 0.0;
    final femalePct = total > 0 ? (course.femaleCount / total * 100) : 0.0;
    final unclassifiedPct = total > 0 ? (course.unclassifiedCount / total * 100) : 0.0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Riga Titolo Corso + Badge Tipo + Badges Totale e Completati
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: rank <= 3 ? AppTheme.primaryBlue : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '#$rank',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: rank <= 3 ? Colors.white : Colors.grey.shade700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.courseName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      course.courseShortname,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                alignment: WrapAlignment.end,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  // Badge Totale Attivi
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.people_alt_rounded, size: 14, color: AppTheme.primaryBlue),
                        const SizedBox(width: 6),
                        Text(
                          '$total attivi',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Badge Completati
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF86EFAC)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF16A34A)),
                        const SizedBox(width: 6),
                        Text(
                          '${course.completedCount} completati (${course.completionPercentage.toStringAsFixed(1)}%)',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF15803D),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Stacked Progress Bar proporzionale
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Container(
              height: 12,
              width: double.infinity,
              color: Colors.grey.shade200,
              child: total == 0
                  ? const SizedBox.shrink()
                  : Row(
                      children: [
                        if (course.maleCount > 0)
                          Expanded(
                            flex: course.maleCount,
                            child: Container(color: const Color(0xFF2563EB)),
                          ),
                        if (course.femaleCount > 0)
                          Expanded(
                            flex: course.femaleCount,
                            child: Container(color: const Color(0xFFE11D48)),
                          ),
                        if (course.unclassifiedCount > 0)
                          Expanded(
                            flex: course.unclassifiedCount,
                            child: Container(color: const Color(0xFF64748B)),
                          ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 10),

          // Dettaglio Gender (M / F / N.C.) con percentuali + Info Completamento
          Wrap(
            spacing: 16,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _buildGenderChipStat(
                const Color(0xFF2563EB),
                'M',
                course.maleCount,
                malePct,
              ),
              _buildGenderChipStat(
                const Color(0xFFE11D48),
                'F',
                course.femaleCount,
                femalePct,
              ),
              _buildGenderChipStat(
                const Color(0xFF64748B),
                'N.C.',
                course.unclassifiedCount,
                unclassifiedPct,
              ),
              Container(
                height: 12,
                width: 1,
                color: Colors.grey.shade300,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.task_alt_rounded, size: 13, color: Color(0xFF16A34A)),
                  const SizedBox(width: 5),
                  Text(
                    'Completati: ',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Text(
                    '${course.completedCount} su $total (${course.completionPercentage.toStringAsFixed(1)}%)',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF15803D),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Informazioni per Lingua per ogni corso
          if (course.langCounts.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.language_rounded, size: 13, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      'Lingue:',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                ...(course.langCounts.entries.toList()
                      ..sort((a, b) => b.value.compareTo(a.value)))
                    .map((e) {
                  final lPct = total > 0 ? (e.value / total * 100) : 0.0;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F9FF),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: const Color(0xFFBAE6FD)),
                    ),
                    child: Text(
                      '${e.key}: ${e.value} (${lPct.toStringAsFixed(0)}%)',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0369A1),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGenderChipStat(Color color, String label, int count, double pct) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
        Text(
          '$count (${pct.toStringAsFixed(1)}%)',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
      ],
    );
  }

  Widget _buildTypeChipStat(
    Color textColor,
    Color bgColor,
    Color borderColor,
    IconData icon,
    String label,
    int count,
    int total,
  ) {
    final pct = total > 0 ? (count / total * 100) : 0.0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          Flexible(
            child: Text(
              '$count (${pct.toStringAsFixed(1)}%)',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // SEZIONE STATISTICHE FEEDBACK (feedback_for_bi)
  // ===========================================================================

  Widget _buildOverallFeedbackByLangChart() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card con Titolo e Badge Media Globale
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 800;
              final titleWidget = Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.star_rounded, color: Color(0xFFD97706), size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'VALUTAZIONE MEDIA FEEDBACK PER LINGUA (GENERALE)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Media generale delle valutazioni (HQ1-HQ4) dei questionari compilati, suddivisa per lingua',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ],
              );

              final statsWidget = Wrap(
                spacing: 10,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFDE68A)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.stars_rounded, size: 16, color: Color(0xFFD97706)),
                        const SizedBox(width: 6),
                        Text(
                          'Media Piattaforma: ${_overallFeedbackAverage > 0 ? _overallFeedbackAverage.toStringAsFixed(2) : '-'} / 5.0',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF92400E),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.rate_review_outlined, size: 16, color: Color(0xFF475569)),
                        const SizedBox(width: 6),
                        Text(
                          '$_totalFeedbackCount questionari',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF334155),
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
                    const SizedBox(height: 14),
                    statsWidget,
                  ],
                );
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: titleWidget),
                    const SizedBox(width: 16),
                    statsWidget,
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 20),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 20),

          if (_feedbackLangStats.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Center(
                child: Text(
                  'Nessun dato di feedback presente nel database locale. Esegui la sincronizzazione per visualizzare le metriche.',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = constraints.maxWidth >= 900
                    ? (constraints.maxWidth - 20) / 2
                    : constraints.maxWidth;

                return Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: _feedbackLangStats.map((stat) {
                    return SizedBox(
                      width: cardWidth,
                      child: _buildLangFeedbackCard(stat),
                    );
                  }).toList(),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildLangFeedbackCard(FeedbackLangStat stat) {
    final avg = stat.averageScore;
    final color = avg >= 4.0
        ? const Color(0xFF16A34A)
        : (avg >= 3.0 ? const Color(0xFFD97706) : const Color(0xFFDC2626));

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.2)),
                    ),
                    child: Text(
                      stat.lang,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${stat.count} risposte (${stat.textCount} commenti)',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: color.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star_rounded, size: 15, color: color),
                    const SizedBox(width: 4),
                    Text(
                      '${avg.toStringAsFixed(2)} / 5.0',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          const SizedBox(height: 14),
          _buildFeedbackHqProgressRow('HQ1 (Rilevanza & Chiarezza)', stat.avgHq1),
          const SizedBox(height: 10),
          _buildFeedbackHqProgressRow('HQ2 (Efficacia Docente/Materiali)', stat.avgHq2),
          const SizedBox(height: 10),
          _buildFeedbackHqProgressRow('HQ3 (Piattaforma & Fruibilità)', stat.avgHq3),
          const SizedBox(height: 10),
          _buildFeedbackHqProgressRow('HQ4 (Soddisfazione Complessiva)', stat.avgHq4),
        ],
      ),
    );
  }

  Widget _buildFeedbackHqProgressRow(String label, double value) {
    final clamped = (value / 5.0).clamp(0.0, 1.0);
    final color = value >= 4.0
        ? const Color(0xFF16A34A)
        : (value >= 3.0 ? const Color(0xFFD97706) : const Color(0xFFDC2626));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${value.toStringAsFixed(2)} / 5',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: clamped,
            minHeight: 6,
            backgroundColor: const Color(0xFFE2E8F0),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildCourseFeedbackByLangChart() {
    final query = _feedbackCourseSearchQuery.trim().toLowerCase();
    final filtered = _courseFeedbackStats.where((c) {
      if (query.isEmpty) return true;
      final idStr = c.courseId.toString();
      final name = c.courseName.toLowerCase();
      final short = c.courseShortname.toLowerCase();
      return idStr.contains(query) || name.contains(query) || short.contains(query);
    }).toList();

    final displayedCourses = _showAllFeedbackCourses
        ? filtered
        : filtered.take(8).toList();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card con Titolo, Ricerca ed Export Excel
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 980;

              final titleWidget = Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.school_rounded, color: AppTheme.primaryBlue, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'MEDIA FEEDBACK PER CORSO E SUDDIVISIONE PER LINGUA',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Valutazione media delle risposte aggregate per ID corso e dettaglio delle medie per singola lingua',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ],
              );

              final actionsWidget = Wrap(
                spacing: 12,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(
                    width: 220,
                    height: 36,
                    child: TextField(
                      onChanged: (val) {
                        setState(() {
                          _feedbackCourseSearchQuery = val;
                        });
                      },
                      style: const TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        hintText: 'Cerca per ID o nome...',
                        hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                        prefixIcon: const Icon(Icons.search, size: 16),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: (_courseFeedbackStats.isEmpty || _isExportingFeedback)
                        ? null
                        : _exportFeedbackToExcel,
                    icon: _isExportingFeedback
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.table_view_rounded, size: 16),
                    label: const Text('Esporta Excel'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryBlue,
                      side: BorderSide(color: AppTheme.primaryBlue.withValues(alpha: 0.5)),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              );

              if (isCompact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleWidget,
                    const SizedBox(height: 16),
                    actionsWidget,
                  ],
                );
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: titleWidget),
                    const SizedBox(width: 16),
                    actionsWidget,
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 20),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 20),

          if (_courseFeedbackStats.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Center(
                child: Text(
                  'Nessun feedback presente nel database locale.',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ),
            )
          else if (displayedCourses.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Center(
                child: Text(
                  'Nessun corso corrisponde ai filtri di ricerca impostati.',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ),
            )
          else ...[
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: displayedCourses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final course = displayedCourses[index];
                return _buildCourseFeedbackRow(index + 1, course);
              },
            ),
            if (filtered.length > 8) ...[
              const SizedBox(height: 16),
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _showAllFeedbackCourses = !_showAllFeedbackCourses;
                    });
                  },
                  icon: Icon(
                    _showAllFeedbackCourses ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    size: 18,
                  ),
                  label: Text(
                    _showAllFeedbackCourses
                        ? 'Mostra solo i principali 8 corsi'
                        : 'Mostra tutti i ${filtered.length} corsi',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.primaryBlue,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildCourseFeedbackRow(int rank, CourseFeedbackStat course) {
    final avg = course.overallAverage;
    final color = avg >= 4.0
        ? const Color(0xFF16A34A)
        : (avg >= 3.0 ? const Color(0xFFD97706) : const Color(0xFFDC2626));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: rank <= 3 ? AppTheme.primaryBlue : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '#$rank',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: rank <= 3 ? Colors.white : Colors.grey.shade700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  'ID: ${course.courseId}',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF334155),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.courseName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    if (course.courseShortname.isNotEmpty && course.courseShortname != course.courseName)
                      Text(
                        course.courseShortname,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Badge Totale Feedback Corso
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFC7D2FE)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.reviews_outlined, size: 13, color: Color(0xFF4F46E5)),
                    const SizedBox(width: 5),
                    Text(
                      '${course.totalFeedbackCount} feedback',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4F46E5),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Badge Media Corso
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: color.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star_rounded, size: 14, color: color),
                    const SizedBox(width: 4),
                    Text(
                      '${avg.toStringAsFixed(2)} / 5.0',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          const SizedBox(height: 12),

          // Suddivisione Medie per Lingua per questo Corso
          Wrap(
            spacing: 8,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text(
                'Medie per Lingua:',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF475569),
                ),
              ),
              ...course.sortedLanguages.map((lKey) {
                final lStat = course.langStats[lKey]!;
                final lAvg = lStat.averageScore;
                final lColor = lAvg >= 4.0
                    ? const Color(0xFF16A34A)
                    : (lAvg >= 3.0 ? const Color(0xFFD97706) : const Color(0xFFDC2626));

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          lStat.lang,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(Icons.star_rounded, size: 12, color: lColor),
                      const SizedBox(width: 2),
                      Text(
                        lAvg.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: lColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${lStat.count})',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}

class _GenderDonutPainter extends CustomPainter {
  final int male;
  final int female;
  final int unclassified;

  _GenderDonutPainter({
    required this.male,
    required this.female,
    required this.unclassified,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final total = male + female + unclassified;
    final center = Offset(size.width / 2, size.height / 2);
    const strokeWidth = 22.0;
    final radius = (size.width - strokeWidth) / 2;

    if (total == 0) {
      final paint = Paint()
        ..color = const Color(0xFFE2E8F0)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;
      canvas.drawCircle(center, radius, paint);
      return;
    }

    final rect = Rect.fromCircle(center: center, radius: radius);
    double startAngle = -3.141592653589793 / 2;

    final items = [
      (male, const Color(0xFF2563EB)),
      (female, const Color(0xFFE11D48)),
      (unclassified, const Color(0xFF64748B)),
    ];

    for (final item in items) {
      final count = item.$1;
      final color = item.$2;
      if (count > 0) {
        final sweepAngle = (count / total) * 2 * 3.141592653589793;
        final paint = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.butt;
        canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
        startAngle += sweepAngle;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _GenderDonutPainter oldDelegate) {
    return oldDelegate.male != male ||
        oldDelegate.female != female ||
        oldDelegate.unclassified != unclassified;
  }
}
