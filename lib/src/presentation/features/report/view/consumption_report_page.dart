import 'package:flutter/widgets.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/widgets/placeholder_page.dart';

class ConsumptionReportPage extends StatelessWidget {
  const ConsumptionReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderPage(title: context.locale.consumptionReport);
  }
}
