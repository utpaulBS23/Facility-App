part of '../view/door_control_page.dart';

class _PrimaryDeviceCard extends StatelessWidget {
  const _PrimaryDeviceCard({required this.facility});

  final FacilityEntity facility;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dimensions = context.dimensions;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(dimensions.padding.p16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(dimensions.radius.r16),
        gradient: LinearGradient(
          begin: const Alignment(-0.5, -0.87),
          end: const Alignment(0.5, 0.87),
          colors: [
            colors.selfieZoneGradientStart,
            colors.selfieZoneGradientEnd,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.locale.primaryDevice.toUpperCase(),
            style: context.textStyle.bodySmallUppercase.copyWith(
              color: colors.selfieZonePlaceholderIcon,
            ),
          ),
          Gap(dimensions.spacing.s6),
          Text(
            facility.name,
            style: context.textStyle.titleLarge.copyWith(
              color: colors.onPrimary,
            ),
          ),
          Gap(dimensions.spacing.s6),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: dimensions.spacing.s16,
                color: colors.selfieZonePlaceholderIcon,
              ),
              Gap(dimensions.spacing.s4),
              Expanded(
                child: Text(
                  facility.address,
                  style: context.textStyle.bodyMedium.copyWith(
                    color: colors.selfieZonePlaceholderIcon,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
