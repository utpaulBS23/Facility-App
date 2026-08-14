part of '../view/request_details_page.dart';

class _RequestDetailsBottomBar extends StatelessWidget {
  const _RequestDetailsBottomBar({
    required this.delivery,
    required this.onConfirmTap,
  });

  final DeliveryEntity? delivery;
  final VoidCallback onConfirmTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return PermissionGate(
      permissions: const [UserPermission.deliveryConfirm],
      child: Container(
        padding: EdgeInsets.all(spacing.s16),
        decoration: BoxDecoration(
          color: context.color.onPrimary,
          border: Border(
            top: BorderSide(color: context.color.borderSubtle),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: spacing.s44,
                child: FilledButton(
                  onPressed: delivery == null ? null : onConfirmTap,
                  child: Text(context.locale.confirmDeliveryReceipt),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
