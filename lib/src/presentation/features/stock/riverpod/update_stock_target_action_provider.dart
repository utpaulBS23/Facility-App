import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/stock/facility_stock_target_entity.dart';
import 'facility_stock_target_detail_provider.dart';
import 'stock_averaging_provider.dart';

part 'update_stock_target_action_provider.g.dart';

@riverpod
class UpdateStockTargetAction extends _$UpdateStockTargetAction {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<bool> saveTargets({
    required int facilityId,
    required List<FacilityStockTargetEntity> targets,
  }) async {
    if (state.isLoading) return false;

    state = const AsyncValue.loading();

    final updateUseCase = ref.read(updateStockTargetUseCaseProvider);

    for (final target in targets) {
      final result = await updateUseCase(
        targetId: target.id,
        monthlyTargetQty: target.monthlyTargetQty,
      );
      if (result is Error) {
        final error = (result as Error).error;
        state = AsyncValue.error(error.message, StackTrace.current);
        return false;
      }
    }

    ref.invalidate(facilityStockTargetDetailNotifierProvider(facilityId));
    ref.invalidate(stockAveragingOverviewProvider);
    state = const AsyncValue.data(null);
    return true;
  }
}
