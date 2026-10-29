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

// The name, status, address, rating, management facts and direction come
// from the toilet list, the rest from the facility details call. What the
// server does not send (or marks as a placeholder) shows "$_none".
const _none = '-';

String _time(BuildContext context, String? hms) {
  final parts = (hms ?? '').split(':');
  final h = parts.isNotEmpty ? int.tryParse(parts[0]) : null;
  final m = parts.length > 1 ? int.tryParse(parts[1]) : null;
  if (h == null || m == null) return _none;
  final hour = h % 12 == 0 ? 12 : h % 12;
  final clock = m == 0 ? '$hour' : '$hour:${m.toString().padLeft(2, '0')}';

  final period = h < 12 ? context.locale.toiletAm : context.locale.toiletPm;

  return context.numbers.phone('$clock $period');
}

String _initials(String name) {
  final words = name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty);

  return words.take(2).map((w) => w.characters.first.toUpperCase()).join();
}

/// "Checked in 6:02 AM"; the server sends a date time or `HH:mm:ss`.
String _checkIn(BuildContext context, String? raw) {
  if (raw == null || raw.isEmpty) return context.locale.toiletNotCheckedInYet;
  final parsed = DateTime.tryParse(raw)?.toLocal();
  final hms = parsed == null
      ? raw
      : '${parsed.hour}:${parsed.minute.toString().padLeft(2, '0')}';
  final time = _time(context, hms);

  return context.locale.toiletCheckedInAt(time == _none ? raw : time);
}

String _openingHours(BuildContext context, ToiletEntity t) {
  if (t.is24Hours) return context.locale.toiletOpen24Hours;

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
  if (days.length == 7) return context.locale.toiletEveryDay;
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
                  : context.locale.toiletKm(n.decimal(d!.distanceKm!, 1)),
              codeText: d?.code ?? _none,
            ),
            gap,
            ToiletSectionCard(
              title: context.locale.toiletConsumerAccess,
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
                        label: context.locale.today,
                        tone: DashboardTone.blue,
                      ),
                      DashboardStatTile(
                        value: d == null ? _none : n.integer(d.visitsThisWeek),
                        label: context.locale.thisWeek,
                        tone: DashboardTone.green,
                      ),
                      DashboardStatTile(
                        value: d == null ? _none : n.integer(d.visitsThisMonth),
                        label: context.locale.toiletThisMonth,
                        tone: DashboardTone.red,
                      ),
                    ],
                  ),
                  gap,
                  if (d != null && d.hourly.isNotEmpty)
                    HourlyVisitorsChart(
                      title: context.locale.toiletVisitorsByHourToday,
                      peakLabel: context.locale.toiletPeak,
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
                        context.locale.toiletVisitorsByHourTodayColon,
                        _none,
                      ),
                    ),
                  SizedBox(height: context.dimensions.spacing.s8),
                  ToiletInfoNote(
                    icon: Icons.info_outline,
                    child: ToiletInfoNote.labelled(
                      context,
                      context.locale.toiletPeakHoursColon,
                      d?.peakHoursLabel ?? _none,
                    ),
                  ),
                ],
              ),
            ),
            gap,
            ToiletSectionCard(
              title: context.locale.toiletIncomeTargetAndGoal,
              child: ToiletTileRow(
                children: [
                  ToiletGoalBox(
                    label: context.locale.toiletDailyIncomeTarget,
                    value: d == null ? _none : money(d.dailyTarget),
                    footnote: context.locale.toiletTodayAmount(
                      d != null
                          ? money(d.todayAchieved)
                          : toilet == null
                          ? _none
                          : money(toilet.revenue),
                    ),
                    tone: DashboardTone.blue,
                  ),
                  ToiletGoalBox(
                    label: context.locale.toiletMonthlyGoal,
                    value: d == null ? _none : money(d.monthlyTarget),
                    footnote: context.locale.toiletThisMonthAmount(
                      d == null ? _none : money(d.monthAchieved),
                    ),
                    tone: DashboardTone.green,
                  ),
                ],
              ),
            ),
            gap,
            ToiletSectionCard(
              title: context.locale.toiletMonthlyProgress,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DashboardMeter(
                    label: context.locale.toiletGoalComplete,
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
                        label: context.locale.toiletAchieved,
                        tone: DashboardTone.green,
                        compact: true,
                      ),
                      DashboardStatTile(
                        value: d == null ? _none : money(d.progressRemaining),
                        label: context.locale.toiletRemaining,
                        tone: DashboardTone.orange,
                        compact: true,
                      ),
                      DashboardStatTile(
                        value: d == null ? _none : n.integer(d.daysLeft),
                        label: context.locale.toiletDaysLeft,
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
              title: context.locale.toiletManagementInformation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (toilet != null) ...[
                    if (toilet.supervisorName.isNotEmpty) ...[
                      ToiletInfoRow(
                        icon: Icons.person_outline_rounded,
                        label: context.locale.supervisor,
                        value: toilet.supervisorName,
                      ),
                      SizedBox(height: context.dimensions.spacing.s10),
                    ],
                    ToiletInfoRow(
                      icon: Icons.access_time_rounded,
                      label: context.locale.toiletOpeningHours,
                      value: _openingHours(context, toilet),
                    ),
                    SizedBox(height: context.dimensions.spacing.s10),
                    ToiletInfoRow(
                      icon: Icons.calendar_today_outlined,
                      label: context.locale.toiletOpenDays,
                      value: _operatingDays(context, toilet),
                    ),
                    SizedBox(height: context.dimensions.spacing.s10),
                    ToiletInfoRow(
                      icon: Icons.payments_outlined,
                      label: context.locale.toiletEntryFee,
                      value: toilet.isFree
                          ? context.locale.toiletFree
                          : n.currency(toilet.usageFee),
                    ),
                    SizedBox(height: context.dimensions.spacing.s10),
                    ToiletInfoRow(
                      icon: Icons.accessible_rounded,
                      label: context.locale.toiletDisabilityFriendly,
                      value: toilet.disableFriendly
                          ? context.locale.yes
                          : context.locale.no,
                    ),
                    SizedBox(height: context.dimensions.spacing.s10),
                  ],
                  ToiletInfoRow(
                    icon: Icons.air_rounded,
                    label: context.locale.toiletAirQualityScore,
                    value: d?.airQuality ?? _none,
                  ),
                  SizedBox(height: context.dimensions.spacing.s10),
                  ToiletInfoRow(
                    icon: Icons.bar_chart_rounded,
                    label: context.locale.toiletCleaningFrequency,
                    value: d?.cleaningFrequency ?? _none,
                  ),
                  SizedBox(height: context.dimensions.spacing.s10),
                  ToiletInfoRow(
                    icon: Icons.schedule_rounded,
                    label: context.locale.toiletLastCleaning,
                    value: d?.lastCleaningAt ?? _none,
                  ),
                  gap,
                  Text(
                    context.locale.toiletSupplyStock,
                    style: context.textStyle.labelLarge.copyWith(
                      color: context.color.text.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: context.dimensions.spacing.s10),
                  if (d == null || d.supplyStock.isEmpty)
                    ToiletInfoRow(
                      icon: Icons.inventory_2_outlined,
                      label: context.locale.toiletStockLabel,
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
                            ToiletSupplyLevel.ok => context.locale.toiletInStock,
                            ToiletSupplyLevel.low => context.locale.toiletLow,
                            ToiletSupplyLevel.out => context.locale.toiletOut,
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
              title: context.locale.attendance,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ToiletTileRow(
                    children: [
                      DashboardStatTile(
                        value: d == null ? _none : n.integer(d.present),
                        label: context.locale.present,
                        tone: DashboardTone.green,
                      ),
                      DashboardStatTile(
                        value: d == null ? _none : n.integer(d.late),
                        label: context.locale.late,
                        tone: DashboardTone.orange,
                      ),
                      DashboardStatTile(
                        value: d == null ? _none : n.integer(d.notCheckedIn),
                        label: context.locale.toiletNotInYet,
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
                          ToiletStaffStatus.present => context.locale.present,
                          ToiletStaffStatus.late => context.locale.late,
                          ToiletStaffStatus.notCheckedIn => context.locale.toiletNotInYet,
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
        secondaryLabel: context.locale.toiletEarningReport,
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
