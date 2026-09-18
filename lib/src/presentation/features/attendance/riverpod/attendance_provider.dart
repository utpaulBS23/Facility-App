import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/permission_guard.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/attendance_entity.dart';
import '../../../../domain/entities/partner_staff_entity.dart';

part 'attendance_provider.g.dart';

@riverpod
Future<MonthlyAttendanceSummaryEntity> monthlyAttendanceOverview(
  Ref ref,
  String month, {
  int? facilityId,
  int? userId,
}) async {
  final result = await ref
      .read(getMonthlyAttendanceOverviewUseCaseProvider)
      .call(month: month, facilityId: facilityId, userId: userId);
  return switch (result) {
    Success(:final data) => data!,
    Error(:final error) => throw Exception(error),
    _ => throw Exception('Unexpected error'),
  };
}

// WHY: family on facilityId — the attendance staff filter must scope to the
// facility already selected in the filter sheet, same as the assign-staff
// flow (roster/shift), instead of listing every partner staff member.
@riverpod
Future<List<PartnerStaffEntity>> attendanceStaffOptions(
  Ref ref, {
  int? facilityId,
}) async {
  final result = await ref
      .read(getPartnerStaffUseCaseProvider)
      .call(facilityId: facilityId);
  return switch (result) {
    Success(:final data) => data ?? [],
    Error() => [],
    _ => [],
  };
}

@riverpod
class ApproveAttendance extends _$ApproveAttendance {
  @override
  AsyncValue<AttendanceItemEntity?> build() => const AsyncValue.data(null);

  Future<void> approve({required int attendanceId}) async {
    if (state.isLoading) return;

    if (!ref.hasPermission(UserPermission.attendanceApprove)) {
      state = AsyncValue.error(Failure.permissionDenied, StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();
    final result = await ref
        .read(approveAttendanceUseCaseProvider)
        .call(attendanceId: attendanceId);
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

  Future<void> reject({required int attendanceId}) async {
    if (state.isLoading) return;

    if (!ref.hasPermission(UserPermission.attendanceReject)) {
      state = AsyncValue.error(Failure.permissionDenied, StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();
    final result = await ref
        .read(rejectAttendanceUseCaseProvider)
        .call(attendanceId: attendanceId);
    state = switch (result) {
      Success(:final data) => AsyncValue.data(data),
      Error(:final error) => AsyncValue.error(error, StackTrace.current),
      _ => AsyncValue.error('Unexpected error', StackTrace.current),
    };
  }
}
