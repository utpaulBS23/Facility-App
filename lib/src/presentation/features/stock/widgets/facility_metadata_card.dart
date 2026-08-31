part of '../view/stock_averaging_details_page.dart';

class _FacilityMetadataCard extends StatelessWidget {
  const _FacilityMetadataCard({
    required this.facilityName,
    required this.updatedByName,
    required this.updatedAt,
  });

  final String facilityName;
  final String updatedByName;
  final String updatedAt;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;

    final dateStr = updatedAt.length >= 10 ? updatedAt.substring(0, 10) : updatedAt;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        border: Border.all(color: color.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.locale.facility,
            style: textStyle.bodySmall.copyWith(
              color: color.text.secondary,
            ),
          ),
          Gap(spacing.s4),
          Text(
            facilityName,
            style: textStyle.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: color.text.primary,
            ),
          ),
          Divider(color: color.borderSubtle, height: spacing.s24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Last updated',
                style: textStyle.bodySmall.copyWith(
                  color: color.text.secondary,
                ),
              ),
              Text(
                dateStr.isEmpty ? 'N/A' : dateStr,
                style: textStyle.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color.text.primary,
                ),
              ),
            ],
          ),
          Gap(spacing.s8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Updated by',
                style: textStyle.bodySmall.copyWith(
                  color: color.text.secondary,
                ),
              ),
              Text(
                updatedByName.isEmpty ? 'N/A' : updatedByName,
                style: textStyle.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color.text.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
