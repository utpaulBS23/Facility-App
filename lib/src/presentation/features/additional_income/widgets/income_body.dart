part of '../view/additional_income_page.dart';

class _AdditionalIncomeBody extends StatelessWidget {
  const _AdditionalIncomeBody({
    required this.listAsync,
    required this.onRetry,
  });

  final AsyncValue<AdditionalIncomeListResultEntity> listAsync;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return RefreshIndicator(
      onRefresh: () async => onRetry(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(spacing.s16),
        child: _IncomeListSection(listAsync: listAsync, onRetry: onRetry),
      ),
    );
  }
}
