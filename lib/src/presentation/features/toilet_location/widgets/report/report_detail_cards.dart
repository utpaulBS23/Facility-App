import 'package:flutter/material.dart';

import '../../../../../core/extensions/app_localization.dart';
import '../../../../../domain/entities/master_data_entity.dart';
import '../../../../../domain/entities/toilet_location/facility_monthly_report_entity.dart';
import '../../../dashboard/widgets/dashboard_tone.dart';
import '../details/toilet_section_card.dart';
import 'report_labels.dart';
import 'report_line_widgets.dart';

// The detail tables of the admin web's monthly report: income items, expense
// items, customer numbers and the bKash collection. Rows are named by the
// data the server sent.

// TODO: card titles and total labels are English only until the next
// localisation pass.

String _money(BuildContext context, num v) {
  final n = context.numbers;

  return v < 0 ? '-৳ ${n.integer(-v)}' : '৳ ${n.integer(v)}';
}

/// A card body of label/amount rows. Every row but the last has a hairline.
class _Lines extends StatelessWidget {
  const _Lines({required this.rows, this.total});

  final List<(String, String)> rows;
  final Widget? total;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < rows.length; i++)
          ReportLineRow(
            label: rows[i].$1,
            value: rows[i].$2,
            showDivider: i < rows.length - 1,
          ),
        ?total,
      ],
    );
  }
}

/// One row per income source the records name: each service, each
/// extra-income type, each product.
class ReportIncomeItemsCard extends StatelessWidget {
  const ReportIncomeItemsCard({
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
    return ToiletSectionCard(
      title: 'Income items',
      child: _Lines(
        rows: [
          for (final line in report.incomeLines)
            (
              reportIncomeLabel(
                context,
                line,
                incomeTypes: incomeTypes,
                languageCode: languageCode,
              ),
              _money(context, line.value),
            ),
        ],
        total: ReportTotalRow(
          label: 'Total Income',
          value: _money(context, report.totalIncome),
          tone: DashboardTone.green,
        ),
      ),
    );
  }
}

/// Spend per expense category: the partner's categories first, zeros
/// included, then any other category that has spend.
class ReportExpenseItemsCard extends StatelessWidget {
  const ReportExpenseItemsCard({
    super.key,
    required this.report,
    required this.catalog,
    required this.languageCode,
  });

  final FacilityMonthlyReportEntity report;

  /// The expense categories the partner has set up; may be empty while they
  /// load or if they cannot be read.
  final List<MasterDataItemEntity> catalog;
  final String languageCode;

  @override
  Widget build(BuildContext context) {
    final spend = {for (final l in report.expenseLines) l.key: l.value};
    final ordered = [...catalog]
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    final known = {for (final c in ordered) c.value};

    final rows = <(String, String)>[
      for (final c in ordered)
        (c.localizedLabel(languageCode), _money(context, spend[c.value] ?? 0)),
      for (final e in spend.entries)
        if (!known.contains(e.key))
          (prettyKey(e.key), _money(context, e.value)),
    ];

    return ToiletSectionCard(
      title: 'Expense items',
      child: _Lines(
        rows: rows,
        total: ReportTotalRow(
          label: 'Total Expense',
          value: _money(context, report.totalExpense),
          tone: DashboardTone.red,
        ),
      ),
    );
  }
}

/// Users of each service the records name, by gender, and the total.
class ReportCustomerNumbersCard extends StatelessWidget {
  const ReportCustomerNumbersCard({super.key, required this.report});

  final FacilityMonthlyReportEntity report;

  @override
  Widget build(BuildContext context) {
    final n = context.numbers;
    final locale = context.locale;

    return ToiletSectionCard(
      title: 'Customer numbers',
      child: _Lines(
        rows: [
          for (final s in report.services) ...[
            ('${s.label} — ${locale.female}', n.integer(s.women)),
            ('${s.label} — ${locale.male}', n.integer(s.men)),
          ],
        ],
        total: ReportTotalRow(
          label: 'Total user',
          value: n.integer(report.totalUsers),
        ),
      ),
    );
  }
}

/// Income against what was remitted to bKash.
class ReportBkashCard extends StatelessWidget {
  const ReportBkashCard({super.key, required this.report});

  final FacilityMonthlyReportEntity report;

  @override
  Widget build(BuildContext context) {
    final gap = report.totalIncome - report.bkashCollected;

    return ToiletSectionCard(
      title: 'Bkash collections',
      child: _Lines(
        rows: [
          ('Total Income', _money(context, report.totalIncome)),
          ('Income collected by Bkash', _money(context, report.bkashCollected)),
        ],
        total: ReportTotalRow(
          label: 'Income gap / due',
          value: _money(context, gap),
          tone: gap > 0 ? DashboardTone.red : DashboardTone.green,
        ),
      ),
    );
  }
}
