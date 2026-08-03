part of '../view/request_details_page.dart';

class _ReceivedItemsList extends StatefulWidget {
  const _ReceivedItemsList({
    required this.items,
    required this.priority,
    required this.isApprovedStage,
    this.isDelivered = false,
    required this.canEdit,
    required this.onEvidenceReportTap,
  });

  final List<ReceivedItemUiModel> items;
  final SupplyUrgency priority;
  final bool isApprovedStage;
  final bool isDelivered;
  final bool canEdit;
  final void Function(ReceivedItemUiModel item) onEvidenceReportTap;

  @override
  State<_ReceivedItemsList> createState() => _ReceivedItemsListState();
}

class _ReceivedItemsListState extends State<_ReceivedItemsList> {
  bool _isEditing = false;

  final List<String> _availableItems = [
    'Jumbo Toilet Roll',
    'Liquid Hand Soap',
    'Paper Towel Pack',
    'LED Desk Lamp',
  ];

  final List<NewRequestItemFormEntry> _newItems = [];

  void _onAddItem() {
    setState(() {
      _newItems.add(
        NewRequestItemFormEntry(
          itemName: _availableItems.first,
          quantity: 1,
          unit: 'Rolls',
        ),
      );
    });
  }

  void _onRemoveNewItem(int index) {
    setState(() {
      _newItems.removeAt(index);
    });
  }

  void _onSave() {
    setState(() {
      _isEditing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.locale.itemChangesSavedSuccessfully)),
    );
  }

  void _onCancel() {
    setState(() {
      _isEditing = false;
      _newItems.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;

    final totalCount = widget.items.length + _newItems.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.isApprovedStage
                  ? context.locale.receivedItemsCount(totalCount)
                  : context.locale.requestedItemsCount(totalCount),
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
        // Gap(spacing.s6),
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
              isDelivered: widget.isDelivered,
              onEvidenceReportTap: () => widget.onEvidenceReportTap(item),
            );
          },
        ),
        if (_isEditing && _newItems.isNotEmpty) ...[
          Gap(spacing.s12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _newItems.length,
            separatorBuilder: (context, index) => Gap(spacing.s12),
            itemBuilder: (context, index) {
              final newItem = _newItems[index];
              return _NewItemEntryCard(
                item: newItem,
                availableItemNames: _availableItems,
                onNameChanged: (name) {
                  setState(() {
                    _newItems[index] = newItem.copyWith(itemName: name);
                  });
                },
                onQuantityChanged: (qty) {
                  setState(() {
                    _newItems[index] = newItem.copyWith(quantity: qty);
                  });
                },
                onRemove: () => _onRemoveNewItem(index),
              );
            },
          ),
        ],
        if (_isEditing && !widget.isDelivered) ...[
          Gap(spacing.s12),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton.icon(
              onPressed: _onAddItem,
              icon: const Icon(Icons.add_rounded, size: 18),
              label: Text(context.locale.addItem),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: color.borderSubtle),
                foregroundColor: color.text.primary,
                backgroundColor: color.scaffoldBackground,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
