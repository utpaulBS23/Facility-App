/// Door lock entity representing lock status
class DoorLockEntity {
  final String facilityId;
  final bool isLocked;
  final DateTime lastUpdated;

  /// Indicates if data is from cache (offline)
  final bool cachedData;

  /// Indicates if sync is pending
  final bool syncPending;

  DoorLockEntity({
    required this.facilityId,
    required this.isLocked,
    required this.lastUpdated,
    this.cachedData = false,
    this.syncPending = false,
  });

  /// Getter for unlocked status
  bool get isUnlocked => !isLocked;

  /// Check if data is fresh (less than 5 minutes old)
  bool get isFresh {
    final age = DateTime.now().difference(lastUpdated);
    return age.inMinutes < 5;
  }

  /// Check if data needs refresh
  bool get needsRefresh => cachedData || !isFresh;

  /// User-friendly status message
  String get statusMessage {
    final lockStatus = isLocked ? 'LOCKED' : 'UNLOCKED';
    if (cachedData) {
      return '$lockStatus (offline data)';
    }
    if (syncPending) {
      return '$lockStatus (syncing...)';
    }
    return lockStatus;
  }

  /// Copy with modified fields
  DoorLockEntity copyWith({
    String? facilityId,
    bool? isLocked,
    DateTime? lastUpdated,
    bool? cachedData,
    bool? syncPending,
  }) {
    return DoorLockEntity(
      facilityId: facilityId ?? this.facilityId,
      isLocked: isLocked ?? this.isLocked,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      cachedData: cachedData ?? this.cachedData,
      syncPending: syncPending ?? this.syncPending,
    );
  }

  @override
  String toString() => 'DoorLockEntity('
      'facility: $facilityId, '
      'isLocked: $isLocked, '
      'cached: $cachedData, '
      'lastUpdated: $lastUpdated)';
}