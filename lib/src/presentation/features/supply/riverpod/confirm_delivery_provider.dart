import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/supply/confirm_delivery_request.dart';
import '../../../../domain/entities/supply/delivery_entity.dart';

part 'confirm_delivery_provider.g.dart';

@riverpod
class ConfirmDelivery extends _$ConfirmDelivery {
  @override
  AsyncValue<DeliveryEntity?> build() => const AsyncValue.data(null);

  Future<void> confirm({
    required int deliveryId,
    required ConfirmDeliveryRequest request,
  }) async {
    if (state.isLoading) {
      return;
    }

    state = const AsyncValue.loading();

    final result = await ref.read(confirmDeliveryUseCaseProvider).call(
          deliveryId: deliveryId,
          request: request,
        );

    state = result.when(
      success: (data) => AsyncValue.data(data),
      error: (error) => AsyncValue.error(error, StackTrace.current),
    );
  }
}
