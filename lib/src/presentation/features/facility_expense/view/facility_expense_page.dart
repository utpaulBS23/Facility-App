import 'package:flutter/widgets.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/widgets/placeholder_page.dart';

class FacilityExpensePage extends StatelessWidget {
  const FacilityExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderPage(title: context.locale.expenseEntry);
  }
}
