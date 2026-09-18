part of '../view/training_sessions_page.dart';

class _TrainingSessionsListSection extends StatelessWidget {
  const _TrainingSessionsListSection({
    required this.sessionsAsync,
    required this.onSessionTap,
    required this.onRetry,
  });

  final AsyncValue<PaginatedListEntity<TrainingSessionEntity>> sessionsAsync;
  final ValueChanged<TrainingSessionEntity> onSessionTap;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return sessionsAsync.when(
      data: (paginated) {
        if (paginated.items.isEmpty) {
          return Padding(
            padding: EdgeInsets.only(top: spacing.s48),
            child: Center(
              child: Text(
                context.locale.noTrainingSessionsFound,
                style: context.textStyle.bodyMedium.copyWith(
                  color: context.color.text.secondary,
                ),
              ),
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: paginated.items.length,
          separatorBuilder: (_, index) => Gap(spacing.s12),
          itemBuilder: (context, index) {
            final session = paginated.items[index];
            return _TrainingSessionListCard(
              session: session,
              onTap: () => onSessionTap(session),
            );
          },
        );
      },
      loading: () => const _TrainingSessionShimmer(),
      error: (err, _) => AppErrorWidget(
        message: err.localizedMessage(context),
        onRetry: onRetry,
      ),
    );
  }
}
