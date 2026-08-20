import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/supply/delivery_entity.dart';
import '../../../../domain/entities/supply/supply_request_payloads.dart';

part 'confirm_delivery_provider.g.dart';

@riverpod
class ConfirmDelivery extends _$ConfirmDelivery {
  @override
  AsyncValue<DeliveryEntity?> build() => const AsyncValue.data(null);

  Future<void> confirm(ConfirmDeliveryRequestEntity request) async {
    if (state.isLoading) {
      return;
    }

    state = const AsyncValue.loading();

    final result = await ref.read(confirmDeliveryUseCaseProvider).call(request);

    state = result.when(
      success: (data) => AsyncValue.data(data),
      error: (error) => AsyncValue.error(error, StackTrace.current),
    );
  }
}
