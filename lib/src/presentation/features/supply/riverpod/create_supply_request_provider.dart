import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/supply/supply_request_entity.dart';
import '../../../../domain/entities/supply/supply_request_payloads.dart';

part 'create_supply_request_provider.g.dart';

@riverpod
class CreateSupplyRequest extends _$CreateSupplyRequest {
  @override
  AsyncValue<SupplyRequestEntity?> build() => const AsyncValue.data(null);

  Future<void> create(CreateSupplyRequestEntity request) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    final result = await ref.read(createSupplyRequestUseCaseProvider).call(request);

    state = result.when(
      success: (data) => AsyncValue.data(data),
      error: (error) => AsyncValue.error(error.message, StackTrace.current),
    );
  }
}
