part of '../view/confirm_delivery_page.dart';

class _OrderDetailsSummaryCard extends StatelessWidget {
  const _OrderDetailsSummaryCard({
    required this.requestId,
    required this.requestedBy,
    required this.urgency,
  });

  final String requestId;
  final String requestedBy;
  final String urgency;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        border: Border.all(color: color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Details',
            style: context.textStyle.titleMedium.copyWith(
              color: color.text.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Gap(spacing.s12),
          _DetailRow(label: 'Request ID', value: requestId),
          Gap(spacing.s8),
          _DetailRow(label: 'Requested by', value: requestedBy),
          Gap(spacing.s8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Urgency',
                style: context.textStyle.bodySmall.copyWith(
                  color: color.text.secondary,
                ),
              ),
              StatusDotTag(
                dotColor: urgency.toLowerCase() == 'urgent'
                    ? color.primary
                    : color.warning,
                label: urgency,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final color = context.color;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: context.textStyle.bodySmall.copyWith(
            color: color.text.secondary,
          ),
        ),
        Text(
          value,
          style: context.textStyle.labelLarge.copyWith(
            color: color.text.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
