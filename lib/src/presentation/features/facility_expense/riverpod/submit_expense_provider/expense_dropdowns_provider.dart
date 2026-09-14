import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/base/base.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../domain/entities/master_data_entity.dart';
import 'selected_expense_category_provider.dart';

part 'expense_dropdowns_provider.g.dart';

@riverpod
Future<List<MasterDataItemEntity>> expenseCategoryOptions(Ref ref) async {
  final result = await ref
      .read(getMasterDataItemsUseCaseProvider)
      .call(
        category: 'expenseCategory',
        perPage: 100,
        includeInactive: true,
      );

  return switch (result) {
    Success(:final data) => data ?? const [],
    Error(:final error) => throw Exception(error.message),
    _ => throw Exception('Failed to load master data'),
  };
}

@riverpod
Future<List<MasterDataItemEntity>> paidByOptions(Ref ref) async {
  final result = await ref
      .read(getMasterDataItemsUseCaseProvider)
      .call(
        category: 'expenseCategory',
        perPage: 100,
        includeInactive: true,
      );

  return switch (result) {
    Success(:final data) => data ?? const [],
    Error(:final error) => throw Exception(error.message),
    _ => throw Exception('Failed to load master data'),
  };
}
