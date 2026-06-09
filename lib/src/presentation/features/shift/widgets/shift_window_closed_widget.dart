import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import 'shift_status_page.dart';

class ShiftWindowClosedWidget extends StatelessWidget {
  const ShiftWindowClosedWidget({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return ShiftStatusPage(
      heroColor: context.color.error,
      icon: Icons.lock_outline_rounded,
      title: context.locale.shiftWindowClosed,
      message: message,
      helpText: context.locale.shiftWindowClosedHelp,
      buttonLabel: context.locale.shift,
      onButton: () => context.goNamed(Routes.shift),
    );
  }
}
