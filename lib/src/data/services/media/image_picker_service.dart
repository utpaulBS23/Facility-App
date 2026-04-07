// Author: Md. Shahin Bashar
// Created: 2026-04-06

import 'package:image_picker/image_picker.dart';

abstract class ImagePickerService {
  Future<String?> pickSelfieFromCamera();
}

final class ImagePickerServiceImpl implements ImagePickerService {
  ImagePickerServiceImpl(this._picker);

  final ImagePicker _picker;

  @override
  Future<String?> pickSelfieFromCamera() async {
    final photo = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 85,
    );
    return photo?.path;
  }
}
