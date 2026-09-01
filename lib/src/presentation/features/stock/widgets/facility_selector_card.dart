import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/accessible_facility_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';

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

void showFacilitySelectorSheet({
  required BuildContext context,
  required List<AccessibleFacilityEntity> facilities,
  required int? selectedFacilityId,
  required ValueChanged<int> onSelected,
}) {
  showModalBottomSheet<void>(
    context: context,
    builder: (bottomSheetContext) {
      final color = context.color;
      final spacing = context.dimensions.spacing;

      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(spacing.s16),
              child: Headline2xlTinyText(context.locale.selectFacility),
            ),
            const Divider(height: 1),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: facilities.length,
                itemBuilder: (context, index) {
                  final facility = facilities[index];
                  final isSelected = facility.id == selectedFacilityId;

                  return ListTile(
                    title: Text(facility.name),
                    trailing: isSelected
                        ? Icon(Icons.check_circle_rounded, color: color.primary)
                        : null,
                    onTap: () {
                      onSelected(facility.id);
                      context.pop();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

