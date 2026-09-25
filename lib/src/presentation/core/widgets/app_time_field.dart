import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Tappable time field — opens the platform time picker, shows the picked
/// value formatted. Mirrors [AppTextField.text]'s visual container (56px,
/// bordered, label above value) but is read-only by nature, so it doesn't
/// share that widget's `TextFormField`/validator machinery.
class AppTimeField extends StatelessWidget {
  const AppTimeField({
    super.key,
    required this.label,
    required this.time,
    required this.onChanged,
    this.enabled = true,
  });

  final String label;
  final TimeOfDay time;
  final ValueChanged<TimeOfDay> onChanged;
  final bool enabled;

  Future<void> _pick(BuildContext context) async {
    final picked = await showTimePicker(context: context, initialTime: time);
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dimensions = context.dimensions;
    final textStyle = context.textStyle;

    return InkWell(
      onTap: enabled ? () => _pick(context) : null,
      borderRadius: BorderRadius.circular(dimensions.radius.r12),
      child: Container(
        height: dimensions.spacing.s56,
        padding: EdgeInsets.symmetric(horizontal: dimensions.spacing.s16),
        decoration: BoxDecoration(
          color: enabled ? colors.onPrimary : colors.subtle,
          borderRadius: BorderRadius.circular(dimensions.radius.r12),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: textStyle.bodySmall.copyWith(
                      color: colors.text.secondary,
                    ),
                  ),
                  Text(
                    time.format(context),
                    style: textStyle.labelLarge.copyWith(
                      color: enabled ? colors.text.primary : colors.text.disabled,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.access_time_outlined,
              size: dimensions.spacing.s20,
              color: colors.icon,
            ),
          ],
        ),
      ),
    );
  }
}
