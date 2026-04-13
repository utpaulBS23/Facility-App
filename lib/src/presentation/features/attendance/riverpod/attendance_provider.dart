import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/attendance_entity.dart';

part 'attendance_provider.g.dart';

@riverpod
Future<AttendanceSummaryEntity> attendanceSummary(Ref ref) async {
  final result =
      await ref.read(getAttendanceSummaryUseCaseProvider).call();
  return switch (result) {
    Success(:final data) => data!,
    Error(:final error) => throw Exception(error),
    _ => throw Exception('Unexpected error'),
  };
}

@riverpod
Future<AttendanceDetailEntity> attendanceDetail(
  Ref ref,
  String id,
) async {
  final result =
      await ref.read(getAttendanceDetailUseCaseProvider).call(id);
  return switch (result) {
    Success(:final data) => data!,
    Error(:final error) => throw Exception(error),
    _ => throw Exception('Unexpected error'),
  };
}
