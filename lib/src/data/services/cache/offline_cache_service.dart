import 'dart:convert';

import 'cache_service.dart';

/// Last known lock state for one facility, cached for offline reads.
class OfflineRelayStatus {
  OfflineRelayStatus({
    required this.facilityId,
    required this.isLocked,
    required this.lastUpdated,
  });

  final String facilityId;
  final bool isLocked;
  final DateTime lastUpdated;

  Map<String, dynamic> toJson() => {
    'facilityId': facilityId,
    'isLocked': isLocked,
    'lastUpdated': lastUpdated.toIso8601String(),
  };

  factory OfflineRelayStatus.fromJson(Map<String, dynamic> json) =>
      OfflineRelayStatus(
        facilityId: json['facilityId'] as String,
        isLocked: json['isLocked'] as bool,
        lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      );
}

/// A lock/unlock command that couldn't reach the gateway and is queued for
/// the next sync.
class OfflineDoorCommand {
  OfflineDoorCommand({
    required this.id,
    required this.facilityId,
    required this.unlock,
    required this.timestamp,
  });

  final String id;
  final String facilityId;
  final bool unlock;
  final DateTime timestamp;

  Map<String, dynamic> toJson() => {
    'id': id,
    'facilityId': facilityId,
    'unlock': unlock,
    'timestamp': timestamp.toIso8601String(),
  };

  factory OfflineDoorCommand.fromJson(Map<String, dynamic> json) =>
      OfflineDoorCommand(
        id: json['id'] as String,
        facilityId: json['facilityId'] as String,
        unlock: json['unlock'] as bool,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}

/// Offline cache for door lock state, backed by the app's shared
/// [CacheService] rather than a separate database — this feature's storage
/// needs (one status blob, one pending-command queue) don't warrant one.
class OfflineCacheService {
  OfflineCacheService(this._cache);

  final CacheService _cache;

  Future<void> saveRelayStatus(OfflineRelayStatus status) async {
    final all = _readStatusMap();
    all[status.facilityId] = status.toJson();
    await _cache.save<String>(CacheKey.doorLockStatusCache, jsonEncode(all));
  }

  OfflineRelayStatus? getRelayStatus(String facilityId) {
    final json = _readStatusMap()[facilityId];
    return json == null ? null : OfflineRelayStatus.fromJson(json);
  }

  Future<void> queueCommand(OfflineDoorCommand command) async {
    final commands = _readCommands()..add(command);
    await _writeCommands(commands);
  }

  List<OfflineDoorCommand> getPendingCommands() => _readCommands();

  Future<void> clearPendingCommands() async {
    await _cache.save<String>(
      CacheKey.doorLockPendingCommands,
      jsonEncode(<dynamic>[]),
    );
  }

  Future<void> clearAll() async {
    await _cache.remove([
      CacheKey.doorLockStatusCache,
      CacheKey.doorLockPendingCommands,
    ]);
  }

  Map<String, Map<String, dynamic>> _readStatusMap() {
    final raw = _cache.get<String>(CacheKey.doorLockStatusCache);
    if (raw == null) return {};
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map(
      (key, value) => MapEntry(key, value as Map<String, dynamic>),
    );
  }

  List<OfflineDoorCommand> _readCommands() {
    final raw = _cache.get<String>(CacheKey.doorLockPendingCommands);
    if (raw == null) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map(
          (json) => OfflineDoorCommand.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }

  Future<void> _writeCommands(List<OfflineDoorCommand> commands) async {
    final encoded = jsonEncode(commands.map((c) => c.toJson()).toList());
    await _cache.save<String>(CacheKey.doorLockPendingCommands, encoded);
  }
}
