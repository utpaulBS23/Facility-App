import '../models/door_lock_model.dart';

/// In-memory mock data source for door access / gateway controller
class DoorAccessMockDataSource {
  final Map<String, bool> _doorStateMap = {};

  Future<DoorLockModel> getDoorStatus(String facilityId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final isLocked = _doorStateMap[facilityId] ?? true;

    return DoorLockModel(
      facilityId: facilityId,
      isLocked: isLocked,
      lastUpdated: DateTime.now().toIso8601String(),
    );
  }

  Future<bool> unlockDoor(String facilityId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _doorStateMap[facilityId] = false;
    return true;
  }

  Future<bool> lockDoor(String facilityId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _doorStateMap[facilityId] = true;
    return true;
  }
}
