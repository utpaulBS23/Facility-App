import 'package:flutter/material.dart';

import '../../../../../core/extensions/app_numbers.dart';
import '../../../../../domain/entities/toilet_location/facility_monthly_report_entity.dart';
import '../../../dashboard/widgets/dashboard_tone.dart';
import '../details/toilet_section_card.dart';
import 'report_line_widgets.dart';

// TODO: labels are English only until the next localisation pass.

String _money(BuildContext context, num v) {
  final n = context.numbers;

  return v < 0 ? '-৳ ${n.integer(-v)}' : '৳ ${n.integer(v)}';
}

/// "water_bill" to "Water bill".
String _categoryLabel(String key) {
  final text = key.replaceAll('_', ' ').trim();
  if (text.isEmpty) return text;

  return text[0].toUpperCase() + text.substring(1);
}

/// How many people used each service, with the women among them.
class ReportSubscribersCard extends StatelessWidget {
  const ReportSubscribersCard({super.key, required this.report});

  final FacilityMonthlyReportEntity report;

  @override
  Widget build(BuildContext context) {
    final n = context.numbers;
    // The records do not track subscriptions, so those read as a dash.
    const untracked = '—';

    return ToiletSectionCard(
      title: 'Number of subscribers',
      child: Column(
        children: [
          ReportStatPairRow(
            left: ReportStat(
              label: 'Pay per user toilet',
              value: n.integer(report.toiletUsers.total),
            ),
            right: ReportStat(
              label: 'Pay per user shower',
              value: n.integer(report.showerUsers.total),
            ),
            showDivider: false,
          ),
          ReportStatPairRow(
            left: ReportStat(
              label: 'Including women',
              value: n.integer(report.toiletUsers.women),
              strong: false,
            ),
            right: ReportStat(
              label: 'Including women',
              value: n.integer(report.showerUsers.women),
              strong: false,
            ),
          ),
          const ReportStatPairRow(
            left: ReportStat(
              label: 'Subscribe user (toilet)',
              value: untracked,
            ),
            right: ReportStat(
              label: 'Subscribed user (water)',
              value: untracked,
            ),
            showDivider: false,
          ),
          const ReportStatPairRow(
            left: ReportStat(
              label: 'Including women',
              value: untracked,
              strong: false,
            ),
            right: ReportStat(
              label: 'Including women',
              value: untracked,
              strong: false,
            ),
          ),
          ReportTotalRow(
            label: 'TOTAL USERS (SUBSCRIPTION + PAY PER USE)',
            value: n.integer(report.totalUsers),
          ),
        ],
      ),
    );
  }
}

/// Income that came through the app and package purchases.
class ReportDigitalSystemCard extends StatelessWidget {
  const ReportDigitalSystemCard({super.key, required this.report});

  final FacilityMonthlyReportEntity report;

  @override
  Widget build(BuildContext context) {
    return ToiletSectionCard(
      title: 'Digital system',
      child: Column(
        children: [
          ReportLineRow(
            label: 'Pay Per/Manager Apps Income',
            value: _money(context, report.appIncome),
          ),
          ReportLineRow(
            label: 'Package income',
            value: _money(context, report.packageIncome),
          ),
          ReportLineRow(
            label: 'Pay as you go',
            value: _money(context, 0),
            showDivider: false,
          ),
          ReportTotalRow(
            label: 'TOTAL',
            value: _money(context, report.digitalIncome),
          ),
        ],
      ),
    );
  }
}

/// Income by source. Lines the design always shows are always listed; the
/// rest appear only when they hold money, so the total still adds up.
class ReportRevenueCard extends StatelessWidget {
  const ReportRevenueCard({super.key, required this.report});

  final FacilityMonthlyReportEntity report;

  static const _always = <String, String>{
    'toilet': 'Pay per use toilet',
    'shower': 'Pay per use shower',
    'drinking_water': 'Drinking water',
    'subscription': 'Subscription (toilet use)',
    'laundry': 'Laundry',
    'product_sales': 'Product sales',
    'locker': 'Locker',
    'other_income': 'Other income',
  };

  static const _whenPresent = <String, String>{
    'urinal': 'Pay per use urine',
    'sanitary_pad': 'Sanitary pad',
    'app': 'Income via app',
  };

  @override
  Widget build(BuildContext context) {
    final lines = <(String, num)>[
      for (final e in _always.entries) (e.value, report.incomeOf(e.key)),
      for (final e in _whenPresent.entries)
        if (report.incomeOf(e.key) != 0) (e.value, report.incomeOf(e.key)),
    ];

    return ToiletSectionCard(
      title: 'Revenue (Tk)',
      child: Column(
        children: [
          for (var i = 0; i < lines.length; i++)
            ReportLineRow(
              compact: true,
              label: lines[i].$1,
              value: _money(context, lines[i].$2),
              showDivider: i < lines.length - 1,
            ),
          ReportTotalRow(
            compact: true,
            label: 'TOTAL',
            value: _money(context, report.totalIncome),
            tone: DashboardTone.green,
          ),
        ],
      ),
    );
  }
}

/// Spend by expense category.
class ReportServiceCostCard extends StatelessWidget {
  const ReportServiceCostCard({super.key, required this.report});

  final FacilityMonthlyReportEntity report;

  @override
  Widget build(BuildContext context) {
    final lines = report.expenseLines;

    return ToiletSectionCard(
      title: 'Service cost (Tk)',
      child: Column(
        children: [
          for (var i = 0; i < lines.length; i++)
            ReportLineRow(
              compact: true,
              label: _categoryLabel(lines[i].key),
              value: _money(context, lines[i].value),
              showDivider: i < lines.length - 1,
            ),
          ReportTotalRow(
            compact: true,
            label: 'TOTAL',
            value: _money(context, report.totalExpense),
            tone: DashboardTone.red,
          ),
        ],
      ),
    );
  }
}
