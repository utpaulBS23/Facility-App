import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/partner_staff_entity.dart';
import '../../../../domain/entities/report/incentive_fine_calc_entity.dart';
import '../../../../domain/entities/report/incentive_fine_facility_entity.dart';
import '../../../../domain/entities/report/incentive_fine_report_entity.dart';
import '../../../../domain/entities/report/profit_report_period.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/number_formatter.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/category_filter_chips.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../../../core/widgets/month_filter_button.dart';
import '../../../core/widgets/supervisor_filter_button.dart';
import '../riverpod/incentive_fine_report_provider.dart';
import '../riverpod/supervisor_options_provider.dart';

part '../widgets/facility_breakdown_card.dart';
part '../widgets/incentive_result_card.dart';
part '../widgets/profit_report_collapsible_card.dart';
part '../widgets/profit_report_content.dart';
part '../widgets/profit_summary_card.dart';

class ProfitReportPage extends ConsumerStatefulWidget {
  const ProfitReportPage({super.key});

  @override
  ConsumerState<ProfitReportPage> createState() => _ProfitReportPageState();
}

class _ProfitReportPageState extends ConsumerState<ProfitReportPage> {
  late String _selectedMonth;
  ProfitReportPeriod _selectedPeriod = ProfitReportPeriod.monthly;
  PartnerStaffEntity? _selectedSupervisor;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = '${now.year}-${now.month.toString().padLeft(2, '0')}';
  }

  void _fetch() {
    final supervisor = _selectedSupervisor;
    if (supervisor == null) return;
    ref
        .read(incentiveFineReportProvider.notifier)
        .fetch(
          supervisorId: supervisor.id,
          referenceMonth: _selectedMonth,
          periodType: _selectedPeriod,
        );
  }

  void _onSupervisorsLoaded(List<PartnerStaffEntity> supervisors) {
    if (_selectedSupervisor != null || supervisors.isEmpty) return;
    setState(() => _selectedSupervisor = supervisors.first);
    _fetch();
  }

  void _onSupervisorChanged(PartnerStaffEntity supervisor) {
    if (_selectedSupervisor?.id == supervisor.id) return;
    setState(() => _selectedSupervisor = supervisor);
    _fetch();
  }

  void _onMonthChanged(String month) {
    setState(() => _selectedMonth = month);
    _fetch();
  }

  void _onPeriodChanged(ProfitReportPeriod period) {
    if (_selectedPeriod == period) return;
    setState(() => _selectedPeriod = period);
    _fetch();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final reportAsync = ref.watch(incentiveFineReportProvider);
    final supervisorsAsync = ref.watch(supervisorOptionsProvider);

    ref.listen(supervisorOptionsProvider, (previous, next) {
      next.whenData(_onSupervisorsLoaded);
    });

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(
        title: context.locale.profitReport,
        actions: [
          MonthFilterButton(
            month: DateTime(
              int.parse(_selectedMonth.split('-')[0]),
              int.parse(_selectedMonth.split('-')[1]),
            ),
            lastDate: DateTime.now(),
            onSelected: (date) => _onMonthChanged(
              '${date.year}-${date.month.toString().padLeft(2, '0')}',
            ),
          ),
          SupervisorFilterButton(
            supervisorsAsync: supervisorsAsync,
            selected: _selectedSupervisor,
            onChanged: _onSupervisorChanged,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(spacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: CategoryFilterChips<ProfitReportPeriod>(
                categories: ProfitReportPeriod.values,
                selectedCategory: _selectedPeriod,
                onSelected: _onPeriodChanged,
                labelBuilder: (context, period) => switch (period) {
                  ProfitReportPeriod.monthly => context.locale.monthly,
                  ProfitReportPeriod.quarterly => context.locale.quarterly,
                  ProfitReportPeriod.annual => context.locale.annual,
                },
              ),
            ),
            Gap(spacing.s16),
            Expanded(
              child: switch (reportAsync) {
                AsyncData(:final value) => _ProfitReportContent(
                  report: value,
                ),
                AsyncError(:final error) => AppErrorWidget(
                  message: error.localizedMessage(context),
                  onRetry: _fetch,
                ),
                _ => const Center(child: CircularProgressIndicator()),
              },
            ),
          ],
        ),
      ),
    );
  }
}
