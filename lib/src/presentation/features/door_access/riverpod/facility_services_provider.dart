import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/cash_collection/cash_collection_entity.dart';

final facilityServicesProvider =
    FutureProvider.family<List<FacilityServiceEntity>, String>(
  (ref, facilityId) async {
    final session = ref.watch(authenticationRepositoryProvider).currentSession;
    if (session == null) return [];

    final partnerId = session.activePartnerId;
    if (partnerId == null) return [];

    final facilityIdInt = int.tryParse(facilityId);
    if (facilityIdInt == null) return [];

    final result = await ref
        .read(cashCollectionRepositoryProvider)
        .getFacilityServices(partnerId: partnerId, facilityId: facilityIdInt);

    return switch (result) {
      Success(:final data) => data ?? [],
      Error() => [],
      _ => [],
    };
  },
);
