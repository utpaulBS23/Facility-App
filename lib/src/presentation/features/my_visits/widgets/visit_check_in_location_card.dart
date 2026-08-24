part of '../view/visit_detail_page.dart';

class _VisitCheckInLocationCard extends StatelessWidget {
  const _VisitCheckInLocationCard({required this.state});

  final VisitCheckInState state;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        border: Border.all(color: context.color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.near_me_outlined,
                size: 16,
                color: context.color.text.secondary,
              ),
              const Gap(8),
              LabelLargeText(
                context.locale.liveLocationSharing,
                color: context.color.text.secondary,
              ),
            ],
          ),
          Gap(spacing.s16),
          Column(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: context.color.successAlt,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_on,
                  size: 28,
                  color: context.color.success,
                ),
              ),
              Gap(spacing.s20),
              LabelLargeText(context.locale.sharingYourLocation),
              Gap(spacing.s6),
              BodyRegularText(
                context.locale.locationSharingSubtitle,
                color: context.color.text.secondary,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
