part of '../view/request_details_page.dart';

class _ReceivedItemsSection extends ConsumerWidget {
  const _ReceivedItemsSection({
    required this.request,
    required this.isEditing,
    required this.onEditToggled,
    required this.editedQuantities,
    required this.onQuantityChanged,
    required this.onEditingCancelled,
    required this.onEvidenceReportTap,
  });

  final SupplyRequestEntity request;
  final bool isEditing;
  final ValueChanged<bool> onEditToggled;
  final Map<int, int> editedQuantities;
  final void Function(int stockItemId, int qty) onQuantityChanged;
  final VoidCallback onEditingCancelled;
  final void Function(int stockItemId) onEvidenceReportTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!request.hasDelivery) {
      return _ReceivedItemsList(
        requestItems: request.items,
        priority: request.urgency,
        hasDelivery: false,
        isConfirmed: false,
        canEdit: false,
        isEditing: isEditing,
        onEditToggled: onEditToggled,
        editedQuantities: editedQuantities,
        onQuantityChanged: onQuantityChanged,
        onEditingCancelled: onEditingCancelled,
        onEvidenceReportTap: onEvidenceReportTap,
      );
    }

    final deliveryAsync = ref.watch(
      supplyRequestDeliveryProvider(request.requestCode),
    );

    return deliveryAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => AppErrorWidget(
        message: err.localizedMessage(context),
        onRetry: () => ref.invalidate(
          supplyRequestDeliveryProvider(request.requestCode),
        ),
      ),
      data: (delivery) => _ReceivedItemsList(
        requestItems: request.items,
        deliveryItems: delivery?.items,
        priority: request.urgency,
        hasDelivery: true,
        isConfirmed: request.isDelivered,
        canEdit: request.status == SupplyRequestStatus.inDelivery,
        isEditing: isEditing,
        onEditToggled: onEditToggled,
        editedQuantities: editedQuantities,
        onQuantityChanged: onQuantityChanged,
        onEditingCancelled: onEditingCancelled,
        onEvidenceReportTap: onEvidenceReportTap,
      ),
    );
  }
}
