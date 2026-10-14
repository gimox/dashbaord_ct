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
import '../exclusions/models/course_exclusion.dart';
import 'models/course_active_stat.dart';
import 'services/active_users_progress_excel_exporter.dart';
import 'services/course_active_stats_excel_exporter.dart';

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

class _HomeDashboardViewState extends ConsumerState<HomeDashboardView> {
  bool _isLoading = true;
  int _participatingUsersCount = 0;
  int _activeUsersCount = 0;
  int _enrolledUsersCount = 0;
  int _activeMaleCount = 0;
  int _activeFemaleCount = 0;
  int _activeUnclassifiedCount = 0;
  Map<String, int> _activeLangCounts = {};
  Map<String, Map<String, int>> _activeGenderLangCounts = {};

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
  StreamSubscription<void>? _statMdlSub;
  StreamSubscription<void>? _enrolledSub;
  StreamSubscription<void>? _usersSub;
  StreamSubscription<void>? _coursesSub;
  StreamSubscription<void>? _exclusionsSub;

  @override
  void initState() {
    super.initState();
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
  }

  @override
  void dispose() {
    _statMdlSub?.cancel();
    _enrolledSub?.cancel();
    _usersSub?.cancel();
    _coursesSub?.cancel();
    _exclusionsSub?.cancel();
    super.dispose();
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
      int maleCount = 0;
      int femaleCount = 0;
      int unclassifiedCount = 0;
      final Map<String, int> activeLangMap = {};
      final Map<String, Map<String, int>> activeGenderLangMap = {};

      for (final userId in uniqueEnrolledUsers) {
        final u = usersMap[userId];
        if (u != null && u.firstaccess != null && u.firstaccess! > 0) {
          uniqueActiveUsers.add(userId);

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
        }
      }

      // 4. Mappatura tipo corso (sync/async) e completamento corsi da validStats
      final Map<int, List<String>> courseTagsMap = {};
      final Set<String> completedCourseUserSet = {};

      for (final stat in validStats) {
        final cId = stat.idCorso;
        final uId = stat.userId;
        if (cId != null) {
          final tag = (stat.ntag ?? '').trim().toLowerCase();
          if (tag.isNotEmpty) {
            courseTagsMap.putIfAbsent(cId, () => []).add(tag);
          }
          if (uId != null) {
            final isCompleted = (stat.statoCompletamentoCorso ?? '').trim().toLowerCase() == 'completato' ||
                stat.dataCompletamentoCorso != null;
            if (isCompleted) {
              completedCourseUserSet.add('$cId-$uId');
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

      for (final item in validEnrolled) {
        final uId = item.userId;
        final cId = item.courseId;
        if (uId == null || cId == null) continue;

        // Considera SOLO utenti attivi (iscritti con firstaccess > 0)
        if (!uniqueActiveUsers.contains(uId)) continue;

        // Evita duplicati dello stesso utente nello stesso corso
        if (!processedCourseUser.add('$cId-$uId')) continue;

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
            courseType: resolveCourseType(cId),
          ),
        );

        if (completedCourseUserSet.contains('$cId-$uId')) {
          stat.completedCount++;
        }

        final u = usersMap[uId];
        if (u != null) {
          final rawGender = _getCustomFieldValue(u, ['gender', 'sesso', 'genere'])?.trim().toLowerCase() ?? '';
          if (rawGender == 'm' || rawGender.startsWith('masch') || rawGender == 'male') {
            stat.maleCount++;
          } else if (rawGender == 'f' || rawGender.startsWith('femm') || rawGender == 'female') {
            stat.femaleCount++;
          } else {
            stat.unclassifiedCount++;
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
        } else {
          stat.unclassifiedCount++;
          stat.langCounts['N.D.'] = (stat.langCounts['N.D.'] ?? 0) + 1;
        }
      }

      final sortedCourseStats = courseStatsMap.values.toList()
        ..sort((a, b) => b.total.compareTo(a.total));

      // 6. Calcolo suddivisione utenti attivi: Completati, In corso, Solo iscritti con gender e tipo corso (Sync / Async da Vista per Utente)
      final Set<int> completedActiveUserIds = {};
      final Set<int> startedActiveUserIds = {};

      // Raggruppamento delle attività per (uId, cId) esattamente come in Vista per Utente
      final Map<String, List<StatMdl>> userCourseStatMap = {};
      for (final stat in validStats) {
        final uId = stat.userId;
        final cId = stat.idCorso;
        if (uId == null || cId == null) continue;
        userCourseStatMap.putIfAbsent('$uId-$cId', () => []).add(stat);

        if (!uniqueActiveUsers.contains(uId)) continue;

        final st = (stat.statoCompletamentoCorso ?? '').trim().toLowerCase();
        final isCompleted = st == 'completato' || stat.dataCompletamentoCorso != null;
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

        // Corsi associati all'utente (iscritti o con attività), escludendo i corsi in blacklist
        final userCourses = <int>{
          ...?userEnrolledCourses[uId],
          for (final key in userCourseStatMap.keys)
            if (key.startsWith('$uId-')) int.tryParse(key.substring('$uId-'.length)) ?? 0,
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
          _courseActiveStats = sortedCourseStats;
          _activeUserDetails = activeUserDetailsList;
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
      body: SingleChildScrollView(
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

                // Grafico Totale Iscrizioni (Tutti i corsi: Genere e Lingua)
                _buildTotalEnrollmentsChart(),
                const SizedBox(height: 28),

                // Grafico Distribuzione Gender Utenti Attivi
                _buildGenderDistributionChart(),
                const SizedBox(height: 28),

                // Grafico Stato Avanzamento Utenti Attivi (Completati, In corso, Solo iscritti)
                _buildActiveUsersProgressChart(),
                const SizedBox(height: 28),

                // Grafico Distribuzione Iscrizioni per Corso (Utenti Attivi con Gender)
                _buildCourseEnrollmentGenderChart(),
              ],
            ),
          ),
        ),
      ),
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
    final total = _activeUsersCount;
    final malePct = total > 0 ? (_activeMaleCount / total) : 0.0;
    final femalePct = total > 0 ? (_activeFemaleCount / total) : 0.0;
    final unclassPct = total > 0 ? (_activeUnclassifiedCount / total) : 0.0;

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
                        'Ripartizione per genere calcolata sui $total utenti attivi',
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
                      '$total Utenti Attivi',
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
                          male: _activeMaleCount,
                          female: _activeFemaleCount,
                          unclassified: _activeUnclassifiedCount,
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
                            'Attivi',
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
                    count: _activeMaleCount,
                    percentage: malePct,
                    color: const Color(0xFF2563EB),
                    bgColor: const Color(0xFFEFF6FF),
                    icon: Icons.male_rounded,
                  ),
                  const SizedBox(height: 12),
                  _buildGenderBar(
                    label: 'Donne (F)',
                    count: _activeFemaleCount,
                    percentage: femalePct,
                    color: const Color(0xFFE11D48),
                    bgColor: const Color(0xFFFFF1F2),
                    icon: Icons.female_rounded,
                  ),
                  const SizedBox(height: 12),
                  _buildGenderBar(
                    label: 'Non classificato',
                    count: _activeUnclassifiedCount,
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
          _buildLanguageDistributionSection(),
        ],
      ),
    );
  }

  Widget _buildLanguageDistributionSection() {
    if (_activeLangCounts.isEmpty) return const SizedBox.shrink();

    final total = _activeUsersCount;
    final sortedLangs = _activeLangCounts.entries.toList()
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
                  'DISTRIBUZIONE PER LINGUA (USER\'S PREF COURSE LANG)',
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
            final genderBreakdown = _activeGenderLangCounts[lang] ?? {};
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
              final isCompact = constraints.maxWidth < 740;
              return Flex(
                direction: isCompact ? Axis.vertical : Axis.horizontal,
                crossAxisAlignment: isCompact ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
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
                      Column(
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
                    ],
                  ),
                  if (isCompact) const SizedBox(height: 14),
                  // Legenda Gender & Azione Esporta Excel
                  Wrap(
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
                  ),
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
              final isCompact = constraints.maxWidth < 720;
              return Flex(
                direction: isCompact ? Axis.vertical : Axis.horizontal,
                crossAxisAlignment: isCompact ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
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
                      Column(
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
                    ],
                  ),
                  if (isCompact) const SizedBox(height: 14),
                  // Legenda Gender & Azione Esporta Excel
                  Wrap(
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
                  ),
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
