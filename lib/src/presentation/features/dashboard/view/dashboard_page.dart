import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/app_numbers.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../core/utils/api_date.dart';
import '../../../../domain/entities/dashboard_entity.dart';
import '../../../core/application_state/session_provider/session_provider.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/category_filter_chips.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/month_filter_button.dart';
import '../riverpod/dashboard_provider.dart';
import '../widgets/check_in_out_card.dart';
import '../widgets/column_chart.dart';
import '../widgets/dashboard_chart_common.dart';
import '../widgets/dashboard_filter_chips.dart';
import '../widgets/dashboard_header.dart';
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

// TODO: texts below are English only; move them to the arb files with the
// next localisation pass.
const _allFacilities = 'All facilities';
const _allExecutives = 'All executives';
const _topRevenue = 'Top revenue';
const _lowRevenue = 'Lowest revenue';

/// The Dashboard tab. The user's role (from login) decides whether a
/// dashboard is requested at all; the response type decides what is drawn:
///
/// * supervisor: shortage, today's counts, week charts, facility cards
/// * operations manager: shortage, executives, issues
/// * partner owner: shortage, revenue, issues
/// * attendant: none, the API has no dashboard for the role
class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  DateTime _month = _thisMonth();

  static DateTime _thisMonth() {
    final now = DateTime.now();

    return DateTime(now.year, now.month);
  }

  // The server defaults to this month and ignores it for the owner.
  String get _monthParam =>
      '${_month.year.toString().padLeft(4, '0')}-'
      '${_month.month.toString().padLeft(2, '0')}';

  void _pickMonth() {
    showMonthPickerDialog(
      context,
      month: _month,
      lastDate: DateTime.now(),
      onSelected: (m) => setState(() => _month = DateTime(m.year, m.month)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(userSessionProvider.select((s) => s?.role));
    final user = ref.watch(dashboardUserProvider);
    final language = Localizations.localeOf(context).languageCode;
    final name = user?.localizedName(language) ?? '';

    final header = DashboardHeader(
      greeting: name.isEmpty ? 'Welcome' : 'Welcome, $name',
      initial: name.isEmpty ? '?' : name.characters.first.toUpperCase(),
      role: _roleLabel(role),
      dateText: DateFormat('EEE, d MMM', language).format(DateTime.now()),
    );

    // An attendant has no dashboard; other roles, and a session saved before
    // role_key existed (null), ask the server, which has the final say.
    final Widget body = role == UserRole.attendant
        ? const _Message('No dashboard for your role.')
        : ref
              .watch(dashboardProvider(month: _monthParam))
              .when(
                loading: () => const Center(child: LoadingIndicator()),
                error: (e, _) => AppErrorWidget(
                  message: e.localizedMessage(context),
                  onRetry: () =>
                      ref.invalidate(dashboardProvider(month: _monthParam)),
                ),
                data: (dashboard) => _DashboardBody(
                  dashboard: dashboard,
                  month: _month,
                  onPickMonth: _pickMonth,
                ),
              );

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            header,
            Expanded(
              child: RefreshIndicator(
                // An attendant has no dashboard to reload; refreshing would
                // call the endpoint and get its 404.
                onRefresh: () async {
                  if (role == UserRole.attendant) return;
                  ref.invalidate(dashboardProvider(month: _monthParam));
                  // The error state is drawn by the page; don't rethrow here.
                  try {
                    await ref.read(
                      dashboardProvider(month: _monthParam).future,
                    );
                  } on Object {
                    return;
                  }
                },
                child: body is _DashboardBody
                    ? body
                    : LayoutBuilder(
                        builder: (context, box) => SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(height: box.maxHeight, child: body),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _roleLabel(UserRole? role) => switch (role) {
    UserRole.partnerOwner => 'Partner Owner',
    UserRole.opsManager => 'Operations Manager',
    UserRole.supervisor => 'Supervisor',
    UserRole.attendant => 'Attendant',
    null => '',
  };
}

class _Message extends StatelessWidget {
  const _Message(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: context.textStyle.bodyMedium.copyWith(
          color: context.color.text.secondary,
        ),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({
    required this.dashboard,
    required this.month,
    required this.onPickMonth,
  });

  final DashboardEntity dashboard;
  final DateTime month;
  final VoidCallback onPickMonth;

  @override
  Widget build(BuildContext context) {
    final gap = SizedBox(height: context.dimensions.spacing.s12);
    final d = dashboard;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(context.dimensions.spacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Design order: check in/out card, then the shortage alert.
          if (d case SupervisorDashboardEntity(:final checkInOut)) ...[
            _CheckInOut(checkInOut),
            gap,
          ],
          if (d.staffShortage.items.isNotEmpty) ...[
            _ShortageAlert(shortage: d.staffShortage),
            gap,
          ],
          ...switch (d) {
            SupervisorDashboardEntity() => [
              _SupervisorSections(d, month: month, onPickMonth: onPickMonth),
            ],
            OpsManagerDashboardEntity() => [
              _OpsManagerSections(d, month: month, onPickMonth: onPickMonth),
            ],
            PartnerOwnerDashboardEntity() => [_OwnerSections(d)],
          },
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------- shared

String _money(BuildContext context, num v) => '৳ ${context.numbers.integer(v)}';

String _signedPct(BuildContext context, num v) =>
    '${v >= 0 ? '▲' : '▼'} ${context.numbers.percent(v.abs())}';

String _firstName(String name) => name.trim().split(' ').first;

class _ShortageAlert extends ConsumerWidget {
  const _ShortageAlert({required this.shortage});

  final DashboardStaffShortageEntity shortage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final n = context.numbers;
    // WHY gated: the shift details page loads from the shift-slots endpoint,
    // which only roles with shift access may call.
    final canOpenShift =
        ref.watch(userSessionProvider.select((s) => s?.hasShiftAccess)) ??
        false;
    final itemByRow = <StaffShortageRow, DashboardShortageItemEntity>{};
    final language = Localizations.localeOf(context).languageCode;

    String startText(String hhmm) {
      final parts = hhmm.split(':');
      final h = parts.length == 2 ? int.tryParse(parts[0]) : null;
      final m = parts.length == 2 ? int.tryParse(parts[1]) : null;
      if (h == null || m == null) return hhmm;

      return 'Starts ${DateFormat.jm(language).format(DateTime(2000, 1, 1, h, m))}';
    }

    final rows = [
      for (final i in shortage.items)
        StaffShortageRow(
          facility: i.localizedFacility(language),
          slot: i.shiftLabel,
          when: startText(i.shiftStartTime),
          peopleText: '${n.integer(i.shortageCount)} person',
          assignLabel: 'Assign staff for ${i.localizedFacility(language)}',
        ),
    ];
    for (var k = 0; k < rows.length; k++) {
      itemByRow[rows[k]] = shortage.items[k];
    }

    void openShift(StaffShortageRow row) {
      final slotId = itemByRow[row]?.shiftSlotId;
      if (slotId == null) return;
      context.pushNamed(
        Routes.shiftDetails,
        pathParameters: {
          'facilityId': '${itemByRow[row]!.facilityId}',
          // The shortage list is today's slots only.
          'date': ApiDate.date(DateTime.now()),
          'slotId': '$slotId',
        },
      );
    }

    return StaffShortageAlert(
      totalText: n.integer(shortage.totalShortage),
      summary:
          '${n.integer(shortage.totalShortage)} people short across '
          '${n.integer(shortage.facilityCount)} facilities',
      rows: rows,
      onAssign: canOpenShift ? openShift : null,
    );
  }
}

String _weekday(BuildContext context, DateTime? d) => d == null
    ? ''
    : DateFormat('E', Localizations.localeOf(context).languageCode).format(d);

DashboardTone _issueTone(DashboardIssueStatus s) => switch (s) {
  DashboardIssueStatus.open => DashboardTone.red,
  DashboardIssueStatus.inProgress => DashboardTone.orange,
  DashboardIssueStatus.assigned => DashboardTone.blue,
  DashboardIssueStatus.resolved => DashboardTone.green,
  DashboardIssueStatus.other => DashboardTone.neutral,
};

/// Issue donut, summary tiles and recent list, for the roles that get them.
class _IssueSections extends StatelessWidget {
  const _IssueSections(this.issues);

  final DashboardIssuesEntity issues;

  @override
  Widget build(BuildContext context) {
    final n = context.numbers;
    final gap = SizedBox(height: context.dimensions.spacing.s12);
    final s = issues.summary;
    final labels = {for (final e in issues.byStatus) e.status: e.label};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DonutChart(
          title: 'Issues by status',
          subtitle: 'All facilities, this month',
          centerLabel: 'issues',
          slices: [
            for (final e in issues.byStatus)
              DonutSlice(
                label: e.label,
                value: e.count,
                tone: _issueTone(e.status),
              ),
          ],
        ),
        gap,
        IssueSummaryCard(
          title: 'Issue summary',
          counts: [
            IssueCount(
              valueText: n.integer(s.critical),
              label: 'Critical',
              tone: DashboardTone.red,
            ),
            IssueCount(
              valueText: n.integer(s.medium),
              label: 'Medium',
              tone: DashboardTone.orange,
            ),
            IssueCount(
              valueText: n.integer(s.total),
              label: 'Total issue',
              tone: DashboardTone.blue,
            ),
            IssueCount(
              valueText: n.integer(s.solved),
              label: 'Solved',
              tone: DashboardTone.green,
            ),
          ],
        ),
        if (issues.recent.isNotEmpty) ...[
          gap,
          RecentIssuesCard(
            title: 'Recent issues',
            issues: [
              for (final i in issues.recent)
                IssueRow(
                  title: i.title,
                  facility: i.facilityName,
                  status: labels[i.status] ?? i.statusLabel,
                  tone: _issueTone(i.status),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

// ------------------------------------------------------------ supervisor

/// The supervisor's own attendance today. Display only: the check-in and
/// check-out buttons are off because the dashboard API describes no action
/// for them (this attendance comes from visit check-ins).
class _CheckInOut extends StatelessWidget {
  const _CheckInOut(this.data);

  final DashboardCheckInOutEntity data;

  @override
  Widget build(BuildContext context) {
    final n = context.numbers;
    final language = Localizations.localeOf(context).languageCode;
    String time(DateTime? t) =>
        t == null ? '--:--' : DateFormat.jm(language).format(t);
    final place = data.facilityName;
    final visits = data.visitCount;

    // Design wording: "<place> · not checked in yet / working since / completed".
    final prefix = place == null || place.isEmpty ? '' : '$place · ';
    final (status, tone) = switch (data.status) {
      DashboardCheckInStatus.notCheckedIn => (
        '${prefix}not checked in yet',
        DashboardTone.neutral,
      ),
      DashboardCheckInStatus.checkedIn => (
        '${prefix}working since ${time(data.checkInAt)}',
        DashboardTone.green,
      ),
      DashboardCheckInStatus.checkedOut => (
        '${prefix}completed ${time(data.checkInAt)} to '
            '${time(data.checkOutAt)} · ${n.integer(visits)} visits',
        DashboardTone.blue,
      ),
    };

    return CheckInOutCard(
      checkInText: time(data.checkInAt),
      checkOutText: time(data.checkOutAt),
      statusText: status,
      statusTone: tone,
      canCheckIn: data.status == DashboardCheckInStatus.notCheckedIn,
      canCheckOut: data.status == DashboardCheckInStatus.checkedIn,
    );
  }
}

class _SupervisorSections extends StatefulWidget {
  const _SupervisorSections(
    this.d, {
    required this.month,
    required this.onPickMonth,
  });

  final SupervisorDashboardEntity d;
  final DateTime month;
  final VoidCallback onPickMonth;

  @override
  State<_SupervisorSections> createState() => _SupervisorSectionsState();
}

class _SupervisorSectionsState extends State<_SupervisorSections> {
  String _facility = _allFacilities;

  FacilityCardData _card(
    BuildContext context,
    DashboardFacilitySummaryEntity f,
  ) {
    final n = context.numbers;
    final language = Localizations.localeOf(context).languageCode;
    final male = f.visitors.male;
    final female = f.visitors.female;
    final total = male + female;
    final malePct = total == 0 ? 0 : (male / total * 100).round();

    return FacilityCardData(
      name: f.localizedName(language),
      percent: f.achievementPct,
      pctText: n.percent(f.achievementPct),
      achievedText: '${_money(context, f.achievedRevenue)} achieved',
      targetText: 'Target ${_money(context, f.targetRevenue)}',
      expenseText: _money(context, f.expense),
      maleCount: male,
      femaleCount: female,
      maleText: '${n.integer(male)} (${n.percent(malePct)})',
      femaleText: '${n.integer(female)} (${n.percent(100 - malePct)})',
      totalVisitorsText: '${n.integer(f.visitors.total)} total',
      inProgressText: n.integer(f.issues.inProgress),
      completedText: n.integer(f.issues.completed),
      pendingText: n.integer(f.issues.pending),
    );
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.d;
    final n = context.numbers;
    final spacing = context.dimensions.spacing;
    final gap = SizedBox(height: spacing.s12);
    final language = Localizations.localeOf(context).languageCode;
    final s = d.stats;

    Widget row(Widget a, Widget b) => IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: a),
          SizedBox(width: spacing.s10),
          Expanded(child: b),
        ],
      ),
    );

    final visible = [
      for (final f in d.facilities)
        if (_facility == _allFacilities ||
            f.localizedName(language) == _facility)
          f,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        row(
          DashboardStatTile(
            value: n.integer(s.todayWorking),
            label: 'Today working',
            tone: DashboardTone.green,
            hint: 'of ${n.integer(s.todayRostered)} rostered',
          ),
          DashboardStatTile(
            value: n.integer(s.pendingApproval),
            label: 'Pending approval',
            tone: DashboardTone.orange,
            hint: 'Needs your review',
          ),
        ),
        SizedBox(height: spacing.s10),
        row(
          DashboardStatTile(
            value: n.integer(s.notCheckedIn),
            label: 'Not checked in',
            tone: DashboardTone.blue,
            hint: 'Shift not started',
          ),
          DashboardStatTile(
            value: n.integer(s.late),
            label: 'Late',
            tone: DashboardTone.red,
            hint: 'Past start time',
          ),
        ),
        gap,
        if (d.collection.isNotEmpty) ...[
          TrendChart(
            title: 'Collection this week',
            subtitle: 'Achieved vs daily target',
            labels: [for (final p in d.collection) _weekday(context, p.date)],
            valuePrefix: '৳ ',
            series: [
              ChartSeries(
                name: 'Achieved',
                tone: DashboardTone.brand,
                area: true,
                values: [for (final p in d.collection) p.revenue],
              ),
              ChartSeries(
                name: 'Target',
                tone: DashboardTone.neutral,
                dashed: true,
                values: [for (final p in d.collection) p.target],
              ),
            ],
          ),
          gap,
        ],
        if (d.visitorsPerDay.isNotEmpty) ...[
          ColumnChart(
            title: 'Visitors per day',
            subtitle: 'Male and female, last 7 days',
            labels: [
              for (final v in d.visitorsPerDay) _weekday(context, v.date),
            ],
            series: [
              ChartSeries(
                name: 'Male',
                tone: DashboardTone.blue,
                values: [for (final v in d.visitorsPerDay) v.male],
              ),
              ChartSeries(
                name: 'Female',
                tone: DashboardTone.brand,
                values: [for (final v in d.visitorsPerDay) v.female],
              ),
            ],
          ),
          gap,
        ],
        ...[
          DashboardSectionHeader(
            title: 'Facility summary',
            subtitle:
                '${n.integer(visible.length)} of '
                '${n.integer(d.facilities.length)} facilities',
            actionLabel: DateFormat('MMM yyyy', language).format(widget.month),
            onAction: widget.onPickMonth,
          ),
          SizedBox(height: spacing.s12),
          CategoryFilterChips<String>(
            categories: [
              _allFacilities,
              for (final f in d.facilities) f.localizedName(language),
            ],
            selectedCategory: _facility,
            onSelected: (v) => setState(() => _facility = v),
          ),
          for (final f in visible) ...[
            SizedBox(height: spacing.s12),
            FacilityCard(data: _card(context, f)),
          ],
        ],
      ],
    );
  }
}

// ------------------------------------------------------- ops manager

class _OpsManagerSections extends StatefulWidget {
  const _OpsManagerSections(
    this.d, {
    required this.month,
    required this.onPickMonth,
  });

  final OpsManagerDashboardEntity d;
  final DateTime month;
  final VoidCallback onPickMonth;

  @override
  State<_OpsManagerSections> createState() => _OpsManagerSectionsState();
}

class _OpsManagerSectionsState extends State<_OpsManagerSections> {
  String _executive = _allExecutives;

  @override
  Widget build(BuildContext context) {
    final d = widget.d;
    final n = context.numbers;
    final spacing = context.dimensions.spacing;
    final gap = SizedBox(height: spacing.s12);
    final language = Localizations.localeOf(context).languageCode;

    final visible = [
      for (final e in d.executives)
        if (_executive == _allExecutives || e.name == _executive) e,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (d.executiveTargets.isNotEmpty) ...[
          ColumnChart(
            title: 'Target vs achievement',
            subtitle: 'Monthly, by executive',
            labels: [for (final e in d.executiveTargets) _firstName(e.name)],
            mode: ColumnChartMode.grouped,
            valuePrefix: '৳ ',
            series: [
              ChartSeries(
                name: 'Target',
                tone: DashboardTone.neutral,
                values: [for (final e in d.executiveTargets) e.target],
              ),
              ChartSeries(
                name: 'Achieved',
                tone: DashboardTone.brand,
                values: [for (final e in d.executiveTargets) e.achieved],
              ),
            ],
          ),
          gap,
        ],
        ...[
          DashboardSectionHeader(
            title: 'Executive details',
            subtitle:
                'Showing ${n.integer(visible.length)} of '
                '${n.integer(d.executives.length)} executives',
            actionLabel: DateFormat('MMM yyyy', language).format(widget.month),
            onAction: widget.onPickMonth,
          ),
          SizedBox(height: spacing.s12),
          CategoryFilterChips<String>(
            categories: [_allExecutives, for (final e in d.executives) e.name],
            selectedCategory: _executive,
            onSelected: (v) => setState(() => _executive = v),
          ),
          for (final e in visible) ...[
            SizedBox(height: spacing.s12),
            ExecutiveCard(
              name: e.name,
              facilityCountText: n.integer(e.totalFacility),
              targetText: _money(context, e.monthlyTarget),
              facilities: [
                for (final f in e.facilities)
                  FacilityRow(
                    name: f.localizedName(language),
                    meterLabel: 'Target vs achievement',
                    percent: f.achievementPct,
                    pctText: n.percent(f.achievementPct),
                    footLeft: 'Expense ${_money(context, f.expense)}',
                    footRight:
                        'M ${n.integer(f.visitorsToday.male)} · '
                        'F ${n.integer(f.visitorsToday.female)} today',
                  ),
              ],
            ),
          ],
          gap,
        ],
        _IssueSections(d.issues),
      ],
    );
  }
}

// ------------------------------------------------------- partner owner

class _OwnerSections extends StatefulWidget {
  const _OwnerSections(this.d);

  final PartnerOwnerDashboardEntity d;

  @override
  State<_OwnerSections> createState() => _OwnerSectionsState();
}

class _OwnerSectionsState extends State<_OwnerSections> {
  String _revenue = _topRevenue;

  @override
  Widget build(BuildContext context) {
    final d = widget.d;
    final n = context.numbers;
    final spacing = context.dimensions.spacing;
    final gap = SizedBox(height: spacing.s12);
    final language = Localizations.localeOf(context).languageCode;
    final top = _revenue == _topRevenue;
    final all = top ? d.topFacilities : d.lowestFacilities;
    // The server sends every facility; the list shows the first few.
    final shown = all.take(5).toList();
    final t = d.totalRevenue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KpiHeroCard(
          label:
              'Total revenue · '
              '${DateFormat('MMM yyyy', language).format(DateTime.now())}',
          value: _money(context, t.amount),
          deltaText: '${_signedPct(context, t.changePct)} vs last month',
          deltaPositive: t.changePct >= 0,
          footnote: 'across ${n.integer(t.facilityCount)} facilities',
        ),
        if (d.revenueTrend.isNotEmpty) ...[
          gap,
          TrendChart(
            title: 'Revenue trend',
            subtitle: 'Last 6 months vs monthly target',
            labels: [for (final m in d.revenueTrend) m.label],
            valuePrefix: '৳ ',
            series: [
              ChartSeries(
                name: 'Revenue',
                tone: DashboardTone.brand,
                area: true,
                values: [for (final m in d.revenueTrend) m.revenue],
              ),
              ChartSeries(
                name: 'Target',
                tone: DashboardTone.neutral,
                dashed: true,
                values: [for (final m in d.revenueTrend) m.target],
              ),
            ],
          ),
        ],
        if (all.isNotEmpty) ...[
          gap,
          const DashboardSectionHeader(
            title: 'Revenue by facility',
            subtitle: 'Share of monthly target reached',
          ),
          gap,
          DashboardFilterChips(
            style: DashboardFilterStyle.segmented,
            options: const [_topRevenue, _lowRevenue],
            selected: _revenue,
            onSelected: (v) => setState(() => _revenue = v),
          ),
          for (var i = 0; i < shown.length; i++) ...[
            SizedBox(height: spacing.s8),
            RevenueRow(
              rank: n.integer(top ? i + 1 : all.length - i),
              name: shown[i].localizedName(language),
              amountText: _money(context, shown[i].revenue),
              percent: shown[i].targetPct,
              percentText: n.percent(shown[i].targetPct),
              deltaText:
                  '${_signedPct(context, shown[i].changePct)} vs last month',
              deltaPositive: shown[i].changePct >= 0,
              tone: top ? DashboardTone.green : DashboardTone.red,
            ),
          ],
        ],
        gap,
        _IssueSections(d.issues),
      ],
    );
  }
}
