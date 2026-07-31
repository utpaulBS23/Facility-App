import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/supply/delivery_entity.dart';
import '../../../core/extensions/ref_extensions.dart';

part 'confirm_delivery_provider.g.dart';

@riverpod
class ConfirmDelivery extends _$ConfirmDelivery {
  @override
  AsyncValue<DeliveryEntity?> build() => const AsyncValue.data(null);

  Future<void> confirm(int deliveryId) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    final result = await ref
        .read(confirmDeliveryUseCaseProvider)
        .call(deliveryId: deliveryId);

    state = result.toAsyncValue();
  }
}
