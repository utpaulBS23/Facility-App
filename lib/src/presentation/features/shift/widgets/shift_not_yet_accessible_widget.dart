import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import 'shift_status_page.dart';

class ShiftNotYetAccessibleWidget extends StatelessWidget {
  const ShiftNotYetAccessibleWidget({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return ShiftStatusPage(
      heroColor: context.color.warning,
      icon: Icons.schedule_outlined,
      title: context.locale.shiftNotYetAccessible,
      message: message,
      helpText: context.locale.shiftNotYetAccessibleHelp,
      buttonLabel: context.locale.shift,
      onButton: () => context.goNamed(Routes.shift),
    );
  }
}
