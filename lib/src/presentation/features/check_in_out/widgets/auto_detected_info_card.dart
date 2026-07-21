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
  const _AutoDetectedInfoCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.color;
    final dimensions = context.dimensions;
    final checkInInfoState = ref.watch(checkInInfoProvider);

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
            value: checkInInfoState.when(
              data: (info) => info?.location ?? context.locale.loading,
              loading: () => context.locale.loading,
              error: (err, stack) =>context.locale.locationUnavailable,
            ),
          ),
          Gap(dimensions.spacing.s8),
          _ContactInfoItem(
            icon: Icons.access_time_outlined,
            label: context.locale.checkInTime,
            value: checkInInfoState.when(
              data: (info) => info?.checkInTime ?? context.locale.loading,
              loading: () => context.locale.loading,
              error: (err, stack) =>context.locale.loading,
            ),
          ),
          Gap(dimensions.spacing.s8),
          _ContactInfoItem(
            icon: Icons.person_outline,
            label: context.locale.supervisorName,
            value: checkInInfoState.when(
              data: (info) => info?.supervisorName ?? context.locale.loading,
              loading: () => context.locale.loading,
              error: (err, stack) =>context.locale.loading,
            ),
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
