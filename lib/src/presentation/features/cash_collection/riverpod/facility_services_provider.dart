import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/cash_collection/cash_collection_entity.dart';

part 'facility_services_provider.g.dart';

/// Every service x gender price row offered at [facilityId]: the lines of a
/// manual income entry.
@riverpod
Future<List<FacilityServiceEntity>> facilityServices(
  Ref ref,
  int facilityId,
) async {
  final result = await ref
      .read(getFacilityServicesUseCaseProvider)
      .call(facilityId);

  return switch (result) {
    Success(:final data) => data ?? const [],
    Error(:final error) => throw error,
    _ => throw Failure.emptyResponse('get facility services'),
  };
}
