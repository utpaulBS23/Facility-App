import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/application_logo.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.onPrimary,
      body: Center(
        child: ApplicationLogo(semanticLabel: context.locale.pbilLogo),
      ),
    );
  }
}
