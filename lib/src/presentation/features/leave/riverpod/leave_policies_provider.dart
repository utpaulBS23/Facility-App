import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/leave/leave_policy_entity.dart';

final leavePoliciesProvider =
    FutureProvider<List<LeavePolicyEntity>>((ref) async {
  final result = await ref.read(getLeavePoliciesUseCaseProvider).call();

  return result.when(
    success: (data) => data ?? const [],
    error: (error) => throw Exception(error.message),
  );
});
