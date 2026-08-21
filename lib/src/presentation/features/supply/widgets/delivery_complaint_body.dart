part of '../view/delivery_complaint_page.dart';

class _DeliveryComplaintBody extends StatelessWidget {
  const _DeliveryComplaintBody({
    required this.item,
    required this.reasonController,
    required this.onReasonChanged,
  });

  final DeliveryItemEntity item;
  final TextEditingController reasonController;
  final VoidCallback onReasonChanged;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return SingleChildScrollView(
      padding: EdgeInsets.all(spacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DiscrepancySummaryCard(item: item),
          Gap(spacing.s16),
          const _ProofPhotoPickerCard(),
          Gap(spacing.s16),
          _AdditionalDetailsCard(
            controller: reasonController,
            onChanged: onReasonChanged,
          ),
        ],
      ),
    );
  }
}
