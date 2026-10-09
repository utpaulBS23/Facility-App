import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';
import '../riverpod/leave_requests_provider.dart';

/// Cancel button for the applicant's own pending leave request.
class LeaveDetailsCancelBar extends ConsumerStatefulWidget {
  const LeaveDetailsCancelBar({
    super.key,
    required this.leaveRequestId,
    required this.onActionStarted,
  });

  final int leaveRequestId;
  final VoidCallback onActionStarted;

  @override
  ConsumerState<LeaveDetailsCancelBar> createState() =>
      _LeaveDetailsCancelBarState();
}

class _LeaveDetailsCancelBarState extends ConsumerState<LeaveDetailsCancelBar> {
  bool _isCancelling = false;

  Future<void> _onCancel() async {
    if (_isCancelling) return;
    setState(() => _isCancelling = true);
    widget.onActionStarted();

    await ref
        .read(leaveRequestsProvider.notifier)
        .cancel(widget.leaveRequestId);

    if (mounted) setState(() => _isCancelling = false);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        border: Border(top: BorderSide(color: color.borderSubtle)),
      ),
      child: SafeArea(
        child: OutlinedButton(
          onPressed: _isCancelling ? null : _onCancel,
          style: OutlinedButton.styleFrom(
            foregroundColor: color.primary,
            side: BorderSide(color: color.primary),
            minimumSize: Size(double.infinity, spacing.s44),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(context.dimensions.radius.r10),
            ),
          ),
          child: _isCancelling
              ? SizedBox(
                  width: spacing.s20,
                  height: spacing.s20,
                  child: CircularProgressIndicator(
                    strokeWidth: spacing.s2,
                    color: color.primary,
                  ),
                )
              : Text(context.locale.cancel),
        ),
      ),
    );
  }
}
