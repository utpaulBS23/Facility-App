import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/training/training_session_entity.dart';
import '../../../../domain/entities/training/training_status.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../../../core/widgets/status_dot_tag.dart';
import '../extensions/training_status_extension.dart';
import '../riverpod/training_session_details_provider.dart';

part '../widgets/training_detail_row.dart';
part '../widgets/training_session_details_body.dart';
part '../widgets/training_session_details_error.dart';
part '../widgets/training_session_details_loading.dart';
part '../widgets/training_session_info_card.dart';
part '../widgets/training_not_started_notice_card.dart';

class TrainingSessionDetailsPage extends ConsumerWidget {
  const TrainingSessionDetailsPage({super.key, required this.sessionId});

  final int sessionId;

  void _onBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed(Routes.trainingSessions);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(trainingSessionDetailsProvider(sessionId));

    return switch (sessionAsync) {
      AsyncData(value: final session) => _TrainingSessionDetailsBody(
        session: session,
        onBack: () => _onBack(context),
      ),
      AsyncError(:final error) => _TrainingSessionDetailsError(
        error: error,
        onRetry: () =>
            ref.invalidate(trainingSessionDetailsProvider(sessionId)),
        onBack: () => _onBack(context),
      ),
      _ => _TrainingSessionDetailsLoading(onBack: () => _onBack(context)),
    };
  }
}
