import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/leave/leave_policy_entity.dart';
import '../../../core/extensions/ref_extensions.dart';

part 'leave_policies_provider.g.dart';

@riverpod
class LeavePolicies extends _$LeavePolicies {
  @override
  Future<List<LeavePolicyEntity>> build() async {
    final result = await ref.read(getLeavePoliciesUseCaseProvider).call();

    return result.getOrThrow() ?? const[];
  }
}
