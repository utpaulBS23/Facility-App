import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../entities/profile_entity.dart';
import '../entities/profile_payloads.dart';
import '../repositories/profile_repository.dart';

final class GetProfileUseCase {
  GetProfileUseCase({required this.repository});

  final ProfileRepository repository;

  Future<Result<UserProfileEntity, Failure>> call() async {
    final result = await repository.getProfile();

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('get profile')),
    };
  }
}

final class UpdateProfileUseCase {
  UpdateProfileUseCase({required this.repository});

  final ProfileRepository repository;

  Future<Result<UserProfileEntity, Failure>> call(
    UpdateProfileEntity request,
  ) async {
    final result = await repository.updateProfile(request);

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('update profile')),
    };
  }
}
