part of '../view/inspection_checklist_page.dart';

class _InspectionFacilityCard extends StatelessWidget {
  const _InspectionFacilityCard({required this.detail});

  final VisitDetailEntity detail;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        borderRadius: .circular(radius.r6),
        border: Border.all(color: context.color.borderSubtle),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: context.color.brandAccent.withValues(alpha: 0.12),
              borderRadius: .circular(radius.r6),
            ),
            child: Icon(
              Icons.business_rounded,
              color: context.color.brandAccent,
              size: 24,
            ),
          ),
          SizedBox(width: spacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                LabelLargeText(
                  detail.facilityName,
                  color: context.color.text.primary,
                ),
                SizedBox(height: spacing.s4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: context.color.text.secondary,
                    ),
                    SizedBox(width: spacing.s4),
                    Expanded(
                      child: BodySmallText(
                        detail.facilityAddress,
                        color: context.color.text.secondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
