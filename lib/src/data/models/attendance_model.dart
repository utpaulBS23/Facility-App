import 'package:dart_mappable/dart_mappable.dart';

part 'attendance_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class AttendanceSummaryModel with AttendanceSummaryModelMappable {
  AttendanceSummaryModel({
    this.presentCount,
    this.lateCount,
    this.absentCount,
    this.leaveCount,
  });

  @MappableField(key: 'present_count')
  final int? presentCount;

  @MappableField(key: 'late_count')
  final int? lateCount;

  @MappableField(key: 'absent_count')
  final int? absentCount;

  @MappableField(key: 'leave_count')
  final int? leaveCount;

  static const fromJson = AttendanceSummaryModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class AttendanceApproverModel with AttendanceApproverModelMappable {
  AttendanceApproverModel({required this.id, this.name, this.uid});

  final int id;
  final String? name;
  final String? uid;

  static const fromJson = AttendanceApproverModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class AttendanceShiftInfoModel with AttendanceShiftInfoModelMappable {
  AttendanceShiftInfoModel({
    required this.id,
    this.shiftType,
    this.startTime,
    this.endTime,
    this.facilityName,
  });

  final int id;

  @MappableField(key: 'shift_type')
  final String? shiftType;

  @MappableField(key: 'start_time')
  final String? startTime;

  @MappableField(key: 'end_time')
  final String? endTime;

  @MappableField(key: 'facility_name')
  final String? facilityName;

  static const fromJson = AttendanceShiftInfoModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class AttendanceItemModel with AttendanceItemModelMappable {
  AttendanceItemModel({
    required this.id,
    required this.userId,
    this.userName,
    this.userUid,
    this.date,
    this.status,
    this.isLate,
    this.checkInTime,
    this.checkOutTime,
    this.durationHours,
    this.attendanceType,
    this.location,
    this.reason,
    this.checkInSelfie,
    this.checkOutSelfie,
    this.shift,
    this.approver,
  });

  final int id;

  @MappableField(key: 'user_id')
  final int userId;

  @MappableField(key: 'user_name')
  final String? userName;

  @MappableField(key: 'user_uid')
  final String? userUid;

  final String? date;
  final String? status;

  @MappableField(key: 'is_late')
  final bool? isLate;

  @MappableField(key: 'check_in_time')
  final String? checkInTime;

  @MappableField(key: 'check_out_time')
  final String? checkOutTime;

  @MappableField(key: 'duration_hours')
  final num? durationHours;

  @MappableField(key: 'attendance_type')
  final String? attendanceType;

  final String? location;
  final String? reason;

  @MappableField(key: 'check_in_selfie')
  final String? checkInSelfie;

  @MappableField(key: 'check_out_selfie')
  final String? checkOutSelfie;

  final AttendanceShiftInfoModel? shift;
  final AttendanceApproverModel? approver;

  static const fromJson = AttendanceItemModelMapper.fromJson;
}
