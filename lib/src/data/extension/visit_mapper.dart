import '../../domain/entities/visit_entity.dart';
import '../models/visit_model.dart';

VisitStatus _parseStatus(String? raw) => switch (raw) {
      'completed' => VisitStatus.completed,
      'pending' => VisitStatus.pending,
      _ => VisitStatus.scheduled,
    };

VisitType _parseType(String? raw) => switch (raw) {
      'follow_up' => VisitType.followUp,
      _ => VisitType.routineInspection,
    };

extension VisitStatsSummaryModelToEntity on VisitStatsSummaryModel {
  VisitStatsSummaryEntity toEntity() => VisitStatsSummaryEntity(
        todayCount: todayCount ?? 0,
        weekCount: weekCount ?? 0,
        completedCount: completedCount ?? 0,
      );
}

extension VisitSummaryModelToEntity on VisitSummaryModel {
  VisitSummaryEntity toEntity() => VisitSummaryEntity(
        id: id,
        facilityName: facilityName ?? '',
        facilityAddress: facilityAddress ?? '',
        status: _parseStatus(status),
        type: _parseType(type),
        date: date ?? '',
        startTime: startTime ?? '',
        endTime: endTime ?? '',
      );
}

extension VisitAssignedByModelToEntity on VisitAssignedByModel {
  VisitAssignedByEntity toEntity() => VisitAssignedByEntity(
        name: name ?? '',
        role: role ?? '',
      );
}

extension VisitDetailModelToEntity on VisitDetailModel {
  VisitDetailEntity toEntity() => VisitDetailEntity(
        id: id,
        facilityName: facilityName ?? '',
        facilityAddress: facilityAddress ?? '',
        facilityLatitude: facilityLatitude ?? 0.0,
        facilityLongitude: facilityLongitude ?? 0.0,
        inRangeThresholdMeters: inRangeThresholdMeters ?? 100.0,
        status: _parseStatus(status),
        type: _parseType(type),
        date: date ?? '',
        startTime: startTime ?? '',
        endTime: endTime ?? '',
        assignedBy: assignedBy?.toEntity(),
      );
}

extension VisitCheckInRequestEntityToJson on VisitCheckInRequestEntity {
  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
      };
}
