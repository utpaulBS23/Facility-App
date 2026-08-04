import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/stock/shift_stock_count_entity.dart';
import 'submit_shift_stock_count_provider.dart';

final shiftStockCountsProvider =
    FutureProvider.family<List<ShiftStockCountEntity>, int?>((
      ref,
      facilityId,
    ) async {
      ref.listen(submitShiftStockCountProvider, (previous, next) {
        if (next is AsyncData && next.value != null) {
          ref.invalidateSelf();
        }
      });

      final result = await ref
          .read(getShiftStockCountsUseCaseProvider)
          .call(facilityId: facilityId);

      return result.when(
        success: (data) => data ?? const [],
        error: (error) => throw Exception(error.message),
      );
    });
