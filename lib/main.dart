import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/universal_io.dart';
import 'package:window_manager/window_manager.dart';

import 'core/db/isar_provider.dart';
import 'core/navigation/app_router.dart';
import 'core/services/proxy_service.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/models/app_settings.dart';
import 'features/settings/providers/app_settings_provider.dart';
import 'features/sync/models/badge_user.dart';
import 'features/sync/models/category.dart';
import 'features/sync/models/course.dart';
import 'features/sync/models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inizializzazione Finestra Desktop
  if (!kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux)) {
    await windowManager.ensureInitialized();
    const windowOptions = WindowOptions(
      size: Size(1360, 800),
      minimumSize: Size(1000, 700),
      center: true,
      // backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );
    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  // 2. Inizializzazione Database Isar Locale
  String? dirPath;
  if (!kIsWeb) {
    final dir = await getApplicationSupportDirectory();
    if (!dir.existsSync()) {
      try {
        dir.createSync(recursive: true);
      } catch (_) {}
    }
    dirPath = dir.path;
  }

  final isar = await Isar.open(
    [AppSettingsSchema, UserSchema, CategorySchema, CourseSchema, BadgeUserSchema],
    directory: dirPath ?? '',
    inspector: !kIsWeb,
  );

  // Verifica difensiva su UserSchema per prevenire disallineamenti di schema in sviluppo
  try {
    await isar.users.where().findAll();
  } catch (e) {
    debugPrint('[Isar] Disallineamento schema User: $e. Pulizia tabella utenti.');
    await isar.writeTxn(() async => await isar.users.clear());
  }

  // Verifica difensiva su CategorySchema per prevenire disallineamenti di schema in sviluppo
  try {
    await isar.categories.where().findAll();
  } catch (e) {
    debugPrint('[Isar] Disallineamento schema Category: $e. Pulizia tabella categorie.');
    await isar.writeTxn(() async => await isar.categories.clear());
  }

  // Verifica difensiva su CourseSchema per prevenire disallineamenti di schema in sviluppo
  try {
    await isar.courses.where().findAll();
  } catch (e) {
    debugPrint('[Isar] Disallineamento schema Course: $e. Pulizia tabella corsi.');
    await isar.writeTxn(() async => await isar.courses.clear());
  }

  // Verifica difensiva su BadgeUserSchema per prevenire disallineamenti di schema in sviluppo
  try {
    await isar.badgeUsers.where().findAll();
  } catch (e) {
    debugPrint('[Isar] Disallineamento schema BadgeUser: $e. Pulizia tabella badges_users.');
    await isar.writeTxn(() async => await isar.badgeUsers.clear());
  }

  // 3. Inizializzazione Proxy Service con le impostazioni persistite
  AppSettings settings;
  try {
    settings = await isar.appSettings.get(0) ?? AppSettings();
    if (settings.id == 0 && (await isar.appSettings.count()) == 0) {
      await isar.writeTxn(() async => await isar.appSettings.put(settings));
    }
  } catch (e) {
    debugPrint('[Isar] Disallineamento schema AppSettings: $e. Ripristino impostazioni iniziali.');
    settings = AppSettings();
    await isar.writeTxn(() async {
      await isar.appSettings.clear();
      await isar.appSettings.put(settings);
    });
  }
  await ProxyService.initialize(settings);

  // 4. Avvio dell'Applicazione con Riverpod
  runApp(
    ProviderScope(
      overrides: [
        isarProvider.overrideWithValue(isar),
        appSettingsProvider.overrideWith(
          (ref) => AppSettingsNotifier(isar, initialSettings: settings),
        ),
      ],
      child: const EnterpriseApp(),
    ),
  );
}

class EnterpriseApp extends ConsumerWidget {
  const EnterpriseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'Enterprise App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
