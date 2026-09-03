import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<Result<UserProfileEntity, Failure>> getProfile();
  Future<Result<UserProfileEntity, Failure>> updateProfile({
    String? name,
    String? email,
    String? phoneNumber,
  });
  Future<Result<UserProfileEntity, Failure>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  });
}
