import 'package:flutter/material.dart';

import '../../../core/extensions/app_localization.dart';
import '../theme/theme.dart';

/// Shared shell for the app's "create X" form dialogs — title bar with a
/// close affordance, a scrollable body, and a cancel/submit footer.
///
/// WHY extracted: [CreateRosterDialog] and [CreateShiftDialog] repeated this
/// exact shell (sizing, dividers, button row, loading-spinner-in-button) with
/// only the title, body, and submit copy differing. One widget now owns the
/// chrome; each dialog only supplies its fields.
class FormDialogShell extends StatelessWidget {
  static const double _maxHeightFraction = 0.85;

  /// Creates a [FormDialogShell].
  const FormDialogShell({
    super.key,
    required this.title,
    required this.onClose,
    required this.body,
    required this.onCancel,
    required this.onSubmit,
    required this.isSubmitting,
    required this.submitLabel,
  });

  /// Dialog title, shown beside the close icon.
  final String title;

  /// Invoked by the close icon.
  final VoidCallback onClose;

  /// The dialog's fields — wrapped in scrolling padding by this shell.
  final Widget body;

  /// Invoked by the footer's cancel button.
  final VoidCallback onCancel;

  /// Invoked by the footer's submit button; `null` disables it.
  final VoidCallback? onSubmit;

  /// Swaps the submit button's label for a loading spinner.
  final bool isSubmitting;

  /// Label of the submit button when not [isSubmitting].
  final String submitLabel;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Dialog(
      backgroundColor: context.color.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius.r16),
      ),
      insetPadding: EdgeInsets.symmetric(
        horizontal: spacing.s16,
        vertical: spacing.s24,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: spacing.s420,
          // WHY: a fraction of the viewport, not a fixed size — Dimensions
          // only holds absolute pixel buckets, so this stays a local
          // constant rather than a mis-fitting token (same precedent as
          // selfie_zone.dart's `screenHeight * 0.4`).
          maxHeight: MediaQuery.sizeOf(context).height * _maxHeightFraction,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Header(title: title, onClose: onClose),
              Divider(height: 1, color: context.color.borderSubtle),
              Padding(padding: EdgeInsets.all(spacing.s20), child: body),
              Divider(height: 1, color: context.color.borderSubtle),
              _Footer(
                onCancel: onCancel,
                onSubmit: onSubmit,
                isSubmitting: isSubmitting,
                submitLabel: submitLabel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title, required this.onClose});

  final String title;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        spacing.s20,
        spacing.s20,
        spacing.s12,
        spacing.s16,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: context.textStyle.titleMedium.copyWith(
                color: context.color.text.primary,
              ),
            ),
          ),
          GestureDetector(
            onTap: onClose,
            child: Icon(Icons.close_rounded, color: context.color.icon),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    required this.onCancel,
    required this.onSubmit,
    required this.isSubmitting,
    required this.submitLabel,
  });

  final VoidCallback onCancel;
  final VoidCallback? onSubmit;
  final bool isSubmitting;
  final String submitLabel;

  @override
  Widget build(BuildContext context) {
    final radius = context.dimensions.radius;
    return Padding(
      padding: EdgeInsets.all(context.dimensions.spacing.s16),
      // WHY: OverflowBar (not a bare Row) — every button in this app's theme
      // forces minimumSize.width = infinity, which collides with the
      // unbounded main-axis width a plain Row gives non-flex children.
      child: OverflowBar(
        alignment: MainAxisAlignment.end,
        spacing: context.dimensions.spacing.s8,
        children: [
          TextButton(
            onPressed: onCancel,
            child: Text(
              context.locale.cancel,
              style: context.textStyle.labelLarge.copyWith(
                color: context.color.text.secondary,
              ),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius.r6),
              ),
            ),
            onPressed: onSubmit,
            child: isSubmitting
                ? SizedBox.square(
                    dimension: context.dimensions.spacing.s20,
                    child: CircularProgressIndicator.adaptive(
                      valueColor: AlwaysStoppedAnimation(
                        context.color.onPrimary,
                      ),
                    ),
                  )
                : Text(
                    submitLabel,
                    style: context.textStyle.labelLarge.copyWith(
                      color: context.color.onPrimary,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
