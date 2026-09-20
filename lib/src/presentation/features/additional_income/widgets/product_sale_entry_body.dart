part of '../view/additional_income_page.dart';

class _ProductSaleEntryBody extends StatelessWidget {
  const _ProductSaleEntryBody({
    required this.listAsync,
    required this.onRetry,
  });

  final AsyncValue<ProductSaleEntryListResultEntity> listAsync;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return RefreshIndicator(
      onRefresh: () async => onRetry(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(spacing.s16),
        child: _ProductSaleEntrySection(listAsync: listAsync, onRetry: onRetry),
      ),
    );
  }
}
