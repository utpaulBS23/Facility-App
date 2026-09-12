part of '../view/facility_expense_page.dart';

class _FacilityExpenseBody extends StatelessWidget {
  const _FacilityExpenseBody({
    required this.listAsync,
    required this.facilityName,
    required this.canPickFacility,
    required this.onPickFacility,
    required this.onRetry,
  });

  final AsyncValue<FacilityExpenseListResultEntity> listAsync;
  final String? facilityName;
  final bool canPickFacility;
  final VoidCallback onPickFacility;
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
            _ExpenseListSection(listAsync: listAsync, onRetry: onRetry),
          ],
        ),
      ),
    );
  }
}
