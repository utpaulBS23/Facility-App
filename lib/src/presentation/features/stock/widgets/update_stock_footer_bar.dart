part of '../view/update_stock_page.dart';

class _UpdateStockFooterBar extends StatelessWidget {
  const _UpdateStockFooterBar({required this.onSave});

  final VoidCallback onSave;

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
          height: 44,
          child: FilledButton(
            onPressed: onSave,
            child: const Text('Save'),
          ),
        ),
      ),
    );
  }
}
