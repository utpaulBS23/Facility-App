import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/common/paginated_list_entity.dart';
import '../../../../domain/entities/supply/stock_item_entity.dart';
import '../../../../domain/entities/supply/supply_filters.dart';

part 'item_catalog_provider.g.dart';

@riverpod
Future<PaginatedListEntity<StockItemEntity>> itemCatalog(
  Ref ref,
  bool? isActive,
) async {
  final result = await ref
      .read(getItemCatalogUseCaseProvider)
      .call(ItemCatalogFilter(isActive: isActive));

  return result.when(
    success: (data) => data ?? const PaginatedListEntity.empty(),
    error: (error) => throw Exception(error.message),
  );
}
