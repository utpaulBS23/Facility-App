part of '../view/additional_income_page.dart';

class _AdditionalIncomeBody extends StatelessWidget {
  const _AdditionalIncomeBody({
    required this.listAsync,
    required this.facilityName,
    required this.canPickFacility,
    required this.onPickFacility,
    required this.onRetry,
  });

  final AsyncValue<AdditionalIncomeListResultEntity> listAsync;
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
              AsyncData(:final value) => _IncomeStatsRow(summary: value.summary),
              AsyncError() => const SizedBox.shrink(),
              _ => const _IncomeStatsRowShimmer(),
            },
            Gap(spacing.s16),
            _IncomeFacilitySelector(
              facilityName: facilityName,
              onTap: canPickFacility ? onPickFacility : null,
            ),
            Gap(spacing.s16),
            _IncomeListSection(listAsync: listAsync, onRetry: onRetry),
          ],
        ),
      ),
    );
  }
}
