import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/base/base.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../domain/entities/leave/leave_balance_entity.dart';
import 'submit_leave_request_provider.dart';

part 'leave_balance_provider.g.dart';

@riverpod
Future<List<LeaveBalanceEntity>> leaveBalance(Ref ref, int? attendantId) async {
  ref.listen(submitLeaveRequestProvider, (previous, next) {
    if (next is AsyncData && next.value != null) {
      ref.invalidateSelf();
    }
  });

  final result = await ref.read(getLeaveBalancesUseCaseProvider)(
    attendantId: attendantId,
  );

  return switch (result) {
    Success(:final data) => data ?? const [],
    Error(:final error) => throw Exception(error.message),
    _ => throw Exception('Failed to load leave balance'),
  };
}
