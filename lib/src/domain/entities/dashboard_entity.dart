import '../../core/utils/localized_text.dart';

/// The role that decides which home dashboard the app mounts.
///
/// WHY: the server derives the dashboard from the token on every call; this is
/// only the client's hint for which screen to build and never goes back to the
/// server.
enum UserRole {
  partnerOwner('partner_owner'),
  opsManager('ops_manager'),
  supervisor('supervisor'),
  attendant('attendant');

  const UserRole(this.key);

  final String key;

  /// Unknown or missing keys give null, so a newer backend never breaks login.
  static UserRole? fromKey(String? key) {
    for (final role in values) {
      if (role.key == key) return role;
    }

    return null;
  }
}

class DashboardShortageItemEntity {
  const DashboardShortageItemEntity({
    required this.shiftSlotId,
    required this.weeklyRosterId,
    required this.facilityId,
    required this.facilityName,
    required this.facilityNameBn,
    required this.shiftLabel,
    required this.shiftStartTime,
    required this.shortageCount,
  });

  /// Null if the server omitted it; the Assign button then has nowhere to go.
  final int? shiftSlotId;
  final int? weeklyRosterId;
  final int facilityId;
  final String facilityName;
  final String? facilityNameBn;
  final String shiftLabel;

  /// "HH:mm", 24 hour.
  final String shiftStartTime;
  final int shortageCount;

  String localizedFacility(String languageCode) =>
      localizedText(languageCode, facilityName, facilityNameBn);
}

class DashboardStaffShortageEntity {
  const DashboardStaffShortageEntity({
    required this.totalShortage,
    required this.facilityCount,
    required this.items,
  });

  final int totalShortage;
  final int facilityCount;
  final List<DashboardShortageItemEntity> items;
}

enum DashboardCheckInStatus {
  notCheckedIn('not_checked_in'),
  checkedIn('checked_in'),
  checkedOut('checked_out');

  const DashboardCheckInStatus(this.key);

  final String key;

  static DashboardCheckInStatus fromKey(String? key) {
    for (final status in values) {
      if (status.key == key) return status;
    }

    return notCheckedIn;
  }
}

/// The supervisor's own attendance today, from visit check-ins.
class DashboardCheckInOutEntity {
  const DashboardCheckInOutEntity({
    required this.status,
    required this.checkInAt,
    required this.checkOutAt,
    required this.facilityName,
    required this.visitCount,
  });

  final DashboardCheckInStatus status;
  final DateTime? checkInAt;
  final DateTime? checkOutAt;
  final String? facilityName;
  final int visitCount;
}

class DashboardStatsEntity {
  const DashboardStatsEntity({
    required this.todayWorking,
    required this.todayRostered,
    required this.pendingApproval,
    required this.notCheckedIn,
    required this.late,
  });

  final int todayWorking;
  final int todayRostered;
  final int pendingApproval;
  final int notCheckedIn;
  final int late;
}

class DashboardCollectionPointEntity {
  const DashboardCollectionPointEntity({
    required this.date,
    required this.revenue,
    required this.target,
  });

  final DateTime? date;
  final num revenue;
  final num target;
}

class DashboardVisitorsEntity {
  const DashboardVisitorsEntity({
    required this.date,
    required this.male,
    required this.female,
    required this.total,
  });

  final DateTime? date;
  final int male;
  final int female;
  final int total;
}

class DashboardIssueBucketsEntity {
  const DashboardIssueBucketsEntity({
    required this.inProgress,
    required this.completed,
    required this.pending,
  });

  final int inProgress;
  final int completed;
  final int pending;
}

class DashboardFacilitySummaryEntity {
  const DashboardFacilitySummaryEntity({
    required this.facilityId,
    required this.facilityName,
    required this.facilityNameBn,
    required this.targetRevenue,
    required this.achievedRevenue,
    required this.achievementPct,
    required this.expense,
    required this.visitors,
    required this.issues,
  });

  final int facilityId;
  final String facilityName;
  final String? facilityNameBn;
  final num targetRevenue;
  final num achievedRevenue;
  final num achievementPct;
  final num expense;
  final DashboardVisitorsEntity visitors;
  final DashboardIssueBucketsEntity issues;

  String localizedName(String languageCode) =>
      localizedText(languageCode, facilityName, facilityNameBn);
}

class DashboardExecutiveTargetEntity {
  const DashboardExecutiveTargetEntity({
    required this.executiveId,
    required this.name,
    required this.target,
    required this.achieved,
  });

  final int executiveId;
  final String name;
  final num target;
  final num achieved;
}

class DashboardExecutiveFacilityEntity {
  const DashboardExecutiveFacilityEntity({
    required this.facilityId,
    required this.facilityName,
    required this.facilityNameBn,
    required this.achievementPct,
    required this.expense,
    required this.visitorsToday,
  });

  final int facilityId;
  final String facilityName;
  final String? facilityNameBn;
  final num achievementPct;
  final num expense;
  final DashboardVisitorsEntity visitorsToday;

  String localizedName(String languageCode) =>
      localizedText(languageCode, facilityName, facilityNameBn);
}

class DashboardExecutiveDetailEntity {
  const DashboardExecutiveDetailEntity({
    required this.executiveId,
    required this.name,
    required this.totalFacility,
    required this.monthlyTarget,
    required this.facilities,
  });

  final int executiveId;
  final String name;
  final int totalFacility;
  final num monthlyTarget;
  final List<DashboardExecutiveFacilityEntity> facilities;
}

/// Wire statuses of [DashboardIssueStatusEntity.status]; unknown ones are kept
/// as [other].
enum DashboardIssueStatus {
  open('open'),
  assigned('assigned'),
  inProgress('in_progress'),
  resolved('resolved'),
  other('');

  const DashboardIssueStatus(this.key);

  final String key;

  static DashboardIssueStatus fromKey(String? key) {
    for (final status in values) {
      if (status.key == key) return status;
    }

    return other;
  }
}

class DashboardIssueStatusEntity {
  const DashboardIssueStatusEntity({
    required this.status,
    required this.label,
    required this.count,
    required this.percentage,
  });

  final DashboardIssueStatus status;

  /// Server English label, shown when [status] is unknown.
  final String label;
  final int count;
  final num percentage;
}

class DashboardIssueSummaryEntity {
  const DashboardIssueSummaryEntity({
    required this.critical,
    required this.medium,
    required this.total,
    required this.solved,
  });

  final int critical;
  final int medium;
  final int total;
  final int solved;
}

class DashboardRecentIssueEntity {
  const DashboardRecentIssueEntity({
    required this.id,
    required this.title,
    required this.facilityName,
    required this.status,
    required this.statusLabel,
  });

  final int id;
  final String title;
  final String facilityName;
  final DashboardIssueStatus status;
  final String statusLabel;
}

class DashboardIssuesEntity {
  const DashboardIssuesEntity({
    required this.totalIssues,
    required this.byStatus,
    required this.summary,
    required this.recent,
  });

  final int totalIssues;
  final List<DashboardIssueStatusEntity> byStatus;
  final DashboardIssueSummaryEntity summary;
  final List<DashboardRecentIssueEntity> recent;
}

class DashboardTotalRevenueEntity {
  const DashboardTotalRevenueEntity({
    required this.amount,
    required this.changePct,
    required this.facilityCount,
  });

  final num amount;
  final num changePct;
  final int facilityCount;
}

class DashboardRevenueTrendEntity {
  const DashboardRevenueTrendEntity({
    required this.label,
    required this.revenue,
    required this.target,
  });

  final String label;
  final num revenue;
  final num target;
}

class DashboardFacilityRevenueEntity {
  const DashboardFacilityRevenueEntity({
    required this.facilityId,
    required this.facilityName,
    required this.facilityNameBn,
    required this.revenue,
    required this.targetPct,
    required this.changePct,
  });

  final int facilityId;
  final String facilityName;
  final String? facilityNameBn;
  final num revenue;
  final num targetPct;
  final num changePct;

  String localizedName(String languageCode) =>
      localizedText(languageCode, facilityName, facilityNameBn);
}

/// One of the three home dashboards. Each subtype carries only what its role
/// sees; the page switches over the sealed type.
sealed class DashboardEntity {
  const DashboardEntity({required this.staffShortage});

  final DashboardStaffShortageEntity staffShortage;
}

class SupervisorDashboardEntity extends DashboardEntity {
  const SupervisorDashboardEntity({
    required super.staffShortage,
    required this.month,
    required this.checkInOut,
    required this.stats,
    required this.dailyTarget,
    required this.collection,
    required this.visitorsPerDay,
    required this.facilities,
  });

  /// `YYYY-MM` the facility summary is for.
  final String month;
  final DashboardCheckInOutEntity checkInOut;
  final DashboardStatsEntity stats;
  final num dailyTarget;
  final List<DashboardCollectionPointEntity> collection;
  final List<DashboardVisitorsEntity> visitorsPerDay;
  final List<DashboardFacilitySummaryEntity> facilities;
}

class OpsManagerDashboardEntity extends DashboardEntity {
  const OpsManagerDashboardEntity({
    required super.staffShortage,
    required this.month,
    required this.executiveTargets,
    required this.issues,
    required this.executives,
  });

  /// `YYYY-MM` the executive sections are for.
  final String month;
  final List<DashboardExecutiveTargetEntity> executiveTargets;
  final DashboardIssuesEntity issues;
  final List<DashboardExecutiveDetailEntity> executives;
}

class PartnerOwnerDashboardEntity extends DashboardEntity {
  const PartnerOwnerDashboardEntity({
    required super.staffShortage,
    required this.totalRevenue,
    required this.revenueTrend,
    required this.topFacilities,
    required this.lowestFacilities,
    required this.issues,
  });

  final DashboardTotalRevenueEntity totalRevenue;
  final List<DashboardRevenueTrendEntity> revenueTrend;
  final List<DashboardFacilityRevenueEntity> topFacilities;
  final List<DashboardFacilityRevenueEntity> lowestFacilities;
  final DashboardIssuesEntity issues;
}
