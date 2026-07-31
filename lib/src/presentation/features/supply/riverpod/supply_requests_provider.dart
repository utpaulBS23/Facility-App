import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/common/paginated_list_entity.dart';
import '../../../../domain/entities/supply/supply_request_entity.dart';
import '../../../../domain/entities/supply/supply_request_status.dart';

part 'supply_requests_provider.g.dart';

@riverpod
class SupplyRequests extends _$SupplyRequests {
  @override
  Future<PaginatedListEntity<SupplyRequestEntity>> build({
    SupplyRequestStatus? status,
  }) async {
    final result = await ref
        .read(getSupplyRequestsUseCaseProvider)
        .call(status: status);

    return result.when(
      success: (data) => data ?? const PaginatedListEntity.empty(),
      error: (error) => throw error,
    );
  }
}
