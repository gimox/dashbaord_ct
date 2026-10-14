import 'dart:convert';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_io/universal_io.dart';
import '../../../core/db/isar_provider.dart';
import '../../settings/providers/app_settings_provider.dart';
import '../models/badge_user.dart';
import '../models/category.dart';
import '../models/course.dart';
import '../models/course_info.dart';
import '../models/merge_webex_user.dart';
import '../models/stat_mdl.dart';
import '../models/user.dart';
import '../models/user_course_enrolled.dart';

class GlobalSyncState {
  final bool isSyncing;
  final String currentOperation;
  final double progress; // 0.0 to 1.0
  final String? errorMessage;
  final String? successMessage;
  final DateTime? lastSyncTime;

  const GlobalSyncState({
    this.isSyncing = false,
    this.currentOperation = '',
    this.progress = 0.0,
    this.errorMessage,
    this.successMessage,
    this.lastSyncTime,
  });

  GlobalSyncState copyWith({
    bool? isSyncing,
    String? currentOperation,
    double? progress,
    String? errorMessage,
    String? successMessage,
    DateTime? lastSyncTime,
  }) {
    return GlobalSyncState(
      isSyncing: isSyncing ?? this.isSyncing,
      currentOperation: currentOperation ?? this.currentOperation,
      progress: progress ?? this.progress,
      errorMessage: errorMessage,
      successMessage: successMessage,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
    );
  }
}

class GlobalSyncNotifier extends StateNotifier<GlobalSyncState> {
  final Ref ref;

  GlobalSyncNotifier(this.ref) : super(const GlobalSyncState());

  Future<bool> syncAll() async {
    if (state.isSyncing) return false;

    final settings = ref.read(appSettingsProvider);
    final baseUrl = settings.apiBaseUrl.trim();
    final username = settings.apiUsername.trim();
    final password = settings.apiPassword;

    if (baseUrl.isEmpty) {
      state = state.copyWith(
        isSyncing: false,
        errorMessage: 'Base URL non configurato nei parametri API SERVER.',
      );
      return false;
    }

    state = state.copyWith(
      isSyncing: true,
      currentOperation: 'Inizializzazione sincronizzazione...',
      progress: 0.0,
      errorMessage: null,
      successMessage: null,
    );

    final isar = ref.read(isarProvider);
    final errors = <String>[];
    int totalSaved = 0;

    // Helper per chiamate HTTP generiche
    Future<List<dynamic>?> fetchEndpoint(String endpoint) async {
      try {
        var fullUrl = baseUrl;
        if (!fullUrl.endsWith('/')) {
          fullUrl += '/$endpoint';
        } else {
          fullUrl += endpoint;
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
          if (decoded is List) {
            return decoded;
          } else if (decoded is Map) {
            final map = Map<String, dynamic>.from(decoded);
            if (map.containsKey('username')) return [map];
            for (final key in ['users', 'categories', 'courses', 'badges_users', 'course_info', 'merge_webex_users', 'stat_mdl', 'user_course_enrolled', 'data', 'elements', 'records', 'results']) {
              if (map[key] is List) return map[key] as List;
            }
            for (final v in map.values) {
              if (v is List && v.isNotEmpty && v.first is Map) {
                return v;
              }
            }
          }
          return [];
        } else {
          throw Exception('HTTP ${response.statusCode}: $responseBody');
        }
      } catch (e) {
        debugPrint('[GlobalSync] Errore fetch $endpoint: $e');
        errors.add('$endpoint: $e');
        return null;
      }
    }

    try {
      // 1. Users
      state = state.copyWith(currentOperation: 'Sincronizzazione Utenti (1/8)...', progress: 0.125);
      final usersData = await fetchEndpoint('users');
      if (usersData != null && usersData.isNotEmpty) {
        final list = <User>[];
        for (final item in usersData) {
          if (item is Map) {
            try {
              list.add(User.fromJson(Map<String, dynamic>.from(item)));
            } catch (_) {}
          }
        }
        if (list.isNotEmpty) {
          await isar.writeTxn(() async => await isar.users.putAll(list));
          await ref.read(appSettingsProvider.notifier).updateUsersSyncDate(DateTime.now());
          totalSaved += list.length;
        }
      }

      // 2. Categories
      state = state.copyWith(currentOperation: 'Sincronizzazione Categorie (2/8)...', progress: 0.25);
      final categoriesData = await fetchEndpoint('categories');
      if (categoriesData != null && categoriesData.isNotEmpty) {
        final list = <Category>[];
        for (final item in categoriesData) {
          if (item is Map) {
            try {
              list.add(Category.fromJson(Map<String, dynamic>.from(item)));
            } catch (_) {}
          }
        }
        if (list.isNotEmpty) {
          await isar.writeTxn(() async => await isar.categories.putAll(list));
          await ref.read(appSettingsProvider.notifier).updateCategoriesSyncDate(DateTime.now());
          totalSaved += list.length;
        }
      }

      // 3. Courses
      state = state.copyWith(currentOperation: 'Sincronizzazione Corsi (3/8)...', progress: 0.375);
      final coursesData = await fetchEndpoint('courses');
      if (coursesData != null && coursesData.isNotEmpty) {
        final list = <Course>[];
        for (final item in coursesData) {
          if (item is Map) {
            try {
              list.add(Course.fromJson(Map<String, dynamic>.from(item)));
            } catch (_) {}
          }
        }
        if (list.isNotEmpty) {
          await isar.writeTxn(() async => await isar.courses.putAll(list));
          await ref.read(appSettingsProvider.notifier).updateCoursesSyncDate(DateTime.now());
          totalSaved += list.length;
        }
      }

      // 4. Badges Users
      state = state.copyWith(currentOperation: 'Sincronizzazione Badge Utenti (4/8)...', progress: 0.50);
      final badgesData = await fetchEndpoint('badges_users');
      if (badgesData != null && badgesData.isNotEmpty) {
        final list = <BadgeUser>[];
        for (final item in badgesData) {
          if (item is Map) {
            try {
              list.add(BadgeUser.fromJson(Map<String, dynamic>.from(item)));
            } catch (_) {}
          }
        }
        if (list.isNotEmpty) {
          await isar.writeTxn(() async => await isar.badgeUsers.putAll(list));
          await ref.read(appSettingsProvider.notifier).updateBadgesUsersSyncDate(DateTime.now());
          totalSaved += list.length;
        }
      }

      // 5. Course Info
      state = state.copyWith(currentOperation: 'Sincronizzazione Info Corsi (5/8)...', progress: 0.625);
      final courseInfoData = await fetchEndpoint('course_info');
      if (courseInfoData != null && courseInfoData.isNotEmpty) {
        final list = <CourseInfo>[];
        for (final item in courseInfoData) {
          if (item is Map) {
            try {
              list.add(CourseInfo.fromJson(Map<String, dynamic>.from(item)));
            } catch (_) {}
          }
        }
        if (list.isNotEmpty) {
          await isar.writeTxn(() async => await isar.courseInfos.putAll(list));
          await ref.read(appSettingsProvider.notifier).updateCourseInfoSyncDate(DateTime.now());
          totalSaved += list.length;
        }
      }

      // 6. Merge Webex Users
      state = state.copyWith(currentOperation: 'Sincronizzazione Utenti Webex (6/8)...', progress: 0.75);
      final webexData = await fetchEndpoint('merge_webex_users');
      if (webexData != null && webexData.isNotEmpty) {
        final list = <MergeWebexUser>[];
        for (final item in webexData) {
          if (item is Map) {
            try {
              list.add(MergeWebexUser.fromJson(Map<String, dynamic>.from(item)));
            } catch (_) {}
          }
        }
        if (list.isNotEmpty) {
          await isar.writeTxn(() async => await isar.mergeWebexUsers.putAll(list));
          await ref.read(appSettingsProvider.notifier).updateMergeWebexUsersSyncDate(DateTime.now());
          totalSaved += list.length;
        }
      }

      // 7. Stat Mdl
      state = state.copyWith(currentOperation: 'Sincronizzazione Statistiche Mdl (7/8)...', progress: 0.875);
      final statData = await fetchEndpoint('stat_mdl');
      if (statData != null && statData.isNotEmpty) {
        final list = <StatMdl>[];
        for (final item in statData) {
          if (item is Map) {
            try {
              list.add(StatMdl.fromJson(Map<String, dynamic>.from(item)));
            } catch (_) {}
          }
        }
        if (list.isNotEmpty) {
          await isar.writeTxn(() async => await isar.statMdls.putAll(list));
          await ref.read(appSettingsProvider.notifier).updateStatMdlSyncDate(DateTime.now());
          totalSaved += list.length;
        }
      }

      // 8. User Course Enrolled
      state = state.copyWith(currentOperation: 'Sincronizzazione Iscrizioni Corsi (8/8)...', progress: 1.0);
      final enrolledData = await fetchEndpoint('user_course_enrolled');
      if (enrolledData != null && enrolledData.isNotEmpty) {
        final list = <UserCourseEnrolled>[];
        for (final item in enrolledData) {
          if (item is Map) {
            try {
              list.add(UserCourseEnrolled.fromJson(Map<String, dynamic>.from(item)));
            } catch (_) {}
          }
        }
        if (list.isNotEmpty) {
          await isar.writeTxn(() async => await isar.userCourseEnrolleds.putAll(list));
          await ref.read(appSettingsProvider.notifier).updateUserCourseEnrolledSyncDate(DateTime.now());
          totalSaved += list.length;
        }
      }

      final now = DateTime.now();
      await ref.read(appSettingsProvider.notifier).updateLastSyncTime(now);

      final msg = errors.isEmpty
          ? 'Sincronizzazione completata: $totalSaved record salvati con successo.'
          : 'Sincronizzazione terminata con alcune segnalazioni su ${errors.length} endpoint.';

      state = state.copyWith(
        isSyncing: false,
        currentOperation: '',
        progress: 1.0,
        successMessage: msg,
        errorMessage: errors.isNotEmpty ? errors.join('\n') : null,
        lastSyncTime: now,
      );

      return errors.isEmpty;
    } catch (e) {
      state = state.copyWith(
        isSyncing: false,
        currentOperation: '',
        errorMessage: 'Errore generale di sincronizzazione: $e',
      );
      return false;
    }
  }
}

final globalSyncProvider = StateNotifierProvider<GlobalSyncNotifier, GlobalSyncState>((ref) {
  return GlobalSyncNotifier(ref);
});
