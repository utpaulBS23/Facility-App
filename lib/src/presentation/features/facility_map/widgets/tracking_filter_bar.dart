import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';

/// Facility and attendant filter chips with a "Clear filters" link.
class TrackingFilterBar extends StatelessWidget {
  const TrackingFilterBar({
    super.key,
    required this.facilityLabel,
    required this.attendantLabel,
    required this.onFacilityTap,
    required this.onAttendantTap,
    required this.onClear,
    required this.hasFilters,
  });

  final String facilityLabel;
  final String attendantLabel;
  final VoidCallback onFacilityTap;
  final VoidCallback onAttendantTap;
  final VoidCallback onClear;
  final bool hasFilters;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Container(
      width: double.infinity,
      color: context.color.onPrimary,
      padding: EdgeInsets.fromLTRB(
        spacing.s16,
        spacing.s8,
        spacing.s16,
        spacing.s12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _FilterChip(
                  icon: Icons.apartment_outlined,
                  label: facilityLabel,
                  onTap: onFacilityTap,
                ),
              ),
              SizedBox(width: spacing.s8),
              Expanded(
                child: _FilterChip(
                  icon: Icons.person_outline_rounded,
                  label: attendantLabel,
                  onTap: onAttendantTap,
                ),
              ),
            ],
          ),
          if (hasFilters) ...[
            SizedBox(height: spacing.s8),
            GestureDetector(
              onTap: onClear,
              child: Text(
                context.locale.clearFilters,
                style: context.textStyle.labelMedium.copyWith(
                  color: context.color.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.dimensions.radius.r10),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.s12,
          vertical: spacing.s10,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: context.color.borderSubtle),
          borderRadius: BorderRadius.circular(context.dimensions.radius.r10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: context.color.text.secondary),
            SizedBox(width: spacing.s8),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textStyle.bodyMedium.copyWith(
                  color: context.color.text.primary,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 20,
              color: context.color.text.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
