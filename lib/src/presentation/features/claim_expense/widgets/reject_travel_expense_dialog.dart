import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/form_dialog_shell.dart';

/// Asks the reviewer why a claim is rejected; pops the note, or null when
/// cancelled. The server requires a note of at most [maxLength] characters.
class RejectTravelExpenseDialog extends StatefulWidget {
  const RejectTravelExpenseDialog({super.key});

  static const maxLength = 255;

  @override
  State<RejectTravelExpenseDialog> createState() =>
      _RejectTravelExpenseDialogState();
}

class _RejectTravelExpenseDialogState extends State<RejectTravelExpenseDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _note => _controller.text.trim();

  bool get _isTooLong => _note.length > RejectTravelExpenseDialog.maxLength;

  @override
  Widget build(BuildContext context) {
    return FormDialogShell(
      title: context.locale.rejectClaim,
      onClose: () => Navigator.of(context).pop(),
      onCancel: () => Navigator.of(context).pop(),
      isSubmitting: false,
      submitLabel: context.locale.reject,
      onSubmit: _note.isEmpty || _isTooLong
          ? null
          : () => Navigator.of(context).pop(_note),
      body: AppTextField.description(
        controller: _controller,
        label: '${context.locale.rejectionNote} *',
        hint: context.locale.rejectionNoteHint,
        errorText: _isTooLong
            ? context.locale.maxLengthValidation(
                RejectTravelExpenseDialog.maxLength,
              )
            : null,
        onChanged: (_) => setState(() {}),
      ),
    );
  }
}
