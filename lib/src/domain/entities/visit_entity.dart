enum VisitStatus { scheduled, inProgress, completed, resolved, pending }

enum VisitType { routineInspection, followUp }

class VisitStatsSummaryEntity {
  const VisitStatsSummaryEntity({
    required this.total,
    required this.pending,
    required this.inProgress,
    required this.completed,
  });

  final int total;
  final int pending;
  final int inProgress;
  final int completed;
}

class VisitSummaryEntity {
  const VisitSummaryEntity({
    required this.id,
    required this.facilityName,
    required this.status,
    required this.type,
    required this.date,
    required this.scheduledStartTime,
    required this.scheduledEndTime,
    this.title,
    this.facilityAddress,
    this.travelOriginType,
    this.travelOriginId,
    this.travelStartedAt,
  });

  final int id;
  final String facilityName;
  final String? facilityAddress;
  final String? title;
  final VisitStatus status;
  final VisitType type;
  final String date;
  final String scheduledStartTime;
  final String scheduledEndTime;

  // WHY: the travel route check-in call needs to know where the trip to
  // this visit started from — this is the only place the API surfaces it
  // (the visit list), so it's carried through the route `extra` down to
  // [TravelRouteCheckInRequestEntity] rather than re-fetched.
  final String? travelOriginType;
  final int? travelOriginId;
  final String? travelStartedAt;
}

class VisitListEntity {
  const VisitListEntity({
    required this.stats,
    required this.visits,
  });

  final VisitStatsSummaryEntity stats;
  final List<VisitSummaryEntity> visits;
}

class VisitAssignedByEntity {
  const VisitAssignedByEntity({
    required this.name,
    required this.role,
  });

  final String name;
  final String role;
}

class VisitDetailEntity {
  const VisitDetailEntity({
    required this.id,
    required this.facilityName,
    this.facilityId,
    required this.status,
    required this.type,
    required this.date,
    required this.scheduledStartTime,
    required this.scheduledEndTime,
    this.facilityAddress,
    this.facilityLatitude,
    this.facilityLongitude,
    this.inRangeThresholdMeters,
    this.assignedBy,
    this.locationVerified = false,
    this.travelStartedAt,
  });

  final int id;
  final String facilityName;
  final int? facilityId;
  final String? facilityAddress;
  final double? facilityLatitude;
  final double? facilityLongitude;
  final double? inRangeThresholdMeters;
  final VisitStatus status;
  final VisitType type;
  final String date;
  final String scheduledStartTime;
  final String scheduledEndTime;
  final VisitAssignedByEntity? assignedBy;
  final bool locationVerified;
  final String? travelStartedAt;
}

class GpsVerificationEntity {
  const GpsVerificationEntity({
    required this.userLatitude,
    required this.userLongitude,
    required this.facilityLatitude,
    required this.facilityLongitude,
    required this.distanceMeters,
    required this.isInRange,
  });

  final double userLatitude;
  final double userLongitude;
  final double facilityLatitude;
  final double facilityLongitude;
  final double distanceMeters;
  final bool isInRange;
}

class VisitCheckInRequestEntity {
  const VisitCheckInRequestEntity({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;
}

