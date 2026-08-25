import 'package:flutter/widgets.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/widgets/placeholder_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderPage(title: context.locale.dashboard);
  }
}
