part of '../view/update_stock_page.dart';

class _UpdateStockFooterBar extends StatelessWidget {
  const _UpdateStockFooterBar({
    required this.onSave,
    required this.isLoading,
  });

  final VoidCallback? onSave;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;

    return PermissionGate(
      permissions: const [UserPermission.shiftStockCountCreate],
      child: Container(
        padding: EdgeInsets.all(spacing.s16),
        decoration: BoxDecoration(
          color: color.onPrimary,
          border: Border(top: BorderSide(color: color.borderSubtle)),
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: spacing.s44,
            child: FilledButton(
              onPressed: isLoading ? null : onSave,
              child: isLoading
                  ? SizedBox(
                      width: spacing.s20,
                      height: spacing.s20,
                      child: CircularProgressIndicator(
                        strokeWidth: spacing.s2,
                        color: color.onPrimary,
                      ),
                    )
                  : Text(context.locale.save),
            ),
          ),
        ),
      ),
    );
  }
}
