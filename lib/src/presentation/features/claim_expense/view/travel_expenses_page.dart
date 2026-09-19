import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/login_entity.dart';
import '../../../../domain/entities/travel_expense_entity.dart';
import '../../../../domain/entities/travel_expense_list_filter.dart';
import '../../../../domain/entities/travel_expense_status.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/category_filter_chips.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/status_dot_tag.dart';
import '../extensions/travel_expense_status_extension.dart';
import '../riverpod/travel_expenses_list_provider.dart';

part '../widgets/travel_expense_list_card.dart';
part '../widgets/travel_expense_stats_row.dart';

class TravelExpensesPage extends ConsumerStatefulWidget {
  const TravelExpensesPage({super.key});

  @override
  ConsumerState<TravelExpensesPage> createState() =>
      _TravelExpensesPageState();
}

class _TravelExpensesPageState extends ConsumerState<TravelExpensesPage> {
  TravelExpenseListFilter _selectedFilter = TravelExpenseListFilter.all;

  void _onFilterSelected(TravelExpenseListFilter filter) {
    if (_selectedFilter == filter) return;
    setState(() => _selectedFilter = filter);
  }

  void _onAddTravelExpense(BuildContext context) {
    context.pushNamed(Routes.addTravelExpense);
  }

  String _filterLabel(BuildContext context, TravelExpenseListFilter filter) {
    return switch (filter) {
      TravelExpenseListFilter.all => context.locale.all,
      TravelExpenseListFilter.waiting => context.locale.pending,
      TravelExpenseListFilter.allowed => context.locale.approved,
      TravelExpenseListFilter.rejected => context.locale.rejected,
    };
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final expensesAsync = ref.watch(travelExpensesListProvider);
    final allExpenses = expensesAsync.valueOrNull ?? const [];
    final filteredExpenses = [
      for (final expense in allExpenses)
        if (_selectedFilter.matches(expense.status)) expense,
    ];

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(title: context.locale.claimExpense),
      floatingActionButton: PermissionGate(
        permissions: const [UserPermission.travelExpenseCreate],
        child: FloatingActionButton(
          onPressed: () => _onAddTravelExpense(context),
          backgroundColor: context.color.primary,
          foregroundColor: context.color.onPrimary,
          child: const Icon(Icons.add),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              spacing.s16,
              spacing.s16,
              spacing.s16,
              spacing.s12,
            ),
            child: _TravelExpenseStatsRow(
              stats: _TravelExpenseStats.from(allExpenses),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              spacing.s16,
              0,
              spacing.s16,
              spacing.s8,
            ),
            child: CategoryFilterChips<TravelExpenseListFilter>(
              categories: TravelExpenseListFilter.values,
              selectedCategory: _selectedFilter,
              onSelected: _onFilterSelected,
              labelBuilder: _filterLabel,
            ),
          ),
          Expanded(
            child: expensesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => AppErrorWidget(
                message: err.localizedMessage(context),
                onRetry: () =>
                    ref.read(travelExpensesListProvider.notifier).fetch(),
              ),
              data: (_) {
                if (filteredExpenses.isEmpty) {
                  return Center(
                    child: Text(
                      context.locale.noTravelExpensesFound,
                      style: context.textStyle.bodyMedium.copyWith(
                        color: context.color.text.secondary,
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.all(spacing.s16),
                  itemCount: filteredExpenses.length,
                  separatorBuilder: (context, index) => Gap(spacing.s12),
                  itemBuilder: (context, index) =>
                      _TravelExpenseListCard(expense: filteredExpenses[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
