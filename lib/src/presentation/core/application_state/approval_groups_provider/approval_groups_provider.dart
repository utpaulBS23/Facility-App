import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/approval/approval_config_entity.dart';

part 'approval_groups_provider.g.dart';

// WHY errors become an empty list: the endpoint needs a configuration
// permission that plain approvers (e.g. supervisors) do not have, and the
// list pages then fall back to a single "Pending" chip.
@riverpod
Future<List<ApprovalGroupEntity>> approvalGroups(
  Ref ref,
  ApprovalModule module,
) async {
  final result = await ref.read(getApprovalGroupsUseCaseProvider).call(module);

  return switch (result) {
    Success(:final data) => data ?? const [],
    _ => const [],
  };
}
