part of '../view/request_details_page.dart';

class _RequestDetailsLoading extends StatelessWidget {
  const _RequestDetailsLoading({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(
        title: context.locale.requestDetailsTitle,
        onBack: onBack,
      ),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
