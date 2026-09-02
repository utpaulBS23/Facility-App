import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'selection_picker_sheet.dart';

/// Reusable top app bar filter button that triggers [SelectionPickerSheet] bottom modal.
class AppBarFilterButton<T> extends StatelessWidget {
  const AppBarFilterButton({
    super.key,
    required this.title,
    required this.currentValue,
    required this.options,
    required this.onSelected,
    this.icon = Icons.filter_list_rounded,
  });

  final String title;
  final T currentValue;
  final List<({T value, String label})> options;
  final ValueChanged<T> onSelected;
  final IconData icon;

  Future<void> _openPicker(BuildContext context) async {
    final result = await showModalBottomSheet<({T value})>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SelectionPickerSheet<T>(
        title: title,
        options: options,
        isSelected: (val) => val == currentValue,
      ),
    );

    if (result != null && result.value != currentValue) {
      onSelected(result.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _openPicker(context),
      icon: Icon(
        icon,
        color: context.color.primary,
      ),
    );
  }
}
