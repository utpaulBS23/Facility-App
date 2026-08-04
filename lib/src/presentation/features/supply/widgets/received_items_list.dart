part of '../view/request_details_page.dart';

class _ReceivedItemsList extends StatefulWidget {
  const _ReceivedItemsList({
    required this.items,
    required this.priority,
    required this.hasDelivery,
    required this.isConfirmed,
    required this.canEdit,
    required this.editedQuantities,
    required this.onQuantityChanged,
    required this.onEditingCancelled,
    required this.onEvidenceReportTap,
  });

  final List<ReceivedItemUiModel> items;
  final SupplyUrgency priority;
  final bool hasDelivery;
  final bool isConfirmed;
  final bool canEdit;
  final Map<int, int> editedQuantities;
  final void Function(int stockItemId, int qty) onQuantityChanged;
  final VoidCallback onEditingCancelled;
  final void Function(ReceivedItemUiModel item) onEvidenceReportTap;

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

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.hasDelivery
                  ? context.locale.receivedItemsCount(widget.items.length)
                  : context.locale.requestedItemsCount(widget.items.length),
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
          dotColor: widget.priority.urgencyColor(context),
          label: widget.priority.localizedName(context),
        ),
        Gap(spacing.s12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.items.length,
          separatorBuilder: (context, index) => Gap(spacing.s12),
          itemBuilder: (context, index) {
            final item = widget.items[index];

            return _ReceivedItemCard(
              item: item,
              isEditing: _isEditing,
              hasDelivery: widget.hasDelivery,
              isConfirmed: widget.isConfirmed,
              editedQuantity: widget.editedQuantities[item.stockItemId],
              onQuantityChanged: (qty) =>
                  widget.onQuantityChanged(item.stockItemId, qty),
              onEvidenceReportTap: () => widget.onEvidenceReportTap(item),
            );
          },
        ),
      ],
    );
  }
}
