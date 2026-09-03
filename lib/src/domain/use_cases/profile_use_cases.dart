import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetProfileUseCase {
  GetProfileUseCase({required this.repository});

  final ProfileRepository repository;

  Future<Result<UserProfileEntity, Failure>> call() => repository.getProfile();
}

class UpdateProfileUseCase {
  UpdateProfileUseCase({required this.repository});

  final ProfileRepository repository;

  Future<Result<UserProfileEntity, Failure>> call({
    String? name,
    String? email,
    String? phoneNumber,
  }) =>
      repository.updateProfile(
        name: name,
        email: email,
        phoneNumber: phoneNumber,
      );
}

class ChangePasswordUseCase {
  ChangePasswordUseCase({required this.repository});

  final ProfileRepository repository;

  Future<Result<UserProfileEntity, Failure>> call({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) =>
      repository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        newPasswordConfirmation: newPasswordConfirmation,
      );
}
