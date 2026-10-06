import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/toilet_location/facility_monthly_report_entity.dart';

part 'toilet_earning_report_provider.g.dart';

/// One facility's report for [month] (`YYYY-MM`), added up from the month's
/// records.
@riverpod
Future<FacilityMonthlyReportEntity> toiletEarningReport(
  Ref ref, {
  required int facilityId,
  required String month,
}) async {
  final result = await ref
      .read(getFacilityMonthlyReportUseCaseProvider)
      .call(facilityId: facilityId, month: month);
  return switch (result) {
    Success(:final data?) => data,
    Error(:final error) => throw error,
    _ => throw StateError('Empty report response'),
  };
}
