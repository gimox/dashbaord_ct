import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart';

import '../models/app_update_info.dart';

class AppUpdateService {
  static const String githubOwner = 'gimox';
  static const String githubRepo = 'dashbaord_ct';

  /// Confronta due versioni semver (es. "1.1.0" vs "1.0.0").
  /// Restituisce > 0 se v1 > v2, < 0 se v1 < v2, 0 se uguali.
  static int compareSemVer(String v1, String v2) {
    String clean(String v) => v.trim().replaceAll(RegExp(r'^[vV]'), '').split('+').first.split('-').first;

    final parts1 = clean(v1).split('.').map((p) => int.tryParse(p) ?? 0).toList();
    final parts2 = clean(v2).split('.').map((p) => int.tryParse(p) ?? 0).toList();

    while (parts1.length < 3) {
      parts1.add(0);
    }
    while (parts2.length < 3) {
      parts2.add(0);
    }

    for (int i = 0; i < 3; i++) {
      if (parts1[i] > parts2[i]) return 1;
      if (parts1[i] < parts2[i]) return -1;
    }
    return 0;
  }

  /// Recupera la versione corrente dell'applicazione
  static Future<String> getCurrentAppVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return info.version.isNotEmpty ? info.version : '1.0.0';
    } catch (e) {
      debugPrint('[AppUpdateService] Errore lettura package_info: $e');
      return '1.0.0';
    }
  }

  /// Controlla la presenza di un aggiornamento su GitHub Releases
  static Future<AppUpdateInfo> checkForUpdate() async {
    final currentVersion = await getCurrentAppVersion();

    try {
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 10);

      // Endpoint GitHub per l'ultima release
      final uri = Uri.parse('https://api.github.com/repos/$githubOwner/$githubRepo/releases/latest');
      final request = await client.getUrl(uri);
      request.headers.set(HttpHeaders.userAgentHeader, 'CyberProTrainAdmin-App');
      request.headers.set(HttpHeaders.acceptHeader, 'application/vnd.github.v3+json');

      final response = await request.close();

      if (response.statusCode == 404) {
        // Nessuna release pubblicata finora
        return AppUpdateInfo.empty(currentVersion);
      }

      if (response.statusCode != 200) {
        throw HttpException('GitHub API ha risposto con codice ${response.statusCode}');
      }

      final bodyString = await response.transform(utf8.decoder).join();
      final Map<String, dynamic> data = jsonDecode(bodyString) as Map<String, dynamic>;

      final rawTagName = data['tag_name'] as String? ?? '';
      final latestVersion = rawTagName.replaceAll(RegExp(r'^[vV]'), '').trim();
      final releaseName = data['name'] as String? ?? rawTagName;
      final releaseNotes = data['body'] as String? ?? '';
      final htmlUrl = data['html_url'] as String? ?? 'https://github.com/$githubOwner/$githubRepo/releases';
      DateTime? publishedAt;
      if (data['published_at'] != null) {
        publishedAt = DateTime.tryParse(data['published_at'] as String);
      }

      final hasUpdate = compareSemVer(latestVersion, currentVersion) > 0;

      // Seleziona l'asset compatibile con il sistema operativo attuale
      final assets = (data['assets'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
      final selectedAsset = _selectPlatformAsset(assets);

      return AppUpdateInfo(
        currentVersion: currentVersion,
        latestVersion: latestVersion.isNotEmpty ? latestVersion : currentVersion,
        releaseName: releaseName,
        releaseNotes: releaseNotes,
        publishedAt: publishedAt,
        downloadUrl: selectedAsset?['browser_download_url'] as String?,
        assetName: selectedAsset?['name'] as String?,
        assetSize: selectedAsset?['size'] as int?,
        hasUpdate: hasUpdate,
        htmlUrl: htmlUrl,
      );
    } catch (e) {
      debugPrint('[AppUpdateService] Errore verifica aggiornamenti: $e');
      rethrow;
    }
  }

  /// Trova l'asset GitHub appropriato per la piattaforma corrente
  static Map<String, dynamic>? _selectPlatformAsset(List<Map<String, dynamic>> assets) {
    if (kIsWeb || assets.isEmpty) return null;

    if (Platform.isWindows) {
      // 1. Installer Setup exe
      for (final a in assets) {
        final name = (a['name'] as String? ?? '').toLowerCase();
        if (name.endsWith('_setup.exe') || (name.endsWith('.exe') && name.contains('setup'))) {
          return a;
        }
      }
      // 2. Qualsiasi exe
      for (final a in assets) {
        final name = (a['name'] as String? ?? '').toLowerCase();
        if (name.endsWith('.exe')) return a;
      }
      // 3. Zip Windows
      for (final a in assets) {
        final name = (a['name'] as String? ?? '').toLowerCase();
        if (name.endsWith('.zip') && name.contains('windows')) return a;
      }
    } else if (Platform.isMacOS) {
      // 1. DMG macOS
      for (final a in assets) {
        final name = (a['name'] as String? ?? '').toLowerCase();
        if (name.endsWith('.dmg')) return a;
      }
      // 2. Zip macOS
      for (final a in assets) {
        final name = (a['name'] as String? ?? '').toLowerCase();
        if (name.endsWith('.zip') && name.contains('macos')) return a;
      }
    } else if (Platform.isLinux) {
      // 1. tar.gz o AppImage Linux
      for (final a in assets) {
        final name = (a['name'] as String? ?? '').toLowerCase();
        if (name.endsWith('.tar.gz') || name.endsWith('.appimage') || name.endsWith('.deb')) {
          return a;
        }
      }
    }

    return null;
  }

  /// Scarica l'asset ed esegue l'installazione / apertura dell'aggiornamento
  static Future<void> downloadAndInstallUpdate(
    AppUpdateInfo info, {
    void Function(double progress, int downloaded, int total)? onProgress,
  }) async {
    if (kIsWeb) {
      throw UnsupportedError('Aggiornamento automatico non supportato su Web');
    }

    if (info.downloadUrl == null || info.downloadUrl!.isEmpty) {
      throw StateError('Nessun file di aggiornamento disponibile per questa piattaforma');
    }

    final tempDir = await getTemporaryDirectory();
    final filename = info.assetName ?? 'CyberProTrain_Update_${info.latestVersion}';
    final targetFile = File('${tempDir.path}/$filename');

    // Se esiste già un file parziale o precedente, rimuovilo
    if (await targetFile.exists()) {
      try {
        await targetFile.delete();
      } catch (_) {}
    }

    final client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 15);

    // Gestione download con redirect (GitHub ➔ AWS S3)
    Uri currentUri = Uri.parse(info.downloadUrl!);
    HttpClientRequest request = await client.getUrl(currentUri);
    request.headers.set(HttpHeaders.userAgentHeader, 'CyberProTrainAdmin-App');
    HttpClientResponse response = await request.close();

    int redirectCount = 0;
    while (response.isRedirect && redirectCount < 5) {
      redirectCount++;
      final redirectUrl = response.headers.value(HttpHeaders.locationHeader);
      if (redirectUrl == null) break;
      currentUri = Uri.parse(redirectUrl);
      request = await client.getUrl(currentUri);
      request.headers.set(HttpHeaders.userAgentHeader, 'CyberProTrainAdmin-App');
      response = await request.close();
    }

    if (response.statusCode != 200) {
      throw HttpException('Download fallito con codice HTTP ${response.statusCode}');
    }

    final totalBytes = response.contentLength > 0 ? response.contentLength : (info.assetSize ?? 0);
    int receivedBytes = 0;

    final sink = targetFile.openWrite();
    await for (final chunk in response) {
      receivedBytes += chunk.length;
      sink.add(chunk);
      if (totalBytes > 0) {
        onProgress?.call(receivedBytes / totalBytes, receivedBytes, totalBytes);
      }
    }
    await sink.flush();
    await sink.close();

    debugPrint('[AppUpdateService] File scaricato in: ${targetFile.path} ($receivedBytes byte)');

    // Esegui l'installazione in base alla piattaforma
    await _launchInstaller(targetFile.path);
  }

  /// Avvia l'installer o apre il file scaricato
  static Future<void> _launchInstaller(String filePath) async {
    if (kIsWeb) return;

    if (Platform.isWindows) {
      if (filePath.toLowerCase().endsWith('.exe')) {
        // Avvia l'installer Windows (Inno Setup no-admin)
        // Avviato in modalità disaccoppiata (detached)
        await Process.start(
          filePath,
          [],
          mode: ProcessStartMode.detached,
        );
        // Chiudi l'applicazione per consentire la sostituzione dei file
        exit(0);
      } else {
        // Se è uno zip, apri la cartella che lo contiene
        final parent = File(filePath).parent.path;
        await Process.start('explorer.exe', [parent], mode: ProcessStartMode.detached);
      }
    } else if (Platform.isMacOS) {
      // Apre il file .dmg con DiskImageMounter nel Finder
      await Process.start('open', [filePath], mode: ProcessStartMode.detached);
    } else if (Platform.isLinux) {
      if (filePath.toLowerCase().endsWith('.appimage')) {
        await Process.run('chmod', ['+x', filePath]);
        await Process.start(filePath, [], mode: ProcessStartMode.detached);
        exit(0);
      } else {
        final parent = File(filePath).parent.path;
        await Process.start('xdg-open', [parent], mode: ProcessStartMode.detached);
      }
    }
  }
}
