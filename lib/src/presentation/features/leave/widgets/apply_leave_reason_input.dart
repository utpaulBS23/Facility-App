import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/widgets/app_text_field.dart';

class LeaveReasonInput extends StatefulWidget {
  const LeaveReasonInput({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  final String initialValue;
  final ValueChanged<String> onChanged;

  @override
  State<LeaveReasonInput> createState() => _LeaveReasonInputState();
}

class _LeaveReasonInputState extends State<LeaveReasonInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField.description(
      controller: _controller,
      label: context.locale.reason,
      hint: context.locale.reasonOptional,
      onChanged: widget.onChanged,
    );
  }
}
