import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/stock/facility_stock_averaging_overview_entity.dart';
import '../../../../domain/entities/stock/facility_stock_target_entity.dart';
import '../../../../domain/entities/stock/stock_averaging_filter.dart';
import '../../../../domain/entities/stock/stock_averaging_overview_entity.dart';
import '../../../../domain/entities/stock/top_demand_item_entity.dart';

part 'stock_averaging_provider.g.dart';

@riverpod
FutureOr<StockAveragingOverviewEntity> stockAveragingOverview(
  Ref ref, {
  int? facilityId,
}) async {
  final useCase = ref.read(getStockAveragingUseCaseProvider);
  final filter = StockAveragingFilter(
    facilityId: facilityId,
    perPage: 100,
  );

  final result = await useCase(filter);

  return switch (result) {
    Success(:final data) =>
      _toOverview(data?.targets ?? const [], data?.topDemandItems ?? const []),
    Error(:final error) => throw error,
    _ => const StockAveragingOverviewEntity(facilities: [], topDemandItems: []),
  };
}

/// Groups the flat target list by `facility_id` — the API has no
/// per-facility summary object, so this is derived client-side.
StockAveragingOverviewEntity _toOverview(
  List<FacilityStockTargetEntity> targets,
  List<TopDemandItemEntity> topDemandItems,
) {
  final byFacility = <int, List<FacilityStockTargetEntity>>{};
  for (final target in targets) {
    (byFacility[target.facilityId] ??= []).add(target);
  }

  final facilities = byFacility.entries.map((entry) {
    final rows = entry.value;
    return FacilityStockAveragingOverviewEntity(
      facilityId: entry.key,
      facilityName: rows.first.facilityName,
      itemCount: rows.length,
      monthlyTotalDemandQty: rows.fold(
        0.0,
        (sum, row) => sum + row.monthlyTargetQty,
      ),
    );
  }).toList();

  return StockAveragingOverviewEntity(
    facilities: facilities,
    topDemandItems: topDemandItems,
  );
}
