import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/supply/delivery_entity.dart';
import '../../../core/extensions/ref_extensions.dart';

part 'supply_request_dispatch_provider.g.dart';

@riverpod
class SupplyRequestDispatch extends _$SupplyRequestDispatch {
  @override
  AsyncValue<DeliveryEntity?> build() => const AsyncValue.data(null);

  Future<void> dispatch(int supplyRequestId) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    final result = await ref
        .read(dispatchSupplyRequestUseCaseProvider)
        .call(supplyRequestId);

    state = result.toAsyncValue();
  }
}
