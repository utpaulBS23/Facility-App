import 'package:dart_mappable/dart_mappable.dart';

import '../../domain/entities/visit_entity.dart';

part 'visit_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class VisitListResponseModel with VisitListResponseModelMappable {
  VisitListResponseModel({required this.data, required this.stats});

  final List<VisitSummaryModel> data;
  final VisitStatsModel stats;

  static const fromJson = VisitListResponseModelMapper.fromJson;

  VisitListEntity toEntity() => VisitListEntity(
        stats: stats.toEntity(),
        visits: data.map((e) => e.toEntity()).toList(),
      );
}

@MappableClass(generateMethods: GenerateMethods.decode)
class VisitStatsModel with VisitStatsModelMappable {
  VisitStatsModel({
    required this.todayCount,
    required this.thisWeekCount,
    required this.inProgress,
    required this.completed,
  });

  @MappableField(key: 'today_count')
  final int todayCount;

  @MappableField(key: 'this_week_count')
  final int thisWeekCount;

  @MappableField(key: 'in_progress')
  final int inProgress;

  final int completed;

  static const fromJson = VisitStatsModelMapper.fromJson;

  VisitStatsSummaryEntity toEntity() => VisitStatsSummaryEntity(
        todayCount: todayCount,
        thisWeekCount: thisWeekCount,
        inProgress: inProgress,
        completed: completed,
      );
}

@MappableClass(generateMethods: GenerateMethods.decode)
class VisitSummaryModel with VisitSummaryModelMappable {
  VisitSummaryModel({
    required this.id,
    required this.facilityName,
    required this.status,
    this.title,
    this.visitType,
    required this.scheduledDate,
    this.scheduledStartTime,
    this.scheduledEndTime,
    this.locationVerified,
    this.checkInAt,
    this.totalScore,
    this.maxScore,
    this.itemsTotal,
    this.itemsCompleted,
    this.priority,
    this.assignedToName,
    this.travelOriginType,
    this.travelOriginId,
    this.travelOriginName,
    this.facilityAddress,
    this.travelStartedAt,
  });

  final int id;

  @MappableField(key: 'facility_name')
  final String facilityName;

  @MappableField(key: 'facility_address')
  final String? facilityAddress;

  final String status;

  final String? title;

  @MappableField(key: 'visit_type')
  final String? visitType;

  @MappableField(key: 'scheduled_date')
  final String scheduledDate;

  @MappableField(key: 'scheduled_start_time')
  final String? scheduledStartTime;

  @MappableField(key: 'scheduled_end_time')
  final String? scheduledEndTime;

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

  @MappableField(key: 'travel_origin_type')
  final String? travelOriginType;

  @MappableField(key: 'travel_origin_id')
  final int? travelOriginId;

  @MappableField(key: 'travel_origin_name')
  final String? travelOriginName;

  @MappableField(key: 'travel_started_at')
  final String? travelStartedAt;

  static const fromJson = VisitSummaryModelMapper.fromJson;

  VisitSummaryEntity toEntity() => VisitSummaryEntity(
        id: id,
        facilityName: facilityName,
        facilityAddress: facilityAddress,
        status: _parseStatus(status),
        title: title,
        priority: priority,
        type: _parseVisitType(visitType ?? ''),
        date: scheduledDate,
        scheduledStartTime: _trimTime(scheduledStartTime ?? ''),
        scheduledEndTime: _trimTime(scheduledEndTime ?? ''),
        travelOriginType: travelOriginType,
        travelOriginId: travelOriginId,
        travelOriginName: travelOriginName,
        travelStartedAt: travelStartedAt,
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
    this.facilityId,
    required this.status,
    this.title,
    this.visitType,
    required this.scheduledDate,
    this.scheduledStartTime,
    this.scheduledEndTime,
    this.createdByName,
    this.createdByRole,
    this.locationVerified,
    this.checkInAt,
    this.checkInDistanceMeters,
    this.totalScore,
    this.maxScore,
    this.scorePercentage,
    this.itemsTotal,
    this.itemsCompleted,
    this.priority,
    this.assignedToName,
    this.facilityAddress,
    this.travelTrackingExcluded,
    this.travelOriginType,
    this.travelOriginId,
    this.travelOriginName,
    this.travelDistanceKm,
    this.travelStartedAt,
    this.submittedAt,
  });

  final int id;

  @MappableField(key: 'facility_name')
  final String facilityName;

  @MappableField(key: 'facility_id')
  final int? facilityId;

  @MappableField(key: 'facility_address')
  final String? facilityAddress;

  final String status;

  final String? title;

  @MappableField(key: 'visit_type')
  final String? visitType;

  @MappableField(key: 'scheduled_date')
  final String scheduledDate;

  @MappableField(key: 'scheduled_start_time')
  final String? scheduledStartTime;

  @MappableField(key: 'scheduled_end_time')
  final String? scheduledEndTime;

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

  @MappableField(key: 'score_percentage')
  final double? scorePercentage;

  @MappableField(key: 'items_total')
  final int? itemsTotal;

  @MappableField(key: 'items_completed')
  final int? itemsCompleted;

  final String? priority;

  @MappableField(key: 'assigned_to_name')
  final String? assignedToName;

  @MappableField(key: 'travel_tracking_excluded')
  final bool? travelTrackingExcluded;

  @MappableField(key: 'travel_origin_type')
  final String? travelOriginType;

  @MappableField(key: 'travel_origin_id')
  final int? travelOriginId;

  @MappableField(key: 'travel_origin_name')
  final String? travelOriginName;

  @MappableField(key: 'travel_distance_km')
  final double? travelDistanceKm;

  @MappableField(key: 'travel_started_at')
  final String? travelStartedAt;

  @MappableField(key: 'submitted_at')
  final String? submittedAt;

  static const fromJson = VisitDetailModelMapper.fromJson;

  VisitDetailEntity toEntity() => VisitDetailEntity(
        id: id,
        facilityName: facilityName,
        facilityId: facilityId,
        facilityAddress: facilityAddress,
        status: _parseStatus(status),
        title: title,
        type: _parseVisitType(visitType ?? ''),
        date: scheduledDate,
        scheduledStartTime: _trimTime(scheduledStartTime ?? ''),
        scheduledEndTime: _trimTime(scheduledEndTime ?? ''),
        locationVerified: locationVerified ?? false,
        assignedBy: createdByName != null
            ? VisitAssignedByEntity(
                name: createdByName!,
                role: createdByRole ?? '',
              )
            : null,
        scorePercentage: scorePercentage,
        travelTrackingExcluded: travelTrackingExcluded ?? false,
        travelOriginType: travelOriginType,
        travelOriginId: travelOriginId,
        travelOriginName: travelOriginName,
        travelDistanceKm: travelDistanceKm,
        travelStartedAt: travelStartedAt,
        submittedAt: submittedAt,
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
