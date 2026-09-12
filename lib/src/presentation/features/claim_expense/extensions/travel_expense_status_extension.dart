import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/travel_expense_status.dart';
import '../../../core/theme/theme.dart';

extension TravelExpenseStatusLocalization on TravelExpenseStatus {
  String localizedName(BuildContext context) {
    return switch (this) {
      TravelExpenseStatus.waiting => context.locale.pending,
      TravelExpenseStatus.allowed => context.locale.approved,
      TravelExpenseStatus.rejected => context.locale.rejected,
      TravelExpenseStatus.unknown => context.locale.notAvailable,
    };
  }

  Color statusColor(BuildContext context) {
    return switch (this) {
      TravelExpenseStatus.waiting => context.color.warning,
      TravelExpenseStatus.allowed => context.color.success,
      TravelExpenseStatus.rejected => context.color.error,
      TravelExpenseStatus.unknown => context.color.text.secondary,
    };
  }
}
