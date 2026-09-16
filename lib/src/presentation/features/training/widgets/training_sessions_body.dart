part of '../view/training_sessions_page.dart';

class _TrainingSessionsBody extends StatelessWidget {
  const _TrainingSessionsBody({
    required this.selectedFilter,
    required this.sessionsAsync,
    required this.onFilterSelected,
    required this.onSessionTap,
    required this.onRetry,
  });

  final TrainingFilter selectedFilter;
  final AsyncValue<PaginatedListEntity<TrainingSessionEntity>> sessionsAsync;
  final ValueChanged<TrainingFilter> onFilterSelected;
  final ValueChanged<TrainingSessionEntity> onSessionTap;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return RefreshIndicator(
      onRefresh: () async => onRetry(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(spacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CategoryFilterChips<TrainingFilter>(
              categories: TrainingFilter.values,
              selectedCategory: selectedFilter,
              onSelected: onFilterSelected,
              labelBuilder: (context, filter) => _getFilterLabel(context, filter),
            ),
            Gap(spacing.s16),
            _TrainingSessionsListSection(
              sessionsAsync: sessionsAsync,
              onSessionTap: onSessionTap,
              onRetry: onRetry,
            ),
          ],
        ),
      ),
    );
  }

  String _getFilterLabel(BuildContext context, TrainingFilter filter) {
    return switch (filter) {
      TrainingFilter.all => context.locale.all,
      TrainingFilter.scheduled => context.locale.notStarted,
      TrainingFilter.inProgress => context.locale.inProgress,
      TrainingFilter.completed => context.locale.completed,
    };
  }
}
