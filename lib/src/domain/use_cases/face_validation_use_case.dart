import '../../core/base/result.dart';
import '../entities/face_validation_entity.dart';
import '../repositories/face_validation_repository.dart';

final class ValidateFaceUseCase {
  ValidateFaceUseCase(this.repository);

  final FaceValidationRepository repository;

  Future<Result<FaceValidationEntity, String>> call({
    required int partnerId,
    required String imagePath,
  }) async {
    final result = await repository.validateFace(
      partnerId: partnerId,
      imagePath: imagePath,
    );

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Something went wrong'),
    };
  }
}
