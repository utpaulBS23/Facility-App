import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/supply/supply_request_entity.dart';
import 'confirm_delivery_provider.dart';
import 'supply_request_action_provider.dart';
import 'supply_request_dispatch_provider.dart';

final supplyRequestDetailsProvider = FutureProvider.family<
    SupplyRequestEntity,
    int>((ref, supplyRequestId) async {
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
  ref.listen(supplyRequestDispatchProvider, (previous, next) {
    if (next is AsyncData && next.value != null) {
      ref.invalidateSelf();
    }
  });

  final result = await ref
      .read(getSupplyRequestDetailsUseCaseProvider)
      .call(supplyRequestId);

  return result.when(
    success: (data) => data!,
    error: (error) => throw Exception(error.message),
  );
});
