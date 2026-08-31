import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/base/base.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../domain/entities/stock/shift_stock_count_entity.dart';
import '../widgets/update_stock_form_entry.dart';

part 'submit_shift_stock_count_provider.g.dart';

@riverpod
class SubmitShiftStockCount extends _$SubmitShiftStockCount {
  @override
  AsyncValue<List<ShiftStockCountEntity>?> build() {
    return const AsyncData(null);
  }

  Future<void> submit({
    required int shiftAssignmentId,
    required List<ShiftStockCountItemFormEntry> items,
  }) async {
    if (state.isLoading) return;

    state = const AsyncLoading();

    final params = items.map((entry) {
      final qty = double.tryParse(entry.qtyController.text) ?? 0.0;
      return SubmitStockCountItemEntity(
        stockItemId: entry.stockItemId,
        qtyOnHand: qty,
      );
    }).toList();

    final useCase = ref.read(submitShiftStockCountUseCaseProvider);
    final result = await useCase(
      shiftAssignmentId: shiftAssignmentId,
      items: params,
    );

    state = result.when(
      success: (data) => AsyncValue.data(data),
      error: (error) => AsyncValue.error(error.message, StackTrace.current),
    );
  }
}
