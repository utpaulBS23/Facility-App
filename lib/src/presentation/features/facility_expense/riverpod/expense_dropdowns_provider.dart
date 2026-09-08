import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/master_data_entity.dart';

part 'expense_dropdowns_provider.g.dart';

@riverpod
Future<List<MasterDataItemEntity>> expenseCategoryOptions(Ref ref) async {
  final result = await ref
      .read(getMasterDataItemsUseCaseProvider)
      .call(category: 'expenseCategory');

  return switch (result) {
    Success(:final data) => data ?? const [],
    Error(:final error) => throw Exception(error.message),
    _ => throw Exception('Failed to load master data'),
  };
}

@riverpod
Future<List<MasterDataItemEntity>> paymentMethodOptions(Ref ref) async {
  final result = await ref
      .read(getMasterDataItemsUseCaseProvider)
      .call(category: 'paymentMethod');

  return switch (result) {
    Success(:final data) => data ?? const [],
    Error(:final error) => throw Exception(error.message),
    _ => throw Exception('Failed to load master data'),
  };
}
