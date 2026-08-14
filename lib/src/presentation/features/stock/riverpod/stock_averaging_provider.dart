import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/stock/stock_averaging_filter.dart';
import '../../../../domain/entities/stock/stock_averaging_page_entity.dart';

part 'stock_averaging_provider.g.dart';

@riverpod
FutureOr<StockAveragingPageEntity> stockAveraging(
  Ref ref, {
  int? facilityId,
}) async {
  final useCase = ref.read(getStockAveragingUseCaseProvider);
  final filter = StockAveragingFilter(
    facilityId: facilityId,
  );

  final result = await useCase(filter);

  return switch (result) {
    Success(:final data) => data ?? const StockAveragingPageEntity(items: [], topDemandItems: []),
    Error(:final error) => throw error,
    _ => const StockAveragingPageEntity(items: [], topDemandItems: []),
  };
}
