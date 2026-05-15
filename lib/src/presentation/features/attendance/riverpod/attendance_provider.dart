import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/attendance_entity.dart';

part 'attendance_provider.g.dart';

@riverpod
Future<MonthlyAttendanceSummaryEntity> monthlyAttendanceOverview(
  Ref ref,
  String month,
) async {
  final result = await ref
      .read(getMonthlyAttendanceOverviewUseCaseProvider)
      .call(
        partnerId: ref.read(getCurrentUserUseCaseProvider).call()!.partnerId!,
        month: month,
      );
  return switch (result) {
    Success(:final data) => data!,
    Error(:final error) => throw Exception(error),
    _ => throw Exception('Unexpected error'),
  };
}

@riverpod
class ApproveAttendance extends _$ApproveAttendance {
  @override
  AsyncValue<AttendanceItemEntity?> build() => const AsyncValue.data(null);

  Future<void> approve({
    required int partnerId,
    required int attendanceId,
  }) async {
    if (state.isLoading) return;
    state = const AsyncValue.loading();
    final result = await ref
        .read(approveAttendanceUseCaseProvider)
        .call(partnerId: partnerId, attendanceId: attendanceId);
    state = switch (result) {
      Success(:final data) => AsyncValue.data(data),
      Error(:final error) => AsyncValue.error(error, StackTrace.current),
      _ => AsyncValue.error('Unexpected error', StackTrace.current),
    };
  }
}

@riverpod
class RejectAttendance extends _$RejectAttendance {
  @override
  AsyncValue<AttendanceItemEntity?> build() => const AsyncValue.data(null);

  Future<void> reject({
    required int partnerId,
    required int attendanceId,
  }) async {
    if (state.isLoading) return;
    state = const AsyncValue.loading();
    final result = await ref
        .read(rejectAttendanceUseCaseProvider)
        .call(partnerId: partnerId, attendanceId: attendanceId);
    state = switch (result) {
      Success(:final data) => AsyncValue.data(data),
      Error(:final error) => AsyncValue.error(error, StackTrace.current),
      _ => AsyncValue.error('Unexpected error', StackTrace.current),
    };
  }
}
