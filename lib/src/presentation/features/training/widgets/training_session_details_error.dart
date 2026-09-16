part of '../view/training_session_details_page.dart';

class _TrainingSessionDetailsError extends StatelessWidget {
  const _TrainingSessionDetailsError({
    required this.error,
    required this.onRetry,
    required this.onBack,
  });

  final Object error;
  final VoidCallback onRetry;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(
        title: context.locale.trainingDetailsTitle,
        onBack: onBack,
      ),
      body: AppErrorWidget(
        message: error.localizedMessage(context),
        onRetry: onRetry,
      ),
    );
  }
}
