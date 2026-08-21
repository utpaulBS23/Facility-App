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
      appBar: AppBar(
        leading: AppBackButton(onTap: onBack),
        leadingWidth: AppBackButton.width,
        title: Headline2xlTinyText(context.locale.requestDetailsTitle),
        centerTitle: true,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: AppErrorWidget(
        message: error.localizedMessage(context),
        onRetry: onRetry,
      ),
    );
  }
}
