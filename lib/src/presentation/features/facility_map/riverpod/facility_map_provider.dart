import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/facility_map_entity.dart';
import '../../../../domain/entities/partner_staff_entity.dart';

part 'facility_map_provider.g.dart';

/// Active facility pins and attendant pins for the Facility Map screen,
/// optionally narrowed to one facility on the server.
@riverpod
Future<FacilityMapEntity> facilityMap(Ref ref, {int? facilityId}) async {
  final result = await ref
      .read(getFacilityMapUseCaseProvider)
      .call(facilityId: facilityId);
  return switch (result) {
    Success(:final data?) => data,
    Error(:final error) => throw error,
    _ => throw StateError('Empty facility map response'),
  };
}

/// Every attendant of the partner (optionally of one facility), including
/// attendants without a map position, like the admin panel's picker.
@riverpod
Future<List<PartnerStaffEntity>> facilityMapAttendants(
  Ref ref, {
  int? facilityId,
}) async {
  final result = await ref
      .read(getPartnerStaffUseCaseProvider)
      .call(facilityId: facilityId);
  return switch (result) {
    Success(:final data) => data ?? const [],
    _ => const [],
  };
}
