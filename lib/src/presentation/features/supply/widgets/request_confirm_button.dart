part of '../view/request_details_page.dart';

class _RequestConfirmButton extends StatelessWidget {
  const _RequestConfirmButton({
    required this.delivery,
    required this.onConfirmTap,
    this.isEnabled = true,
  });

  final DeliveryEntity? delivery;
  final VoidCallback onConfirmTap;
  final bool isEnabled;

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
                  onPressed: (isEnabled && delivery != null) ? onConfirmTap : null,
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
