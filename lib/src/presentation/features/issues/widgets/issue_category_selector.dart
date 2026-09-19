import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/problem_category_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';

class IssueCategorySelector extends StatelessWidget {
  const IssueCategorySelector({
    super.key,
    required this.selected,
    required this.hasError,
    required this.onTap,
  });

  final ProblemCategoryEntity? selected;
  final bool hasError;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = context.dimensions.radius;
    final spacing = context.dimensions.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              border: Border.all(
                color: hasError
                    ? context.color.error
                    : context.color.borderSubtle,
              ),
              borderRadius: BorderRadius.circular(radius.r6),
            ),
            padding: EdgeInsets.symmetric(horizontal: spacing.s16),
            child: Row(
              children: [
                Expanded(
                  child: BodyRegularText(
                    selected?.name ?? context.locale.specificProblemHint,
                    color: selected != null
                        ? context.color.text.primary
                        : context.color.text.secondary,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: context.color.text.secondary,
                ),
              ],
            ),
          ),
        ),
        if (hasError) ...[
          Gap(spacing.s4),
          Padding(
            padding: EdgeInsets.only(left: spacing.s4),
            child: BodySmallText(
              context.locale.fieldRequired,
              color: context.color.error,
            ),
          ),
        ],
      ],
    );
  }
}
