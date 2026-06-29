part of '../view/visit_detail_page.dart';

class _VisitCheckInLocationCard extends StatelessWidget {
  const _VisitCheckInLocationCard({
    required this.state,
    required this.captureResult,
    required this.onRetry,
  });

  final VisitCheckInState state;
  final VisitCheckInCaptureEntity captureResult;
  final VoidCallback onRetry;

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
                context.locale.gpsLocationVerification,
                color: context.color.text.secondary,
              ),
            ],
          ),
          Gap(spacing.s16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                      Icons.check,
                      size: 28,
                      color: context.color.success,
                    ),
                  ),
                  Gap(spacing.s20),
                  LabelLargeText(context.locale.locationVerified),
                  Gap(spacing.s6),
                  BodyRegularText(
                    context.locale.withinRange,
                    color: context.color.text.secondary,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Gap(spacing.s20),
              _CoordinatesBox(captureResult: captureResult),
            ],
          ),
        ],
      ),
    );
  }
}

class _CoordinatesBox extends StatelessWidget {
  const _CoordinatesBox({required this.captureResult});

  final VisitCheckInCaptureEntity captureResult;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    final yourLatLng =
        '${captureResult.yourLat.toStringAsFixed(6)}, ${captureResult.yourLng.toStringAsFixed(6)}';
    final facilityLatLng =
        '${captureResult.facilityLat.toStringAsFixed(6)}, ${captureResult.facilityLng.toStringAsFixed(6)}';

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: context.color.scaffoldBackground,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _CoordRow(label: context.locale.yourPosition, value: yourLatLng),
          Gap(spacing.s8),
          _CoordRow(label: context.locale.facilityName, value: facilityLatLng),
          Gap(spacing.s8),
          Divider(color: context.color.borderSubtle, height: 1),
          Gap(spacing.s8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.locale.distance.toUpperCase(),
                style: context.textStyle.bodySmall.copyWith(
                  color: context.color.success,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.6,
                ),
              ),
              Text(
                '${captureResult.distanceMeters}m away',
                style: context.textStyle.labelLarge.copyWith(
                  color: context.color.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CoordRow extends StatelessWidget {
  const _CoordRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BodyRegularText(label, color: context.color.text.secondary),
        BodySmallText(value, color: context.color.text.secondary),
      ],
    );
  }
}
