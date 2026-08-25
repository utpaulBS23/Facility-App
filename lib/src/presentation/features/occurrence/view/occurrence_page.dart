import 'package:flutter/widgets.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/widgets/placeholder_page.dart';

class OccurrencePage extends StatelessWidget {
  const OccurrencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderPage(title: context.locale.occurrences);
  }
}
