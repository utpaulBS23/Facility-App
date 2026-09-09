part of '../view/facility_expense_page.dart';

class _FacilityExpenseBody extends StatelessWidget {
  const _FacilityExpenseBody({
    required this.listAsync,
    required this.facilityName,
    required this.canPickFacility,
    required this.onPickFacility,
    required this.onAddExpense,
    required this.onRetry,
  });

  final AsyncValue<FacilityExpenseListResultEntity> listAsync;
  final String? facilityName;
  final bool canPickFacility;
  final VoidCallback onPickFacility;
  final VoidCallback onAddExpense;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return RefreshIndicator(
      onRefresh: () async => onRetry(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(spacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            switch (listAsync) {
              AsyncData(:final value) => _ExpenseStatsRow(summary: value.summary),
              AsyncError() => const SizedBox.shrink(),
              _ => const _ExpenseStatsRowShimmer(),
            },
            Gap(spacing.s16),
            _ExpenseFacilitySelector(
              facilityName: facilityName,
              onTap: canPickFacility ? onPickFacility : null,
            ),
            Gap(spacing.s16),
            PermissionGate(
              permissions: const [UserPermission.facilityExpenseCreate],
              child: FilledButton(
                onPressed: onAddExpense,
                style: FilledButton.styleFrom(
                  backgroundColor: context.color.primary,
                  foregroundColor: context.color.onPrimary,
                  minimumSize: Size.fromHeight(spacing.s56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      context.dimensions.radius.r12,
                    ),
                  ),
                ),
                child: Text(
                  context.locale.addExpense,
                  style: context.textStyle.labelLarge.copyWith(
                    color: context.color.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Gap(spacing.s16),
            _ExpenseListSection(listAsync: listAsync, onRetry: onRetry),
          ],
        ),
      ),
    );
  }
}
