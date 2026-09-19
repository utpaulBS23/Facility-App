import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/travel_expense_entity.dart';

part 'travel_expense_detail_provider.g.dart';

@riverpod
Future<TravelExpenseEntity> travelExpenseDetail(
  Ref ref,
  int travelExpenseId,
) async {
  final result = await ref
      .read(getTravelExpenseDetailUseCaseProvider)
      .call(travelExpenseId);

  return switch (result) {
    Success(:final data) when data != null => data,
    Error(:final error) => throw error,
    _ => throw Failure.emptyResponse('get travel expense detail'),
  };
}
