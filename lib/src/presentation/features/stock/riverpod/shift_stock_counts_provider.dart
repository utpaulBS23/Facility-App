import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/stock/shift_stock_count_entity.dart';

part 'shift_stock_counts_provider.g.dart';

@riverpod
FutureOr<List<ShiftStockCountEntity>> shiftStockCounts(
  Ref ref, {
  int? facilityId,
  int? shiftAssignmentId,
}) async {
  final useCase = ref.read(getShiftStockCountsUseCaseProvider);
  final result = await useCase(
    facilityId: facilityId,
    shiftAssignmentId: shiftAssignmentId,
  );

  return switch (result) {
    Success(:final data) => data ?? const [],
    Error(:final error) => throw error,
    _ => const [],
  };
}
