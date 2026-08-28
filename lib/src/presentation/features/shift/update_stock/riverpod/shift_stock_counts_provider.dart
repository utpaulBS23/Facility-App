import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/base/base.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../domain/entities/stock/shift_stock_count_entity.dart';
import 'submit_shift_stock_count_provider.dart';

part 'shift_stock_counts_provider.g.dart';

@riverpod
class ShiftStockCounts extends _$ShiftStockCounts {
  @override
  Future<List<ShiftStockCountEntity>> build() async {
    ref.listen(submitShiftStockCountProvider, (previous, next) {
      if (next is AsyncData && next.value != null) {
        ref.invalidateSelf();
      }
    });

    final useCase = ref.read(getShiftStockCountsUseCaseProvider);
    final result = await useCase();

    return result.when(
      success: (data) => data ?? const [],
      error: (error) => throw Exception(error.message),
    );
  }
}
