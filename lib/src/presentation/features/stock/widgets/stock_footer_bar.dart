part of '../view/stock_page.dart';

class _StockFooterBar extends StatelessWidget {
  const _StockFooterBar({required this.onUpdateStockBalances});

  final VoidCallback onUpdateStockBalances;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        border: Border(top: BorderSide(color: color.borderSubtle)),
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: spacing.s44,
          child: FilledButton.icon(
            onPressed: onUpdateStockBalances,
            icon: const Icon(Icons.edit_outlined),
            label: Text(context.locale.updateStockBalances),
          ),
        ),
      ),
    );
  }
}
