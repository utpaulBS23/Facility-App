import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/common/paginated_list_entity.dart';
import '../../../../domain/entities/supply/stock_item_entity.dart';

final itemCatalogProvider = FutureProvider.family<
    PaginatedListEntity<StockItemEntity>,
    bool?>((ref, isActive) async {
  final result = await ref.read(getItemCatalogUseCaseProvider).call(
        isActive: isActive,
      );

  return result.when(
    success: (data) => data ?? const PaginatedListEntity.empty(),
    error: (error) => throw Exception(error.message),
  );
});
