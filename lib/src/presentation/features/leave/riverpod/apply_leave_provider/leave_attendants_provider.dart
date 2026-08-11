import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/base/base.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../domain/entities/leave/leave_attendant_entity.dart';

part 'leave_attendants_provider.g.dart';

@riverpod
Future<List<LeaveAttendantEntity>> leaveAttendants(Ref ref) async {
  final result = await ref.read(getLeaveAttendantsUseCaseProvider)();

  return switch (result) {
    Success(:final data) => data ?? const [],
    Error(:final error) => throw Exception(error.message),
    _ => throw Exception('Failed to load leave attendants'),
  };
}