part of '../view/stock_averaging_page.dart';

class _FacilityAveragingListCard extends StatelessWidget {
  const _FacilityAveragingListCard({
    required this.item,
    required this.onTap,
  });

  final FacilityAveragingItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        border: Border.all(color: color.borderSubtle),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(spacing.s10),
            decoration: BoxDecoration(
              color: color.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(
                context.dimensions.radius.r10,
              ),
            ),
            child: Icon(
              Icons.water_drop_outlined,
              color: color.primary,
              size: 22,
            ),
          ),
          Gap(spacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    StatusDotTag(
                      label: item.statusText,
                      dotColor: color.warning,
                    ),
                  ],
                ),
                Gap(spacing.s6),
                Text(
                  item.facilityName,
                  style: textStyle.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color.text.primary,
                  ),
                ),
                Gap(spacing.s4),
                Row(
                  children: [
                    Icon(
                      Icons.person_outline_rounded,
                      size: 14,
                      color: color.text.secondary,
                    ),
                    Gap(spacing.s4),
                    Text(
                      item.managerName,
                      style: textStyle.bodySmall.copyWith(
                        color: color.text.secondary,
                      ),
                    ),
                  ],
                ),
                Gap(spacing.s6),
                Row(
                  children: [
                    Text(
                      'Update: ${item.lastUpdate}  •  ',
                      style: textStyle.bodySmall.copyWith(
                        color: color.text.secondary,
                        fontSize: 11,
                      ),
                    ),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: color.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Gap(spacing.s4),
                    Text(
                      item.setupStatus,
                      style: textStyle.bodySmall.copyWith(
                        color: color.success,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onTap,
            icon: Icon(
              Icons.edit_outlined,
              color: color.text.secondary,
              size: 20,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
