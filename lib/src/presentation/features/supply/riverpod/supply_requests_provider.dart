import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/common/paginated_list_entity.dart';
import '../../../../domain/entities/supply/supply_request_entity.dart';
import '../../../../domain/entities/supply/supply_request_status.dart';
import 'confirm_delivery_provider.dart';
import 'supply_request_action_provider.dart';

final supplyRequestsProvider = FutureProvider.family<
    PaginatedListEntity<SupplyRequestEntity>,
    SupplyRequestStatus?>((ref, status) async {
  ref.listen(supplyRequestActionProvider, (previous, next) {
    if (next is AsyncData && next.value != null) {
      ref.invalidateSelf();
    }
  });
  ref.listen(confirmDeliveryProvider, (previous, next) {
    if (next is AsyncData && next.value != null) {
      ref.invalidateSelf();
    }
  });

  final result = await ref
      .read(getSupplyRequestsUseCaseProvider)
      .call(status: status);

  return result.when(
    success: (data) => data ?? const PaginatedListEntity.empty(),
    error: (error) => throw Exception(error.message),
  );
});
