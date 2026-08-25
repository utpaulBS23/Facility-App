/// Domain enum representing update types.
enum UpdateType {
  none('none'),
  soft('soft'),
  hard('hard');

  const UpdateType(this.value);
  final String value;

  static UpdateType fromString(String? value) {
    return UpdateType.values.firstWhere(
      (e) => e.value.toLowerCase() == value?.toLowerCase(),
      orElse: () => UpdateType.none,
    );
  }
}

/// Domain enum representing installation sources.
enum InstallSource {
  sideload('sideload'),
  playStore('play_store');

  const InstallSource(this.value);
  final String value;

  static InstallSource fromString(String? value) {
    return InstallSource.values.firstWhere(
      (e) => e.value.toLowerCase() == value?.toLowerCase(),
      orElse: () => InstallSource.sideload,
    );
  }
}

/// Domain enum representing user update actions.
enum UpdateActionType {
  updated('updated'),
  skipped('skipped'),
  dismissed('dismissed');

  const UpdateActionType(this.value);
  final String value;

  static UpdateActionType fromString(String? value) {
    return UpdateActionType.values.firstWhere(
      (e) => e.value.toLowerCase() == value?.toLowerCase(),
      orElse: () => UpdateActionType.dismissed,
    );
  }
}

/// Domain enum representing the state of an in-app APK download.
enum DownloadStatus {
  idle,
  downloading,
  verifying,
  completed,
  error,
}

/// Domain entity tracking in-app download progress and state.
class DownloadProgressEntity {
  const DownloadProgressEntity({
    this.status = DownloadStatus.idle,
    this.receivedBytes = 0,
    this.totalBytes = 0,
    this.filePath,
    this.errorMessage,
  });

  final DownloadStatus status;
  final int receivedBytes;
  final int totalBytes;
  final String? filePath;
  final String? errorMessage;

  double get progress => totalBytes > 0 ? (receivedBytes / totalBytes) : 0.0;
  int get progressPercent => (progress * 100).clamp(0, 100).toInt();

  bool get isDownloading => status == DownloadStatus.downloading;
  bool get isVerifying => status == DownloadStatus.verifying;
  bool get isCompleted => status == DownloadStatus.completed;
  bool get isError => status == DownloadStatus.error;
}

/// Domain entity representing the version check response.
class AppUpdateCheckResponseEntity {
  const AppUpdateCheckResponseEntity({
    required this.updateType,
    required this.installSource,
    required this.eventId,
    this.latestVersionName,
    this.latestVersionCode,
    this.currentVersionName,
    this.currentVersionCode,
    this.changelog = const [],
    this.downloadUrl,
    this.fileSizeBytes,
    this.checksumSha256,
    this.storeUrl,
  });

  final UpdateType updateType;
  final InstallSource installSource;
  final int eventId;
  final String? latestVersionName;
  final int? latestVersionCode;
  final String? currentVersionName;
  final int? currentVersionCode;
  final List<String> changelog;
  final String? downloadUrl;
  final int? fileSizeBytes;
  final String? checksumSha256;
  final String? storeUrl;

  bool get isHardUpdate => updateType == UpdateType.hard;
  bool get isSoftUpdate => updateType == UpdateType.soft;
  bool get hasUpdate => isHardUpdate || isSoftUpdate;

  String? get updateUrl => switch (installSource) {
    InstallSource.sideload => downloadUrl ?? storeUrl,
    InstallSource.playStore => storeUrl ?? downloadUrl,
  };

  AppUpdateCheckResponseEntity copyWith({
    UpdateType? updateType,
    InstallSource? installSource,
    int? eventId,
    String? latestVersionName,
    int? latestVersionCode,
    String? currentVersionName,
    int? currentVersionCode,
    List<String>? changelog,
    String? downloadUrl,
    int? fileSizeBytes,
    String? checksumSha256,
    String? storeUrl,
  }) {
    return AppUpdateCheckResponseEntity(
      updateType: updateType ?? this.updateType,
      installSource: installSource ?? this.installSource,
      eventId: eventId ?? this.eventId,
      latestVersionName: latestVersionName ?? this.latestVersionName,
      latestVersionCode: latestVersionCode ?? this.latestVersionCode,
      currentVersionName: currentVersionName ?? this.currentVersionName,
      currentVersionCode: currentVersionCode ?? this.currentVersionCode,
      changelog: changelog ?? this.changelog,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      checksumSha256: checksumSha256 ?? this.checksumSha256,
      storeUrl: storeUrl ?? this.storeUrl,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppUpdateCheckResponseEntity &&
          runtimeType == other.runtimeType &&
          updateType == other.updateType &&
          installSource == other.installSource &&
          eventId == other.eventId &&
          latestVersionName == other.latestVersionName &&
          latestVersionCode == other.latestVersionCode &&
          currentVersionName == other.currentVersionName &&
          currentVersionCode == other.currentVersionCode &&
          downloadUrl == other.downloadUrl &&
          fileSizeBytes == other.fileSizeBytes &&
          checksumSha256 == other.checksumSha256 &&
          storeUrl == other.storeUrl;

  @override
  int get hashCode => Object.hash(
        updateType,
        installSource,
        eventId,
        latestVersionName,
        latestVersionCode,
        currentVersionName,
        currentVersionCode,
        downloadUrl,
        fileSizeBytes,
        checksumSha256,
        storeUrl,
      );
}

/// Domain entity representing an update action report request.
class AppUpdateActionRequestEntity {
  const AppUpdateActionRequestEntity({
    required this.eventId,
    required this.action,
  });

  final int eventId;
  final UpdateActionType action;
}

/// Domain entity holding device hardware and OS information.
class DeviceInfoEntity {
  const DeviceInfoEntity({
    required this.deviceId,
    required this.deviceModel,
    required this.osVersion,
    required this.versionCode,
    required this.versionName,
  });

  final String deviceId;
  final String deviceModel;
  final String osVersion;
  final int versionCode;
  final String versionName;
}
