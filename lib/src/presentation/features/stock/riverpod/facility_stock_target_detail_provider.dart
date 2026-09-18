import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/stock/facility_stock_target_detail_entity.dart';
import '../../../../domain/entities/stock/facility_stock_target_entity.dart';
import '../../../../domain/entities/stock/stock_averaging_filter.dart';

part 'facility_stock_target_detail_provider.g.dart';

@riverpod
class FacilityStockTargetDetailNotifier
    extends _$FacilityStockTargetDetailNotifier {
  @override
  FutureOr<FacilityStockTargetDetailEntity> build(int facilityId) async {
    return _fetchTargets();
  }

  // WHY: no dedicated per-facility endpoint exists — reuse the same flat
  // list call the overview page makes, filtered to this one facility.
  Future<FacilityStockTargetDetailEntity> _fetchTargets() async {
    final useCase = ref.read(getStockAveragingUseCaseProvider);
    final result = await useCase(
      StockAveragingFilter(facilityId: facilityId, perPage: 100),
    );

    return switch (result) {
      Success(:final data) when data != null => _toDetail(data.targets),
      Error(:final error) => throw error,
      _ => throw Failure.emptyResponse('facility stock targets'),
    };
  }

  FacilityStockTargetDetailEntity _toDetail(
    List<FacilityStockTargetEntity> targets,
  ) {
    return FacilityStockTargetDetailEntity(
      facilityId: facilityId,
      facilityName: targets.isNotEmpty ? targets.first.facilityName : '',
      monthlyTotalDemandQty: targets.fold(
        0.0,
        (sum, target) => sum + target.monthlyTargetQty,
      ),
      targets: targets,
    );
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
}
