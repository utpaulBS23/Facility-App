import '../../core/base/result.dart';
import '../entities/face_validation_entity.dart';
import '../repositories/face_validation_repository.dart';

final class ValidateFaceUseCase {
  ValidateFaceUseCase(this.repository);

  final FaceValidationRepository repository;

  Future<Result<FaceValidationEntity, String>> call({
    required int partnerId,
    required String imagePath,
    required double lat,
    required double lng,
    required String address,
  }) async {
    final result = await repository.validateFace(
      partnerId: partnerId,
      imagePath: imagePath,
      lat: lat,
      lng: lng,
      address: address,
    );

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Something went wrong'),
    };
  }
}
