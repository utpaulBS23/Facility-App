import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/category_filter_chips.dart';
import '../../../core/widgets/month_filter_button.dart';
import '../widgets/check_in_out_card.dart';
import '../widgets/column_chart.dart';
import '../widgets/dashboard_filter_chips.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_meter.dart';
import '../widgets/dashboard_section_header.dart';
import '../widgets/dashboard_stat_tile.dart';
import '../widgets/dashboard_tone.dart';
import '../widgets/donut_chart.dart';
import '../widgets/executive_card.dart';
import '../widgets/facility_card.dart';
import '../widgets/facility_row.dart';
import '../widgets/issue_row.dart';
import '../widgets/issue_summary_card.dart';
import '../widgets/kpi_hero_card.dart';
import '../widgets/revenue_row.dart';
import '../widgets/staff_shortage_alert.dart';
import '../widgets/trend_chart.dart';
import 'dashboard_sample_data.dart';

const _allFacilities = 'All facilities';
const _allExecutives = 'All executives';
const _topRevenue = 'Top revenue';
const _lowRevenue = 'Lowest revenue';

/// The Dashboard tab, with every role's components on one page: the
/// supervisor's day (check in, shortage, counts, charts, facility cards), the
/// operations manager's executives and issues, and the owner's revenue.
///
/// TODO: sample content, see dashboard_sample_data.dart.
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _facility = _allFacilities;
  String _executive = _allExecutives;
  String _revenue = _topRevenue;
  DateTime _facilityMonth = _thisMonth();
  DateTime _executiveMonth = _thisMonth();

  static DateTime _thisMonth() {
    final now = DateTime.now();
    return DateTime(now.year, now.month);
  }

  String _monthLabel(DateTime month) => DateFormat(
    'MMM yyyy',
    Localizations.localeOf(context).languageCode,
  ).format(month);

  void _pickMonth(DateTime current, ValueChanged<DateTime> onPicked) {
    showMonthPickerDialog(
      context,
      month: current,
      lastDate: DateTime.now(),
      onSelected: (m) => setState(() => onPicked(m)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gap = SizedBox(height: context.dimensions.spacing.s12);

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const DashboardHeader(
                greeting: 'Welcome, Rahim',
                initial: 'R',
                role: 'Supervisor',
                dateText: 'Mon, 5 Oct',
                unreadText: '3',
                bellLabel: 'Notifications, 3 unread',
              ),
              Padding(
                padding: EdgeInsets.all(context.dimensions.spacing.s16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // My day. Not checked in yet: Check In is live, Check Out
                    // is not.
                    CheckInOutCard(
                      checkInText: '--:--',
                      checkOutText: '--:--',
                      statusText: 'Mirpur morning shift · not checked in yet',
                      statusTone: DashboardTone.neutral,
                      onCheckIn: () {},
                    ),
                    gap,
                    StaffShortageAlert(
                      totalText: '7',
                      summary: '7 people short across 4 facilities',
                      rows: sampleShortages,
                      onAssign: (_) {},
                    ),
                    gap,
                    const _CountTiles(),
                    gap,

                    // Revenue
                    const KpiHeroCard(
                      label: 'Total revenue · Oct 2026',
                      value: '৳ 45,000',
                      deltaText: '▲ 4% vs last month',
                      deltaPositive: true,
                      footnote: 'across 6 facilities',
                    ),
                    gap,
                    const TrendChart(
                      title: 'Revenue trend',
                      subtitle: 'Last 6 months vs monthly target',
                      labels: sampleMonths,
                      valuePrefix: '৳ ',
                      series: sampleRevenueSeries,
                    ),
                    gap,
                    const DashboardSectionHeader(
                      title: 'Revenue by facility',
                      subtitle: 'Share of monthly target reached',
                      actionLabel: 'View all',
                    ),
                    gap,
                    DashboardFilterChips(
                      style: DashboardFilterStyle.segmented,
                      options: const [_topRevenue, _lowRevenue],
                      selected: _revenue,
                      onSelected: (v) => setState(() => _revenue = v),
                    ),
                    for (final r
                        in _revenue == _topRevenue
                            ? sampleTopRevenue
                            : sampleLowRevenue) ...[
                      SizedBox(height: context.dimensions.spacing.s8),
                      RevenueRow(
                        rank: '${r.rank}',
                        name: r.name,
                        amountText: '৳ ${sampleMoney(r.amount)}',
                        percent: r.percent,
                        percentText: '${r.percent}%',
                        deltaText:
                            '${r.delta >= 0 ? '▲' : '▼'} ${r.delta.abs()}% '
                            'vs last month',
                        deltaPositive: r.delta >= 0,
                        tone: r.tone,
                      ),
                    ],
                    gap,

                    // Collection and visitors
                    const TrendChart(
                      title: 'Collection this week',
                      subtitle: 'Achieved vs daily target · all facilities',
                      labels: sampleDays,
                      valuePrefix: '৳ ',
                      series: sampleCollectionSeries,
                    ),
                    gap,
                    const ColumnChart(
                      title: 'Visitors per day',
                      subtitle: 'Male and female, last 7 days',
                      labels: sampleDays,
                      series: sampleVisitorSeries,
                    ),
                    gap,

                    // Executives
                    const ColumnChart(
                      title: 'Target vs achievement',
                      subtitle: 'Monthly, by executive',
                      labels: sampleExecutiveLabels,
                      mode: ColumnChartMode.grouped,
                      valuePrefix: '৳ ',
                      series: sampleExecutiveSeries,
                    ),
                    gap,
                    ..._executiveSection(),
                    gap,

                    // Facilities
                    ..._facilitySection(),
                    gap,

                    // Issues
                    const DonutChart(
                      title: 'Issues by status',
                      subtitle: 'All facilities, this month',
                      centerLabel: 'issues',
                      slices: sampleIssueSlices,
                    ),
                    gap,
                    const IssueSummaryCard(
                      title: 'Issue summary',
                      counts: sampleIssueCounts,
                    ),
                    gap,
                    RecentIssuesCard(
                      title: 'Recent issues',
                      issues: [
                        for (final i in sampleRecentIssues)
                          IssueRow(
                            title: i.title,
                            facility: i.facility,
                            status: i.status,
                            tone: i.tone,
                          ),
                      ],
                    ),
                    SizedBox(height: context.dimensions.spacing.s16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _executiveSection() {
    final spacing = context.dimensions.spacing;
    final visible = [
      for (final e in sampleExecutives)
        if (_executive == _allExecutives || e.name == _executive) e,
    ];

    return [
      DashboardSectionHeader(
        title: 'Executive details',
        subtitle:
            'Showing ${visible.length} of ${sampleExecutives.length} '
            'executives',
        actionLabel: _monthLabel(_executiveMonth),
        onAction: () => _pickMonth(_executiveMonth, (m) => _executiveMonth = m),
      ),
      SizedBox(height: spacing.s12),
      CategoryFilterChips<String>(
        categories: [_allExecutives, for (final e in sampleExecutives) e.name],
        selectedCategory: _executive,
        onSelected: (v) => setState(() => _executive = v),
      ),
      for (final e in visible) ...[
        SizedBox(height: spacing.s12),
        ExecutiveCard(
          name: e.name,
          facilityCountText: '${e.facilities.length}',
          targetText: '৳ ${sampleMoney(e.target)}',
          facilities: [
            for (final f in e.facilities)
              FacilityRow(
                name: f.name,
                meterLabel: 'Target vs achievement',
                percent: f.pct,
                pctText: '${f.pct}%',
                footLeft: 'Expense ৳ ${sampleMoney(f.expense)}',
                footRight: 'M ${f.male} · F ${f.female} per day',
              ),
          ],
        ),
      ],
    ];
  }

  List<Widget> _facilitySection() {
    final spacing = context.dimensions.spacing;
    final visible = [
      for (final f in sampleFacilities)
        if (_facility == _allFacilities || f.name == _facility) f,
    ];

    return [
      DashboardSectionHeader(
        title: 'Facility summary',
        subtitle: '${visible.length} of ${sampleFacilities.length} facilities',
        actionLabel: _monthLabel(_facilityMonth),
        onAction: () => _pickMonth(_facilityMonth, (m) => _facilityMonth = m),
      ),
      SizedBox(height: spacing.s12),
      CategoryFilterChips<String>(
        categories: [_allFacilities, for (final f in sampleFacilities) f.name],
        selectedCategory: _facility,
        onSelected: (v) => setState(() => _facility = v),
      ),
      for (final f in visible) ...[
        SizedBox(height: spacing.s12),
        FacilityCard(data: f.toCard()),
      ],
    ];
  }
}

class _CountTiles extends StatelessWidget {
  const _CountTiles();

  @override
  Widget build(BuildContext context) {
    final gap = context.dimensions.spacing.s10;

    Widget row(Widget a, Widget b) => IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: a),
          SizedBox(width: gap),
          Expanded(child: b),
        ],
      ),
    );

    return Column(
      children: [
        row(
          const DashboardStatTile(
            value: '18',
            label: 'Today working',
            tone: DashboardTone.green,
            hint: 'of 23 rostered',
          ),
          const DashboardStatTile(
            value: '4',
            label: 'Pending approval',
            tone: DashboardTone.orange,
            hint: 'Needs your review',
          ),
        ),
        SizedBox(height: gap),
        row(
          const DashboardStatTile(
            value: '3',
            label: 'Not checked in',
            tone: DashboardTone.blue,
            hint: 'Shift not started',
          ),
          const DashboardStatTile(
            value: '2',
            label: 'Late',
            tone: DashboardTone.red,
            hint: 'Past start time',
          ),
        ),
        SizedBox(height: gap),
        const DashboardMeter(
          label: 'Monthly target vs achievement',
          valueText: '63%',
          percent: 63,
          tone: DashboardTone.orange,
          footLeft: '৳ 9,450 achieved',
          footRight: 'Target ৳ 15,000',
        ),
      ],
    );
  }
}
