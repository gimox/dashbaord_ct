import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_update_info.dart';
import '../services/app_update_service.dart';

enum AppUpdateStatus {
  idle,
  checking,
  updateAvailable,
  upToDate,
  downloading,
  downloadCompleted,
  error,
}

class AppUpdateState {
  final AppUpdateStatus status;
  final AppUpdateInfo? info;
  final double downloadProgress;
  final int downloadedBytes;
  final int totalBytes;
  final String? errorMessage;

  const AppUpdateState({
    this.status = AppUpdateStatus.idle,
    this.info,
    this.downloadProgress = 0.0,
    this.downloadedBytes = 0,
    this.totalBytes = 0,
    this.errorMessage,
  });

  AppUpdateState copyWith({
    AppUpdateStatus? status,
    AppUpdateInfo? info,
    double? downloadProgress,
    int? downloadedBytes,
    int? totalBytes,
    String? errorMessage,
  }) {
    return AppUpdateState(
      status: status ?? this.status,
      info: info ?? this.info,
      downloadProgress: downloadProgress ?? this.downloadProgress,
      downloadedBytes: downloadedBytes ?? this.downloadedBytes,
      totalBytes: totalBytes ?? this.totalBytes,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class AppUpdateNotifier extends StateNotifier<AppUpdateState> {
  AppUpdateNotifier() : super(const AppUpdateState());

  /// Esegue la verifica di una nuova versione su GitHub Releases
  Future<AppUpdateInfo?> checkForUpdate({bool silent = false}) async {
    if (state.status == AppUpdateStatus.checking || state.status == AppUpdateStatus.downloading) {
      return state.info;
    }

    state = state.copyWith(
      status: AppUpdateStatus.checking,
      errorMessage: null,
    );

    try {
      final info = await AppUpdateService.checkForUpdate();
      if (info.hasUpdate) {
        state = state.copyWith(
          status: AppUpdateStatus.updateAvailable,
          info: info,
        );
      } else {
        state = state.copyWith(
          status: AppUpdateStatus.upToDate,
          info: info,
        );
      }
      return info;
    } catch (e) {
      state = state.copyWith(
        status: AppUpdateStatus.error,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
      return null;
    }
  }

  /// Scarica e avvia l'installazione dell'aggiornamento
  Future<void> startDownloadAndInstall() async {
    final info = state.info;
    if (info == null || !info.hasUpdate) return;

    state = state.copyWith(
      status: AppUpdateStatus.downloading,
      downloadProgress: 0.0,
      downloadedBytes: 0,
      totalBytes: info.assetSize ?? 0,
      errorMessage: null,
    );

    try {
      await AppUpdateService.downloadAndInstallUpdate(
        info,
        onProgress: (progress, downloaded, total) {
          state = state.copyWith(
            downloadProgress: progress,
            downloadedBytes: downloaded,
            totalBytes: total,
          );
        },
      );

      state = state.copyWith(status: AppUpdateStatus.downloadCompleted);
    } catch (e) {
      state = state.copyWith(
        status: AppUpdateStatus.error,
        errorMessage: 'Download fallito: $e',
      );
    }
  }

  void resetStatus() {
    state = state.copyWith(status: AppUpdateStatus.idle);
  }
}

final appUpdateProvider = StateNotifierProvider<AppUpdateNotifier, AppUpdateState>((ref) {
  return AppUpdateNotifier();
});
