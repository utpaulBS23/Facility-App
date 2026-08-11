import '../models/door_lock_model.dart';

/// Static mock data store in the Data Layer for Door Access feature.
abstract final class DoorAccessMockData {
  /// Raw JSON map simulating backend response
  static const Map<String, dynamic> rawDoorStatusJson = {
    'facility_id': '1',
    'is_locked': true,
    'last_updated': '2026-08-11T18:00:00.000Z',
  };

  /// Pre-built mock DTO model
  static final DoorLockModel initialMockModel = DoorLockModel(
    facilityId: '1',
    isLocked: true,
    lastUpdated: DateTime.now().toIso8601String(),
  );

  /// Dynamically creates a mock DTO model for a given facilityId and lock state
  static DoorLockModel createMockModel({
    required String facilityId,
    required bool isLocked,
  }) {
    return DoorLockModel(
      facilityId: facilityId,
      isLocked: isLocked,
      lastUpdated: DateTime.now().toIso8601String(),
    );
  }
}
