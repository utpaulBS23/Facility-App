import '../../domain/entities/door_lock_entity.dart';
import '../models/door_lock_model.dart';

extension DoorLockModelToEntity on DoorLockModel {
  DoorLockEntity toEntity() {
    return DoorLockEntity(
      facilityId: facilityId,
      isLocked: isLocked,
      lastUpdated: lastUpdated != null
          ? DateTime.tryParse(lastUpdated!) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
