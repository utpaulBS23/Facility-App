part of '../view/confirm_delivery_page.dart';

class _ConfirmDeliveryBody extends StatelessWidget {
  const _ConfirmDeliveryBody({
    required this.request,
    required this.delivery,
    required this.items,
    required this.notesController,
    required this.receiptPhoto,
    required this.onReceiptPhotoChanged,
    required this.onItemToggled,
    required this.onQuantityChanged,
    required this.onToggleAll,
  });

  final SupplyRequestEntity request;
  final DeliveryEntity delivery;
  final List<DeliveryItemEntity> items;
  final TextEditingController notesController;
  final XFile? receiptPhoto;
  final ValueChanged<XFile?> onReceiptPhotoChanged;
  final ValueChanged<int> onItemToggled;
  final void Function(int index, int quantity) onQuantityChanged;
  final VoidCallback onToggleAll;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return SingleChildScrollView(
      padding: EdgeInsets.all(spacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RequestInfoCard(
            label: context.locale.facility,
            title: delivery.localizedFacilityName(context.languageCode),
          ),
          Gap(spacing.s16),
          _OrderDetailsSummaryCard(
            requestId: delivery.requestCode,
            requestedBy: request.localizedRequestedByName(context.languageCode),
            urgency: request.urgency,
          ),
          Gap(spacing.s16),
          _VerifyItemsCard(
            items: items,
            onItemToggled: onItemToggled,
            onQuantityChanged: onQuantityChanged,
            onToggleAll: onToggleAll,
          ),
          Gap(spacing.s16),
          _NotesInputCard(controller: notesController),
          Gap(spacing.s16),
          PhotoPickerCard(
            title: context.locale.deliveryReceiptPhotoOptional,
            photo: receiptPhoto,
            onChanged: onReceiptPhotoChanged,
          ),
          Gap(spacing.s24),
        ],
      ),
    );
  }
}
