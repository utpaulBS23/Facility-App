import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Dropdown form field whose popup menu keeps horizontal breathing room.
class AppDropdownButtonFormField<T> extends StatelessWidget {
  /// Creates an [AppDropdownButtonFormField].
  const AppDropdownButtonFormField({
    super.key,
    this.initialValue,
    this.hint,
    this.decoration,
    this.items,
    this.onChanged,
    this.validator,
    this.dropdownColor,
    this.menuMaxHeight,
    this.icon,
    this.borderRadius,
    this.style,
  });

  final T? initialValue;
  final Widget? hint;
  final InputDecoration? decoration;
  final List<DropdownMenuItem<T>>? items;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;
  final Color? dropdownColor;
  final double? menuMaxHeight;
  final Widget? icon;
  final BorderRadius? borderRadius;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final horizontalInset = context.dimensions.spacing.s16;

    return LayoutBuilder(
      builder: (context, constraints) {
        final menuWidth = constraints.maxWidth.isFinite
            ? (constraints.maxWidth - horizontalInset * 2).clamp(
                0.0,
                constraints.maxWidth,
              )
            : null;

        return FormField<T>(
          // WHY: FormField only reads `initialValue` on first build — it does
          // not resync on rebuild, so a caller-driven selection change (e.g.
          // programmatically picking the active facility) was silently
          // ignored after the first frame. Keying on the value forces a fresh
          // FormField whenever it changes from outside.
          key: ValueKey(initialValue),
          initialValue: initialValue,
          validator: validator,
          builder: (field) {
            final effectiveDecoration = (decoration ?? const InputDecoration())
                .copyWith(errorText: field.errorText);

            return InputDecorator(
              decoration: effectiveDecoration,
              isEmpty: field.value == null,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<T>(
                  value: field.value,
                  hint: hint,
                  items: items,
                  onChanged: (value) {
                    field.didChange(value);
                    onChanged?.call(value);
                  },
                  dropdownColor: dropdownColor,
                  menuMaxHeight: menuMaxHeight,
                  menuWidth: menuWidth,
                  isDense: true,
                  isExpanded: true,
                  icon: icon,
                  borderRadius: borderRadius,
                  style: style,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
