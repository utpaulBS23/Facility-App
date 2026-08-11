import 'package:dart_mappable/dart_mappable.dart';

part 'door_lock_model.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class DoorLockModel with DoorLockModelMappable {
  const DoorLockModel({
    required this.facilityId,
    required this.isLocked,
    this.lastUpdated,
  });

  final String facilityId;
  final bool isLocked;
  final String? lastUpdated;
}
