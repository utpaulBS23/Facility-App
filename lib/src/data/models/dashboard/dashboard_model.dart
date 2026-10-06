import 'package:dart_mappable/dart_mappable.dart';

part 'dashboard_model.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class DashboardShortageItemModel with DashboardShortageItemModelMappable {
  const DashboardShortageItemModel({
    this.shiftSlotId,
    this.weeklyRosterId,
    this.facilityId,
    this.facilityName,
    this.facilityNameBn,
    this.shiftLabel,
    this.shiftStartTime,
    this.shortageCount,
  });

  final int? shiftSlotId;
  final int? weeklyRosterId;
  final int? facilityId;
  final String? facilityName;
  final String? facilityNameBn;
  final String? shiftLabel;
  final String? shiftStartTime;
  final int? shortageCount;

  static const fromJson = DashboardShortageItemModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class DashboardStaffShortageModel with DashboardStaffShortageModelMappable {
  const DashboardStaffShortageModel({
    this.totalShortage,
    this.facilityCount,
    this.items = const [],
  });

  final int? totalShortage;
  final int? facilityCount;
  final List<DashboardShortageItemModel> items;

  static const fromJson = DashboardStaffShortageModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class DashboardCheckInOutModel with DashboardCheckInOutModelMappable {
  const DashboardCheckInOutModel({
    this.status,
    this.checkInAt,
    this.checkOutAt,
    this.facilityId,
    this.facilityName,
    this.visitCount,
  });

  final String? status;
  final String? checkInAt;
  final String? checkOutAt;
  final int? facilityId;
  final String? facilityName;
  final int? visitCount;

  static const fromJson = DashboardCheckInOutModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class DashboardStatsModel with DashboardStatsModelMappable {
  const DashboardStatsModel({
    this.todayWorking,
    this.todayRostered,
    this.pendingApproval,
    this.notCheckedIn,
    this.late,
  });

  final int? todayWorking;
  final int? todayRostered;
  final int? pendingApproval;
  final int? notCheckedIn;
  final int? late;

  static const fromJson = DashboardStatsModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class DashboardCollectionPointModel with DashboardCollectionPointModelMappable {
  const DashboardCollectionPointModel({this.date, this.revenue, this.target});

  final String? date;
  final num? revenue;
  final num? target;

  static const fromJson = DashboardCollectionPointModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class DashboardCollectionModel with DashboardCollectionModelMappable {
  const DashboardCollectionModel({this.dailyTarget, this.series = const []});

  final num? dailyTarget;
  final List<DashboardCollectionPointModel> series;

  static const fromJson = DashboardCollectionModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class DashboardVisitorsModel with DashboardVisitorsModelMappable {
  const DashboardVisitorsModel({this.date, this.male, this.female, this.total});

  final String? date;
  final int? male;
  final int? female;
  final int? total;

  static const fromJson = DashboardVisitorsModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class DashboardAirQualityModel with DashboardAirQualityModelMappable {
  const DashboardAirQualityModel({this.value, this.label, this.isPlaceholder});

  final num? value;
  final String? label;
  final bool? isPlaceholder;

  static const fromJson = DashboardAirQualityModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class DashboardIssueBucketsModel with DashboardIssueBucketsModelMappable {
  const DashboardIssueBucketsModel({
    this.inProgress,
    this.completed,
    this.pending,
  });

  final int? inProgress;
  final int? completed;
  final int? pending;

  static const fromJson = DashboardIssueBucketsModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class DashboardFacilitySummaryModel with DashboardFacilitySummaryModelMappable {
  const DashboardFacilitySummaryModel({
    this.facilityId,
    this.facilityName,
    this.facilityNameBn,
    this.targetRevenue,
    this.achievedRevenue,
    this.achievementPct,
    this.expense,
    this.airQuality,
    this.visitors,
    this.issueSummary,
  });

  final int? facilityId;
  final String? facilityName;
  final String? facilityNameBn;
  final num? targetRevenue;
  final num? achievedRevenue;
  final num? achievementPct;
  final num? expense;
  final DashboardAirQualityModel? airQuality;
  final DashboardVisitorsModel? visitors;
  final DashboardIssueBucketsModel? issueSummary;

  static const fromJson = DashboardFacilitySummaryModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class DashboardExecutiveTargetModel with DashboardExecutiveTargetModelMappable {
  const DashboardExecutiveTargetModel({
    this.executiveId,
    this.executiveName,
    this.target,
    this.achieved,
  });

  final int? executiveId;
  final String? executiveName;
  final num? target;
  final num? achieved;

  static const fromJson = DashboardExecutiveTargetModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class DashboardExecutiveFacilityModel
    with DashboardExecutiveFacilityModelMappable {
  const DashboardExecutiveFacilityModel({
    this.facilityId,
    this.facilityName,
    this.facilityNameBn,
    this.achievementPct,
    this.expense,
    this.visitorsToday,
  });

  final int? facilityId;
  final String? facilityName;
  final String? facilityNameBn;
  final num? achievementPct;
  final num? expense;
  final DashboardVisitorsModel? visitorsToday;

  static const fromJson = DashboardExecutiveFacilityModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class DashboardExecutiveDetailModel with DashboardExecutiveDetailModelMappable {
  const DashboardExecutiveDetailModel({
    this.executiveId,
    this.executiveName,
    this.totalFacility,
    this.monthlyTarget,
    this.facilities = const [],
  });

  final int? executiveId;
  final String? executiveName;
  final int? totalFacility;
  final num? monthlyTarget;
  final List<DashboardExecutiveFacilityModel> facilities;

  static const fromJson = DashboardExecutiveDetailModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class DashboardIssueStatusModel with DashboardIssueStatusModelMappable {
  const DashboardIssueStatusModel({
    this.status,
    this.label,
    this.count,
    this.percentage,
  });

  final String? status;
  final String? label;
  final int? count;
  final num? percentage;

  static const fromJson = DashboardIssueStatusModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class DashboardIssueSummaryModel with DashboardIssueSummaryModelMappable {
  const DashboardIssueSummaryModel({
    this.critical,
    this.medium,
    this.total,
    this.solved,
  });

  final int? critical;
  final int? medium;
  final int? total;
  final int? solved;

  static const fromJson = DashboardIssueSummaryModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class DashboardRecentIssueModel with DashboardRecentIssueModelMappable {
  const DashboardRecentIssueModel({
    this.id,
    this.title,
    this.facilityId,
    this.facilityName,
    this.status,
    this.priority,
    this.createdAt,
  });

  final int? id;
  final String? title;
  final int? facilityId;
  final String? facilityName;
  final String? status;
  final String? priority;
  final String? createdAt;

  static const fromJson = DashboardRecentIssueModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class DashboardIssuesModel with DashboardIssuesModelMappable {
  const DashboardIssuesModel({
    this.totalIssues,
    this.byStatus = const [],
    this.summary,
    this.recent = const [],
  });

  final int? totalIssues;
  final List<DashboardIssueStatusModel> byStatus;
  final DashboardIssueSummaryModel? summary;
  final List<DashboardRecentIssueModel> recent;

  static const fromJson = DashboardIssuesModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class DashboardTotalRevenueModel with DashboardTotalRevenueModelMappable {
  const DashboardTotalRevenueModel({
    this.amount,
    this.changePct,
    this.facilityCount,
  });

  final num? amount;
  final num? changePct;
  final int? facilityCount;

  static const fromJson = DashboardTotalRevenueModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class DashboardRevenueTrendModel with DashboardRevenueTrendModelMappable {
  const DashboardRevenueTrendModel({
    this.yearMonth,
    this.label,
    this.revenue,
    this.target,
  });

  final String? yearMonth;
  final String? label;
  final num? revenue;
  final num? target;

  static const fromJson = DashboardRevenueTrendModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class DashboardFacilityRevenueModel with DashboardFacilityRevenueModelMappable {
  const DashboardFacilityRevenueModel({
    this.facilityId,
    this.facilityName,
    this.facilityNameBn,
    this.revenue,
    this.targetPct,
    this.changePct,
  });

  final int? facilityId;
  final String? facilityName;
  final String? facilityNameBn;
  final num? revenue;
  final num? targetPct;
  final num? changePct;

  static const fromJson = DashboardFacilityRevenueModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class DashboardRevenueByFacilityModel
    with DashboardRevenueByFacilityModelMappable {
  const DashboardRevenueByFacilityModel({
    this.top = const [],
    this.lowest = const [],
  });

  final List<DashboardFacilityRevenueModel> top;
  final List<DashboardFacilityRevenueModel> lowest;

  static const fromJson = DashboardRevenueByFacilityModelMapper.fromJson;
}

/// The three dashboards share one decode shape: [dashboardType] says which of
/// the optional blocks the server filled in.
@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class DashboardDataModel with DashboardDataModelMappable {
  const DashboardDataModel({
    this.dashboardType,
    this.month,
    this.checkInOut,
    this.staffShortage,
    this.stats,
    this.collectionThisWeek,
    this.visitorsPerDay = const [],
    this.facilitySummary = const [],
    this.targetVsAchievementByExecutive = const [],
    this.issues,
    this.executiveDetails = const [],
    this.totalRevenue,
    this.revenueTrend = const [],
    this.revenueByFacility,
  });

  final String? dashboardType;

  /// `YYYY-MM` the server resolved for `?month=`.
  final String? month;
  final DashboardCheckInOutModel? checkInOut;
  final DashboardStaffShortageModel? staffShortage;
  final DashboardStatsModel? stats;
  final DashboardCollectionModel? collectionThisWeek;
  final List<DashboardVisitorsModel> visitorsPerDay;
  final List<DashboardFacilitySummaryModel> facilitySummary;
  final List<DashboardExecutiveTargetModel> targetVsAchievementByExecutive;
  final DashboardIssuesModel? issues;
  final List<DashboardExecutiveDetailModel> executiveDetails;
  final DashboardTotalRevenueModel? totalRevenue;
  final List<DashboardRevenueTrendModel> revenueTrend;
  final DashboardRevenueByFacilityModel? revenueByFacility;

  static const fromJson = DashboardDataModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class DashboardResponseModel with DashboardResponseModelMappable {
  const DashboardResponseModel({this.data});

  final DashboardDataModel? data;

  static const fromJson = DashboardResponseModelMapper.fromJson;
}
