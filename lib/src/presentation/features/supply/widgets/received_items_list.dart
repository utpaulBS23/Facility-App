part of '../view/request_details_page.dart';

class _ReceivedItemsList extends StatefulWidget {
  const _ReceivedItemsList({
    required this.requestItems,
    this.deliveryItems,
    required this.priority,
    required this.hasDelivery,
    required this.isConfirmed,
    required this.canEdit,
    required this.editedQuantities,
    required this.onQuantityChanged,
    required this.onEditingCancelled,
    required this.onEvidenceReportTap,
  });

  final List<SupplyRequestItemEntity> requestItems;
  final List<DeliveryItemEntity>? deliveryItems;
  final SupplyUrgency priority;
  final bool hasDelivery;
  final bool isConfirmed;
  final bool canEdit;
  final Map<int, int> editedQuantities;
  final void Function(int stockItemId, int qty) onQuantityChanged;
  final VoidCallback onEditingCancelled;
  final void Function(int stockItemId) onEvidenceReportTap;

  @override
  State<_ReceivedItemsList> createState() => _ReceivedItemsListState();
}

class _ReceivedItemsListState extends State<_ReceivedItemsList> {
  bool _isEditing = false;

  void _onSave() {
    setState(() => _isEditing = false);
  }

  void _onCancel() {
    setState(() => _isEditing = false);
    widget.onEditingCancelled();
  }

  Color _urgencyColor(BuildContext context, SupplyUrgency urgency) =>
      switch (urgency) {
        SupplyUrgency.urgent => context.color.primary,
        SupplyUrgency.high => context.color.warning,
        SupplyUrgency.normal => context.color.success,
        SupplyUrgency.low => context.color.text.secondary,
      };

  String _urgencyLabel(BuildContext context, SupplyUrgency urgency) =>
      switch (urgency) {
        SupplyUrgency.urgent => context.locale.urgencyUrgent,
        SupplyUrgency.high => context.locale.urgencyHigh,
        SupplyUrgency.normal => context.locale.urgencyNormal,
        SupplyUrgency.low => context.locale.urgencyLow,
      };

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;

    final itemCount = widget.deliveryItems?.length ?? widget.requestItems.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.hasDelivery
                  ? context.locale.receivedItemsCount(itemCount)
                  : context.locale.requestedItemsCount(itemCount),
              style: context.textStyle.titleMedium.copyWith(
                color: color.text.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (!_isEditing)
              TextButton(
                onPressed: widget.canEdit
                    ? () => setState(() => _isEditing = true)
                    : null,
                style: TextButton.styleFrom(
                  foregroundColor: color.primary,
                  disabledForegroundColor: color.text.secondary,
                ),
                child: Text(context.locale.edit),
              )
            else
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: _onCancel,
                    style: TextButton.styleFrom(
                      foregroundColor: color.text.secondary,
                    ),
                    child: Text(context.locale.cancel),
                  ),
                  Gap(spacing.s4),
                  TextButton(
                    onPressed: _onSave,
                    style: TextButton.styleFrom(
                      foregroundColor: color.primary,
                    ),
                    child: Text(context.locale.save),
                  ),
                ],
              ),
          ],
        ),
        StatusDotTag(
          dotColor: _urgencyColor(context, widget.priority),
          label: _urgencyLabel(context, widget.priority),
        ),
        Gap(spacing.s12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: itemCount,
          separatorBuilder: (context, index) => Gap(spacing.s12),
          itemBuilder: (context, index) {
            final String name;
            final String code;
            final int expectedQty;
            final int receivedQty;
            final String unit;
            final int stockItemId;

            if (widget.deliveryItems != null && index < widget.deliveryItems!.length) {
              final dItem = widget.deliveryItems![index];
              name = dItem.itemName;
              code = dItem.itemCode;
              expectedQty = dItem.qtyExpected.round();
              receivedQty = dItem.qtyReceived.round();
              unit = dItem.unit;
              stockItemId = dItem.stockItemId;
            } else {
              final rItem = widget.requestItems[index];
              name = rItem.itemName;
              code = rItem.itemCode;
              expectedQty = rItem.qtyRequested.round();
              receivedQty = rItem.qtyRequested.round();
              unit = rItem.unit;
              stockItemId = rItem.stockItemId;
            }

            return _ReceivedItemCard(
              name: name,
              code: code,
              expectedQuantity: expectedQty,
              receivedQuantity: receivedQty,
              unit: unit,
              stockItemId: stockItemId,
              isEditing: _isEditing,
              hasDelivery: widget.hasDelivery,
              isConfirmed: widget.isConfirmed,
              editedQuantity: widget.editedQuantities[stockItemId],
              onQuantityChanged: (qty) =>
                  widget.onQuantityChanged(stockItemId, qty),
              onEvidenceReportTap: () => widget.onEvidenceReportTap(stockItemId),
            );
          },
        ),
      ],
    );
  }
}
