import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/stock/shift_stock_count_entity.dart';
import '../../../../domain/entities/stock/submit_stock_count_request.dart';

part 'submit_shift_stock_count_provider.g.dart';

@riverpod
class SubmitShiftStockCount extends _$SubmitShiftStockCount {
  @override
  AsyncValue<List<ShiftStockCountEntity>?> build() => const AsyncValue.data(
    null,
  );

  Future<void> submit({
    required int shiftAssignmentId,
    required SubmitStockCountRequest request,
  }) async {
    if (state.isLoading) {
      return;
    }

    state = const AsyncValue.loading();

    final result = await ref.read(submitShiftStockCountUseCaseProvider).call(
      shiftAssignmentId: shiftAssignmentId,
      request: request,
    );

    state = result.when(
      success: (data) => AsyncValue.data(data),
      error: (error) => AsyncValue.error(error, StackTrace.current),
    );
  }
}
