import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/app_snackbar.dart';
import '../riverpod/travel_expense_review_provider.dart';
import 'reject_travel_expense_dialog.dart';

/// Reject and Approve buttons for a claim waiting for review.
class TravelExpenseReviewBar extends ConsumerStatefulWidget {
  const TravelExpenseReviewBar({super.key, required this.travelExpenseId});

  final int travelExpenseId;

  @override
  ConsumerState<TravelExpenseReviewBar> createState() =>
      _TravelExpenseReviewBarState();
}

class _TravelExpenseReviewBarState
    extends ConsumerState<TravelExpenseReviewBar> {
  /// What the running request is, so its buttons show the spinner.
  bool? _approving;

  Future<void> _onApprove() async {
    setState(() => _approving = true);
    await ref
        .read(travelExpenseReviewProvider.notifier)
        .approve(widget.travelExpenseId);
    if (!mounted) return;
    _finish(context.locale.claimApprovedSuccess);
  }

  Future<void> _onReject() async {
    final note = await showDialog<String>(
      context: context,
      builder: (_) => const RejectTravelExpenseDialog(),
    );
    if (note == null || !mounted) return;

    setState(() => _approving = false);
    await ref
        .read(travelExpenseReviewProvider.notifier)
        .reject(widget.travelExpenseId, note);
    if (!mounted) return;
    _finish(context.locale.claimRejectedSuccess);
  }

  void _finish(String successMessage) {
    setState(() => _approving = null);
    final state = ref.read(travelExpenseReviewProvider);
    if (state.hasError) {
      AppSnackBar.showError(context, state.error!.localizedMessage(context));
    } else {
      AppSnackBar.showSuccess(context, successMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final isBusy = _approving != null;

    Widget spinner(Color spinnerColor) => SizedBox(
      width: spacing.s20,
      height: spacing.s20,
      child: CircularProgressIndicator(
        strokeWidth: spacing.s2,
        color: spinnerColor,
      ),
    );

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        border: Border(top: BorderSide(color: color.borderSubtle)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: spacing.s44,
                child: OutlinedButton(
                  onPressed: isBusy ? null : _onReject,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: color.primary),
                    foregroundColor: color.primary,
                  ),
                  child: _approving == false
                      ? spinner(color.primary)
                      : Text(context.locale.reject),
                ),
              ),
            ),
            Gap(spacing.s12),
            Expanded(
              child: SizedBox(
                height: spacing.s44,
                child: FilledButton(
                  onPressed: isBusy ? null : _onApprove,
                  child: _approving == true
                      ? spinner(color.onPrimary)
                      : Text(context.locale.approve),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
