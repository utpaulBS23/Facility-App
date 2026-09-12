import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/app_text_field.dart';

class IssueLocationInputSection extends StatelessWidget {
  const IssueLocationInputSection({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AppTextField.text(
        controller: controller,
        hint: context.locale.location,
        prefixIcon: Icon(
          Icons.location_on_outlined,
          color: context.color.text.secondary,
        ),
      ),
    );
  }
}
