import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';

class AssignStaffPage extends StatelessWidget {
  const AssignStaffPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
        title: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.dimensions.spacing.s16,
          ),
          child: LabelLargeText(context.locale.assignStaff),
        ),
      ),
      body: const SizedBox.shrink(),
    );
  }
}
