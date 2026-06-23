import 'package:dart_mappable/dart_mappable.dart';

import '../../domain/entities/visit_entity.dart';

part 'visit_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class VisitListResponseModel with VisitListResponseModelMappable {
  VisitListResponseModel({required this.data, required this.meta});

  final List<VisitSummaryModel> data;
  final VisitMetaModel meta;

  static const fromJson = VisitListResponseModelMapper.fromJson;

  VisitListEntity toEntity() => VisitListEntity(
        stats: meta.toEntity(),
        visits: data.map((e) => e.toEntity()).toList(),
      );
}

@MappableClass(generateMethods: GenerateMethods.decode)
class VisitMetaModel with VisitMetaModelMappable {
  VisitMetaModel({
    required this.todayCount,
    required this.thisWeekCount,
    required this.completedCount,
  });

  @MappableField(key: 'today_count')
  final int todayCount;

  @MappableField(key: 'this_week_count')
  final int thisWeekCount;

  @MappableField(key: 'completed_count')
  final int completedCount;

  static const fromJson = VisitMetaModelMapper.fromJson;

  VisitStatsSummaryEntity toEntity() => VisitStatsSummaryEntity(
        todayCount: todayCount,
        thisWeekCount: thisWeekCount,
        completedCount: completedCount,
      );
}

@MappableClass(generateMethods: GenerateMethods.decode)
class VisitSummaryModel with VisitSummaryModelMappable {
  VisitSummaryModel({
    required this.id,
    required this.facilityName,
    required this.status,
    required this.visitType,
    required this.scheduledDate,
    required this.scheduledStartTime,
    required this.scheduledEndTime,
    this.locationVerified,
    this.checkInAt,
    this.totalScore,
    this.maxScore,
    this.itemsTotal,
    this.itemsCompleted,
    this.priority,
    this.assignedToName,
  });

  final int id;

  @MappableField(key: 'facility_name')
  final String facilityName;

  final String status;

  @MappableField(key: 'visit_type')
  final String visitType;

  @MappableField(key: 'scheduled_date')
  final String scheduledDate;

  @MappableField(key: 'scheduled_start_time')
  final String scheduledStartTime;

  @MappableField(key: 'scheduled_end_time')
  final String scheduledEndTime;

  @MappableField(key: 'location_verified')
  final bool? locationVerified;

  @MappableField(key: 'check_in_at')
  final String? checkInAt;

  @MappableField(key: 'total_score')
  final int? totalScore;

  @MappableField(key: 'max_score')
  final int? maxScore;

  @MappableField(key: 'items_total')
  final int? itemsTotal;

  @MappableField(key: 'items_completed')
  final int? itemsCompleted;

  final String? priority;

  @MappableField(key: 'assigned_to_name')
  final String? assignedToName;

  static const fromJson = VisitSummaryModelMapper.fromJson;

  VisitSummaryEntity toEntity() => VisitSummaryEntity(
        id: id,
        facilityName: facilityName,
        status: _parseStatus(status),
        type: _parseVisitType(visitType),
        date: scheduledDate,
        scheduledStartTime: _trimTime(scheduledStartTime),
        scheduledEndTime: _trimTime(scheduledEndTime),
      );
}

@MappableClass(generateMethods: GenerateMethods.decode)
class VisitDetailResponseModel with VisitDetailResponseModelMappable {
  VisitDetailResponseModel({required this.data});

  final VisitDetailModel data;

  static const fromJson = VisitDetailResponseModelMapper.fromJson;

  VisitDetailEntity toEntity() => data.toEntity();
}

@MappableClass(generateMethods: GenerateMethods.decode)
class VisitDetailModel with VisitDetailModelMappable {
  VisitDetailModel({
    required this.id,
    required this.facilityName,
    required this.status,
    required this.visitType,
    required this.scheduledDate,
    required this.scheduledStartTime,
    required this.scheduledEndTime,
    this.createdByName,
    this.createdByRole,
    this.locationVerified,
    this.checkInAt,
    this.checkInDistanceMeters,
    this.totalScore,
    this.maxScore,
    this.itemsTotal,
    this.itemsCompleted,
    this.priority,
    this.assignedToName,
  });

  final int id;

  @MappableField(key: 'facility_name')
  final String facilityName;

  final String status;

  @MappableField(key: 'visit_type')
  final String visitType;

  @MappableField(key: 'scheduled_date')
  final String scheduledDate;

  @MappableField(key: 'scheduled_start_time')
  final String scheduledStartTime;

  @MappableField(key: 'scheduled_end_time')
  final String scheduledEndTime;

  @MappableField(key: 'created_by_name')
  final String? createdByName;

  @MappableField(key: 'created_by_role')
  final String? createdByRole;

  @MappableField(key: 'location_verified')
  final bool? locationVerified;

  @MappableField(key: 'check_in_at')
  final String? checkInAt;

  @MappableField(key: 'check_in_distance_meters')
  final int? checkInDistanceMeters;

  @MappableField(key: 'total_score')
  final int? totalScore;

  @MappableField(key: 'max_score')
  final int? maxScore;

  @MappableField(key: 'items_total')
  final int? itemsTotal;

  @MappableField(key: 'items_completed')
  final int? itemsCompleted;

  final String? priority;

  @MappableField(key: 'assigned_to_name')
  final String? assignedToName;

  static const fromJson = VisitDetailModelMapper.fromJson;

  VisitDetailEntity toEntity() => VisitDetailEntity(
        id: id,
        facilityName: facilityName,
        status: _parseStatus(status),
        type: _parseVisitType(visitType),
        date: scheduledDate,
        scheduledStartTime: _trimTime(scheduledStartTime),
        scheduledEndTime: _trimTime(scheduledEndTime),
        assignedBy: createdByName != null
            ? VisitAssignedByEntity(
                name: createdByName!,
                role: createdByRole ?? '',
              )
            : null,
      );
}

// WHY: API returns "HH:mm:ss"; drop seconds for display.
String _trimTime(String t) => t.length >= 5 ? t.substring(0, 5) : t;

VisitStatus _parseStatus(String raw) => switch (raw) {
      'in_progress' => VisitStatus.inProgress,
      'resolved' => VisitStatus.resolved,
      'completed' => VisitStatus.completed,
      'pending' => VisitStatus.pending,
      _ => VisitStatus.scheduled,
    };

VisitType _parseVisitType(String raw) => switch (raw) {
      'follow_up' => VisitType.followUp,
      _ => VisitType.routineInspection,
    };
