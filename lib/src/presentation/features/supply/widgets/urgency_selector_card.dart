import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/supply/supply_request_status.dart';
import '../../../core/theme/theme.dart';
import '../extensions/supply_status_extension.dart';

class UrgencySelectorCard extends StatelessWidget {
  const UrgencySelectorCard({
    super.key,
    required this.selectedUrgency,
    required this.onChanged,
  });

  final SupplyUrgency selectedUrgency;
  final ValueChanged<SupplyUrgency> onChanged;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        border: Border.all(color: color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.locale.urgency,
            style: context.textStyle.bodySmall.copyWith(
              color: color.text.secondary,
            ),
          ),
          Gap(spacing.s8),
          Container(
            padding: EdgeInsets.all(spacing.s4),
            decoration: BoxDecoration(
              color: color.scaffoldBackground,
              borderRadius: BorderRadius.circular(radius.r16),
            ),
            child: Row(
              children: [
                for (final urgency in SupplyUrgency.values) ...[
                  if (urgency != SupplyUrgency.values.first) Gap(spacing.s4),
                  Expanded(
                    child: _UrgencySegmentButton(
                      label: urgency.localizedName(context),
                      isSelected: selectedUrgency == urgency,
                      onTap: () => onChanged(urgency),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UrgencySegmentButton extends StatelessWidget {
  const _UrgencySegmentButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: spacing.s40,
        decoration: BoxDecoration(
          color: isSelected ? color.onPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(radius.r12),
          border: isSelected ? Border.all(color: color.borderSubtle) : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: context.textStyle.labelLarge.copyWith(
            color: isSelected ? color.text.primary : color.text.secondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
