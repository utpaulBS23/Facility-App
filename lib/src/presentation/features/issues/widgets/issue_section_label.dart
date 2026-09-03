import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';

class IssueSectionLabel extends StatelessWidget {
  const IssueSectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) =>
      LabelLargeText(text, color: context.color.text.primary);
}
