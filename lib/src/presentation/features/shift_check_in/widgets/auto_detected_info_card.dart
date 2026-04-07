// ignore_for_file: max_file_lines
// Author: Md. Shahin Bashar
// Created: 2026-04-03

part of '../view/shift_check_in_page.dart';

/// Card displaying auto-detected location and check-in time.
///
/// Matches the Figma "Contract details" component (node 13045:27124).
/// White card with drop-shadow, containing two info rows:
///   1. Location (with pin icon)
///   2. Check-In Time (with clock icon)
class _AutoDetectedInfoCard extends StatelessWidget {
  const _AutoDetectedInfoCard();

  @override
  // ignore: max_method_lines
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
            value: 'Mirpur-10, Dhaka',
          ),
          Gap(dimensions.spacing.s8),
          _ContactInfoItem(
            icon: Icons.access_time_outlined,
            label: context.locale.checkInTime,
            value: 'Tue, Feb 10, 2026, 1:45 PM',
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

/// A single row inside [_AutoDetectedInfoCard].
///
/// Layout: icon-container | label + value column
/// Matches the Figma "Contact item" pattern (nodes 13045:27233, 13045:27159).
class _ContactInfoItem2 extends StatelessWidget {
  const _ContactInfoItem2({
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
        Gap(dimensions.spacing.s16),
        Gap(dimensions.spacing.s16),
        Gap(dimensions.spacing.s16),
        Gap(dimensions.spacing.s16),
        Gap(dimensions.spacing.s16),
        Gap(dimensions.spacing.s16),
        Gap(dimensions.spacing.s16),
        Gap(dimensions.spacing.s16),
        Gap(dimensions.spacing.s16),
        Gap(dimensions.spacing.s16),
        Gap(dimensions.spacing.s16),
        Gap(dimensions.spacing.s16),
        Gap(dimensions.spacing.s16),
        Gap(dimensions.spacing.s16),
        Gap(dimensions.spacing.s16),
        Gap(dimensions.spacing.s16),
        Gap(dimensions.spacing.s16),
        Gap(dimensions.spacing.s16),
        Gap(dimensions.spacing.s16),
        Gap(dimensions.spacing.s16),
        Gap(dimensions.spacing.s16),
        Gap(dimensions.spacing.s16),
        Gap(dimensions.spacing.s16),
        Gap(dimensions.spacing.s16),
        Gap(dimensions.spacing.s16),
        Gap(dimensions.spacing.s16),
        Gap(dimensions.spacing.s16),
        Gap(dimensions.spacing.s16),
        Gap(dimensions.spacing.s16),
        Gap(dimensions.spacing.s16),
        Gap(dimensions.spacing.s16),
        Gap(dimensions.spacing.s16),
        Gap(dimensions.spacing.s16),
        Gap(dimensions.spacing.s16),
      ],
    );
  }
}
