import 'package:dart_mappable/dart_mappable.dart';

part 'check_in_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.encode)
class CheckInRequestModel with CheckInRequestModelMappable {
  CheckInRequestModel({
    required this.shiftSlotId,
    required this.lat,
    required this.lng,
    required this.selfieUrl,
  });

  @MappableField(key: 'shift_slot_id')
  final int shiftSlotId;
  final double lat;
  final double lng;
  @MappableField(key: 'selfie_url')
  final String selfieUrl;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class CheckInWarningModel with CheckInWarningModelMappable {
  CheckInWarningModel({this.code, this.message, this.reasonRequired});

  final String? code;
  final String? message;
  @MappableField(key: 'reason_required')
  final bool? reasonRequired;

  static const fromJson = CheckInWarningModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class CheckInDataModel with CheckInDataModelMappable {
  CheckInDataModel({
    required this.attendanceId,
    this.shiftSlotId,
    this.checkInTime,
    this.approvalStatus,
    this.checkInDistanceMeters,
    this.lateByMinutes,
    this.warnings = const [],
  });

  @MappableField(key: 'attendance_id')
  final int attendanceId;
  @MappableField(key: 'shift_slot_id')
  final int? shiftSlotId;
  @MappableField(key: 'check_in_time')
  final String? checkInTime;
  @MappableField(key: 'approval_status')
  final String? approvalStatus;
  @MappableField(key: 'check_in_distance_meters')
  final int? checkInDistanceMeters;
  @MappableField(key: 'late_by_minutes')
  final int? lateByMinutes;
  // WHY: the "clean check-in" example nests an empty `warnings` here; the
  // "late + outside geofence" example puts a populated `warnings` at the
  // response's top level instead. Both locations are parsed and merged in
  // the mapper since the backend hasn't settled on one.
  final List<CheckInWarningModel> warnings;

  static const fromJson = CheckInDataModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class CheckInResponseModel with CheckInResponseModelMappable {
  CheckInResponseModel({required this.data, this.warnings = const []});

  final CheckInDataModel data;
  final List<CheckInWarningModel> warnings;

  static const fromJson = CheckInResponseModelMapper.fromJson;
}
