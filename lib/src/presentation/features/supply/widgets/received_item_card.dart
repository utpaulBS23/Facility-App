part of '../view/request_details_page.dart';

class _ReceivedItemCard extends StatefulWidget {
  const _ReceivedItemCard({
    required this.item,
    required this.isEditing,
    this.isDelivered = false,
    required this.onEvidenceReportTap,
  });

  final MockReceivedItem item;
  final bool isEditing;
  final bool isDelivered;
  final VoidCallback onEvidenceReportTap;

  @override
  State<_ReceivedItemCard> createState() => _ReceivedItemCardState();
}

class _ReceivedItemCardState extends State<_ReceivedItemCard> {
  late int _receivedQty;

  @override
  void initState() {
    super.initState();
    _receivedQty = widget.item.receivedQuantity;
  }

  bool get _hasDiscrepancy =>
      widget.isDelivered && widget.item.expectedQuantity != _receivedQty;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    final borderColor = _hasDiscrepancy
        ? color.warning
        : (widget.isDelivered ? color.success : color.borderSubtle);

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        border: Border.all(
          color: borderColor,
          width: (widget.isDelivered || _hasDiscrepancy) ? 1.5 : 1.0,
        ),
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(spacing.s10),
                decoration: BoxDecoration(
                  color: color.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(radius.r12),
                ),
                child: Icon(
                  widget.item.icon,
                  color: color.primary,
                  size: 20,
                ),
              ),
              Gap(spacing.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.name,
                      style: context.textStyle.labelLarge.copyWith(
                        color: color.text.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gap(spacing.s2),
                    Text(
                      'Item Code: ${widget.item.code}',
                      style: context.textStyle.bodySmall.copyWith(
                        color: color.text.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.isDelivered)
                if (!_hasDiscrepancy)
                  Container(
                    padding: EdgeInsets.all(spacing.s6),
                    decoration: BoxDecoration(
                      color: color.successAlt,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      color: color.success,
                      size: 16,
                    ),
                  )
                else
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: spacing.s8,
                      vertical: spacing.s4,
                    ),
                    decoration: BoxDecoration(
                      color: color.warningAlt,
                      borderRadius: BorderRadius.circular(radius.r10),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: color.warning,
                          size: 16,
                        ),
                        Gap(spacing.s4),
                        Text(
                          '${_receivedQty - widget.item.expectedQuantity}',
                          style: context.textStyle.labelSmall.copyWith(
                            color: color.warning,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
            ],
          ),
          Gap(spacing.s12),
          if (!widget.isDelivered)
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(spacing.s10),
                    decoration: BoxDecoration(
                      color: color.scaffoldBackground,
                      borderRadius: BorderRadius.circular(radius.r10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Requested',
                          style: context.textStyle.bodySmall.copyWith(
                            color: color.text.secondary,
                          ),
                        ),
                        Gap(spacing.s4),
                        Text(
                          '${widget.item.expectedQuantity} ${widget.item.unit}',
                          style: context.textStyle.labelLarge.copyWith(
                            color: color.text.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          else ...[
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(spacing.s10),
                    decoration: BoxDecoration(
                      color: color.scaffoldBackground,
                      borderRadius: BorderRadius.circular(radius.r10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Expected',
                          style: context.textStyle.bodySmall.copyWith(
                            color: color.text.secondary,
                          ),
                        ),
                        Gap(spacing.s4),
                        Text(
                          '${widget.item.expectedQuantity} ${widget.item.unit}',
                          style: context.textStyle.labelLarge.copyWith(
                            color: color.text.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Gap(spacing.s8),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(spacing.s10),
                    decoration: BoxDecoration(
                      color: color.scaffoldBackground,
                      borderRadius: BorderRadius.circular(radius.r10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Received',
                          style: context.textStyle.bodySmall.copyWith(
                            color: color.text.secondary,
                          ),
                        ),
                        Gap(spacing.s4),
                        Text(
                          '$_receivedQty ${widget.item.unit}',
                          style: context.textStyle.labelLarge.copyWith(
                            color: color.text.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Gap(spacing.s12),
            Row(
              children: [
                Text(
                  'Amount received',
                  style: context.textStyle.labelLarge.copyWith(
                    color: color.text.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (widget.isEditing)
                  ItemStepperInput(
                    quantity: _receivedQty,
                    onChanged: (qty) => setState(() => _receivedQty = qty),
                  )
                else
                  Text(
                    '$_receivedQty ${widget.item.unit}',
                    style: context.textStyle.labelLarge.copyWith(
                      color: color.text.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
            if (_hasDiscrepancy) ...[
              Gap(spacing.s12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: widget.onEvidenceReportTap,
                  style: FilledButton.styleFrom(
                    backgroundColor: color.warningAlt,
                    foregroundColor: color.warning,
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.center_focus_weak_rounded, size: 18),
                  label: const Text('Photo of the evidence report'),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
