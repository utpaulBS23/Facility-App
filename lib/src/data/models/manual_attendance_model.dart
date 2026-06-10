import 'package:dart_mappable/dart_mappable.dart';

part 'manual_attendance_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class ManualAttendanceDataModel with ManualAttendanceDataModelMappable {
  ManualAttendanceDataModel({
    required this.id,
    required this.shiftId,
    this.status,
    this.userName,
    this.shiftDate,
    this.checkInTime,
    this.checkOutTime,
    this.address,
    this.reason,
    this.approverName,
  });

  final int id;

  @MappableField(key: 'shift_id')
  final int shiftId;

  final String? status;

  @MappableField(key: 'user_name')
  final String? userName;

  @MappableField(key: 'shift_date')
  final String? shiftDate;

  @MappableField(key: 'check_in_time')
  final String? checkInTime;

  @MappableField(key: 'check_out_time')
  final String? checkOutTime;

  final String? address;
  final String? reason;

  @MappableField(key: 'approver_name')
  final String? approverName;

  static const fromJson = ManualAttendanceDataModelMapper.fromJson;
}
