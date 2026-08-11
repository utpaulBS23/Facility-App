import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/leave/leave_request_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/permission_gate.dart';
import '../riverpod/leave_requests_provider.dart';

class LeaveDetailsActionBar extends ConsumerStatefulWidget {
  const LeaveDetailsActionBar({
    super.key,
    required this.leaveRequest,
    required this.onActionStarted,
  });

  final LeaveRequestEntity leaveRequest;
  final ValueChanged<bool> onActionStarted;

  @override
  ConsumerState<LeaveDetailsActionBar> createState() =>
      _LeaveDetailsActionBarState();
}

class _LeaveDetailsActionBarState
    extends ConsumerState<LeaveDetailsActionBar> {
  bool _isApproving = false;
  bool _isRejecting = false;

  void _onApprove() async {
    if (_isApproving || _isRejecting) return;
    setState(() => _isApproving = true);
    widget.onActionStarted(true);

    await ref
        .read(leaveRequestsProvider.notifier)
        .approve(widget.leaveRequest.id);

    if (mounted) setState(() => _isApproving = false);
  }

  void _onReject() async {
    if (_isApproving || _isRejecting) return;
    setState(() => _isRejecting = true);
    widget.onActionStarted(false);

    await ref
        .read(leaveRequestsProvider.notifier)
        .reject(widget.leaveRequest.id);

    if (mounted) setState(() => _isRejecting = false);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final isLoading = _isApproving || _isRejecting;

    return Container(
      padding: EdgeInsets.fromLTRB(
        spacing.s16,
        spacing.s12,
        spacing.s16,
        spacing.s20,
      ),
      decoration: BoxDecoration(
        color: color.onPrimary,
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
        border: Border(top: BorderSide(color: color.borderSubtle)),
      ),
      child: Row(
        children: [
          Expanded(
            child: PermissionGate(
              permissions: const [
                UserPermission.leaveApproveSupervisor,
                UserPermission.leaveApproveManager,
              ],
              child: FilledButton(
                onPressed: isLoading ? null : _onApprove,
                style: FilledButton.styleFrom(
                  backgroundColor: color.primary,
                  foregroundColor: color.onPrimary,
                  minimumSize: Size(double.infinity, spacing.s44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      context.dimensions.radius.r10,
                    ),
                  ),
                ),
                child: _isApproving
                    ? SizedBox(
                        width: spacing.s20,
                        height: spacing.s20,
                        child: CircularProgressIndicator(
                          strokeWidth: spacing.s2,
                          color: color.onPrimary,
                        ),
                      )
                    : Text(context.locale.approved),
              ),
            ),
          ),
          Gap(spacing.s12),
          Expanded(
            child: PermissionGate(
              permissions: const [
                UserPermission.leaveReject,
                UserPermission.leaveApproveSupervisor,
                UserPermission.leaveApproveManager,
              ],
              child: OutlinedButton(
                onPressed: isLoading ? null : _onReject,
                style: OutlinedButton.styleFrom(
                  foregroundColor: color.primary,
                  side: BorderSide(color: color.primary),
                  minimumSize: Size(double.infinity, spacing.s44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      context.dimensions.radius.r10,
                    ),
                  ),
                ),
                child: _isRejecting
                    ? SizedBox(
                        width: spacing.s20,
                        height: spacing.s20,
                        child: CircularProgressIndicator(
                          strokeWidth: spacing.s2,
                          color: color.primary,
                        ),
                      )
                    : Text(context.locale.rejection),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
