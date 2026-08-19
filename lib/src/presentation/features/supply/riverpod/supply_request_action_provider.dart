import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/supply/supply_request_payloads.dart';

part 'supply_request_action_provider.g.dart';

@riverpod
class SupplyRequestAction extends _$SupplyRequestAction {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> approve(int supplyRequestId, {String? notes}) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    final result = await ref
        .read(approveSupplyRequestUseCaseProvider)
        .call(
          ApproveSupplyRequestEntity(
            supplyRequestId: supplyRequestId,
            notes: notes,
          ),
        );

    state = result.when(
      success: (_) => const AsyncValue.data(null),
      error: (error) => AsyncValue.error(error.message, StackTrace.current),
    );
  }

  Future<void> reject(int supplyRequestId, {String? notes}) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    final result = await ref
        .read(rejectSupplyRequestUseCaseProvider)
        .call(
          RejectSupplyRequestEntity(
            supplyRequestId: supplyRequestId,
            notes: notes,
          ),
        );

    state = result.when(
      success: (_) => const AsyncValue.data(null),
      error: (error) => AsyncValue.error(error.message, StackTrace.current),
    );
  }

  Future<void> dispatch(int supplyRequestId) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    final result = await ref
        .read(dispatchSupplyRequestUseCaseProvider)
        .call(supplyRequestId);

    state = result.when(
      success: (_) => const AsyncValue.data(null),
      error: (error) => AsyncValue.error(error.message, StackTrace.current),
    );
  }
}
