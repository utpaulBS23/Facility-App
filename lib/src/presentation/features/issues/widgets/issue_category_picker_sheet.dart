import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/problem_category_entity.dart';
import '../../../core/widgets/picker_sheet_states.dart';
import '../../../core/widgets/selection_picker_sheet.dart';
import '../riverpod/create_issue_provider.dart';

class IssueCategoryPickerSheet extends ConsumerWidget {
  const IssueCategoryPickerSheet({
    super.key,
    required this.partnerId,
    this.selected,
  });

  final int partnerId;
  final ProblemCategoryEntity? selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(problemCategoriesProvider(partnerId));

    return categoriesAsync.when(
      loading: () => const PickerSheetLoading(),
      error: (_, _) => PickerSheetError(
        message: context.locale.reportIssueFailed,
      ),
      data: (categories) {
        if (categories.isEmpty) {
          return PickerSheetError(
            message: context.locale.noProblemCategoriesFound,
          );
        }
        return SelectionPickerSheet<ProblemCategoryEntity>(
          title: context.locale.specificProblem,
          options: [
            for (final category in categories)
              (value: category, label: category.name),
          ],
          isSelected: (value) => value.value == selected?.value,
        );
      },
    );
  }
}
