part of '../view/training_session_details_page.dart';

class _TrainingSessionDetailsLoading extends StatelessWidget {
  const _TrainingSessionDetailsLoading({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(
        title: context.locale.trainingDetailsTitle,
        onBack: onBack,
      ),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
