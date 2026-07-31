import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/supply/delivery_entity.dart';
import '../../../core/extensions/ref_extensions.dart';
import 'confirm_delivery_provider.dart';

part 'supply_request_delivery_provider.g.dart';

@riverpod
class SupplyRequestDelivery extends _$SupplyRequestDelivery {
  @override
  Future<DeliveryEntity?> build(String requestCode) async {
    ref.invalidateProviderOnSuccess(confirmDeliveryProvider);

    final result = await ref
        .read(getDeliveryForSupplyRequestUseCaseProvider)
        .call(requestCode: requestCode);

    return result.getOrThrow();
  }
}
