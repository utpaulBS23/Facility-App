import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/accessible_facility_entity.dart';
import '../../../core/theme/theme.dart';

class FacilityDropdownCard extends StatelessWidget {
  const FacilityDropdownCard({
    super.key,
    required this.selectedFacilityId,
    required this.facilities,
    required this.onChanged,
  });

  final int? selectedFacilityId;
  final List<AccessibleFacilityEntity> facilities;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.s16,
        vertical: spacing.s12,
      ),
      decoration: BoxDecoration(
        color: color.onPrimary,
        border: Border.all(color: color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.location_on_outlined,
            color: color.text.secondary,
            size: spacing.s20,
          ),
          Gap(spacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.locale.facility,
                  style: context.textStyle.bodySmall.copyWith(
                    color: color.text.secondary,
                  ),
                ),
                Gap(spacing.s2),
                DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: selectedFacilityId,
                    isDense: true,
                    isExpanded: true,
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: color.text.secondary,
                    ),
                    style: context.textStyle.labelLarge.copyWith(
                      color: color.text.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    items: facilities.map((facility) {
                      return DropdownMenuItem<int>(
                        value: facility.id,
                        child: Text(
                          facility.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) onChanged(val);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
