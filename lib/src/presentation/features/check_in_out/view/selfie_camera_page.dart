import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/loading_indicator.dart';

part '../widgets/selfie_camera_capture_button.dart';
part '../widgets/selfie_camera_error_view.dart';

/// In-app selfie capture screen.
///
/// WHY a custom camera screen instead of `image_picker`'s native camera:
/// `preferredCameraDevice: CameraDevice.front` only hints which lens opens
/// first — the OS camera app still shows its own front/back switch button,
/// which `image_picker` has no API to hide. This screen opens only the
/// front lens and renders no switch-camera control at all, so there is
/// nothing on screen to flip to the back camera with.
class SelfieCameraPage extends StatefulWidget {
  const SelfieCameraPage({super.key});

  @override
  State<SelfieCameraPage> createState() => _SelfieCameraPageState();
}

class _SelfieCameraPageState extends State<SelfieCameraPage> {
  CameraController? _controller;
  late Future<void> _initialization;
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    _initialization = _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );
    final controller = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await controller.initialize();
    _controller = controller;
  }

  void _onRetryInit() {
    setState(() => _initialization = _initCamera());
  }

  Future<void> _onCapture() async {
    final controller = _controller;
    if (controller == null || _isCapturing) return;

    setState(() => _isCapturing = true);
    try {
      final photo = await controller.takePicture();
      if (mounted) Navigator.of(context).pop(photo.path);
    } on CameraException {
      if (mounted) setState(() => _isCapturing = false);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // WHY Colors.black, not a theme token: this is a full-bleed camera
      // viewfinder — the backdrop is a technical letterboxing color for
      // when the preview's aspect ratio doesn't fill the screen, not a
      // themed app surface.
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true,
      body: FutureBuilder<void>(
        future: _initialization,
        builder: (context, snapshot) {
          final controller = _controller;
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: LoadingIndicator());
          }
          if (snapshot.hasError || controller == null) {
            return _SelfieCameraErrorView(onRetry: _onRetryInit);
          }

          return Stack(
            fit: StackFit.expand,
            children: [
              CameraPreview(controller),
              Positioned(
                left: 0,
                right: 0,
                bottom: context.dimensions.spacing.s40,
                child: Column(
                  children: [
                    Text(
                      context.locale.centerFaceInFrame,
                      textAlign: TextAlign.center,
                      style: context.textStyle.bodyRegular.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Gap(context.dimensions.spacing.s20),
                    _SelfieCameraCaptureButton(
                      isCapturing: _isCapturing,
                      onTap: _onCapture,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
