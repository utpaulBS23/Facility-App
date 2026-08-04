import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/stock/facility_stock_target_entity.dart';

final facilityStockTargetsProvider =
    FutureProvider.family<List<FacilityStockTargetEntity>, int?>((
      ref,
      facilityId,
    ) async {
      final result = await ref
          .read(getFacilityStockTargetsUseCaseProvider)
          .call(facilityId: facilityId);

      return result.when(
        success: (data) => data ?? const [],
        error: (error) => throw Exception(error.message),
      );
    });
