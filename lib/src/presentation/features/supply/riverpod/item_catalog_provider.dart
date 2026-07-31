import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/common/paginated_list_entity.dart';
import '../../../../domain/entities/supply/stock_item_entity.dart';
import '../../../core/extensions/ref_extensions.dart';

part 'item_catalog_provider.g.dart';

@riverpod
Future<PaginatedListEntity<StockItemEntity>> itemCatalog(
  Ref ref, {
  String? search,
  bool? isActive,
}) async {
  final result = await ref.read(getItemCatalogUseCaseProvider).call(
        search: search,
        isActive: isActive,
      );

  return result.getOrThrow() ?? const PaginatedListEntity.empty();
}
