import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/toilet_location/facility_wise_report_entity.dart';

part 'toilet_earning_report_provider.g.dart';

/// One facility's report for [month] (`YYYY-MM`). An empty
/// [FacilityWiseReportEntity.facilities] means the month is not closed yet.
@riverpod
Future<FacilityWiseReportEntity> toiletEarningReport(
  Ref ref, {
  required int facilityId,
  required String month,
}) async {
  final result = await ref
      .read(getFacilityWiseReportUseCaseProvider)
      .call(facilityId: facilityId, month: month);
  return switch (result) {
    Success(:final data?) => data,
    Error(:final error) => throw error,
    _ => throw StateError('Empty report response'),
  };
}
