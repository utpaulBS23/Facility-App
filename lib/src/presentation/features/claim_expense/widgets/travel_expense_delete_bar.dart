import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/app_snackbar.dart';
import '../riverpod/claim_expense_provider.dart';
import 'delete_travel_expense_confirm_dialog.dart';

/// Delete button for the claimant's own `waiting` travel expense claim.
///
/// Pops the details page on a successful delete.
class TravelExpenseDeleteBar extends ConsumerStatefulWidget {
  const TravelExpenseDeleteBar({super.key, required this.travelExpenseId});

  final int travelExpenseId;

  @override
  ConsumerState<TravelExpenseDeleteBar> createState() =>
      _TravelExpenseDeleteBarState();
}

class _TravelExpenseDeleteBarState
    extends ConsumerState<TravelExpenseDeleteBar> {
  bool _isDeleting = false;

  Future<void> _onDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const DeleteTravelExpenseConfirmDialog(),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _isDeleting = true);

    await ref
        .read(deleteTravelExpenseProvider.notifier)
        .delete(widget.travelExpenseId);

    if (!mounted) return;

    final state = ref.read(deleteTravelExpenseProvider);
    if (state.hasError) {
      setState(() => _isDeleting = false);
      AppSnackBar.showError(context, state.error!.localizedMessage(context));
      return;
    }

    AppSnackBar.showSuccess(context, context.locale.deleteClaimSuccess);
    Navigator.of(context).pop();
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
          onPressed: _isDeleting ? null : _onDelete,
          style: OutlinedButton.styleFrom(
            foregroundColor: color.error,
            side: BorderSide(color: color.error),
            minimumSize: Size(double.infinity, spacing.s44),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(context.dimensions.radius.r10),
            ),
          ),
          child: _isDeleting
              ? SizedBox(
                  width: spacing.s20,
                  height: spacing.s20,
                  child: CircularProgressIndicator(
                    strokeWidth: spacing.s2,
                    color: color.error,
                  ),
                )
              : Text(context.locale.deleteClaim),
        ),
      ),
    );
  }
}
