import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/supervisor_attendance_detail_entity.dart';

part 'supervisor_attendance_detail_provider.g.dart';

@riverpod
Future<SupervisorAttendanceDetailEntity> supervisorAttendanceDetail(
  Ref ref, {
  required int userId,
  required String date,
}) async {
  final result = await ref
      .read(getSupervisorAttendanceDetailsUseCaseProvider)
      .call(userId: userId, date: date);

  return switch (result) {
    Success(:final data) => data!,
    Error(:final error) => throw error,
    _ => throw Failure.emptyResponse('get supervisor attendance details'),
  };
}
