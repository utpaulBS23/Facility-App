import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/form_selector_card.dart';

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
                child: FormSelectorCard.text(
                  title: context.locale.facility,
                  icon: Icons.apartment_outlined,
                  value: facilityLabel,
                  placeholder: facilityLabel,
                  onTap: onFacilityTap,
                ),
              ),
              SizedBox(width: spacing.s8),
              Expanded(
                child: FormSelectorCard.text(
                  title: context.locale.attendant,
                  icon: Icons.person_outline_rounded,
                  value: attendantLabel,
                  placeholder: attendantLabel,
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
