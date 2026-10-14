import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import '../../../core/db/isar_provider.dart';
import '../../../core/services/proxy_service.dart';
import '../models/app_settings.dart';

final appSettingsProvider = StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
  final isar = ref.watch(isarProvider);
  return AppSettingsNotifier(isar);
});

class AppSettingsNotifier extends StateNotifier<AppSettings> {
  final Isar _isar;

  AppSettingsNotifier(this._isar, {AppSettings? initialSettings})
      : super(initialSettings ?? AppSettings()) {
    if (initialSettings == null) {
      _loadSettings();
    }
  }

  Future<void> _loadSettings() async {
    try {
      final settings = await _isar.appSettings.get(0);
      if (settings != null) {
        state = settings;
        return;
      }
    } catch (e) {
      debugPrint('[AppSettingsNotifier] Disallineamento schema AppSettings: $e.');
    }

    final initial = AppSettings();
    try {
      await _isar.writeTxn(() async {
        await _isar.appSettings.clear();
        await _isar.appSettings.put(initial);
      });
    } catch (_) {}
    state = initial;
  }

  Future<void> updateNetworkSettings({
    required bool proxyEnabled,
    required bool proxyAutoConfig,
    required String customProxyUrl,
    required bool bypassSslVerification,
    required String proxyUsername,
    required String proxyPassword,
  }) async {
    final updated = AppSettings()
      ..id = 0
      ..appName = state.appName
      ..sharepointSiteName = state.sharepointSiteName
      ..sharepointDocumentLibrary = state.sharepointDocumentLibrary
      ..syncOnStartup = state.syncOnStartup
      ..proxyEnabled = proxyEnabled
      ..proxyAutoConfig = proxyAutoConfig
      ..customProxyUrl = customProxyUrl
      ..bypassSslVerification = bypassSslVerification
      ..proxyUsername = proxyUsername
      ..proxyPassword = proxyPassword
      ..apiBaseUrl = state.apiBaseUrl
      ..apiUsername = state.apiUsername
      ..apiPassword = state.apiPassword
      ..apiTestEndpoint = state.apiTestEndpoint
      ..lastUsersSyncDate = state.lastUsersSyncDate
      ..lastCategoriesSyncDate = state.lastCategoriesSyncDate
      ..lastCoursesSyncDate = state.lastCoursesSyncDate
      ..lastBadgesUsersSyncDate = state.lastBadgesUsersSyncDate
      ..lastCourseInfoSyncDate = state.lastCourseInfoSyncDate
      ..lastMergeWebexUsersSyncDate = state.lastMergeWebexUsersSyncDate
      ..lastStatMdlSyncDate = state.lastStatMdlSyncDate
      ..lastUserCourseEnrolledSyncDate = state.lastUserCourseEnrolledSyncDate;

    await _isar.writeTxn(() async {
      await _isar.appSettings.put(updated);
    });

    state = updated;
    await ProxyService.initialize(updated);
  }

  Future<void> updateApiSettings({
    required String apiBaseUrl,
    required String apiUsername,
    required String apiPassword,
    required String apiTestEndpoint,
  }) async {
    final updated = AppSettings()
      ..id = 0
      ..appName = state.appName
      ..sharepointSiteName = state.sharepointSiteName
      ..sharepointDocumentLibrary = state.sharepointDocumentLibrary
      ..syncOnStartup = state.syncOnStartup
      ..proxyEnabled = state.proxyEnabled
      ..proxyAutoConfig = state.proxyAutoConfig
      ..customProxyUrl = state.customProxyUrl
      ..bypassSslVerification = state.bypassSslVerification
      ..proxyUsername = state.proxyUsername
      ..proxyPassword = state.proxyPassword
      ..apiBaseUrl = apiBaseUrl
      ..apiUsername = apiUsername
      ..apiPassword = apiPassword
      ..apiTestEndpoint = apiTestEndpoint
      ..lastUsersSyncDate = state.lastUsersSyncDate
      ..lastCategoriesSyncDate = state.lastCategoriesSyncDate
      ..lastCoursesSyncDate = state.lastCoursesSyncDate
      ..lastBadgesUsersSyncDate = state.lastBadgesUsersSyncDate
      ..lastCourseInfoSyncDate = state.lastCourseInfoSyncDate
      ..lastMergeWebexUsersSyncDate = state.lastMergeWebexUsersSyncDate
      ..lastStatMdlSyncDate = state.lastStatMdlSyncDate
      ..lastUserCourseEnrolledSyncDate = state.lastUserCourseEnrolledSyncDate;

    await _isar.writeTxn(() async {
      await _isar.appSettings.put(updated);
    });

    state = updated;
  }

  Future<void> updateUsersSyncDate(DateTime date) async {
    final updated = AppSettings()
      ..id = 0
      ..appName = state.appName
      ..sharepointSiteName = state.sharepointSiteName
      ..sharepointDocumentLibrary = state.sharepointDocumentLibrary
      ..syncOnStartup = state.syncOnStartup
      ..proxyEnabled = state.proxyEnabled
      ..proxyAutoConfig = state.proxyAutoConfig
      ..customProxyUrl = state.customProxyUrl
      ..bypassSslVerification = state.bypassSslVerification
      ..proxyUsername = state.proxyUsername
      ..proxyPassword = state.proxyPassword
      ..apiBaseUrl = state.apiBaseUrl
      ..apiUsername = state.apiUsername
      ..apiPassword = state.apiPassword
      ..apiTestEndpoint = state.apiTestEndpoint
      ..lastUsersSyncDate = date
      ..lastCategoriesSyncDate = state.lastCategoriesSyncDate
      ..lastCoursesSyncDate = state.lastCoursesSyncDate
      ..lastBadgesUsersSyncDate = state.lastBadgesUsersSyncDate
      ..lastCourseInfoSyncDate = state.lastCourseInfoSyncDate
      ..lastMergeWebexUsersSyncDate = state.lastMergeWebexUsersSyncDate
      ..lastStatMdlSyncDate = state.lastStatMdlSyncDate
      ..lastUserCourseEnrolledSyncDate = state.lastUserCourseEnrolledSyncDate;

    await _isar.writeTxn(() async {
      await _isar.appSettings.put(updated);
    });

    state = updated;
  }

  Future<void> updateCategoriesSyncDate(DateTime date) async {
    final updated = AppSettings()
      ..id = 0
      ..appName = state.appName
      ..sharepointSiteName = state.sharepointSiteName
      ..sharepointDocumentLibrary = state.sharepointDocumentLibrary
      ..syncOnStartup = state.syncOnStartup
      ..proxyEnabled = state.proxyEnabled
      ..proxyAutoConfig = state.proxyAutoConfig
      ..customProxyUrl = state.customProxyUrl
      ..bypassSslVerification = state.bypassSslVerification
      ..proxyUsername = state.proxyUsername
      ..proxyPassword = state.proxyPassword
      ..apiBaseUrl = state.apiBaseUrl
      ..apiUsername = state.apiUsername
      ..apiPassword = state.apiPassword
      ..apiTestEndpoint = state.apiTestEndpoint
      ..lastUsersSyncDate = state.lastUsersSyncDate
      ..lastCategoriesSyncDate = date
      ..lastCoursesSyncDate = state.lastCoursesSyncDate
      ..lastBadgesUsersSyncDate = state.lastBadgesUsersSyncDate
      ..lastCourseInfoSyncDate = state.lastCourseInfoSyncDate
      ..lastMergeWebexUsersSyncDate = state.lastMergeWebexUsersSyncDate
      ..lastStatMdlSyncDate = state.lastStatMdlSyncDate
      ..lastUserCourseEnrolledSyncDate = state.lastUserCourseEnrolledSyncDate;

    await _isar.writeTxn(() async {
      await _isar.appSettings.put(updated);
    });

    state = updated;
  }

  Future<void> updateCoursesSyncDate(DateTime date) async {
    final updated = AppSettings()
      ..id = 0
      ..appName = state.appName
      ..sharepointSiteName = state.sharepointSiteName
      ..sharepointDocumentLibrary = state.sharepointDocumentLibrary
      ..syncOnStartup = state.syncOnStartup
      ..proxyEnabled = state.proxyEnabled
      ..proxyAutoConfig = state.proxyAutoConfig
      ..customProxyUrl = state.customProxyUrl
      ..bypassSslVerification = state.bypassSslVerification
      ..proxyUsername = state.proxyUsername
      ..proxyPassword = state.proxyPassword
      ..apiBaseUrl = state.apiBaseUrl
      ..apiUsername = state.apiUsername
      ..apiPassword = state.apiPassword
      ..apiTestEndpoint = state.apiTestEndpoint
      ..lastUsersSyncDate = state.lastUsersSyncDate
      ..lastCategoriesSyncDate = state.lastCategoriesSyncDate
      ..lastCoursesSyncDate = date
      ..lastBadgesUsersSyncDate = state.lastBadgesUsersSyncDate
      ..lastCourseInfoSyncDate = state.lastCourseInfoSyncDate
      ..lastMergeWebexUsersSyncDate = state.lastMergeWebexUsersSyncDate
      ..lastStatMdlSyncDate = state.lastStatMdlSyncDate
      ..lastUserCourseEnrolledSyncDate = state.lastUserCourseEnrolledSyncDate;

    await _isar.writeTxn(() async {
      await _isar.appSettings.put(updated);
    });

    state = updated;
  }

  Future<void> updateBadgesUsersSyncDate(DateTime date) async {
    final updated = AppSettings()
      ..id = 0
      ..appName = state.appName
      ..sharepointSiteName = state.sharepointSiteName
      ..sharepointDocumentLibrary = state.sharepointDocumentLibrary
      ..syncOnStartup = state.syncOnStartup
      ..proxyEnabled = state.proxyEnabled
      ..proxyAutoConfig = state.proxyAutoConfig
      ..customProxyUrl = state.customProxyUrl
      ..bypassSslVerification = state.bypassSslVerification
      ..proxyUsername = state.proxyUsername
      ..proxyPassword = state.proxyPassword
      ..apiBaseUrl = state.apiBaseUrl
      ..apiUsername = state.apiUsername
      ..apiPassword = state.apiPassword
      ..apiTestEndpoint = state.apiTestEndpoint
      ..lastUsersSyncDate = state.lastUsersSyncDate
      ..lastCategoriesSyncDate = state.lastCategoriesSyncDate
      ..lastCoursesSyncDate = state.lastCoursesSyncDate
      ..lastBadgesUsersSyncDate = date
      ..lastCourseInfoSyncDate = state.lastCourseInfoSyncDate
      ..lastMergeWebexUsersSyncDate = state.lastMergeWebexUsersSyncDate
      ..lastStatMdlSyncDate = state.lastStatMdlSyncDate
      ..lastUserCourseEnrolledSyncDate = state.lastUserCourseEnrolledSyncDate;

    await _isar.writeTxn(() async {
      await _isar.appSettings.put(updated);
    });

    state = updated;
  }

  Future<void> updateCourseInfoSyncDate(DateTime date) async {
    final updated = AppSettings()
      ..id = 0
      ..appName = state.appName
      ..sharepointSiteName = state.sharepointSiteName
      ..sharepointDocumentLibrary = state.sharepointDocumentLibrary
      ..syncOnStartup = state.syncOnStartup
      ..proxyEnabled = state.proxyEnabled
      ..proxyAutoConfig = state.proxyAutoConfig
      ..customProxyUrl = state.customProxyUrl
      ..bypassSslVerification = state.bypassSslVerification
      ..proxyUsername = state.proxyUsername
      ..proxyPassword = state.proxyPassword
      ..apiBaseUrl = state.apiBaseUrl
      ..apiUsername = state.apiUsername
      ..apiPassword = state.apiPassword
      ..apiTestEndpoint = state.apiTestEndpoint
      ..lastUsersSyncDate = state.lastUsersSyncDate
      ..lastCategoriesSyncDate = state.lastCategoriesSyncDate
      ..lastCoursesSyncDate = state.lastCoursesSyncDate
      ..lastBadgesUsersSyncDate = state.lastBadgesUsersSyncDate
      ..lastCourseInfoSyncDate = date
      ..lastMergeWebexUsersSyncDate = state.lastMergeWebexUsersSyncDate
      ..lastStatMdlSyncDate = state.lastStatMdlSyncDate
      ..lastUserCourseEnrolledSyncDate = state.lastUserCourseEnrolledSyncDate;

    await _isar.writeTxn(() async {
      await _isar.appSettings.put(updated);
    });

    state = updated;
  }

  Future<void> updateMergeWebexUsersSyncDate(DateTime date) async {
    final updated = AppSettings()
      ..id = 0
      ..appName = state.appName
      ..sharepointSiteName = state.sharepointSiteName
      ..sharepointDocumentLibrary = state.sharepointDocumentLibrary
      ..syncOnStartup = state.syncOnStartup
      ..proxyEnabled = state.proxyEnabled
      ..proxyAutoConfig = state.proxyAutoConfig
      ..customProxyUrl = state.customProxyUrl
      ..bypassSslVerification = state.bypassSslVerification
      ..proxyUsername = state.proxyUsername
      ..proxyPassword = state.proxyPassword
      ..apiBaseUrl = state.apiBaseUrl
      ..apiUsername = state.apiUsername
      ..apiPassword = state.apiPassword
      ..apiTestEndpoint = state.apiTestEndpoint
      ..lastUsersSyncDate = state.lastUsersSyncDate
      ..lastCategoriesSyncDate = state.lastCategoriesSyncDate
      ..lastCoursesSyncDate = state.lastCoursesSyncDate
      ..lastBadgesUsersSyncDate = state.lastBadgesUsersSyncDate
      ..lastCourseInfoSyncDate = state.lastCourseInfoSyncDate
      ..lastMergeWebexUsersSyncDate = date
      ..lastStatMdlSyncDate = state.lastStatMdlSyncDate
      ..lastUserCourseEnrolledSyncDate = state.lastUserCourseEnrolledSyncDate;

    await _isar.writeTxn(() async {
      await _isar.appSettings.put(updated);
    });

    state = updated;
  }

  Future<void> updateStatMdlSyncDate(DateTime date) async {
    final updated = AppSettings()
      ..id = 0
      ..appName = state.appName
      ..sharepointSiteName = state.sharepointSiteName
      ..sharepointDocumentLibrary = state.sharepointDocumentLibrary
      ..syncOnStartup = state.syncOnStartup
      ..proxyEnabled = state.proxyEnabled
      ..proxyAutoConfig = state.proxyAutoConfig
      ..customProxyUrl = state.customProxyUrl
      ..bypassSslVerification = state.bypassSslVerification
      ..proxyUsername = state.proxyUsername
      ..proxyPassword = state.proxyPassword
      ..apiBaseUrl = state.apiBaseUrl
      ..apiUsername = state.apiUsername
      ..apiPassword = state.apiPassword
      ..apiTestEndpoint = state.apiTestEndpoint
      ..lastUsersSyncDate = state.lastUsersSyncDate
      ..lastCategoriesSyncDate = state.lastCategoriesSyncDate
      ..lastCoursesSyncDate = state.lastCoursesSyncDate
      ..lastBadgesUsersSyncDate = state.lastBadgesUsersSyncDate
      ..lastCourseInfoSyncDate = state.lastCourseInfoSyncDate
      ..lastMergeWebexUsersSyncDate = state.lastMergeWebexUsersSyncDate
      ..lastStatMdlSyncDate = date
      ..lastUserCourseEnrolledSyncDate = state.lastUserCourseEnrolledSyncDate;

    await _isar.writeTxn(() async {
      await _isar.appSettings.put(updated);
    });

    state = updated;
  }

  Future<void> updateUserCourseEnrolledSyncDate(DateTime date) async {
    final updated = AppSettings()
      ..id = 0
      ..appName = state.appName
      ..sharepointSiteName = state.sharepointSiteName
      ..sharepointDocumentLibrary = state.sharepointDocumentLibrary
      ..syncOnStartup = state.syncOnStartup
      ..proxyEnabled = state.proxyEnabled
      ..proxyAutoConfig = state.proxyAutoConfig
      ..customProxyUrl = state.customProxyUrl
      ..bypassSslVerification = state.bypassSslVerification
      ..proxyUsername = state.proxyUsername
      ..proxyPassword = state.proxyPassword
      ..apiBaseUrl = state.apiBaseUrl
      ..apiUsername = state.apiUsername
      ..apiPassword = state.apiPassword
      ..apiTestEndpoint = state.apiTestEndpoint
      ..lastUsersSyncDate = state.lastUsersSyncDate
      ..lastCategoriesSyncDate = state.lastCategoriesSyncDate
      ..lastCoursesSyncDate = state.lastCoursesSyncDate
      ..lastBadgesUsersSyncDate = state.lastBadgesUsersSyncDate
      ..lastCourseInfoSyncDate = state.lastCourseInfoSyncDate
      ..lastMergeWebexUsersSyncDate = state.lastMergeWebexUsersSyncDate
      ..lastStatMdlSyncDate = state.lastStatMdlSyncDate
      ..lastUserCourseEnrolledSyncDate = date;

    await _isar.writeTxn(() async {
      await _isar.appSettings.put(updated);
    });

    state = updated;
  }

  Future<void> updateLastSyncTime(DateTime date) async {
    final updated = AppSettings()
      ..id = 0
      ..appName = state.appName
      ..lastSyncTime = date
      ..sharepointSiteName = state.sharepointSiteName
      ..sharepointDocumentLibrary = state.sharepointDocumentLibrary
      ..syncOnStartup = state.syncOnStartup
      ..proxyEnabled = state.proxyEnabled
      ..proxyAutoConfig = state.proxyAutoConfig
      ..customProxyUrl = state.customProxyUrl
      ..bypassSslVerification = state.bypassSslVerification
      ..proxyUsername = state.proxyUsername
      ..proxyPassword = state.proxyPassword
      ..apiBaseUrl = state.apiBaseUrl
      ..apiUsername = state.apiUsername
      ..apiPassword = state.apiPassword
      ..apiTestEndpoint = state.apiTestEndpoint
      ..lastUsersSyncDate = state.lastUsersSyncDate
      ..lastCategoriesSyncDate = state.lastCategoriesSyncDate
      ..lastCoursesSyncDate = state.lastCoursesSyncDate
      ..lastBadgesUsersSyncDate = state.lastBadgesUsersSyncDate
      ..lastCourseInfoSyncDate = state.lastCourseInfoSyncDate
      ..lastMergeWebexUsersSyncDate = state.lastMergeWebexUsersSyncDate
      ..lastStatMdlSyncDate = state.lastStatMdlSyncDate
      ..lastUserCourseEnrolledSyncDate = state.lastUserCourseEnrolledSyncDate;

    await _isar.writeTxn(() async {
      await _isar.appSettings.put(updated);
    });

    state = updated;
  }
}

