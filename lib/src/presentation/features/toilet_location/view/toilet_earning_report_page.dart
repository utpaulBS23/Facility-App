import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/app_numbers.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/toilet_location/facility_wise_report_entity.dart';
import '../../../core/application_state/session_provider/session_provider.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../dashboard/widgets/dashboard_tone.dart';
import '../riverpod/toilet_earning_report_provider.dart';
import '../widgets/details/toilet_section_card.dart';
import '../widgets/report/report_filter_widgets.dart';
import '../widgets/report/report_line_widgets.dart';
import '../widgets/report/report_summary_widgets.dart';

// TODO: texts are English only until the next localisation pass.

/// One toilet's monthly report for a closed month: income, cost, cash moved to
/// bKash or the bank, and the profit or loss.
///
/// WHY only these figures: the facility-wise report API carries nothing else.
/// The design's subscriber, digital system and revenue-by-type tables are left
/// out until the API sends them.
class ToiletEarningReportPage extends ConsumerStatefulWidget {
  const ToiletEarningReportPage({super.key, required this.facilityId});

  final int facilityId;

  @override
  ConsumerState<ToiletEarningReportPage> createState() =>
      _ToiletEarningReportPageState();
}

class _ToiletEarningReportPageState
    extends ConsumerState<ToiletEarningReportPage> {
  // WHY last month first: only closed months have data, and the current one
  // is almost never closed yet.
  late int _year = _lastMonth().year;
  late int _month = _lastMonth().month;

  static DateTime _lastMonth() {
    final now = DateTime.now();

    return DateTime(now.year, now.month - 1);
  }

  String get _monthParam =>
      '${_year.toString().padLeft(4, '0')}-'
      '${_month.toString().padLeft(2, '0')}';

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

    final now = DateTime.now();
    final months = {
      for (var m = 1; m <= 12; m++)
        m: DateFormat.MMMM(language).format(DateTime(2000, m)),
    };
    final years = {
      for (var y = now.year; y > now.year - 5; y--)
        y: n.number(y).replaceAll(',', ''),
    };

    final report = ref.watch(
      toiletEarningReportProvider(
        facilityId: widget.facilityId,
        month: _monthParam,
      ),
    );
    final sessionName = ref.watch(
      userSessionProvider.select(
        (s) => s?.accessibleFacilities
            .where((f) => f.id == widget.facilityId)
            .map((f) => f.localizedName(language))
            .firstOrNull,
      ),
    );
    final toiletName =
        sessionName ?? report.valueOrNull?.first?.facilityName ?? '—';

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
              toilet: ReportToiletSelector(
                caption: 'Public toilet name',
                name: toiletName,
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
            report.when(
              loading: () => Padding(
                padding: EdgeInsets.symmetric(vertical: spacing.s32),
                child: const Center(child: LoadingIndicator()),
              ),
              error: (e, _) => SizedBox(
                height: 240,
                child: AppErrorWidget(
                  message: e.localizedMessage(context),
                  onRetry: () => ref.invalidate(
                    toiletEarningReportProvider(
                      facilityId: widget.facilityId,
                      month: _monthParam,
                    ),
                  ),
                ),
              ),
              data: (data) {
                final row = data.first;
                if (row == null) return const _NotClosedYet();

                return _ReportBody(row: row);
              },
            ),
            SizedBox(height: spacing.s16),
          ],
        ),
      ),
    );
  }
}

class _NotClosedYet extends StatelessWidget {
  const _NotClosedYet();

  @override
  Widget build(BuildContext context) {
    return ToiletSectionCard(
      title: 'Nothing closed yet',
      child: Text(
        'This month has not been closed for this toilet, so there is no '
        'report yet. Pick an earlier month.',
        style: context.textStyle.bodyMedium.copyWith(
          color: context.color.text.secondary,
        ),
      ),
    );
  }
}

class _ReportBody extends StatelessWidget {
  const _ReportBody({required this.row});

  final FacilityWiseRowEntity row;

  @override
  Widget build(BuildContext context) {
    final n = context.numbers;
    final spacing = context.dimensions.spacing;
    final gap = SizedBox(height: spacing.s12);
    String money(num v) => v < 0 ? '-৳ ${n.integer(-v)}' : '৳ ${n.integer(v)}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ToiletTileRow(
          children: [
            ReportSummaryTile(
              icon: Icons.trending_up_rounded,
              value: money(row.income),
              label: 'Total income',
              tone: DashboardTone.green,
            ),
            ReportSummaryTile(
              icon: Icons.trending_down_rounded,
              value: money(row.expense),
              label: 'Total expense',
              tone: DashboardTone.red,
            ),
            ReportSummaryTile(
              icon: Icons.account_balance_wallet_outlined,
              value: money(row.cashBalance),
              label: 'Cash balance',
              tone: DashboardTone.blue,
            ),
          ],
        ),
        gap,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ToiletSectionCard(
                title: 'Service cost (Rs.)',
                child: Column(
                  children: [
                    ReportLineRow(
                      compact: true,
                      label: 'Accounts paid',
                      value: money(row.accountsPaid),
                    ),
                    ReportLineRow(
                      compact: true,
                      label: 'Operation department',
                      value: money(row.operationDepartment),
                      showDivider: false,
                    ),
                    ReportTotalRow(
                      compact: true,
                      label: 'TOTAL',
                      value: money(row.expense),
                      tone: DashboardTone.red,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: spacing.s12),
            Expanded(
              child: ToiletSectionCard(
                title: 'Cash moved (Rs.)',
                child: Column(
                  children: [
                    ReportLineRow(
                      compact: true,
                      label: 'To bKash',
                      value: money(row.toBkash),
                    ),
                    ReportLineRow(
                      compact: true,
                      label: 'To bank',
                      value: money(row.toBank),
                      showDivider: false,
                    ),
                    ReportTotalRow(
                      compact: true,
                      label: 'TOTAL',
                      value: money(row.converted),
                      tone: DashboardTone.blue,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        gap,
        ReportProfitBanner(label: 'Profit/Loss', value: money(row.profitLoss)),
      ],
    );
  }
}
