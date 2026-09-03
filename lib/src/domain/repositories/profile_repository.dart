import '../../core/base/failure.dart';
import '../../core/base/repository.dart';
import '../../core/base/result.dart';
import '../entities/profile_entity.dart';
import '../entities/profile_payloads.dart';

abstract base class ProfileRepository extends Repository {
  Future<Result<UserProfileEntity, Failure>> getProfile();

  Future<Result<UserProfileEntity, Failure>> updateProfile(
    UpdateProfileEntity request,
  );

  Future<Result<void, Failure>> changePassword(
    ChangePasswordEntity request,
  );
}
