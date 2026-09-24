// ignore_for_file: max_file_lines
// Author: Md. Shahin Bashar
// Created: 2026-04-03

part of '../view/shift_check_in_page.dart';

/// Card displaying auto-detected location, check-in time, and supervisor name.
///
/// Matches the Figma "Contract details" component (node 13045:27124).
/// White card with drop-shadow, containing three info rows:
///   1. Location (with pin icon)
///   2. Check-In Time (with clock icon)
///   3. Supervisor Name (with person icon)
class _AutoDetectedInfoCard extends ConsumerWidget {
  const _AutoDetectedInfoCard({this.supervisorName});

  /// The active slot's supervisor, when the caller has one (see
  /// [ShiftCheckInPage.supervisorName]). Takes priority over the logged-in
  /// user's own supervisor field from [checkInInfoProvider].
  final String? supervisorName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dimensions = context.dimensions;
    final checkInInfoState = ref.watch(checkInInfoProvider);
    final info = checkInInfoState.valueOrNull;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (info?.locationFailure != null) ...[
          _LocationDisabledBanner(failure: info!.locationFailure!),
          Gap(dimensions.spacing.s12),
        ],
        _AutoDetectedInfoBody(info: info, supervisorName: supervisorName),
      ],
    );
  }
}

class _AutoDetectedInfoBody extends StatelessWidget {
  const _AutoDetectedInfoBody({required this.info, this.supervisorName});

  final CheckInInfoEntity? info;
  final String? supervisorName;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dimensions = context.dimensions;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(dimensions.padding.p16),
      decoration: BoxDecoration(
        color: colors.onPrimary,
        borderRadius: BorderRadius.circular(dimensions.radius.r12),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 14,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BodyRegularText.secondary(context.locale.autoDetectedInfo),
          Gap(dimensions.spacing.s8),
          _ContactInfoItem(
            icon: Icons.location_on_outlined,
            label: context.locale.location,
            value: info?.location ??
                (info != null
                    ? context.locale.locationUnavailable
                    : context.locale.loading),
          ),
          Gap(dimensions.spacing.s8),
          _ContactInfoItem(
            icon: Icons.access_time_outlined,
            label: context.locale.checkInTime,
            value: info?.checkInTime ?? context.locale.loading,
          ),
          Gap(dimensions.spacing.s8),
          _ContactInfoItem(
            icon: Icons.person_outline,
            label: context.locale.supervisorName,
            value: supervisorName?.isNotEmpty == true
                ? supervisorName!
                : info?.supervisorName ?? context.locale.loading,
          ),
        ],
      ),
    );
  }
}

/// Banner shown when location couldn't be obtained — explains why and offers
/// Settings (to fix permission/service) and Retry (to re-run detection).
class _LocationDisabledBanner extends ConsumerWidget {
  const _LocationDisabledBanner({required this.failure});

  final Failure failure;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.color;
    final dimensions = context.dimensions;
    final isServiceDisabled = failure.code == 'location_service_disabled';
    final message = isServiceDisabled
        ? context.locale.locationServiceDisabled
        : context.locale.locationPermissionDenied;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(dimensions.padding.p16),
      decoration: BoxDecoration(
        color: colors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(dimensions.radius.r12),
        border: Border.all(color: colors.error.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: context.textStyle.bodyRegular.copyWith(color: colors.error),
          ),
          Gap(dimensions.spacing.s8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => isServiceDisabled
                      ? Geolocator.openLocationSettings()
                      : Geolocator.openAppSettings(),
                  child: Text(context.locale.settings),
                ),
              ),
              Gap(dimensions.spacing.s8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () =>
                      ref.read(checkInInfoProvider.notifier).refresh(),
                  child: Text(context.locale.retry),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A single row inside [_AutoDetectedInfoCard].
///
/// Layout: icon-container | label + value column
/// Matches the Figma "Contact item" pattern (nodes 13045:27233, 13045:27159).
class _ContactInfoItem extends StatelessWidget {
  const _ContactInfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dimensions = context.dimensions;

    return Row(
      children: [
        Container(
          width: dimensions.spacing.s36,
          height: dimensions.spacing.s36,
          decoration: BoxDecoration(
            color: colors.scaffoldBackground,
            borderRadius: BorderRadius.circular(dimensions.radius.r10),
          ),
          child: Icon(
            icon,
            size: dimensions.spacing.s16,
            color: colors.text.secondary,
          ),
        ),
        Gap(dimensions.spacing.s16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabelRegularText(label, color: colors.text.secondary),
              Gap(dimensions.spacing.s4),
              TitleSmallText(value, color: colors.text.primary),
            ],
          ),
        ),
      ],
    );
  }
}
