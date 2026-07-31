import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/leave/leave_request_entity.dart';
import '../../../core/theme/theme.dart';
import '../riverpod/leave_request_action_provider.dart';

class LeaveDetailsActionBar extends ConsumerStatefulWidget {
  const LeaveDetailsActionBar({
    super.key,
    required this.request,
    required this.onActionStarted,
  });

  final LeaveRequestEntity request;
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
        .read(leaveRequestActionProvider.notifier)
        .approve(widget.request.id);

    if (mounted) setState(() => _isApproving = false);
  }

  void _onReject() async {
    if (_isApproving || _isRejecting) return;
    setState(() => _isRejecting = true);
    widget.onActionStarted(false);

    await ref
        .read(leaveRequestActionProvider.notifier)
        .reject(widget.request.id);

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
                        strokeWidth: 2,
                        color: color.onPrimary,
                      ),
                    )
                  : Text(context.locale.approved),
            ),
          ),
          Gap(spacing.s12),
          Expanded(
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
                        strokeWidth: 2,
                        color: color.primary,
                      ),
                    )
                  : Text(context.locale.rejection),
            ),
          ),
        ],
      ),
    );
  }
}
