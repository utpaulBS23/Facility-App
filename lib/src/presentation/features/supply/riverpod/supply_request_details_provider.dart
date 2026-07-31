import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/supply/supply_request_entity.dart';
import '../../../core/extensions/ref_extensions.dart';
import 'confirm_delivery_provider.dart';
import 'supply_request_action_provider.dart';

part 'supply_request_details_provider.g.dart';

@riverpod
class SupplyRequestDetails extends _$SupplyRequestDetails {
  @override
  Future<SupplyRequestEntity> build(int supplyRequestId) async {
    ref.invalidateProviderOnSuccess(supplyRequestActionProvider);
    ref.invalidateProviderOnSuccess(confirmDeliveryProvider);

    final result = await ref
        .read(getSupplyRequestDetailsUseCaseProvider)
        .call(supplyRequestId);

    return result.getOrThrow()!;
  }
}
