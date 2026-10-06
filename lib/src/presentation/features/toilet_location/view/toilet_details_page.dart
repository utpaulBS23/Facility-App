import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/login_entity.dart';
import '../../../../domain/entities/toilet_location/toilet_entity.dart';
import '../../../core/application_state/session_provider/session_provider.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../../dashboard/widgets/dashboard_meter.dart';
import '../../dashboard/widgets/dashboard_stat_tile.dart';
import '../../dashboard/widgets/dashboard_tone.dart';
import '../extensions/toilet_direction_extension.dart';
import '../extensions/toilet_status_extension.dart';
import '../riverpod/toilet_by_id_provider.dart';
import '../riverpod/toilet_name.dart';
import '../widgets/details/toilet_action_bar.dart';
import '../widgets/details/toilet_hero_card.dart';
import '../widgets/details/toilet_info_widgets.dart';
import '../widgets/details/toilet_section_card.dart';

// TODO: the name, status, address, rating, today's visits and income,
// management facts and direction come from the toilet list. Everything else
// has no endpoint yet and shows "$_none"; texts are English only until then.
const _none = '-';

String _time(BuildContext context, String? hms) {
  final parts = (hms ?? '').split(':');
  final h = parts.isNotEmpty ? int.tryParse(parts[0]) : null;
  final m = parts.length > 1 ? int.tryParse(parts[1]) : null;
  if (h == null || m == null) return _none;
  final hour = h % 12 == 0 ? 12 : h % 12;
  final clock = m == 0 ? '$hour' : '$hour:${m.toString().padLeft(2, '0')}';

  return context.numbers.phone('$clock ${h < 12 ? 'AM' : 'PM'}');
}

String _openingHours(BuildContext context, ToiletEntity t) {
  if (t.is24Hours) return 'Open 24 hours';

  return '${_time(context, t.openingTime)} – ${_time(context, t.closingTime)}';
}

String _operatingDays(BuildContext context, ToiletEntity t) {
  const weekday = {
    'mon': 1,
    'tue': 2,
    'wed': 3,
    'thu': 4,
    'fri': 5,
    'sat': 6,
    'sun': 7,
  };
  final days = [
    for (final d in t.operatingDays)
      if (weekday[d.toLowerCase()] != null) weekday[d.toLowerCase()]!,
  ];
  if (days.isEmpty) return _none;
  if (days.length == 7) return 'Every day';
  final language = Localizations.localeOf(context).languageCode;
  // 2024-01-01 is a Monday.
  final format = DateFormat.E(language);

  return days.map((d) => format.format(DateTime(2024, 1, d))).join(', ');
}

/// Everything about one toilet: access numbers, income goal, management info,
/// supply stock and who is on shift.
class ToiletDetailsPage extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final gap = SizedBox(height: context.dimensions.spacing.s12);
    // WHY gated: the earning report needs report.facility_wise.view.
    final toilet = ref.watch(toiletByIdProvider(facilityId));
    final n = context.numbers;
    final canOpenReport = ref.watch(
      userSessionProvider.select(
        (s) => s?.can(UserPermission.reportFacilityWiseView) ?? false,
      ),
    );

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
            ToiletHeroCard(
              name:
                  toiletNameOf(
                    ref,
                    facilityId,
                    Localizations.localeOf(context).languageCode,
                  ) ??
                  _none,
              statusLabel: toilet?.status.localizedName(context) ?? _none,
              address: toilet?.address ?? _none,
              ratingText: toilet == null
                  ? _none
                  : n.decimal(toilet.averageRating, 1),
              distanceText: _none,
              codeText: _none,
            ),
            gap,
            ToiletSectionCard(
              title: 'Consumer access',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ToiletTileRow(
                    children: [
                      DashboardStatTile(
                        value: toilet == null
                            ? _none
                            : n.integer(toilet.visitsToday),
                        label: 'Today',
                        tone: DashboardTone.blue,
                      ),
                      const DashboardStatTile(
                        value: _none,
                        label: 'This week',
                        tone: DashboardTone.green,
                      ),
                      const DashboardStatTile(
                        value: _none,
                        label: 'This month',
                        tone: DashboardTone.red,
                      ),
                    ],
                  ),
                  gap,
                  ToiletInfoNote(
                    icon: Icons.bar_chart_rounded,
                    child: ToiletInfoNote.labelled(
                      context,
                      'Visitors by hour, today:',
                      _none,
                    ),
                  ),
                  SizedBox(height: context.dimensions.spacing.s8),
                  ToiletInfoNote(
                    icon: Icons.info_outline,
                    child: ToiletInfoNote.labelled(
                      context,
                      'Peak hours:',
                      _none,
                    ),
                  ),
                ],
              ),
            ),
            gap,
            ToiletSectionCard(
              title: 'Income target and goal',
              child: ToiletTileRow(
                children: [
                  ToiletGoalBox(
                    label: 'Daily income target',
                    value: _none,
                    footnote: toilet == null
                        ? 'Today: $_none'
                        : 'Today: ৳ ${n.integer(toilet.revenue)}',
                    tone: DashboardTone.blue,
                  ),
                  const ToiletGoalBox(
                    label: 'Monthly goal',
                    value: _none,
                    footnote: 'This month: $_none',
                    tone: DashboardTone.green,
                  ),
                ],
              ),
            ),
            gap,
            ToiletSectionCard(
              title: 'Monthly progress',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const DashboardMeter(
                    label: 'Goal complete',
                    valueText: _none,
                    percent: 0,
                    tone: DashboardTone.neutral,
                  ),
                  gap,
                  const ToiletTileRow(
                    children: [
                      DashboardStatTile(
                        value: _none,
                        label: 'Achieved',
                        tone: DashboardTone.green,
                        compact: true,
                      ),
                      DashboardStatTile(
                        value: _none,
                        label: 'Remaining',
                        tone: DashboardTone.orange,
                        compact: true,
                      ),
                      DashboardStatTile(
                        value: _none,
                        label: 'Days left',
                        tone: DashboardTone.blue,
                        compact: true,
                      ),
                    ],
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
                  if (toilet != null) ...[
                    if (toilet.supervisorName.isNotEmpty) ...[
                      ToiletInfoRow(
                        icon: Icons.person_outline_rounded,
                        label: 'Supervisor',
                        value: toilet.supervisorName,
                      ),
                      SizedBox(height: context.dimensions.spacing.s10),
                    ],
                    ToiletInfoRow(
                      icon: Icons.access_time_rounded,
                      label: 'Opening hours',
                      value: _openingHours(context, toilet),
                    ),
                    SizedBox(height: context.dimensions.spacing.s10),
                    ToiletInfoRow(
                      icon: Icons.calendar_today_outlined,
                      label: 'Open days',
                      value: _operatingDays(context, toilet),
                    ),
                    SizedBox(height: context.dimensions.spacing.s10),
                    ToiletInfoRow(
                      icon: Icons.payments_outlined,
                      label: 'Entry fee',
                      value: toilet.isFree
                          ? 'Free'
                          : n.currency(toilet.usageFee),
                    ),
                    SizedBox(height: context.dimensions.spacing.s10),
                    ToiletInfoRow(
                      icon: Icons.accessible_rounded,
                      label: 'Disability friendly',
                      value: toilet.disableFriendly ? 'Yes' : 'No',
                    ),
                    SizedBox(height: context.dimensions.spacing.s10),
                  ],
                  const ToiletInfoRow(
                    icon: Icons.air_rounded,
                    label: 'Air quality score',
                    value: _none,
                  ),
                  SizedBox(height: context.dimensions.spacing.s10),
                  const ToiletInfoRow(
                    icon: Icons.bar_chart_rounded,
                    label: 'Frequency of cleaning',
                    value: _none,
                  ),
                  SizedBox(height: context.dimensions.spacing.s10),
                  const ToiletInfoRow(
                    icon: Icons.schedule_rounded,
                    label: 'Last cleaning',
                    value: _none,
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
                    valueText: _none,
                    percent: 0,
                    tone: DashboardTone.neutral,
                  ),
                  SizedBox(height: context.dimensions.spacing.s10),
                  const DashboardMeter(
                    label: 'Soap',
                    valueText: _none,
                    percent: 0,
                    tone: DashboardTone.neutral,
                  ),
                  SizedBox(height: context.dimensions.spacing.s10),
                  const DashboardMeter(
                    label: 'Sanitizer',
                    valueText: _none,
                    percent: 0,
                    tone: DashboardTone.neutral,
                  ),
                  SizedBox(height: context.dimensions.spacing.s10),
                  const DashboardMeter(
                    label: 'Hand towel',
                    valueText: _none,
                    percent: 0,
                    tone: DashboardTone.neutral,
                  ),
                ],
              ),
            ),
            gap,
            ToiletSectionCard(
              title: 'Attendance',
              child: const ToiletTileRow(
                children: [
                  DashboardStatTile(
                    value: _none,
                    label: 'Present',
                    tone: DashboardTone.green,
                  ),
                  DashboardStatTile(
                    value: _none,
                    label: 'Late',
                    tone: DashboardTone.orange,
                  ),
                  DashboardStatTile(
                    value: _none,
                    label: 'Not in yet',
                    tone: DashboardTone.blue,
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
        showSecondary: canOpenReport,
        onPrimary: () => toilet?.openDirection(),
        onSecondary: () => context.pushNamed(
          Routes.toiletEarningReport,
          pathParameters: {'id': '$facilityId'},
        ),
      ),
    );
  }
}
