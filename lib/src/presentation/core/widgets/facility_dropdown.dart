import 'package:flutter/material.dart';

import '../../../core/extensions/app_localization.dart';
import '../../../domain/entities/accessible_facility_entity.dart';
import '../theme/theme.dart';
import 'app_dropdown_button_form_field.dart';

/// Facility filter dropdown shared by every tab that scopes its data to one
/// of the session's accessible facilities (shift, attendance, visit, task,
/// issue, board). Renders nothing when the user only has one facility, since
/// there's nothing to filter.
class FacilityDropdown extends StatelessWidget {
  const FacilityDropdown({
    super.key,
    required this.facilities,
    required this.selectedFacilityId,
    required this.onChanged,
  });

  final List<AccessibleFacilityEntity> facilities;
  final int? selectedFacilityId;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    if (facilities.length <= 1) return const SizedBox.shrink();

    return AppDropdownButtonFormField<int>(
      initialValue: selectedFacilityId,
      decoration: InputDecoration(
        labelText: context.locale.facilityName,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.dimensions.radius.r6),
        ),
      ),
      items: [
        for (final facility in facilities)
          DropdownMenuItem(value: facility.id, child: Text(facility.name)),
      ],
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}
