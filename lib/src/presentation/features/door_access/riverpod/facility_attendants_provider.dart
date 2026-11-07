import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/partner_staff_entity.dart';

final facilityAttendantsProvider =
    FutureProvider.family<List<PartnerStaffEntity>, String>(
  (ref, facilityId) async {
    final session = ref.watch(authenticationRepositoryProvider).currentSession;
    if (session == null) return [];

    final partnerId = session.activePartnerId;
    if (partnerId == null) return [];

    final facilityIdInt = int.tryParse(facilityId);

    final result = await ref.read(partnerStaffRepositoryProvider).getPartnerUsers(
          partnerId: partnerId,
          role: 'attendant',
          facilityId: facilityIdInt,
        );

    return switch (result) {
      Success(:final data) => (data ?? []).where((s) => s.isActive).toList(),
      Error() => [],
      _ => [],
    };
  },
);