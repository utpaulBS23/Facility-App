import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/app_numbers.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../../dashboard/widgets/dashboard_tone.dart';
import '../widgets/details/toilet_section_card.dart';
import '../widgets/report/report_filter_widgets.dart';
import '../widgets/report/report_line_widgets.dart';
import '../widgets/report/report_summary_widgets.dart';

// TODO: hardcoded sample figures. Replace with the facility-wise report API
// (GET .../report/facility-wise) once it is wired; texts are English only
// until then.
const _sampleToilet = 'Gulshan-1 Public Toilet';

/// One toilet's monthly report: people served, income and cost for the month,
/// and the profit or loss.
class ToiletEarningReportPage extends StatefulWidget {
  const ToiletEarningReportPage({super.key, required this.facilityId});

  final int facilityId;

  @override
  State<ToiletEarningReportPage> createState() =>
      _ToiletEarningReportPageState();
}

class _ToiletEarningReportPageState extends State<ToiletEarningReportPage> {
  late int _month = DateTime.now().month;
  late int _year = DateTime.now().year;

  void _onBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed(Routes.toiletLocation);
    }
  }

  @override
  Widget build(BuildContext context) {
    final n = context.numbers;
    final c = context.color;
    final spacing = context.dimensions.spacing;
    final language = Localizations.localeOf(context).languageCode;
    final gap = SizedBox(height: spacing.s12);
    String money(num v) => '৳ ${n.integer(v)}';

    final now = DateTime.now();
    final months = {
      for (var m = 1; m <= 12; m++)
        m: DateFormat.MMMM(language).format(DateTime(2000, m)),
    };
    final years = {
      for (var y = now.year; y > now.year - 5; y--)
        y: n.number(y).replaceAll(',', ''),
    };

    return Scaffold(
      backgroundColor: c.scaffoldBackground,
      appBar: DetailAppBar(
        title: 'Public facilities monthly report',
        onBack: _onBack,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Public facilities monthly report',
              style: context.textStyle.labelXl.copyWith(
                color: c.text.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: spacing.s2),
            Text(
              'Financial and management reports',
              style: context.textStyle.bodySmall.copyWith(
                color: c.text.secondary,
              ),
            ),
            gap,
            ReportFilterCard(
              toilet: const ReportToiletSelector(
                caption: 'Public toilet name',
                name: _sampleToilet,
              ),
              month: ReportDropdown<int>(
                caption: 'Select month',
                value: _month,
                items: months,
                onChanged: (v) => setState(() => _month = v),
              ),
              year: ReportDropdown<int>(
                caption: 'Select year',
                value: _year,
                items: years,
                onChanged: (v) => setState(() => _year = v),
              ),
            ),
            gap,
            ToiletTileRow(
              children: [
                ReportSummaryTile(
                  icon: Icons.groups_outlined,
                  value: n.integer(10762),
                  label: 'User',
                  tone: DashboardTone.blue,
                ),
                ReportSummaryTile(
                  icon: Icons.trending_up_rounded,
                  value: money(75420),
                  label: 'Total income',
                  tone: DashboardTone.green,
                ),
                ReportSummaryTile(
                  icon: Icons.trending_up_rounded,
                  value: money(32297),
                  label: 'Total profit',
                  tone: DashboardTone.green,
                ),
              ],
            ),
            gap,
            ToiletSectionCard(
              title: 'Number of subscribers',
              child: Column(
                children: [
                  ReportStatPairRow(
                    left: ReportStat(
                      label: 'Pay per user toilet',
                      value: n.integer(10762),
                    ),
                    right: ReportStat(
                      label: 'Pay per user shower',
                      value: n.integer(0),
                    ),
                    showDivider: false,
                  ),
                  ReportStatPairRow(
                    left: ReportStat(
                      label: 'Including women',
                      value: n.integer(659),
                      strong: false,
                    ),
                    right: ReportStat(
                      label: 'Including women',
                      value: n.integer(0),
                      strong: false,
                    ),
                  ),
                  ReportStatPairRow(
                    left: ReportStat(
                      label: 'Subscribe user (toilet)',
                      value: n.integer(0),
                    ),
                    right: ReportStat(
                      label: 'Subscribed user (water)',
                      value: n.integer(0),
                    ),
                    showDivider: false,
                  ),
                  ReportStatPairRow(
                    left: ReportStat(
                      label: 'Including women',
                      value: n.integer(0),
                      strong: false,
                    ),
                    right: ReportStat(
                      label: 'Including women',
                      value: n.integer(0),
                      strong: false,
                    ),
                  ),
                  ReportTotalRow(
                    label: 'TOTAL USERS (SUBSCRIPTION + PAY PER USE)',
                    value: n.integer(10762),
                  ),
                ],
              ),
            ),
            gap,
            ToiletSectionCard(
              title: 'Digital system',
              child: Column(
                children: [
                  ReportLineRow(
                    label: 'Pay Per/Manager Apps Income',
                    value: money(21034),
                  ),
                  ReportLineRow(label: 'Package income', value: money(1568)),
                  ReportLineRow(label: 'Pay as you go', value: money(100)),
                  ReportTotalRow(label: 'TOTAL', value: money(22702)),
                ],
              ),
            ),
            gap,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ToiletSectionCard(
                    title: 'Revenue (Rs.)',
                    child: Column(
                      children: [
                        ReportLineRow(
                          compact: true,
                          label: 'Pay per use toilet',
                          value: money(67220),
                        ),
                        ReportLineRow(
                          compact: true,
                          label: 'Pay per use shower',
                          value: money(0),
                        ),
                        ReportLineRow(
                          compact: true,
                          label: 'Drinking water',
                          value: money(0),
                        ),
                        ReportLineRow(
                          compact: true,
                          label: 'Subscription (toilet use)',
                          value: money(8100),
                        ),
                        ReportLineRow(
                          compact: true,
                          label: 'Laundry',
                          value: money(0),
                        ),
                        ReportLineRow(
                          compact: true,
                          label: 'Product sales',
                          value: money(0),
                        ),
                        ReportLineRow(
                          compact: true,
                          label: 'Locker',
                          value: money(0),
                        ),
                        ReportLineRow(
                          compact: true,
                          label: 'Advertisement',
                          value: money(100),
                        ),
                        ReportTotalRow(
                          compact: true,
                          label: 'TOTAL',
                          value: money(75420),
                          tone: DashboardTone.green,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: spacing.s12),
                Expanded(
                  child: ToiletSectionCard(
                    title: 'Service cost (Rs.)',
                    child: Column(
                      children: [
                        ReportLineRow(
                          compact: true,
                          label: 'Asset rental',
                          value: money(6000),
                        ),
                        ReportLineRow(
                          compact: true,
                          label: 'Employee salary',
                          value: money(15532),
                        ),
                        ReportLineRow(
                          compact: true,
                          label: 'Utilities (water, electricity, internet)',
                          value: money(12500),
                        ),
                        ReportLineRow(
                          compact: true,
                          label: 'Cleaning supplies',
                          value: money(5561),
                        ),
                        ReportLineRow(
                          compact: true,
                          label: 'Other O&M',
                          value: money(3530),
                        ),
                        ReportLineRow(
                          compact: true,
                          label: 'Laundry costs',
                          value: money(0),
                        ),
                        ReportTotalRow(
                          compact: true,
                          label: 'TOTAL',
                          value: money(43123),
                          tone: DashboardTone.red,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            gap,
            ReportProfitBanner(label: 'Profit/Loss', value: money(32297)),
            SizedBox(height: spacing.s16),
          ],
        ),
      ),
    );
  }
}
