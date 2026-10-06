import 'package:facility_management_app/src/data/extension/dashboard_mapper.dart';
import 'package:facility_management_app/src/data/models/dashboard/dashboard_model.dart';
import 'package:facility_management_app/src/domain/entities/dashboard_entity.dart';
import 'package:flutter_test/flutter_test.dart';

const _shortage = {
  'total_shortage': 3,
  'facility_count': 2,
  'items': [
    {
      'shift_slot_id': 145,
      'weekly_roster_id': 52,
      'facility_id': 1,
      'facility_name': 'Mirpur 1',
      'facility_name_bn': null,
      'shift_label': 'Mirpur 1 Morning shift',
      'shift_start_time': '08:00',
      'shortage_count': 2,
    },
  ],
};

const _issues = {
  'total_issues': 9,
  'by_status': [
    {'status': 'open', 'label': 'Open', 'count': 2, 'percentage': 22.2},
    {'status': 'resolved', 'label': 'Solved', 'count': 3, 'percentage': 33.3},
  ],
  'summary': {'critical': 2, 'medium': 4, 'total': 9, 'solved': 3},
  'recent': [
    {
      'id': 501,
      'title': 'Water leak',
      'facility_id': 10,
      'facility_name': 'Mirpur-10',
      'status': 'open',
      'priority': 'critical',
      'created_at': '2026-10-05T09:12:00+00:00',
    },
  ],
};

DashboardEntity _map(Map<String, dynamic> data) =>
    DashboardResponseModel.fromJson({'data': data}).toEntity();

void main() {
  test('role key maps known values and ignores unknown ones', () {
    expect(UserRole.fromKey('supervisor'), UserRole.supervisor);
    expect(UserRole.fromKey('ops_manager'), UserRole.opsManager);
    expect(UserRole.fromKey('partner_owner'), UserRole.partnerOwner);
    expect(UserRole.fromKey('attendant'), UserRole.attendant);
    expect(UserRole.fromKey('technician'), isNull);
    expect(UserRole.fromKey(null), isNull);
  });

  test('supervisor dashboard', () {
    final d = _map({
      'dashboard_type': 'supervisor',
      'month': '2026-09',
      'check_in_out': {
        'status': 'checked_in',
        'check_in_at': '2026-10-06 08:15:00',
        'check_out_at': null,
        'facility_id': 10,
        'facility_name': 'Mirpur-10',
        'visit_count': 2,
      },
      'staff_shortage': _shortage,
      'stats': {
        'today_working': 18,
        'today_rostered': 23,
        'pending_approval': 4,
        'not_checked_in': 3,
        'late': 2,
      },
      'collection_this_week': {
        'daily_target': 2000.0,
        'series': [
          {'date': '2026-10-05', 'revenue': 2180.0, 'target': 2000.0},
        ],
      },
      'visitors_per_day': [
        {'date': '2026-10-05', 'male': 176, 'female': 119, 'total': 295},
      ],
      'facility_summary': [
        {
          'facility_id': 10,
          'facility_name': 'Mirpur-10',
          'facility_name_bn': null,
          'target_revenue': 15000.0,
          'achieved_revenue': 9450.0,
          'achievement_pct': 63.0,
          'expense': 3200.0,
          'air_quality': {
            'value': 0,
            'label': 'Unknown',
            'is_placeholder': true,
          },
          'visitors': {'male': 142, 'female': 96, 'total': 238},
          'issue_summary': {'in_progress': 3, 'completed': 1, 'pending': 1},
        },
      ],
    });

    expect(d, isA<SupervisorDashboardEntity>());
    d as SupervisorDashboardEntity;
    expect(d.staffShortage.items.single.shortageCount, 2);
    expect(d.staffShortage.items.single.shiftSlotId, 145);
    expect(d.staffShortage.items.single.weeklyRosterId, 52);
    expect(d.month, '2026-09');
    expect(d.checkInOut.status, DashboardCheckInStatus.checkedIn);
    expect(d.checkInOut.checkInAt, DateTime(2026, 10, 6, 8, 15));
    expect(d.checkInOut.checkOutAt, isNull);
    expect(d.checkInOut.visitCount, 2);
    expect(d.stats.todayWorking, 18);
    expect(d.dailyTarget, 2000);
    expect(d.collection.single.date, DateTime(2026, 10, 5));
    expect(d.visitorsPerDay.single.female, 119);
    expect(d.facilities.single.achievementPct, 63);
    expect(d.facilities.single.issues.inProgress, 3);
  });

  test('ops manager dashboard', () {
    final d = _map({
      'dashboard_type': 'ops_manager',
      'staff_shortage': _shortage,
      'target_vs_achievement_by_executive': [
        {
          'executive_id': 7,
          'executive_name': 'Tania Akter',
          'target': 30000.0,
          'achieved': 19100.0,
        },
      ],
      'issues': _issues,
      'executive_details': [
        {
          'executive_id': 8,
          'executive_name': 'Karim Uddin',
          'total_facility': 3,
          'monthly_target': 42000.0,
          'facilities': [
            {
              'facility_id': 10,
              'facility_name': 'Mirpur-10',
              'facility_name_bn': null,
              'achievement_pct': 63.0,
              'expense': 3200.0,
              'visitors_today': {'male': 142, 'female': 96, 'total': 238},
            },
          ],
        },
      ],
    });

    expect(d, isA<OpsManagerDashboardEntity>());
    d as OpsManagerDashboardEntity;
    expect(d.month, '');
    expect(d.executiveTargets.single.achieved, 19100);
    expect(d.executives.single.facilities.single.visitorsToday.male, 142);
    expect(d.issues.byStatus.first.status, DashboardIssueStatus.open);
    expect(d.issues.summary.critical, 2);
    expect(d.issues.recent.single.status, DashboardIssueStatus.open);
  });

  test('partner owner dashboard', () {
    final d = _map({
      'dashboard_type': 'partner_owner',
      'staff_shortage': _shortage,
      'total_revenue': {
        'amount': 45000.0,
        'change_pct': 4.0,
        'facility_count': 6,
      },
      'revenue_trend': [
        {
          'year_month': '2026-10',
          'label': 'Oct',
          'revenue': 45000.0,
          'target': 42000.0,
        },
      ],
      'revenue_by_facility': {
        'top': [
          {
            'facility_id': 11,
            'facility_name': 'Dhanmondi',
            'facility_name_bn': 'ধানমন্ডি',
            'revenue': 12500.0,
            'target_pct': 83.0,
            'change_pct': 6.0,
          },
        ],
        'lowest': [],
      },
      'issues': _issues,
    });

    expect(d, isA<PartnerOwnerDashboardEntity>());
    d as PartnerOwnerDashboardEntity;
    expect(d.totalRevenue.facilityCount, 6);
    expect(d.revenueTrend.single.label, 'Oct');
    expect(d.topFacilities.single.localizedName('bn'), 'ধানমন্ডি');
    expect(d.topFacilities.single.localizedName('en'), 'Dhanmondi');
    expect(d.lowestFacilities, isEmpty);
  });

  test('a missing shortage block is an empty one', () {
    final d = _map({'dashboard_type': 'ops_manager'});
    expect(d.staffShortage.items, isEmpty);
    expect(d.staffShortage.totalShortage, 0);
  });

  test('unknown dashboard type is rejected', () {
    expect(() => _map({'dashboard_type': 'technician'}), throwsFormatException);
  });
}
