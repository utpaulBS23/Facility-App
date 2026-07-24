import 'package:dart_mappable/dart_mappable.dart';

part 'leave_attendant_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class LeaveAttendantShiftModel with LeaveAttendantShiftModelMappable {
  const LeaveAttendantShiftModel({
    required this.id,
    this.shiftName = '',
    this.startTime = '',
    this.endTime = '',
    this.status = 'scheduled',
  });

  final int id;
  @MappableField(key: 'shift_name')
  final String shiftName;
  @MappableField(key: 'start_time')
  final String startTime;
  @MappableField(key: 'end_time')
  final String endTime;
  final String status;

  static const fromJson = LeaveAttendantShiftModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class LeaveAttendantModel with LeaveAttendantModelMappable {
  const LeaveAttendantModel({
    required this.id,
    this.uid = '',
    this.name = '',
    this.facilityId = 0,
    this.facilityName = '',
    this.shift,
  });

  final int id;
  final String uid;
  final String name;
  @MappableField(key: 'facility_id')
  final int facilityId;
  @MappableField(key: 'facility_name')
  final String facilityName;
  final LeaveAttendantShiftModel? shift;

  static const fromJson = LeaveAttendantModelMapper.fromJson;
}
