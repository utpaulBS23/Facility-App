import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/leave/leave_policy_entity.dart';

part 'leave_policies_provider.g.dart';

@riverpod
class LeavePolicies extends _$LeavePolicies {
  @override
  Future<List<LeavePolicyEntity>> build() async {
    final result = await ref.read(getLeavePoliciesUseCaseProvider).call();

    return result.when(
      success: (data) => data ?? const [],
      error: (error) => throw Exception(error.message),
    );
  }
}
