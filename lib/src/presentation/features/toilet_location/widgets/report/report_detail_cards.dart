import 'package:flutter/material.dart';

import '../../../../../core/extensions/app_numbers.dart';
import '../../../../../domain/entities/master_data_entity.dart';
import '../../../../../domain/entities/toilet_location/facility_monthly_report_entity.dart';
import '../../../dashboard/widgets/dashboard_tone.dart';
import '../details/toilet_section_card.dart';
import 'report_line_widgets.dart';

// The detail tables of the admin web's monthly report, in its order and with
// its wording: income items, expense items, customer numbers and the bKash
// collection.

// TODO: labels are English only until the next localisation pass.

String _money(BuildContext context, num v) {
  final n = context.numbers;

  return v < 0 ? '-৳ ${n.integer(-v)}' : '৳ ${n.integer(v)}';
}

/// A card of label/amount rows. Every row but the last has a hairline.
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

/// Every income source, zeros included.
class ReportIncomeItemsCard extends StatelessWidget {
  const ReportIncomeItemsCard({super.key, required this.report});

  final FacilityMonthlyReportEntity report;

  @override
  Widget build(BuildContext context) {
    String m(String key) => _money(context, report.incomeOf(key));
    // The web adds laundry, shop sales and other extras into one line.
    final additional =
        report.incomeOf('laundry') +
        report.incomeOf('product_sales') +
        report.incomeOf('other_income');

    return ToiletSectionCard(
      title: 'Income items',
      child: _Lines(
        rows: [
          ('Pay per use toilet', m('toilet')),
          ('Pay per use Urine', m('urinal')),
          ('Pay per use Showers', m('shower')),
          ('Drinking Water', m('drinking_water')),
          ('Manual Subscription', m('subscription')),
          ('Income Via App', m('app')),
          ('Additional Revenue (Laundry, Shop)', _money(context, additional)),
          ('Sanitary Pad', m('sanitary_pad')),
          ('Locker', m('locker')),
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

  static String _fallbackLabel(String key) {
    final text = key.replaceAll('_', ' ').trim();

    return text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);
  }

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
          (_fallbackLabel(e.key), _money(context, e.value)),
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

/// Users by service and gender, and the total.
class ReportCustomerNumbersCard extends StatelessWidget {
  const ReportCustomerNumbersCard({super.key, required this.report});

  final FacilityMonthlyReportEntity report;

  @override
  Widget build(BuildContext context) {
    final n = context.numbers;
    String c(num v) => n.integer(v);
    const untracked = 'Not tracked';

    return ToiletSectionCard(
      title: 'Customer numbers',
      child: _Lines(
        rows: [
          ('Pay per user Toilet — women', c(report.toiletUsers.women)),
          ('Pay per user Toilet — men', c(report.toiletUsers.men)),
          ('Pay per user Urine — women', c(report.urinalUsers.women)),
          ('Pay per user Urine — men', c(report.urinalUsers.men)),
          ('Pay per user Shower — women', c(report.showerUsers.women)),
          ('Pay per user Shower — men', c(report.showerUsers.men)),
          (
            'Pay per user Drinking Water — women',
            c(report.drinkingWaterUsers.women),
          ),
          (
            'Pay per user Drinking Water — men',
            c(report.drinkingWaterUsers.men),
          ),
          ('Manual Subscribed user (Toilet use)', untracked),
          ('Subscribed user (water)', untracked),
        ],
        total: ReportTotalRow(label: 'Total user', value: c(report.totalUsers)),
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
