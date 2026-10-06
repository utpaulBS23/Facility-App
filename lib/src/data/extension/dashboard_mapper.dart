import '../../domain/entities/dashboard_entity.dart';
import '../models/dashboard/dashboard_model.dart';

const _noShortage = DashboardStaffShortageEntity(
  totalShortage: 0,
  facilityCount: 0,
  items: [],
);

const _noIssues = DashboardIssuesEntity(
  totalIssues: 0,
  byStatus: [],
  summary: DashboardIssueSummaryEntity(
    critical: 0,
    medium: 0,
    total: 0,
    solved: 0,
  ),
  recent: [],
);

const _noVisitors = DashboardVisitorsEntity(
  date: null,
  male: 0,
  female: 0,
  total: 0,
);

extension DashboardShortageItemModelToEntity on DashboardShortageItemModel {
  DashboardShortageItemEntity toEntity() => DashboardShortageItemEntity(
    shiftSlotId: shiftSlotId,
    weeklyRosterId: weeklyRosterId,
    facilityId: facilityId ?? 0,
    facilityName: facilityName ?? '',
    facilityNameBn: facilityNameBn,
    shiftLabel: shiftLabel ?? '',
    shiftStartTime: shiftStartTime ?? '',
    shortageCount: shortageCount ?? 0,
  );
}

extension DashboardStaffShortageModelToEntity on DashboardStaffShortageModel {
  DashboardStaffShortageEntity toEntity() => DashboardStaffShortageEntity(
    totalShortage: totalShortage ?? 0,
    facilityCount: facilityCount ?? 0,
    items: [for (final i in items) i.toEntity()],
  );
}

extension DashboardCheckInOutModelToEntity on DashboardCheckInOutModel {
  DashboardCheckInOutEntity toEntity() => DashboardCheckInOutEntity(
    status: DashboardCheckInStatus.fromKey(status),
    // No toLocal: the server sends a bare `yyyy-MM-dd HH:mm:ss`, which parses
    // as local time already.
    checkInAt: DateTime.tryParse(checkInAt ?? ''),
    checkOutAt: DateTime.tryParse(checkOutAt ?? ''),
    facilityName: facilityName,
    visitCount: visitCount ?? 0,
  );
}

extension DashboardStatsModelToEntity on DashboardStatsModel {
  DashboardStatsEntity toEntity() => DashboardStatsEntity(
    todayWorking: todayWorking ?? 0,
    todayRostered: todayRostered ?? 0,
    pendingApproval: pendingApproval ?? 0,
    notCheckedIn: notCheckedIn ?? 0,
    late: late ?? 0,
  );
}

extension DashboardCollectionPointModelToEntity
    on DashboardCollectionPointModel {
  DashboardCollectionPointEntity toEntity() => DashboardCollectionPointEntity(
    date: DateTime.tryParse(date ?? ''),
    revenue: revenue ?? 0,
    target: target ?? 0,
  );
}

extension DashboardVisitorsModelToEntity on DashboardVisitorsModel {
  DashboardVisitorsEntity toEntity() => DashboardVisitorsEntity(
    date: DateTime.tryParse(date ?? ''),
    male: male ?? 0,
    female: female ?? 0,
    total: total ?? (male ?? 0) + (female ?? 0),
  );
}

extension DashboardIssueBucketsModelToEntity on DashboardIssueBucketsModel {
  DashboardIssueBucketsEntity toEntity() => DashboardIssueBucketsEntity(
    inProgress: inProgress ?? 0,
    completed: completed ?? 0,
    pending: pending ?? 0,
  );
}

extension DashboardFacilitySummaryModelToEntity
    on DashboardFacilitySummaryModel {
  DashboardFacilitySummaryEntity toEntity() => DashboardFacilitySummaryEntity(
    facilityId: facilityId ?? 0,
    facilityName: facilityName ?? '',
    facilityNameBn: facilityNameBn,
    targetRevenue: targetRevenue ?? 0,
    achievedRevenue: achievedRevenue ?? 0,
    achievementPct: achievementPct ?? 0,
    expense: expense ?? 0,
    visitors: visitors?.toEntity() ?? _noVisitors,
    issues:
        issueSummary?.toEntity() ??
        const DashboardIssueBucketsEntity(
          inProgress: 0,
          completed: 0,
          pending: 0,
        ),
  );
}

extension DashboardExecutiveTargetModelToEntity
    on DashboardExecutiveTargetModel {
  DashboardExecutiveTargetEntity toEntity() => DashboardExecutiveTargetEntity(
    executiveId: executiveId ?? 0,
    name: executiveName ?? '',
    target: target ?? 0,
    achieved: achieved ?? 0,
  );
}

extension DashboardExecutiveFacilityModelToEntity
    on DashboardExecutiveFacilityModel {
  DashboardExecutiveFacilityEntity toEntity() =>
      DashboardExecutiveFacilityEntity(
        facilityId: facilityId ?? 0,
        facilityName: facilityName ?? '',
        facilityNameBn: facilityNameBn,
        achievementPct: achievementPct ?? 0,
        expense: expense ?? 0,
        visitorsToday: visitorsToday?.toEntity() ?? _noVisitors,
      );
}

extension DashboardExecutiveDetailModelToEntity
    on DashboardExecutiveDetailModel {
  DashboardExecutiveDetailEntity toEntity() => DashboardExecutiveDetailEntity(
    executiveId: executiveId ?? 0,
    name: executiveName ?? '',
    totalFacility: totalFacility ?? facilities.length,
    monthlyTarget: monthlyTarget ?? 0,
    facilities: [for (final f in facilities) f.toEntity()],
  );
}

extension DashboardIssueStatusModelToEntity on DashboardIssueStatusModel {
  DashboardIssueStatusEntity toEntity() => DashboardIssueStatusEntity(
    status: DashboardIssueStatus.fromKey(status),
    label: label ?? '',
    count: count ?? 0,
    percentage: percentage ?? 0,
  );
}

extension DashboardRecentIssueModelToEntity on DashboardRecentIssueModel {
  DashboardRecentIssueEntity toEntity() => DashboardRecentIssueEntity(
    id: id ?? 0,
    title: title ?? '',
    facilityName: facilityName ?? '',
    status: DashboardIssueStatus.fromKey(status),
    statusLabel: status ?? '',
  );
}

extension DashboardIssuesModelToEntity on DashboardIssuesModel {
  DashboardIssuesEntity toEntity() => DashboardIssuesEntity(
    totalIssues: totalIssues ?? 0,
    byStatus: [for (final s in byStatus) s.toEntity()],
    summary: summary == null
        ? _noIssues.summary
        : DashboardIssueSummaryEntity(
            critical: summary!.critical ?? 0,
            medium: summary!.medium ?? 0,
            total: summary!.total ?? 0,
            solved: summary!.solved ?? 0,
          ),
    recent: [for (final r in recent) r.toEntity()],
  );
}

extension DashboardFacilityRevenueModelToEntity
    on DashboardFacilityRevenueModel {
  DashboardFacilityRevenueEntity toEntity() => DashboardFacilityRevenueEntity(
    facilityId: facilityId ?? 0,
    facilityName: facilityName ?? '',
    facilityNameBn: facilityNameBn,
    revenue: revenue ?? 0,
    targetPct: targetPct ?? 0,
    changePct: changePct ?? 0,
  );
}

extension DashboardDataModelToEntity on DashboardDataModel {
  /// Throws [FormatException] for a `dashboard_type` this client does not
  /// know; the repository surfaces it as a failure.
  DashboardEntity toEntity() {
    final shortage = staffShortage?.toEntity() ?? _noShortage;

    switch (dashboardType) {
      case 'supervisor':
        return SupervisorDashboardEntity(
          staffShortage: shortage,
          month: month ?? '',
          checkInOut:
              checkInOut?.toEntity() ??
              const DashboardCheckInOutEntity(
                status: DashboardCheckInStatus.notCheckedIn,
                checkInAt: null,
                checkOutAt: null,
                facilityName: null,
                visitCount: 0,
              ),
          stats:
              stats?.toEntity() ??
              const DashboardStatsEntity(
                todayWorking: 0,
                todayRostered: 0,
                pendingApproval: 0,
                notCheckedIn: 0,
                late: 0,
              ),
          dailyTarget: collectionThisWeek?.dailyTarget ?? 0,
          collection: [
            for (final p
                in collectionThisWeek?.series ??
                    const <DashboardCollectionPointModel>[])
              p.toEntity(),
          ],
          visitorsPerDay: [for (final v in visitorsPerDay) v.toEntity()],
          facilities: [for (final f in facilitySummary) f.toEntity()],
        );
      case 'ops_manager':
        return OpsManagerDashboardEntity(
          staffShortage: shortage,
          month: month ?? '',
          executiveTargets: [
            for (final e in targetVsAchievementByExecutive) e.toEntity(),
          ],
          issues: issues?.toEntity() ?? _noIssues,
          executives: [for (final e in executiveDetails) e.toEntity()],
        );
      case 'partner_owner':
        return PartnerOwnerDashboardEntity(
          staffShortage: shortage,
          totalRevenue: DashboardTotalRevenueEntity(
            amount: totalRevenue?.amount ?? 0,
            changePct: totalRevenue?.changePct ?? 0,
            facilityCount: totalRevenue?.facilityCount ?? 0,
          ),
          revenueTrend: [
            for (final t in revenueTrend)
              DashboardRevenueTrendEntity(
                label: t.label ?? '',
                revenue: t.revenue ?? 0,
                target: t.target ?? 0,
              ),
          ],
          topFacilities: [
            for (final f
                in revenueByFacility?.top ??
                    const <DashboardFacilityRevenueModel>[])
              f.toEntity(),
          ],
          lowestFacilities: [
            for (final f
                in revenueByFacility?.lowest ??
                    const <DashboardFacilityRevenueModel>[])
              f.toEntity(),
          ],
          issues: issues?.toEntity() ?? _noIssues,
        );
    }

    throw FormatException('Unknown dashboard_type: $dashboardType');
  }
}

extension DashboardResponseModelToEntity on DashboardResponseModel {
  DashboardEntity toEntity() {
    final dashboard = data;
    if (dashboard == null) throw const FormatException('Empty dashboard');

    return dashboard.toEntity();
  }
}
