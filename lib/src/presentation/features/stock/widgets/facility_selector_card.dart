import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';

class FacilitySelectorCard extends StatelessWidget {
  const FacilitySelectorCard({
    super.key,
    required this.facilityName,
    required this.onTap,
  });

  final String facilityName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(radius.r12),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.s16,
          vertical: spacing.s12,
        ),
        decoration: BoxDecoration(
          color: color.onPrimary,
          borderRadius: BorderRadius.circular(radius.r12),
          border: Border.all(color: color.borderSubtle),
        ),
        child: Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              color: color.primary,
              size: spacing.s20,
            ),
            Gap(spacing.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.locale.selectFacility,
                    style: context.textStyle.bodySmall.copyWith(
                      color: color.text.secondary,
                    ),
                  ),
                  Gap(spacing.s2),
                  Text(
                    facilityName,
                    style: context.textStyle.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color.text.primary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: color.text.secondary,
              size: spacing.s24,
            ),
          ],
        ),
      ),
    );
  }
}
