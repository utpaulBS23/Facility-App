part of '../view/profit_report_page.dart';

class _ProfitReportContent extends StatelessWidget {
  const _ProfitReportContent({required this.report});

  final IncentiveFineReportEntity report;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ProfitSummaryCard(report: report),
          Gap(spacing.s16),
          _IncentiveResultCard(report: report),
          Gap(spacing.s16),
          _ProfitReportCollapsibleCard(
            icon: Icons.apartment_outlined,
            title: context.locale.facilityBreakdown,
            subtitle:
                '${report.facilities.length} ${context.locale.facilities}',
            initiallyExpanded: true,
            child: _FacilityBreakdownList(facilities: report.facilities),
          ),
        ],
      ),
    );
  }
}
