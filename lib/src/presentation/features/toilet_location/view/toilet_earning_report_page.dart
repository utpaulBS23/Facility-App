import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/app_numbers.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/master_data_entity.dart';
import '../../../../domain/entities/toilet_location/facility_monthly_report_entity.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../dashboard/widgets/dashboard_tone.dart';
import '../../facility_expense/riverpod/submit_expense_provider/expense_dropdowns_provider.dart';
import '../../additional_income/riverpod/submit_income_provider/income_type_options_provider.dart';
import '../riverpod/toilet_earning_report_provider.dart';
import '../riverpod/toilet_name.dart';
import '../widgets/details/toilet_section_card.dart';
import '../widgets/report/report_breakdown_cards.dart';
import '../widgets/report/report_detail_cards.dart';
import '../widgets/report/report_filter_widgets.dart';
import '../widgets/report/report_summary_widgets.dart';

// TODO: texts are English only until the next localisation pass.

/// One toilet's monthly report: people served, income and cost by source, the
/// digital system, and the profit or loss.
///
/// WHY it is added up here and not read from one report API: the figures come
/// from the day-to-day records, exactly as the admin web's Facility Wise
/// Report PDF adds them (see [buildFacilityMonthlyReport]).
class ToiletEarningReportPage extends ConsumerStatefulWidget {
  const ToiletEarningReportPage({super.key, required this.facilityId});

  final int facilityId;

  @override
  ConsumerState<ToiletEarningReportPage> createState() =>
      _ToiletEarningReportPageState();
}

class _ToiletEarningReportPageState
    extends ConsumerState<ToiletEarningReportPage> {
  late int _year = DateTime.now().year;
  late int _month = DateTime.now().month;

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
    final toiletName = toiletNameOf(ref, widget.facilityId, language);

    return Scaffold(
      backgroundColor: c.scaffoldBackground,
      appBar: DetailAppBar(title: 'Monthly report', onBack: _onBack),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (toiletName != null) ...[
              Text(
                toiletName,
                style: context.textStyle.labelXl.copyWith(
                  color: c.text.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              gap,
            ],
            ReportFilterCard(
              title: 'Select month and year',
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
              data: (data) => _ReportBody(
                report: data,
                // The partner's expense categories, to list unused ones as
                // the web report does; the report still shows without them.
                expenseCatalog:
                    ref.watch(expenseCategoryOptionsProvider).valueOrNull ??
                    const [],
                // The partner's extra-income types name the extra income
                // lines; the report still shows without them.
                incomeTypes:
                    ref.watch(incomeTypeOptionsProvider).valueOrNull ??
                    const [],
                languageCode: language,
              ),
            ),
            SizedBox(height: spacing.s16),
          ],
        ),
      ),
    );
  }
}

class _ReportBody extends StatelessWidget {
  const _ReportBody({
    required this.report,
    required this.expenseCatalog,
    required this.incomeTypes,
    required this.languageCode,
  });

  final FacilityMonthlyReportEntity report;
  final List<MasterDataItemEntity> expenseCatalog;
  final List<MasterDataItemEntity> incomeTypes;
  final String languageCode;

  @override
  Widget build(BuildContext context) {
    final n = context.numbers;
    final spacing = context.dimensions.spacing;
    final gap = SizedBox(height: spacing.s12);
    String money(num v) => v < 0 ? '-৳ ${n.integer(-v)}' : '৳ ${n.integer(v)}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!report.hasRecords) ...[
          ToiletSectionCard(
            title: 'No records',
            child: Text(
              'This toilet has no collections, income or expenses recorded '
              'for this month. Pick another month or toilet.',
              style: context.textStyle.bodyMedium.copyWith(
                color: context.color.text.secondary,
              ),
            ),
          ),
          gap,
        ],
        ToiletTileRow(
          children: [
            ReportSummaryTile(
              icon: Icons.groups_outlined,
              value: n.integer(report.totalUsers),
              label: 'User',
              tone: DashboardTone.blue,
            ),
            ReportSummaryTile(
              icon: Icons.trending_up_rounded,
              value: money(report.totalIncome),
              label: 'Total income',
              tone: DashboardTone.green,
            ),
            ReportSummaryTile(
              icon: report.profitLoss < 0
                  ? Icons.trending_down_rounded
                  : Icons.trending_up_rounded,
              value: money(report.profitLoss),
              label: 'Total profit',
              tone: report.profitLoss < 0
                  ? DashboardTone.red
                  : DashboardTone.green,
            ),
          ],
        ),
        gap,
        ReportSubscribersCard(report: report),
        gap,
        ReportDigitalSystemCard(report: report),
        gap,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ReportRevenueCard(
                report: report,
                incomeTypes: incomeTypes,
                languageCode: languageCode,
              ),
            ),
            SizedBox(width: spacing.s12),
            Expanded(child: ReportServiceCostCard(report: report)),
          ],
        ),
        gap,
        ReportIncomeItemsCard(
          report: report,
          incomeTypes: incomeTypes,
          languageCode: languageCode,
        ),
        gap,
        ReportExpenseItemsCard(
          report: report,
          catalog: expenseCatalog,
          languageCode: languageCode,
        ),
        gap,
        ReportCustomerNumbersCard(report: report),
        gap,
        ReportBkashCard(report: report),
        gap,
        ReportProfitBanner(
          label: 'Profit/Loss',
          value: money(report.profitLoss),
          isLoss: report.profitLoss < 0,
        ),
      ],
    );
  }
}
