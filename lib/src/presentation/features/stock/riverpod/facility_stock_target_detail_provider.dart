import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/stock/facility_stock_target_detail_entity.dart';
import '../../../../domain/entities/stock/facility_stock_target_entity.dart';

part 'facility_stock_target_detail_provider.g.dart';

@riverpod
class FacilityStockTargetDetailNotifier
    extends _$FacilityStockTargetDetailNotifier {
  @override
  FutureOr<FacilityStockTargetDetailEntity> build(int facilityId) async {
    return _fetchTargets();
  }

  Future<FacilityStockTargetDetailEntity> _fetchTargets() async {
    final useCase = ref.read(getFacilityStockTargetsUseCaseProvider);
    final result = await useCase(facilityId);

    return switch (result) {
      Success(:final data) when data != null => data,
      Error(:final error) => throw error,
      _ => throw Failure.emptyResponse('facility stock targets'),
    };
  }

  void updateQty(int stockItemId, double newQty) {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final updatedTargets = currentState.targets.map((t) {
      if (t.stockItemId == stockItemId) {
        return FacilityStockTargetEntity(
          id: t.id,
          facilityId: t.facilityId,
          facilityName: t.facilityName,
          stockItemId: t.stockItemId,
          itemCode: t.itemCode,
          itemName: t.itemName,
          unit: t.unit,
          monthlyTargetQty: newQty.clamp(0, 999999),
          updatedBy: t.updatedBy,
          updatedByName: t.updatedByName,
          updatedAt: t.updatedAt,
        );
      }
      return t;
    }).toList();

    final newTotalDemand = updatedTargets.fold<double>(
      0.0,
      (sum, item) => sum + item.monthlyTargetQty,
    );

    state = AsyncData(
      FacilityStockTargetDetailEntity(
        facilityId: currentState.facilityId,
        facilityName: currentState.facilityName,
        monthlyTotalDemandQty: newTotalDemand,
        targets: updatedTargets,
      ),
    );
  }

  Future<bool> saveTargets() async {
    final currentState = state.valueOrNull;
    if (currentState == null) return false;

    state = const AsyncLoading();

    final updateUseCase = ref.read(updateStockTargetUseCaseProvider);

    for (final target in currentState.targets) {
      final result = await updateUseCase(
        targetId: target.id,
        monthlyTargetQty: target.monthlyTargetQty,
      );
      if (result is Error) {
        state = AsyncError((result as Error).error, StackTrace.current);
        return false;
      }
    }

    try {
      final refreshed = await _fetchTargets();
      state = AsyncData(refreshed);
      return true;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return false;
    }
  }
}
