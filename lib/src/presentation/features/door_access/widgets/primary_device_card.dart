part of '../view/door_control_page.dart';

class _PrimaryDeviceCard extends StatelessWidget {
  const _PrimaryDeviceCard({
    required this.facility,
    this.isOffline = false,
  });

  final FacilityEntity facility;
  final bool isOffline;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dimensions = context.dimensions;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(dimensions.padding.p16),
      decoration: BoxDecoration(
        color: colors.brandAccent,
        border: Border.all(color: colors.primary, width: 1.0),
        borderRadius: BorderRadius.circular(dimensions.radius.r16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.locale.primaryDevice.toUpperCase(),
                style: context.textStyle.bodySmallUppercase.copyWith(
                  color: colors.text.secondary,
                ),
              ),
              if (isOffline)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: dimensions.spacing.s8,
                    vertical: dimensions.spacing.s4,
                  ),
                  decoration: BoxDecoration(
                    color: colors.warningAlt,
                    borderRadius: BorderRadius.circular(dimensions.radius.r12),
                    border: Border.all(color: colors.warning),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.wifi_off_rounded,
                        size: dimensions.spacing.s12,
                        color: colors.warning,
                      ),
                      Gap(dimensions.spacing.s4),
                      Text(
                        context.locale.offline.toUpperCase(),
                        style: context.textStyle.bodySmallUppercase.copyWith(
                          color: colors.warning,
                          fontWeight: TextWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          Gap(dimensions.spacing.s6),
          Text(
            facility.name,
            style: context.textStyle.titleLarge.copyWith(
              color: colors.text.primary,
              fontWeight: TextWeight.bold,
            ),
          ),
          Gap(dimensions.spacing.s6),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: dimensions.spacing.s16,
                color: colors.text.secondary,
              ),
              Gap(dimensions.spacing.s4),
              Expanded(
                child: Text(
                  facility.address,
                  style: context.textStyle.bodyMedium.copyWith(
                    color: colors.text.secondary,
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
