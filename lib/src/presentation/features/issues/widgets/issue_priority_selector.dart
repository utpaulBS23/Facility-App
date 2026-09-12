import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/report_issue_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';

class IssuePrioritySelector extends StatelessWidget {
  const IssuePrioritySelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final IssuePriority selected;
  final ValueChanged<IssuePriority> onChanged;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Row(
      children: IssuePriority.values.map((p) {
        final isLast = p == IssuePriority.values.last;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : spacing.s8),
            child: _PriorityChip(
              label: _label(context, p),
              isSelected: p == selected,
              onTap: () => onChanged(p),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _label(BuildContext context, IssuePriority p) => switch (p) {
    IssuePriority.high => context.locale.priorityHigh,
    IssuePriority.medium => context.locale.priorityMedium,
    IssuePriority.normal => context.locale.priorityNormal,
    IssuePriority.low => context.locale.priorityLow,
  };
}

class _PriorityChip extends StatelessWidget {
  const _PriorityChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = context.dimensions.radius;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 40,
        decoration: BoxDecoration(
          color: isSelected
              ? context.color.primary.withValues(alpha: 0.08)
              : context.color.onPrimary,
          borderRadius: BorderRadius.circular(radius.r6),
          border: Border.all(
            color: isSelected
                ? context.color.primary
                : context.color.borderSubtle,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        alignment: Alignment.center,
        child: BodySmallText(
          label,
          color: isSelected
              ? context.color.primary
              : context.color.text.secondary,
        ),
      ),
    );
  }
}
