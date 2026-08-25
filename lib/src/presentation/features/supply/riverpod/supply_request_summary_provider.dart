import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/supply/supply_request_summary_entity.dart';
import 'supply_request_action_provider.dart';

part 'supply_request_summary_provider.g.dart';

@riverpod
class SupplyRequestSummary extends _$SupplyRequestSummary {
  @override
  Future<SupplyRequestSummaryEntity> build() async {

    ref.listen(supplyRequestActionProvider, (previous, next) {
      if (previous?.isLoading == true && next.hasValue && !next.hasError) {
        ref.invalidateSelf();
      }
    });
    
    return fetch();
  }

  Future<SupplyRequestSummaryEntity> fetch({int? facilityId}) async {
    final result = await ref
        .read(getSupplyRequestSummaryUseCaseProvider)
        .call(facilityId: facilityId);

    return result.when(
      success: (data) => data!,
      error: (error) => throw error,
    );
  }
}
