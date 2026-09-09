import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/base/base.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../domain/entities/master_data_entity.dart';

part 'income_dropdowns_provider.g.dart';

// WHY master-data-sourced, not the dedicated `/income-types` endpoint: per
// instruction, income-type options come from the generic master-data system
// (key TBD, provided later). 'incomeType' is a placeholder category key
// mirroring expenseCategory/paymentMethod naming — see WHY note on
// CreateAdditionalIncomeRequestEntity.incomeTypeId for the resulting wiring
// risk.
@riverpod
Future<List<MasterDataItemEntity>> incomeTypeOptions(Ref ref) async {
  final result = await ref
      .read(getMasterDataItemsUseCaseProvider)
      .call(category: 'incomeType');

  return switch (result) {
    Success(:final data) => data ?? const [],
    Error(:final error) => throw Exception(error.message),
    _ => throw Exception('Failed to load master data'),
  };
}
