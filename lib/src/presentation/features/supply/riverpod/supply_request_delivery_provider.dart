import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/supply/delivery_entity.dart';
import 'confirm_delivery_provider.dart';

final supplyRequestDeliveryProvider = FutureProvider.family<
    DeliveryEntity?,
    String>((ref, requestCode) async {
  ref.listen(confirmDeliveryProvider, (previous, next) {
    if (next is AsyncData && next.value != null) {
      ref.invalidateSelf();
    }
  });

  final result = await ref
      .read(getDeliveryForSupplyRequestUseCaseProvider)
      .call(requestCode: requestCode);

  return result.when(
    success: (data) => data,
    error: (error) => throw Exception(error.message),
  );
});
