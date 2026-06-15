import 'package:dart_mappable/dart_mappable.dart';

part 'visit_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class VisitStatsSummaryModel with VisitStatsSummaryModelMappable {
  VisitStatsSummaryModel({
    this.todayCount,
    this.weekCount,
    this.completedCount,
  });

  @MappableField(key: 'today_count')
  final int? todayCount;

  @MappableField(key: 'week_count')
  final int? weekCount;

  @MappableField(key: 'completed_count')
  final int? completedCount;

  static const fromJson = VisitStatsSummaryModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class VisitSummaryModel with VisitSummaryModelMappable {
  VisitSummaryModel({
    required this.id,
    this.facilityName,
    this.facilityAddress,
    this.status,
    this.type,
    this.date,
    this.startTime,
    this.endTime,
  });

  final int id;

  @MappableField(key: 'facility_name')
  final String? facilityName;

  @MappableField(key: 'facility_address')
  final String? facilityAddress;

  final String? status;
  final String? type;
  final String? date;

  @MappableField(key: 'start_time')
  final String? startTime;

  @MappableField(key: 'end_time')
  final String? endTime;

  static const fromJson = VisitSummaryModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class VisitAssignedByModel with VisitAssignedByModelMappable {
  VisitAssignedByModel({this.name, this.role});

  final String? name;
  final String? role;

  static const fromJson = VisitAssignedByModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class VisitDetailModel with VisitDetailModelMappable {
  VisitDetailModel({
    required this.id,
    this.facilityName,
    this.facilityAddress,
    this.facilityLatitude,
    this.facilityLongitude,
    this.inRangeThresholdMeters,
    this.status,
    this.type,
    this.date,
    this.startTime,
    this.endTime,
    this.assignedBy,
  });

  final int id;

  @MappableField(key: 'facility_name')
  final String? facilityName;

  @MappableField(key: 'facility_address')
  final String? facilityAddress;

  @MappableField(key: 'facility_latitude')
  final double? facilityLatitude;

  @MappableField(key: 'facility_longitude')
  final double? facilityLongitude;

  @MappableField(key: 'in_range_threshold_meters')
  final double? inRangeThresholdMeters;

  final String? status;
  final String? type;
  final String? date;

  @MappableField(key: 'start_time')
  final String? startTime;

  @MappableField(key: 'end_time')
  final String? endTime;

  @MappableField(key: 'assigned_by')
  final VisitAssignedByModel? assignedBy;

  static const fromJson = VisitDetailModelMapper.fromJson;
}
