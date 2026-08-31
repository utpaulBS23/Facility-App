// Author: Md. Shahin Bashar
// Created: 2026-04-06

import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../../domain/repositories/selfie_repository.dart';
import '../services/media/face_detection_service.dart';

final class SelfieRepositoryImpl extends SelfieRepository {
  SelfieRepositoryImpl(this._faceDetectionService);

  final FaceDetectionService _faceDetectionService;

  @override
  Future<Result<String?, Failure>> validateSelfie(String path) async {
    final detectionResult = await asyncGuard(
      () => _faceDetectionService.hasFace(path),
    );

    return switch (detectionResult) {
      Error(:final error) => Error(error),
      Success(data: final bool? faceFound) when faceFound != true => Error(
        const Failure(
          type: FailureType.validation,
          message: 'No face detected. Please retake the photo.',
        ),
      ),
      _ => Success(data: path),
    };
  }
}
