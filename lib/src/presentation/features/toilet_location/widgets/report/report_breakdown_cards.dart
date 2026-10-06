import 'package:flutter/material.dart';

import '../../../../../core/extensions/app_localization.dart';
import '../../../../../domain/entities/master_data_entity.dart';
import '../../../../../domain/entities/toilet_location/facility_monthly_report_entity.dart';
import '../../../dashboard/widgets/dashboard_tone.dart';
import '../details/toilet_section_card.dart';
import 'report_labels.dart';
import 'report_line_widgets.dart';

// TODO: card titles are English only until the next localisation pass. Every
// line inside them is named by the data.

String _money(BuildContext context, num v) {
  final n = context.numbers;

  return v < 0 ? '-৳ ${n.integer(-v)}' : '৳ ${n.integer(v)}';
}

/// How many people used each service, with the women among them. Services are
/// the ones the records name, two to a row.
class ReportSubscribersCard extends StatelessWidget {
  const ReportSubscribersCard({super.key, required this.report});

  final FacilityMonthlyReportEntity report;

  @override
  Widget build(BuildContext context) {
    final n = context.numbers;
    final services = report.services;
    const blank = ReportStat(label: '', value: '');

    return ToiletSectionCard(
      title: 'Number of subscribers',
      child: Column(
        children: [
          for (var i = 0; i < services.length; i += 2) ...[
            ReportStatPairRow(
              left: ReportStat(
                label: services[i].label,
                value: n.integer(services[i].total),
              ),
              right: i + 1 < services.length
                  ? ReportStat(
                      label: services[i + 1].label,
                      value: n.integer(services[i + 1].total),
                    )
                  : blank,
              showDivider: false,
            ),
            ReportStatPairRow(
              left: ReportStat(
                label: context.locale.female,
                value: n.integer(services[i].women),
                strong: false,
              ),
              right: i + 1 < services.length
                  ? ReportStat(
                      label: context.locale.female,
                      value: n.integer(services[i + 1].women),
                      strong: false,
                    )
                  : blank,
              showDivider: i + 2 < services.length,
            ),
          ],
          ReportTotalRow(
            label: 'TOTAL USERS',
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
            showDivider: false,
          ),
          ReportTotalRow(
            label: 'INCOME FROM DIGITAL SYSTEM',
            value: _money(context, report.digitalIncome),
          ),
          ReportTotalRow(
            label: 'DIFFERENCE — DIGITAL SYSTEM VS ACTUAL INCOME',
            value: _money(context, report.totalIncome - report.digitalIncome),
          ),
        ],
      ),
    );
  }
}

/// Income by source, one row per service, extra-income type or product the
/// records name.
class ReportRevenueCard extends StatelessWidget {
  const ReportRevenueCard({
    super.key,
    required this.report,
    required this.incomeTypes,
    required this.languageCode,
  });

  final FacilityMonthlyReportEntity report;

  /// The partner's extra-income types, for their labels; may be empty.
  final List<MasterDataItemEntity> incomeTypes;
  final String languageCode;

  @override
  Widget build(BuildContext context) {
    final lines = report.incomeLines;

    return ToiletSectionCard(
      title: 'Revenue (Tk)',
      child: Column(
        children: [
          for (var i = 0; i < lines.length; i++)
            ReportLineRow(
              compact: true,
              label: reportIncomeLabel(
                context,
                lines[i],
                incomeTypes: incomeTypes,
                languageCode: languageCode,
              ),
              value: _money(context, lines[i].value),
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
              label: prettyKey(lines[i].key),
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
