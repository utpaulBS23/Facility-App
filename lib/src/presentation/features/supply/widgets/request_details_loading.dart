part of '../view/request_details_page.dart';

class _RequestDetailsLoading extends StatelessWidget {
  const _RequestDetailsLoading({
    required this.onBack,
  });

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
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
