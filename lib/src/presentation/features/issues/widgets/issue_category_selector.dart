import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/problem_category_entity.dart';
import '../../../core/widgets/form_selector_card.dart';

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
    return FormSelectorCard.text(
      title: 'Problem Category',
      icon: Icons.report_problem_outlined,
      value: selected?.localizedName(context.languageCode),
      placeholder: context.locale.specificProblemHint,
      errorText: hasError ? context.locale.fieldRequired : null,
      onTap: onTap,
    );
  }
}
