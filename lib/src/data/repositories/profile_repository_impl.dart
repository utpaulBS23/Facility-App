import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../extension/profile_mapper.dart';
import '../models/profile_model.dart';
import '../services/network/rest_client.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({required this.restClient});

  final RestClient restClient;

  @override
  Future<Result<UserProfileEntity, Failure>> getProfile() async {
    try {
      final response = await restClient.getProfile();
      final model = UserProfileModel.fromJson(response.data);
      return Result.success(data: model.toEntity());
    } on Exception catch (e) {
      return Result.error(Failure.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<UserProfileEntity, Failure>> updateProfile({
    String? name,
    String? email,
    String? phoneNumber,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (email != null) body['email'] = email;
      if (phoneNumber != null) body['phone_number'] = phoneNumber;

      final response = await restClient.updateProfile(body: body);
      final model = UserProfileModel.fromJson(response.data);
      return Result.success(data: model.toEntity());
    } on Exception catch (e) {
      return Result.error(Failure.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<UserProfileEntity, Failure>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      final body = <String, dynamic>{
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': newPasswordConfirmation,
      };

      final response = await restClient.updateProfile(body: body);
      final model = UserProfileModel.fromJson(response.data);
      return Result.success(data: model.toEntity());
    } on Exception catch (e) {
      return Result.error(Failure.mapExceptionToFailure(e));
    }
  }
}
