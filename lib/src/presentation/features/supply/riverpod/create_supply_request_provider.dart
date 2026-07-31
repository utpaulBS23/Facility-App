import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/supply/supply_request_entity.dart';
import '../../../../domain/entities/supply/supply_request_status.dart';
import '../../../../domain/repositories/supply_repository.dart';
import '../../../core/extensions/ref_extensions.dart';

part 'create_supply_request_provider.g.dart';

@riverpod
class CreateSupplyRequest extends _$CreateSupplyRequest {
  @override
  AsyncValue<SupplyRequestEntity?> build() => const AsyncValue.data(null);

  Future<void> create({
    required int facilityId,
    SupplyUrgency? urgency,
    String? notes,
    required List<CreateSupplyRequestItemParams> items,
  }) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    final result = await ref.read(createSupplyRequestUseCaseProvider).call(
          facilityId: facilityId,
          urgency: urgency,
          notes: notes,
          items: items,
        );

    state = result.toAsyncValue();
  }
}
