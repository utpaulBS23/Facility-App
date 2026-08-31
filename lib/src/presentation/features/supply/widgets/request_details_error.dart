part of '../view/request_details_page.dart';

class _RequestDetailsError extends StatelessWidget {
  const _RequestDetailsError({
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
        title: context.locale.requestDetailsTitle,
        onBack: onBack,
      ),
      body: AppErrorWidget(
        message: error.localizedMessage(context),
        onRetry: onRetry,
      ),
    );
  }
}
