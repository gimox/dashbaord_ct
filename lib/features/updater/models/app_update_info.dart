class AppUpdateInfo {
  final String currentVersion;
  final String latestVersion;
  final String releaseName;
  final String releaseNotes;
  final DateTime? publishedAt;
  final String? downloadUrl;
  final String? assetName;
  final int? assetSize;
  final bool hasUpdate;
  final String htmlUrl;

  const AppUpdateInfo({
    required this.currentVersion,
    required this.latestVersion,
    required this.releaseName,
    required this.releaseNotes,
    this.publishedAt,
    this.downloadUrl,
    this.assetName,
    this.assetSize,
    required this.hasUpdate,
    required this.htmlUrl,
  });

  factory AppUpdateInfo.empty(String currentVersion) {
    return AppUpdateInfo(
      currentVersion: currentVersion,
      latestVersion: currentVersion,
      releaseName: '',
      releaseNotes: '',
      hasUpdate: false,
      htmlUrl: 'https://github.com/gimox/dashbaord_ct/releases',
    );
  }
}
