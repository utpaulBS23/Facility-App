enum VisitStatus { scheduled, inProgress, completed, resolved, pending }

enum VisitType { routineInspection, followUp }

class VisitStatsSummaryEntity {
  const VisitStatsSummaryEntity({
    required this.todayCount,
    required this.thisWeekCount,
    required this.completedCount,
  });

  final int todayCount;
  final int thisWeekCount;
  final int completedCount;
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
    this.facilityAddress,
  });

  final int id;
  final String facilityName;
  final String? facilityAddress;
  final VisitStatus status;
  final VisitType type;
  final String date;
  final String scheduledStartTime;
  final String scheduledEndTime;
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
  });

  final int id;
  final String facilityName;
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
