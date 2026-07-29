import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/leave/leave_request_entity.dart';
import '../../../../domain/entities/leave/leave_status.dart';
import '../../../../domain/entities/login_entity.dart';
import '../../../core/theme/theme.dart';
import '../riverpod/leave_action_notifier.dart';

extension LeaveActionableX on LeaveRequestEntity {
  bool canUserAction(UserSessionEntity? session) {
    if (session == null) return false;
    return switch (status) {
      LeaveStatus.pendingSupervisor =>
        session.can(AppPermission.leaveApproveSupervisor),
      LeaveStatus.pendingManager =>
        session.can(AppPermission.leaveApproveManager),
      _ => false,
    };
  }
}

Future<bool> executeLeaveAction(
  BuildContext context,
  WidgetRef ref, {
  required int requestId,
  required bool isApprove,
  String? reason,
  VoidCallback? onSuccess,
}) async {
  final success = isApprove
      ? await ref.read(leaveRequestActionProvider.notifier).approve(requestId)
      : await ref
          .read(leaveRequestActionProvider.notifier)
          .reject(requestId, reason: reason);

  if (success && context.mounted) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor:
            isApprove ? context.color.success : context.color.error,
        content: Text(
          isApprove ? context.locale.approved : context.locale.rejection,
          style: TextStyle(color: context.color.onPrimary),
        ),
      ),
    );
    onSuccess?.call();
  }

  return success;
}
