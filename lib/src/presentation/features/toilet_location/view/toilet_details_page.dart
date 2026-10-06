import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../../dashboard/widgets/dashboard_meter.dart';
import '../../dashboard/widgets/dashboard_stat_tile.dart';
import '../../dashboard/widgets/dashboard_tone.dart';
import '../widgets/details/hourly_visitors_chart.dart';
import '../widgets/details/toilet_action_bar.dart';
import '../widgets/details/toilet_attendee_tile.dart';
import '../widgets/details/toilet_hero_card.dart';
import '../widgets/details/toilet_info_widgets.dart';
import '../widgets/details/toilet_section_card.dart';

// TODO: hardcoded sample content. Replace with API data when the toilet
// details endpoints are documented; texts are English only until then.
const _visits = [
  HourlyVisit(hour: 6, count: 12),
  HourlyVisit(hour: 7, count: 22),
  HourlyVisit(hour: 8, count: 58, peak: true),
  HourlyVisit(hour: 9, count: 66, peak: true),
  HourlyVisit(hour: 10, count: 34),
  HourlyVisit(hour: 11, count: 26),
  HourlyVisit(hour: 12, count: 30),
  HourlyVisit(hour: 13, count: 28),
  HourlyVisit(hour: 14, count: 24),
  HourlyVisit(hour: 15, count: 36),
  HourlyVisit(hour: 16, count: 50),
  HourlyVisit(hour: 17, count: 62, peak: true),
  HourlyVisit(hour: 18, count: 68, peak: true),
  HourlyVisit(hour: 19, count: 42),
  HourlyVisit(hour: 20, count: 28),
  HourlyVisit(hour: 21, count: 18),
  HourlyVisit(hour: 22, count: 10),
];

class _Attendee {
  const _Attendee(
    this.initials,
    this.name,
    this.status,
    this.tone,
    this.roleAndPhone,
    this.note,
  );

  final String initials;
  final String name;
  final String status;
  final DashboardTone tone;
  final String roleAndPhone;
  final String note;
}

const _attendees = [
  _Attendee(
    'SA',
    'Shafiqul Alam',
    'Present',
    DashboardTone.green,
    'Lead Attendant · +880 1712-345001',
    'Checked in 6:02 AM',
  ),
  _Attendee(
    'KM',
    'Karim Mia',
    'Present',
    DashboardTone.green,
    'Supervisor · +880 1712-345002',
    'Checked in 5:55 AM',
  ),
  _Attendee(
    'KH',
    'Kamal Hossain',
    'Late',
    DashboardTone.orange,
    'Attendant · +880 1712-345003',
    'Checked in 7:38 AM · 18 min late',
  ),
  _Attendee(
    'RA',
    'Rahima Akter',
    'Not checked in',
    DashboardTone.blue,
    'Attendant · +880 1712-345004',
    'Shift starts 8:20 AM',
  ),
];

/// Everything about one toilet: access numbers, income goal, management info,
/// supply stock and who is on shift.
class ToiletDetailsPage extends StatelessWidget {
  const ToiletDetailsPage({super.key, required this.facilityId});

  final int facilityId;

  void _onBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed(Routes.toiletLocation);
    }
  }

  @override
  Widget build(BuildContext context) {
    final gap = SizedBox(height: context.dimensions.spacing.s12);

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(
        title: context.locale.toiletDetails,
        onBack: () => _onBack(context),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.dimensions.spacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ToiletHeroCard(
              name: 'Mirpur-10 Public Toilet',
              statusLabel: 'Open',
              address: 'Mirpur-10 Roundabout, Dhaka 1216',
              ratingText: '4.2',
              distanceText: '1.2 km',
              codeText: 'IDTL-001',
            ),
            gap,
            ToiletSectionCard(
              title: 'Consumer access',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const ToiletTileRow(
                    children: [
                      DashboardStatTile(
                        value: '342',
                        label: 'Today',
                        tone: DashboardTone.blue,
                      ),
                      DashboardStatTile(
                        value: '2,156',
                        label: 'This week',
                        tone: DashboardTone.green,
                      ),
                      DashboardStatTile(
                        value: '8,943',
                        label: 'This month',
                        tone: DashboardTone.red,
                      ),
                    ],
                  ),
                  gap,
                  const HourlyVisitorsChart(
                    title: 'Visitors by hour, today',
                    peakLabel: 'Peak',
                    visits: _visits,
                  ),
                  gap,
                  ToiletInfoNote(
                    icon: Icons.info_outline,
                    child: ToiletInfoNote.labelled(
                      context,
                      'Peak hours:',
                      '8–10 am, 5–7 pm',
                    ),
                  ),
                ],
              ),
            ),
            gap,
            const ToiletSectionCard(
              title: 'Income target and goal',
              child: ToiletTileRow(
                children: [
                  ToiletGoalBox(
                    label: 'Daily income target',
                    value: '৳ 8,000',
                    footnote: 'Today: ৳ 6,840',
                    tone: DashboardTone.blue,
                  ),
                  ToiletGoalBox(
                    label: 'Monthly goal',
                    value: '৳ 2,00,000',
                    footnote: 'This month: ৳ 1,78,860',
                    tone: DashboardTone.green,
                  ),
                ],
              ),
            ),
            gap,
            ToiletSectionCard(
              title: 'Monthly progress',
              trailing: 'Oct 2026',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const DashboardMeter(
                    label: 'Goal complete',
                    valueText: '89.4%',
                    percent: 89.4,
                    tone: DashboardTone.green,
                    footLeft: '৳ 1,78,860 achieved',
                    footRight: '৳ 21,140 left',
                  ),
                  gap,
                  const ToiletTileRow(
                    children: [
                      DashboardStatTile(
                        value: '৳ 1,78,860',
                        label: 'Achieved',
                        tone: DashboardTone.green,
                        compact: true,
                      ),
                      DashboardStatTile(
                        value: '৳ 21,140',
                        label: 'Remaining',
                        tone: DashboardTone.orange,
                        compact: true,
                      ),
                      DashboardStatTile(
                        value: '25',
                        label: 'Days left',
                        tone: DashboardTone.blue,
                        compact: true,
                      ),
                    ],
                  ),
                  gap,
                  Text(
                    'Needs about ৳ 846 a day to reach the goal.',
                    style: context.textStyle.bodySmall.copyWith(
                      color: context.color.text.secondary,
                    ),
                  ),
                ],
              ),
            ),
            gap,
            ToiletSectionCard(
              title: 'Management information',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const ToiletInfoRow(
                    icon: Icons.air_rounded,
                    label: 'Air quality score',
                    value: 'Good',
                    valueTone: DashboardTone.green,
                  ),
                  SizedBox(height: context.dimensions.spacing.s10),
                  const ToiletInfoRow(
                    icon: Icons.bar_chart_rounded,
                    label: 'Frequency of cleaning',
                    value: '8×/day',
                  ),
                  SizedBox(height: context.dimensions.spacing.s10),
                  const ToiletInfoRow(
                    icon: Icons.schedule_rounded,
                    label: 'Last cleaning',
                    value: '2 hours ago',
                  ),
                  SizedBox(height: context.dimensions.spacing.s10),
                  ToiletInfoNote(
                    icon: Icons.check_rounded,
                    tone: DashboardTone.green,
                    child: Text(
                      'Real-time air tracking is enabled',
                      style: context.textStyle.labelMedium.copyWith(
                        color: DashboardTone.green.foreground(context),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  gap,
                  Text(
                    'Supply stock',
                    style: context.textStyle.labelLarge.copyWith(
                      color: context.color.text.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: context.dimensions.spacing.s10),
                  const DashboardMeter(
                    label: 'Tissue',
                    valueText: '75%',
                    percent: 75,
                    tone: DashboardTone.green,
                  ),
                  SizedBox(height: context.dimensions.spacing.s10),
                  const DashboardMeter(
                    label: 'Soap',
                    valueText: '60%',
                    percent: 60,
                    tone: DashboardTone.green,
                  ),
                  SizedBox(height: context.dimensions.spacing.s10),
                  const DashboardMeter(
                    label: 'Sanitizer',
                    valueText: '85%',
                    percent: 85,
                    tone: DashboardTone.green,
                  ),
                  SizedBox(height: context.dimensions.spacing.s10),
                  const DashboardMeter(
                    label: 'Hand towel',
                    valueText: '22%',
                    percent: 22,
                    tone: DashboardTone.red,
                  ),
                  SizedBox(height: context.dimensions.spacing.s10),
                  Text(
                    'Low stock, reorder soon',
                    style: context.textStyle.bodySmall.copyWith(
                      color: context.color.text.secondary,
                    ),
                  ),
                ],
              ),
            ),
            gap,
            ToiletSectionCard(
              title: 'Attendance',
              subtitle: 'Morning shift · 6:00 AM – 2:00 PM · 3 of 4 checked in',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const ToiletTileRow(
                    children: [
                      DashboardStatTile(
                        value: '2',
                        label: 'Present',
                        tone: DashboardTone.green,
                      ),
                      DashboardStatTile(
                        value: '1',
                        label: 'Late',
                        tone: DashboardTone.orange,
                      ),
                      DashboardStatTile(
                        value: '1',
                        label: 'Not in yet',
                        tone: DashboardTone.blue,
                      ),
                    ],
                  ),
                  SizedBox(height: context.dimensions.spacing.s8),
                  for (var i = 0; i < _attendees.length; i++)
                    ToiletAttendeeTile(
                      initials: _attendees[i].initials,
                      name: _attendees[i].name,
                      statusLabel: _attendees[i].status,
                      statusTone: _attendees[i].tone,
                      roleAndPhone: _attendees[i].roleAndPhone,
                      note: _attendees[i].note,
                      onCall: () {},
                      showDivider: i < _attendees.length - 1,
                    ),
                ],
              ),
            ),
            gap,
          ],
        ),
      ),
      bottomNavigationBar: ToiletActionBar(
        primaryLabel: context.locale.direction,
        secondaryLabel: 'Earning Report',
        onPrimary: () {},
        onSecondary: () => context.pushNamed(
          Routes.toiletEarningReport,
          pathParameters: {'id': '$facilityId'},
        ),
      ),
    );
  }
}
