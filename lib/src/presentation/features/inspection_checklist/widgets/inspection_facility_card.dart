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
        borderRadius: BorderRadius.circular(radius.r6),
        border: Border.all(color: context.color.borderSubtle),
      ),
      child: Row(
        children: [
          Icon(
            Icons.business_rounded,
            color: context.color.primary,
            size: 28,
          ),
          SizedBox(width: spacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabelLargeText(
                  detail.facilityName ?? detail.officeName ?? '',
                  color: context.color.text.primary,
                ),
                if (detail.facilityAddress?.isNotEmpty == true) ...[
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
                          detail.facilityAddress!,
                          color: context.color.text.secondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
