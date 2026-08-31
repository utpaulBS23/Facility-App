import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/stock/facility_stock_balance_entity.dart';
import '../../../../domain/entities/stock/facility_stock_balance_filter.dart';

part 'facility_stock_balance_provider.g.dart';

@riverpod
FutureOr<FacilityStockBalancePageEntity> facilityStockBalance(
  Ref ref, {
  int? facilityId,
  int? stockItemId,
  String? status,
}) async {
  final useCase = ref.read(getFacilityStockBalanceUseCaseProvider);
  final filter = FacilityStockBalanceFilter(
    facilityId: facilityId,
    stockItemId: stockItemId,
    status: status,
  );

  final result = await useCase(filter);

  return switch (result) {
    Success(:final data) => data ?? const FacilityStockBalancePageEntity(items: []),
    Error(:final error) => throw error,
    _ => const FacilityStockBalancePageEntity(items: []),
  };
}
