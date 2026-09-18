import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../theme/theme.dart';
import 'text/typography.dart';

/// Generic single-select list-tile picker bottom sheet — tap a row to pick
/// it and close immediately, no separate Apply step.
///
/// WHY: mirrors [FacilityPickerSheet]'s list-tile look (rounded bordered
/// row, checkmark trailing) for every non-facility single-select filter —
/// attendant, problem category — so every filter sheet in the app shares
/// one interaction shape instead of a chip-and-Apply variant per feature.
///
/// Pops a `({T value})` record, never a bare nullable value — a bare null
/// can't distinguish "picked null" from "dismissed with no selection."
class SelectionPickerSheet<T> extends StatelessWidget {
  const SelectionPickerSheet({
    super.key,
    required this.title,
    required this.options,
    required this.isSelected,
  });

  final String title;
  final List<({T value, String label})> options;
  final bool Function(T value) isSelected;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.75,
      ),
      decoration: BoxDecoration(
        color: context.color.scaffoldBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(radius.r12)),
      ),
      // WHY Material: ListTile paints its background/ink splashes on the
      // nearest Material ancestor — without this the outer Container's own
      // BoxDecoration color hides them.
      child: Material(
        type: MaterialType.transparency,
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gap(spacing.s12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.color.borderSubtle,
                  borderRadius: BorderRadius.circular(radius.r4),
                ),
              ),
              Gap(spacing.s16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: spacing.s16),
                child: LabelLargeText(title),
              ),
              Gap(spacing.s8),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.fromLTRB(
                    spacing.s16,
                    0,
                    spacing.s16,
                    spacing.s16,
                  ),
                  itemCount: options.length,
                  separatorBuilder: (_, _) => Gap(spacing.s8),
                  itemBuilder: (context, index) {
                    final option = options[index];
                    final selected = isSelected(option.value);
                    return ListTile(
                      onTap: () =>
                          Navigator.of(context).pop((value: option.value)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(radius.r10),
                        side: BorderSide(
                          color: selected
                              ? context.color.primary
                              : context.color.borderSubtle,
                        ),
                      ),
                      title: Text(option.label),
                      trailing: selected
                          ? Icon(
                              Icons.check_circle_rounded,
                              color: context.color.primary,
                            )
                          : null,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
