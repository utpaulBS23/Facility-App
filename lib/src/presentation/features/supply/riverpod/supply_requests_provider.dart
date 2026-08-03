import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/common/paginated_list_entity.dart';
import '../../../../domain/entities/supply/supply_request_entity.dart';
import '../../../../domain/entities/supply/supply_request_status.dart';

final supplyRequestsProvider = FutureProvider.family<
    PaginatedListEntity<SupplyRequestEntity>,
    SupplyRequestStatus?>((ref, status) async {
  final result = await ref
      .read(getSupplyRequestsUseCaseProvider)
      .call(status: status);

  return result.when(
    success: (data) => data ?? const PaginatedListEntity.empty(),
    error: (error) => throw Exception(error.message),
  );
});
