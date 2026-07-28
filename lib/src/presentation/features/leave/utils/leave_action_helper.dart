import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/theme.dart';
import '../riverpod/leave_action_notifier.dart';

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
          isApprove
              ? 'Leave request approved.'
              : 'Leave request rejected.',
          style: TextStyle(color: context.color.onPrimary),
        ),
      ),
    );
    onSuccess?.call();
  }

  return success;
}
