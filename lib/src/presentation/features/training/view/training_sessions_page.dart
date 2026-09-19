import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/common/paginated_list_entity.dart';
import '../../../../domain/entities/training/training_filters.dart';
import '../../../../domain/entities/training/training_session_entity.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/category_filter_chips.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../../../core/widgets/status_dot_tag.dart';
import '../../supply/widgets/shimmer/shimmer_box.dart';
import '../extensions/training_status_extension.dart';
import '../riverpod/training_sessions_list_provider.dart';

part '../widgets/shimmer/training_session_shimmer.dart';
part '../widgets/training_session_list_card.dart';
part '../widgets/training_sessions_body.dart';
part '../widgets/training_sessions_list.dart';

class TrainingSessionsPage extends ConsumerStatefulWidget {
  const TrainingSessionsPage({super.key});

  @override
  ConsumerState<TrainingSessionsPage> createState() =>
      _TrainingSessionsPageState();
}

class _TrainingSessionsPageState extends ConsumerState<TrainingSessionsPage> {
  TrainingFilter _selectedFilter = TrainingFilter.all;

  void _onFilterSelected(TrainingFilter filter) {
    if (_selectedFilter == filter) {
      return;
    }

    setState(() => _selectedFilter = filter);
    ref.read(trainingSessionsListProvider.notifier).filter(filter);
  }

  void _onSessionTap(TrainingSessionEntity session) {
    context.pushNamed(
      Routes.trainingSessionDetails,
      pathParameters: {'id': session.id.toString()},
    );
  }

  void _onBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed(Routes.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessionsAsync = ref.watch(trainingSessionsListProvider);

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(
        title: context.locale.trainingSessions,
        onBack: () => _onBack(context),
      ),
      body: _TrainingSessionsBody(
        selectedFilter: _selectedFilter,
        sessionsAsync: sessionsAsync,
        onFilterSelected: _onFilterSelected,
        onSessionTap: _onSessionTap,
        onRetry: () => ref
            .read(trainingSessionsListProvider.notifier)
            .fetch(filter: _selectedFilter),
      ),
    );
  }
}
