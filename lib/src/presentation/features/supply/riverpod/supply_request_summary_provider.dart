import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/supply/supply_request_summary_entity.dart';

part 'supply_request_summary_provider.g.dart';

@riverpod
Future<SupplyRequestSummaryEntity> supplyRequestSummary(
  Ref ref, {
  int? facilityId,
}) async {
  final result = await ref
      .read(getSupplyRequestSummaryUseCaseProvider)
      .call(facilityId: facilityId);

  return switch (result) {
    Success(:final data) when data != null => data,
    Error(:final error) => throw Exception(error.message),
    _ => throw Exception('Failed to fetch supply request summary'),
  };
}
