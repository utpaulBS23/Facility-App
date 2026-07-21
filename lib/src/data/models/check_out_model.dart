import 'package:dart_mappable/dart_mappable.dart';

part 'check_out_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.encode)
class CheckOutRequestModel with CheckOutRequestModelMappable {
  CheckOutRequestModel({
    required this.attendanceId,
    required this.lat,
    required this.lng,
    required this.selfieUrl,
    this.reason,
  });

  @MappableField(key: 'attendance_id')
  final int attendanceId;
  final double lat;
  final double lng;
  @MappableField(key: 'selfie_url')
  final String selfieUrl;
  final String? reason;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class CheckOutWarningModel with CheckOutWarningModelMappable {
  CheckOutWarningModel({this.code, this.message, this.reasonRequired});

  final String? code;
  final String? message;
  @MappableField(key: 'reason_required')
  final bool? reasonRequired;

  static const fromJson = CheckOutWarningModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class CheckOutDataModel with CheckOutDataModelMappable {
  CheckOutDataModel({
    required this.attendanceId,
    this.checkInTime,
    this.checkOutTime,
    this.totalHours,
    this.approvalStatus,
  });

  @MappableField(key: 'attendance_id')
  final int attendanceId;
  @MappableField(key: 'check_in_time')
  final String? checkInTime;
  @MappableField(key: 'check_out_time')
  final String? checkOutTime;
  @MappableField(key: 'total_hours')
  final num? totalHours;
  @MappableField(key: 'approval_status')
  final String? approvalStatus;

  static const fromJson = CheckOutDataModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class CheckOutResponseModel with CheckOutResponseModelMappable {
  CheckOutResponseModel({required this.data, this.warnings = const []});

  final CheckOutDataModel data;
  final List<CheckOutWarningModel> warnings;

  static const fromJson = CheckOutResponseModelMapper.fromJson;
}
