enum VisitStatus { scheduled, inProgress, completed, resolved, pending }

enum VisitType { routineInspection, followUp }

class VisitStatsSummaryEntity {
  const VisitStatsSummaryEntity({
    required this.todayCount,
    required this.thisWeekCount,
    required this.inProgress,
    required this.completed,
  });

  final int todayCount;
  final int thisWeekCount;
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
    this.priority,
    this.travelOriginType,
    this.travelOriginId,
    this.travelOriginName,
    this.travelStartedAt,
  });

  final int id;
  final String facilityName;
  final String? facilityAddress;
  final String? title;
  final String? priority;
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

  /// "Home" (fixed label) when [travelOriginType] is `home`, or the real
  /// facility/office name when chained from a previous visit. Null when no
  /// travel origin has been recorded yet for this visit — a visit in that
  /// state cannot be used as a travel-expense claim's reference visit.
  final String? travelOriginName;
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
    this.title,
    this.facilityAddress,
    this.facilityLatitude,
    this.facilityLongitude,
    this.inRangeThresholdMeters,
    this.assignedBy,
    this.locationVerified = false,
    this.scorePercentage,
    this.travelTrackingExcluded = false,
    this.travelOriginType,
    this.travelOriginId,
    this.travelOriginName,
    this.travelDistanceKm,
    this.travelStartedAt,
    this.submittedAt,
  });

  final int id;
  final String facilityName;
  final int? facilityId;
  final String? facilityAddress;
  final String? title;
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
  final double? scorePercentage;
  final bool travelTrackingExcluded;
  final String? travelOriginType;
  final int? travelOriginId;
  final String? travelOriginName;
  final double? travelDistanceKm;
  final String? travelStartedAt;
  final String? submittedAt;
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

