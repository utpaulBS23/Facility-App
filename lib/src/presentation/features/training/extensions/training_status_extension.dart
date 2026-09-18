import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/training/training_status.dart';
import '../../../core/theme/theme.dart';

extension TrainingStatusLocalization on TrainingStatus {
  String localizedName(BuildContext context) {
    return switch (this) {
      TrainingStatus.scheduled => context.locale.notStarted,
      TrainingStatus.inProgress => context.locale.inProgress,
      TrainingStatus.completed => context.locale.completed,
      TrainingStatus.cancelled => context.locale.cancelled,
      TrainingStatus.unknown => context.locale.notAvailable,
    };
  }

  Color statusColor(BuildContext context) {
    return switch (this) {
      TrainingStatus.scheduled => context.color.text.secondary,
      TrainingStatus.inProgress => context.color.warning,
      TrainingStatus.completed => context.color.success,
      TrainingStatus.cancelled => context.color.error,
      TrainingStatus.unknown => context.color.text.secondary,
    };
  }
}
