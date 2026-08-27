import 'package:flutter/material.dart';

import '../../../core/extensions/app_localization.dart';
import '../theme/theme.dart';
import 'app_dropdown_button_form_field.dart';

/// Clearable filter dropdown — unlike [FacilityDropdown]'s always-one-selected
/// contract, this always offers an explicit "All" entry (null) alongside the
/// given options, for filters that are optional rather than a required
/// context switch.
class FilterDropdown extends StatelessWidget {
  const FilterDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final int? value;
  final List<DropdownMenuItem<int?>> items;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppDropdownButtonFormField<int?>(
      initialValue: value,
      hint: Text(context.locale.all),
      decoration: InputDecoration(
        labelText: label,
        // WHY: without this, an unselected (null) value leaves the label
        // resting inline instead of floated — it then overlaps the "All"
        // hint text drawn in the same spot.
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.dimensions.radius.r6),
        ),
      ),
      items: [
        DropdownMenuItem(value: null, child: Text(context.locale.all)),
        ...items,
      ],
      onChanged: (v) => onChanged(v),
    );
  }
}
