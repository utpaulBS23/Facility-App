part of '../view/selfie_camera_page.dart';

class _SelfieCameraErrorView extends StatelessWidget {
  const _SelfieCameraErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.dimensions.padding.p24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.locale.cameraAccessRequiredMessage,
              textAlign: TextAlign.center,
              style: context.textStyle.bodyRegular.copyWith(
                color: Colors.white,
              ),
            ),
            Gap(context.dimensions.spacing.s16),
            FilledButton(onPressed: onRetry, child: Text(context.locale.retry)),
          ],
        ),
      ),
    );
  }
}
