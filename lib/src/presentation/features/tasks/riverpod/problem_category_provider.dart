import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/master_data_entity.dart';

part 'problem_category_provider.g.dart';

@riverpod
Future<String> problemCategoryLabel(
  ProblemCategoryLabelRef ref, {
  required String categoryValue,
}) async {
  if (categoryValue.isEmpty) return '';

  final result = await ref
      .read(getMasterDataItemsUseCaseProvider)
      .call(category: 'issueProblemCategory');

  return switch (result) {
    Success(:final data) when data != null => data
        .firstWhere(
          (item) => item.value == categoryValue,
          orElse: () => throw 'Not found',
        )
        .label,
    _ => categoryValue,
  };
}
