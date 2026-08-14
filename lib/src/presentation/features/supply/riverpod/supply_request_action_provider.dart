import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/supply/supply_request_entity.dart';
import '../../../core/extensions/ref_extensions.dart';

part 'supply_request_action_provider.g.dart';

@riverpod
class SupplyRequestAction extends _$SupplyRequestAction {
  @override
  AsyncValue<SupplyRequestEntity?> build() => const AsyncValue.data(null);

  Future<void> approve(int supplyRequestId, {String? notes}) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    final result = await ref
        .read(approveSupplyRequestUseCaseProvider)
        .call(supplyRequestId, notes: notes);

    state = result.toAsyncValue();
  }

  Future<void> reject(int supplyRequestId, {String? notes}) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    final result = await ref
        .read(rejectSupplyRequestUseCaseProvider)
        .call(supplyRequestId, notes: notes);

    state = result.toAsyncValue();
  }
}
