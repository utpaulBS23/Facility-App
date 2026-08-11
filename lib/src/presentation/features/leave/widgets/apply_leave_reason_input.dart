import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/widgets/app_text_field.dart';

class LeaveReasonInput extends StatelessWidget {
  const LeaveReasonInput({
    super.key,
    required this.controller,
    this.enabled = true,
  });

  final TextEditingController controller;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return AppTextField.description(
      controller: controller,
      label: context.locale.reason,
      hint: context.locale.reasonOptional,
      enabled: enabled,
    );
  }
}
