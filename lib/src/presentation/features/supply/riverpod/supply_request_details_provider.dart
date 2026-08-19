import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/supply/supply_request_entity.dart';
import 'supply_request_action_provider.dart';

part 'supply_request_details_provider.g.dart';

@riverpod
Future<SupplyRequestEntity> supplyRequestDetails(
  Ref ref,
  int supplyRequestId,
) async {
  ref.listen(supplyRequestActionProvider, (previous, next) {
    if (previous?.isLoading == true && next.hasValue && !next.hasError) {
      ref.invalidateSelf();
    }
  });

  final result = await ref
      .read(getSupplyRequestDetailsUseCaseProvider)
      .call(supplyRequestId);

  return result.when(
    success: (data) => data!,
    error: (error) => throw Exception(error.message),
  );
}
