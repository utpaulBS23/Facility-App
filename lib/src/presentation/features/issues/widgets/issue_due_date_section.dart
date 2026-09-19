import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/theme.dart';
import 'issue_section_label.dart';

class IssueDueDateSection extends StatelessWidget {
  const IssueDueDateSection({
    super.key,
    required this.dueDate,
    required this.onTap,
    required this.onClear,
  });

  final DateTime? dueDate;
  final VoidCallback onTap;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;
    final textStyle = context.textStyle;

    final formatted = dueDate != null
        ? DateFormat('EEEE, MMM d, yyyy').format(dueDate!)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const IssueSectionLabel('Due Date'),
        Gap(spacing.s8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radius.r12),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.s16,
              vertical: spacing.s14,
            ),
            decoration: BoxDecoration(
              color: color.onPrimary,
              border: Border.all(color: color.borderSubtle),
              borderRadius: BorderRadius.circular(radius.r12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_month_outlined,
                  size: 20,
                  color: color.primary,
                ),
                Gap(spacing.s12),
                Expanded(
                  child: Text(
                    formatted ?? 'Select due date',
                    style: textStyle.bodyMedium.copyWith(
                      color: formatted != null
                          ? color.text.primary
                          : color.text.muted,
                    ),
                  ),
                ),
                if (dueDate != null)
                  IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: color.text.secondary,
                    ),
                    onPressed: onClear,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  )
                else
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: color.text.secondary,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
