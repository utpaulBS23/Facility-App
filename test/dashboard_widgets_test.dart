import 'package:facility_management_app/src/core/extensions/app_numbers.dart';
import 'package:facility_management_app/src/core/gen/l10n/app_localizations.dart';
import 'package:facility_management_app/src/presentation/core/theme/theme.dart';
import 'package:facility_management_app/src/presentation/features/dashboard/widgets/check_in_out_card.dart';
import 'package:facility_management_app/src/presentation/features/dashboard/widgets/column_chart.dart';
import 'package:facility_management_app/src/presentation/features/dashboard/widgets/dashboard_chart_common.dart';
import 'package:facility_management_app/src/presentation/features/dashboard/widgets/dashboard_filter_chips.dart';
import 'package:facility_management_app/src/presentation/features/dashboard/widgets/dashboard_header.dart';
import 'package:facility_management_app/src/presentation/features/dashboard/widgets/dashboard_meter.dart';
import 'package:facility_management_app/src/presentation/features/dashboard/widgets/dashboard_section_header.dart';
import 'package:facility_management_app/src/presentation/features/dashboard/widgets/dashboard_stat_tile.dart';
import 'package:facility_management_app/src/presentation/features/dashboard/widgets/dashboard_toggle.dart';
import 'package:facility_management_app/src/presentation/features/dashboard/widgets/dashboard_tone.dart';
import 'package:facility_management_app/src/presentation/features/dashboard/widgets/donut_chart.dart';
import 'package:facility_management_app/src/presentation/features/dashboard/widgets/executive_card.dart';
import 'package:facility_management_app/src/presentation/features/dashboard/widgets/facility_card.dart';
import 'package:facility_management_app/src/presentation/features/dashboard/widgets/facility_row.dart';
import 'package:facility_management_app/src/presentation/features/dashboard/widgets/issue_row.dart';
import 'package:facility_management_app/src/presentation/features/dashboard/widgets/issue_summary_card.dart';
import 'package:facility_management_app/src/presentation/features/dashboard/widgets/kpi_hero_card.dart';
import 'package:facility_management_app/src/presentation/features/dashboard/widgets/notification_item.dart';
import 'package:facility_management_app/src/presentation/features/dashboard/widgets/preference_row.dart';
import 'package:facility_management_app/src/presentation/features/dashboard/widgets/revenue_row.dart';
import 'package:facility_management_app/src/presentation/features/dashboard/widgets/staff_shortage_alert.dart';
import 'package:facility_management_app/src/presentation/features/dashboard/widgets/trend_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

const _facility = FacilityCardData(
  name: 'Mirpur-10 Public Toilet Complex',
  percent: 63,
  pctText: '63%',
  achievedText: '৳ 9,450 achieved',
  targetText: 'Target ৳ 15,000',
  expenseText: '৳ 3,200',
  maleCount: 142,
  femaleCount: 96,
  maleText: '142 (60%)',
  femaleText: '96 (40%)',
  totalVisitorsText: '238 total',
  inProgressText: '3',
  completedText: '1',
  pendingText: '1',
  aqiText: '10',
  aqiLabel: 'Good',
  aqiTone: DashboardTone.green,
);

const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

Widget _gallery() {
  FacilityRow row(String name, num pct) => FacilityRow(
    name: name,
    meterLabel: 'Target vs achievement',
    percent: pct,
    pctText: '$pct%',
    footLeft: 'Expense ৳ 3,200',
    footRight: 'M 142 · F 96 per day',
  );

  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const DashboardHeader(
        greeting: 'Welcome, Rahim',
        initial: 'R',
        role: 'Supervisor',
        dateText: 'Mon, 5 Oct',
        unreadText: '3',
      ),
      CheckInOutCard(
        checkInText: '--:--',
        checkOutText: '--:--',
        statusText: 'Mirpur morning shift - not checked in yet',
        statusTone: DashboardTone.neutral,
        onCheckIn: () {},
      ),
      StaffShortageAlert(
        totalText: '6',
        summary: '6 people short across 3 facilities',
        rows: const [
          StaffShortageRow(
            facility: 'Mirpur 1',
            slot: 'Mirpur morning shift',
            when: 'Starts 8:00 AM',
            peopleText: '2 person',
          ),
          StaffShortageRow(
            facility: 'Dhanmondi Market Restrooms',
            slot: 'Dhanmondi morning shift',
            when: 'Starts 8:00 AM',
            peopleText: '1 person',
          ),
          StaffShortageRow(
            facility: 'Gulshan-2 Market Toilet',
            slot: 'Gulshan day shift',
            when: 'Starts 10:00 AM',
            peopleText: '3 person',
          ),
        ],
        onAssign: (_) {},
      ),
      const Row(
        children: [
          Expanded(
            child: DashboardStatTile(
              value: '18',
              label: 'Today working',
              tone: DashboardTone.green,
              hint: 'of 23 rostered',
            ),
          ),
          Expanded(
            child: DashboardStatTile(
              value: '4',
              label: 'Pending approval',
              tone: DashboardTone.orange,
            ),
          ),
        ],
      ),
      const DashboardSectionHeader(
        title: 'Collection this week',
        subtitle: 'Achieved vs target',
        actionLabel: 'See all',
      ),
      DashboardFilterChips(
        options: const [
          'All facilities',
          'Mirpur-10',
          'Dhanmondi',
          'Gulshan-2',
        ],
        selected: 'All facilities',
        onSelected: (_) {},
      ),
      DashboardFilterChips(
        options: const ['Week', 'Month'],
        selected: 'Week',
        style: DashboardFilterStyle.segmented,
        onSelected: (_) {},
      ),
      const DashboardMeter(
        label: 'Monthly target vs achievement',
        valueText: '63%',
        percent: 63,
        tone: DashboardTone.orange,
        footLeft: '৳ 9,450 achieved',
        footRight: 'Target ৳ 15,000',
      ),
      const KpiHeroCard(
        label: 'Total revenue',
        value: '৳ 1,24,500',
        deltaText: '▲ 6% vs last month',
        deltaPositive: true,
        footnote: 'All facilities',
      ),
      const FacilityCard(data: _facility),
      ExecutiveCard(
        name: 'Karim Uddin',
        facilityCountText: '3',
        targetText: '৳ 42,000',
        facilities: [
          row('Mirpur-10 Public Toilet Complex', 63),
          row('Dhanmondi Market Restrooms', 83),
          row('Gulshan-2 Market Toilet', 49),
        ],
      ),
      const RevenueRow(
        rank: '1',
        name: 'Dhanmondi Market Restrooms',
        amountText: '৳ 12,500',
        percent: 83,
        percentText: '83%',
        deltaText: '▲ 6% vs last month',
        deltaPositive: true,
      ),
      const RevenueRow(
        rank: '3',
        name: 'Gulshan-2 Market Toilet',
        amountText: '৳ 7,300',
        percent: 49,
        percentText: '49%',
        deltaText: '▼ 3% vs last month',
        deltaPositive: false,
      ),
      const IssueSummaryCard(
        title: 'Issue summary',
        counts: [
          IssueCount(
            valueText: '2',
            label: 'Critical',
            tone: DashboardTone.red,
          ),
          IssueCount(
            valueText: '4',
            label: 'Medium',
            tone: DashboardTone.orange,
          ),
          IssueCount(
            valueText: '9',
            label: 'Total issue',
            tone: DashboardTone.blue,
          ),
          IssueCount(
            valueText: '3',
            label: 'Solved',
            tone: DashboardTone.green,
          ),
        ],
      ),
      const RecentIssuesCard(
        title: 'Recent issues',
        issues: [
          IssueRow(
            title: 'Water leak',
            facility: 'Mirpur-10 Public Toilet Complex',
            status: 'Open',
            tone: DashboardTone.red,
          ),
          IssueRow(
            title: 'Power problem',
            facility: 'Dhanmondi Market Restrooms',
            status: 'Ongoing',
            tone: DashboardTone.orange,
          ),
        ],
      ),
      const NotificationItem(
        kind: 'odour',
        tone: DashboardTone.red,
        severity: NotificationSeverity.critical,
        title: 'Odour breach at Mirpur-10 Public Toilet Complex',
        body: 'Ammonia reading is 18 ppm, above the 10 ppm threshold.',
        timeText: '5m ago',
        unread: true,
        expanded: true,
        actionLabel: 'View sensor',
      ),
      const NotificationItem(
        kind: 'staffing',
        tone: DashboardTone.orange,
        severity: NotificationSeverity.medium,
        title: 'Staff shortage tomorrow',
        body: 'Two attendants are missing from the morning shift.',
        timeText: '1h ago',
        expanded: true,
        actionLabel: 'Assign Staff',
        actionIsAssign: true,
      ),
      const PreferenceRow(
        kind: 'camera',
        tone: DashboardTone.red,
        title: 'Camera / Device down',
        hint: 'First alert after 15 min offline. Escalates at 1 hour.',
        pushOn: true,
        pushLocked: true,
        emailOn: true,
      ),
      const PreferenceRow(
        kind: 'digest',
        tone: DashboardTone.blue,
        title: 'Daily summary',
        hint: 'One message each morning.',
        pushOn: false,
        emailMode: EmailMode.digest,
      ),
      const DashboardToggle(label: 'Email', on: false),
      const TrendChart(
        title: 'Collection this week',
        labels: _days,
        valuePrefix: '৳ ',
        series: [
          ChartSeries(
            name: 'Achieved',
            tone: DashboardTone.brand,
            area: true,
            values: [1850, 2100, 1720, 2380, 2210, 2540, 2180],
          ),
          ChartSeries(
            name: 'Target',
            tone: DashboardTone.neutral,
            dashed: true,
            values: [2000, 2000, 2000, 2000, 2000, 2000, 2000],
          ),
        ],
      ),
      const ColumnChart(
        title: 'Visitors per day',
        labels: _days,
        series: [
          ChartSeries(
            name: 'Male',
            tone: DashboardTone.blue,
            values: [142, 150, 138, 161, 155, 190, 176],
          ),
          ChartSeries(
            name: 'Female',
            tone: DashboardTone.brand,
            values: [96, 101, 92, 110, 104, 128, 119],
          ),
        ],
      ),
      const DonutChart(
        title: 'Issues by status',
        centerLabel: 'issues',
        slices: [
          DonutSlice(label: 'Open', value: 2, tone: DashboardTone.red),
          DonutSlice(
            label: 'In progress',
            value: 3,
            tone: DashboardTone.orange,
          ),
          DonutSlice(label: 'Assigned', value: 1, tone: DashboardTone.blue),
          DonutSlice(label: 'Solved', value: 3, tone: DashboardTone.green),
        ],
      ),
    ],
  );
}

Future<void> _pump(WidgetTester tester, Locale locale) async {
  Intl.defaultLocale = locale.languageCode;
  tester.view.physicalSize = const Size(390 * 3, 8000 * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      theme: $LightThemeData('').call(),
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              for (final w in (_gallery() as Column).children) ...[
                w,
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('every component renders without errors in English', (
    tester,
  ) async {
    await _pump(tester, const Locale('en'));

    expect(tester.takeException(), isNull);
    expect(find.text('Staff shortage'), findsOneWidget);
    expect(find.text('Show 1 more facility'), findsOneWidget);
    expect(find.text('Always on'), findsOneWidget);
    expect(find.text('Digest only'), findsOneWidget);
    expect(find.text('83% of target'), findsOneWidget);
  });

  testWidgets('every component renders in Bangla', (tester) async {
    await _pump(tester, const Locale('bn'));

    // WHY not asserted: the test font gives every Bangla glyph a full em, so
    // fixed-width widgets overflow here but not on a device.
    tester.takeException();
    expect(find.text('কর্মী সংকট'), findsOneWidget);
  });

  testWidgets('Show more expands the shortage list and Show less folds it', (
    tester,
  ) async {
    await _pump(tester, const Locale('en'));

    expect(find.text('Gulshan-2 Market Toilet'), findsNWidgets(2));
    await tester.ensureVisible(find.text('Show 1 more facility'));
    await tester.tap(find.text('Show 1 more facility'));
    await tester.pump();

    expect(find.text('Show less'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tapping a day moves the chart readout', (tester) async {
    await _pump(tester, const Locale('en'));

    // The last day is selected first; Monday's value is not in the readout.
    expect(find.text('৳ 1,850'), findsNothing);
    await tester.ensureVisible(find.text('Mon').first);
    await tester.tap(find.text('Mon').first);
    await tester.pump();

    expect(find.text('৳ 1,850'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test('ChartScale rounds the top to an even half step', () {
    expect(ChartScale(2540).top, 3000);
    expect(ChartScale(190 + 128).top, 400);
    expect(ChartScale(0).top, greaterThan(0));
    expect(ChartScale.axisLabel(1500, const AppNumbers('en')), '1.5k');
    expect(ChartScale.axisLabel(2000, const AppNumbers('en')), '2k');
    expect(ChartScale.axisLabel(800, const AppNumbers('en')), '800');
  });

  test('meter tone follows the 50 and 75 thresholds', () {
    expect(DashboardMeter.toneForPercent(75), DashboardTone.green);
    expect(DashboardMeter.toneForPercent(74), DashboardTone.orange);
    expect(DashboardMeter.toneForPercent(50), DashboardTone.orange);
    expect(DashboardMeter.toneForPercent(49), DashboardTone.red);
  });

  test('executive initials use the first two words', () {
    expect(ExecutiveCard.initialsOf('Karim Uddin'), 'KU');
    expect(ExecutiveCard.initialsOf('  rahim '), 'R');
    expect(ExecutiveCard.initialsOf(''), '?');
  });
}
