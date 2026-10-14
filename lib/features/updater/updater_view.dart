import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import 'providers/app_update_provider.dart';
import 'widgets/app_update_dialog.dart';

class UpdaterView extends ConsumerStatefulWidget {
  const UpdaterView({super.key});

  @override
  ConsumerState<UpdaterView> createState() => _UpdaterViewState();
}

class _UpdaterViewState extends ConsumerState<UpdaterView> {
  DateTime? _lastCheckedDate;

  @override
  void initState() {
    super.initState();
    // Esegui la verifica non appena si apre la schermata se non è già stata verificata
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(appUpdateProvider).status == AppUpdateStatus.idle) {
        _checkUpdates();
      }
    });
  }

  Future<void> _checkUpdates() async {
    setState(() => _lastCheckedDate = DateTime.now());
    await ref.read(appUpdateProvider.notifier).checkForUpdate();
  }

  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    var i = 0;
    double count = bytes.toDouble();
    while (count >= 1024 && i < suffixes.length - 1) {
      count /= 1024;
      i++;
    }
    return '${count.toStringAsFixed(1)} ${suffixes[i]}';
  }

  @override
  Widget build(BuildContext context) {
    final updateState = ref.watch(appUpdateProvider);
    final isChecking = updateState.status == AppUpdateStatus.checking;
    final isDownloading = updateState.status == AppUpdateStatus.downloading;
    final isCompleted = updateState.status == AppUpdateStatus.downloadCompleted;
    final hasUpdate = updateState.status == AppUpdateStatus.updateAvailable && updateState.info != null;
    final isUpToDate = updateState.status == AppUpdateStatus.upToDate;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(6),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withAlpha(15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.system_update_alt_rounded,
                          color: AppTheme.primaryBlue,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Aggiornamenti Applicazione',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryBlue,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Verifica e installa automaticamente le nuove versioni rilasciate su GitHub.',
                              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: (isChecking || isDownloading) ? null : _checkUpdates,
                        icon: isChecking
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.refresh_rounded, size: 18),
                        label: Text(isChecking ? 'Verifica...' : 'Controlla ora'),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlue,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Card Stato Versione
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
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
                              Icon(
                                isUpToDate
                                    ? Icons.check_circle_rounded
                                    : hasUpdate
                                        ? Icons.notification_important_rounded
                                        : Icons.info_outline_rounded,
                                color: isUpToDate
                                    ? Colors.green
                                    : hasUpdate
                                        ? Colors.orange.shade800
                                        : Colors.grey.shade700,
                                size: 22,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                isUpToDate
                                    ? 'Applicazione Aggiornata'
                                    : hasUpdate
                                        ? 'Nuova Versione Rilevata'
                                        : 'Stato Versioni',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          if (_lastCheckedDate != null)
                            Text(
                              'Ultimo controllo: ${DateFormat('dd/MM/yyyy HH:mm').format(_lastCheckedDate!)}',
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(height: 1),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Versione Installata',
                                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'v${updateState.info?.currentVersion ?? '1.0.0'}',
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: hasUpdate ? Colors.green.shade50 : Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: hasUpdate ? Colors.green.shade200 : Colors.grey.shade200,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Ultima Release Disponibile',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: hasUpdate ? Colors.green.shade800 : Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    updateState.info?.latestVersion != null
                                        ? 'v${updateState.info!.latestVersion}'
                                        : '-',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: hasUpdate ? Colors.green.shade800 : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      if (updateState.errorMessage != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  updateState.errorMessage!,
                                  style: TextStyle(color: Colors.red.shade900, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Card Dettaglio Aggiornamento Disponibile
                if (hasUpdate) ...[
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.primaryBlue.withAlpha(50)),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryBlue.withAlpha(10),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryBlue,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'v${updateState.info!.latestVersion}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              updateState.info!.releaseName,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            if (updateState.info!.assetSize != null && updateState.info!.assetSize! > 0)
                              Text(
                                _formatBytes(updateState.info!.assetSize!),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Note di rilascio:',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(maxHeight: 200),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: SingleChildScrollView(
                            child: Text(
                              updateState.info!.releaseNotes.isNotEmpty
                                  ? updateState.info!.releaseNotes
                                  : 'Nessuna nota aggiuntiva fornita per questa release.',
                              style: TextStyle(fontSize: 13, color: Colors.grey.shade800, height: 1.4),
                            ),
                          ),
                        ),

                        // Progress Bar Download
                        if (isDownloading) ...[
                          const SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Download in corso...',
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                  ),
                                  Text(
                                    '${(updateState.downloadProgress * 100).toStringAsFixed(0)}%',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryBlue,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: LinearProgressIndicator(
                                  value: updateState.downloadProgress > 0 ? updateState.downloadProgress : null,
                                  minHeight: 8,
                                  backgroundColor: Colors.grey.shade200,
                                  valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                                ),
                              ),
                            ],
                          ),
                        ],

                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () => AppUpdateDialog.show(context, updateState.info!),
                              icon: const Icon(Icons.open_in_new_rounded, size: 16),
                              label: const Text('Dettagli Modale'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            FilledButton.icon(
                              onPressed: isDownloading
                                  ? null
                                  : isCompleted
                                      ? null
                                      : () => ref.read(appUpdateProvider.notifier).startDownloadAndInstall(),
                              icon: isDownloading
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                    )
                                  : Icon(isCompleted ? Icons.check_circle : Icons.download_rounded),
                              label: Text(
                                isDownloading
                                    ? 'Download in corso...'
                                    : isCompleted
                                        ? 'Installazione avviata'
                                        : 'Scarica e Installa Ora',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              style: FilledButton.styleFrom(
                                backgroundColor: AppTheme.primaryBlue,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
