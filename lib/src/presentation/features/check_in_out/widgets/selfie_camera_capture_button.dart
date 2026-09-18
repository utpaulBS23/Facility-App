part of '../view/selfie_camera_page.dart';

class _SelfieCameraCaptureButton extends StatelessWidget {
  const _SelfieCameraCaptureButton({
    required this.isCapturing,
    required this.onTap,
  });

  final bool isCapturing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final size = context.dimensions.spacing.s66;

    return GestureDetector(
      onTap: isCapturing ? null : onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.color.primary,
          border: Border.all(color: Colors.white, width: 4),
        ),
        child: isCapturing
            ? const Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Icon(
                Icons.camera_alt_rounded,
                color: Colors.white,
                size: 28,
              ),
      ),
    );
  }
}
