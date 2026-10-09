import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../widgets/manual_income_form.dart';

/// New manual income entry.
class AddManualIncomePage extends StatelessWidget {
  const AddManualIncomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(title: context.locale.manualIncome),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.s16,
          vertical: spacing.s20,
        ),
        children: const [ManualIncomeForm()],
      ),
    );
  }
}
