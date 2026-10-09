import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/login_entity.dart';
import '../../../../domain/entities/toilet_location/toilet_details_entity.dart';
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
import '../riverpod/toilet_details_provider.dart';
import '../riverpod/toilet_name.dart';
import '../widgets/details/hourly_visitors_chart.dart';
import '../widgets/details/toilet_action_bar.dart';
import '../widgets/details/toilet_attendee_tile.dart';
import '../widgets/details/toilet_hero_card.dart';
import '../widgets/details/toilet_info_widgets.dart';
import '../widgets/details/toilet_section_card.dart';

// TODO: the name, status, address, rating, management facts and direction come
// from the toilet list, the rest from the facility details call. What the
// server does not send (or marks as a placeholder) shows "$_none"; texts are
// English only until then.
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

String _initials(String name) {
  final words = name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty);

  return words.take(2).map((w) => w.characters.first.toUpperCase()).join();
}

/// "Checked in 6:02 AM"; the server sends a date time or `HH:mm:ss`.
String _checkIn(BuildContext context, String? raw) {
  if (raw == null || raw.isEmpty) return 'Not checked in yet';
  final parsed = DateTime.tryParse(raw)?.toLocal();
  final hms = parsed == null
      ? raw
      : '${parsed.hour}:${parsed.minute.toString().padLeft(2, '0')}';
  final time = _time(context, hms);

  return time == _none ? 'Checked in $raw' : 'Checked in $time';
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
    // WHY valueOrNull: while loading, or if the call fails, every number shows
    // "-" (or what the toilet list already knows).
    final d = ref.watch(toiletDetailsProvider(facilityId)).valueOrNull;
    final n = context.numbers;
    String money(num value) => '৳ ${n.integer(value)}';
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
              distanceText: d?.distanceKm == null
                  ? _none
                  : '${n.decimal(d!.distanceKm!, 1)} km',
              codeText: d?.code ?? _none,
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
                        value: d != null
                            ? n.integer(d.visitsToday)
                            : toilet == null
                            ? _none
                            : n.integer(toilet.visitsToday),
                        label: 'Today',
                        tone: DashboardTone.blue,
                      ),
                      DashboardStatTile(
                        value: d == null ? _none : n.integer(d.visitsThisWeek),
                        label: 'This week',
                        tone: DashboardTone.green,
                      ),
                      DashboardStatTile(
                        value: d == null ? _none : n.integer(d.visitsThisMonth),
                        label: 'This month',
                        tone: DashboardTone.red,
                      ),
                    ],
                  ),
                  gap,
                  if (d != null && d.hourly.isNotEmpty)
                    HourlyVisitorsChart(
                      title: 'Visitors by hour, today',
                      peakLabel: 'Peak',
                      visits: [
                        for (final h in d.hourly)
                          HourlyVisit(
                            hour: h.hour,
                            count: h.count,
                            peak: h.isPeak,
                          ),
                      ],
                    )
                  else
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
                      d?.peakHoursLabel ?? _none,
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
                    value: d == null ? _none : money(d.dailyTarget),
                    footnote:
                        'Today: ${d != null
                            ? money(d.todayAchieved)
                            : toilet == null
                            ? _none
                            : money(toilet.revenue)}',
                    tone: DashboardTone.blue,
                  ),
                  ToiletGoalBox(
                    label: 'Monthly goal',
                    value: d == null ? _none : money(d.monthlyTarget),
                    footnote:
                        'This month: ${d == null ? _none : money(d.monthAchieved)}',
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
                  DashboardMeter(
                    label: 'Goal complete',
                    valueText: d == null
                        ? _none
                        : '${n.integer(d.percentComplete.round())}%',
                    percent: d?.percentComplete ?? 0,
                    tone: d != null && d.hasProgressTarget
                        ? DashboardMeter.toneForPercent(d.percentComplete)
                        : DashboardTone.neutral,
                  ),
                  gap,
                  ToiletTileRow(
                    children: [
                      DashboardStatTile(
                        value: d == null ? _none : money(d.progressAchieved),
                        label: 'Achieved',
                        tone: DashboardTone.green,
                        compact: true,
                      ),
                      DashboardStatTile(
                        value: d == null ? _none : money(d.progressRemaining),
                        label: 'Remaining',
                        tone: DashboardTone.orange,
                        compact: true,
                      ),
                      DashboardStatTile(
                        value: d == null ? _none : n.integer(d.daysLeft),
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
                  ToiletInfoRow(
                    icon: Icons.air_rounded,
                    label: 'Air quality score',
                    value: d?.airQuality ?? _none,
                  ),
                  SizedBox(height: context.dimensions.spacing.s10),
                  ToiletInfoRow(
                    icon: Icons.bar_chart_rounded,
                    label: 'Frequency of cleaning',
                    value: d?.cleaningFrequency ?? _none,
                  ),
                  SizedBox(height: context.dimensions.spacing.s10),
                  ToiletInfoRow(
                    icon: Icons.schedule_rounded,
                    label: 'Last cleaning',
                    value: d?.lastCleaningAt ?? _none,
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
                  if (d == null || d.supplyStock.isEmpty)
                    const ToiletInfoRow(
                      icon: Icons.inventory_2_outlined,
                      label: 'Stock',
                      value: _none,
                    )
                  else
                    for (final (i, item) in d.supplyStock.indexed) ...[
                      if (i > 0)
                        SizedBox(height: context.dimensions.spacing.s10),
                      ToiletInfoRow(
                        icon: Icons.inventory_2_outlined,
                        label: item.name,
                        value: [
                          if (item.quantity != null)
                            '${n.integer(item.quantity!)} ${item.unit}'.trim(),
                          switch (item.level) {
                            ToiletSupplyLevel.ok => 'In stock',
                            ToiletSupplyLevel.low => 'Low',
                            ToiletSupplyLevel.out => 'Out',
                          },
                        ].join(' · '),
                        valueTone: switch (item.level) {
                          ToiletSupplyLevel.ok => DashboardTone.green,
                          ToiletSupplyLevel.low => DashboardTone.orange,
                          ToiletSupplyLevel.out => DashboardTone.red,
                        },
                      ),
                    ],
                ],
              ),
            ),
            gap,
            ToiletSectionCard(
              title: 'Attendance',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ToiletTileRow(
                    children: [
                      DashboardStatTile(
                        value: d == null ? _none : n.integer(d.present),
                        label: 'Present',
                        tone: DashboardTone.green,
                      ),
                      DashboardStatTile(
                        value: d == null ? _none : n.integer(d.late),
                        label: 'Late',
                        tone: DashboardTone.orange,
                      ),
                      DashboardStatTile(
                        value: d == null ? _none : n.integer(d.notCheckedIn),
                        label: 'Not in yet',
                        tone: DashboardTone.blue,
                      ),
                    ],
                  ),
                  if (d != null)
                    for (final (i, person) in d.staff.indexed)
                      ToiletAttendeeTile(
                        initials: _initials(person.name),
                        name: person.name,
                        statusLabel: switch (person.status) {
                          ToiletStaffStatus.present => 'Present',
                          ToiletStaffStatus.late => 'Late',
                          ToiletStaffStatus.notCheckedIn => 'Not in yet',
                        },
                        statusTone: switch (person.status) {
                          ToiletStaffStatus.present => DashboardTone.green,
                          ToiletStaffStatus.late => DashboardTone.orange,
                          ToiletStaffStatus.notCheckedIn => DashboardTone.blue,
                        },
                        roleAndPhone: [
                          if (person.role.isNotEmpty) person.role,
                          if (person.phone.isNotEmpty)
                            context.numbers.phone(person.phone),
                        ].join(' · '),
                        note: _checkIn(context, person.checkInTime),
                        onCall: person.phone.isEmpty
                            ? null
                            : () => launchUrl(Uri(scheme: 'tel', path: person.phone)),
                        showDivider: i < d.staff.length - 1,
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
