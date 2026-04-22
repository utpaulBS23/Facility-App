import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

abstract class FaceDetectionService {
  Future<bool> hasFace(String imagePath);

  void close();
}

final class FaceDetectionServiceImpl implements FaceDetectionService {
  FaceDetectionServiceImpl()
    : _detector = FaceDetector(options: FaceDetectorOptions());

  final FaceDetector _detector;

  @override
  Future<bool> hasFace(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final faces = await _detector.processImage(inputImage);

    return faces.isNotEmpty;
  }

  @override
  void close() => _detector.close();
}
