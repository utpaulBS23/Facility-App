part of '../view/visit_check_in_page.dart';

class _VisitCheckInLocationCard extends StatelessWidget {
  const _VisitCheckInLocationCard({
    required this.detail,
    required this.state,
    required this.onRetry,
  });

  final VisitDetailEntity detail;
  final VisitCheckInState state;
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
        borderRadius: .circular(radius.r12),
      ),
      child: Column(
        crossAxisAlignment: .start,
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
          _LocationContent(detail: detail, state: state, onRetry: onRetry),
        ],
      ),
    );
  }
}

class _LocationContent extends StatelessWidget {
  const _LocationContent({
    required this.detail,
    required this.state,
    required this.onRetry,
  });

  final VisitDetailEntity detail;
  final VisitCheckInState state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (state.isLoadingLocation) {
      return Column(
        children: [
          const CircularProgressIndicator.adaptive(),
          Gap(context.dimensions.spacing.s12),
          BodyRegularText(
            context.locale.gettingLocation,
            color: context.color.text.secondary,
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    if (state.locationError != null) {
      return Column(
        children: [
          Icon(Icons.location_off_outlined, size: 40, color: context.color.error),
          Gap(context.dimensions.spacing.s8),
          BodyRegularText(
            state.locationError == 'permission_denied'
                ? context.locale.locationPermissionDenied
                : context.locale.locationUnavailable,
            color: context.color.text.secondary,
            textAlign: TextAlign.center,
          ),
          Gap(context.dimensions.spacing.s12),
          TextButton(onPressed: onRetry, child: Text(context.locale.retry)),
        ],
      );
    }

    final pos = state.position!;
    final userLatLng =
        '${pos.latitude.toStringAsFixed(6)}, ${pos.longitude.toStringAsFixed(6)}';
    final facilityLatLng =
        '${detail.facilityLatitude.toStringAsFixed(6)}, ${detail.facilityLongitude.toStringAsFixed(6)}';

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: context.color.successAlt,
                shape: .circle,
              ),
              child: Icon(
                Icons.check,
                size: 28,
                color: context.color.success,
              ),
            ),
            Gap(context.dimensions.spacing.s20),
            LabelLargeText(context.locale.locationVerified),
            Gap(context.dimensions.spacing.s6),
            BodyRegularText(
              context.locale.withinRange,
              color: context.color.text.secondary,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        Gap(context.dimensions.spacing.s20),
        _CoordinatesBox(
          userLatLng: userLatLng,
          facilityLatLng: facilityLatLng,
        ),
      ],
    );
  }
}

class _CoordinatesBox extends StatelessWidget {
  const _CoordinatesBox({
    required this.userLatLng,
    required this.facilityLatLng,
  });

  final String userLatLng;
  final String facilityLatLng;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: context.color.scaffoldBackground,
        borderRadius: .circular(10),
      ),
      child: Column(
        children: [
          _CoordRow(
            label: context.locale.yourPosition,
            value: userLatLng,
          ),
          Gap(spacing.s8),
          _CoordRow(
            label: context.locale.facilityName,
            value: facilityLatLng,
          ),
          Gap(spacing.s8),
          Divider(color: context.color.borderSubtle, height: 1),
          Gap(spacing.s8),
          Row(
            mainAxisAlignment: .spaceBetween,
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
                '—',
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
      mainAxisAlignment: .spaceBetween,
      children: [
        BodyRegularText(label, color: context.color.text.secondary),
        BodySmallText(value, color: context.color.text.secondary),
      ],
    );
  }
}
