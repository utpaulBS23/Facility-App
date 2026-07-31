import 'package:dart_mappable/dart_mappable.dart';

part 'leave_attendant_model.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class LeaveAttendantShiftModel with LeaveAttendantShiftModelMappable {
  const LeaveAttendantShiftModel({
    required this.id,
    required this.shiftName,
    required this.startTime,
    required this.endTime,
    this.status,
  });

  final int id;
  final String shiftName;
  final String startTime;
  final String endTime;
  final String? status;

  static const fromJson = LeaveAttendantShiftModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class LeaveAttendantModel with LeaveAttendantModelMappable {
  const LeaveAttendantModel({
    required this.id,
    required this.uid,
    required this.name,
    required this.facilityId,
    required this.facilityName,
    this.shift,
  });

  final int id;
  final String uid;
  final String name;
  final int facilityId;
  final String facilityName;
  final LeaveAttendantShiftModel? shift;

  static const fromJson = LeaveAttendantModelMapper.fromJson;
}
