import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/entities/profile_payloads.dart';
import '../../domain/repositories/profile_repository.dart';
import '../extension/profile_mapper.dart';
import '../models/profile_model.dart';
import '../services/network/rest_client.dart';

final class ProfileRepositoryImpl extends ProfileRepository {
  ProfileRepositoryImpl({required this.restClient});

  final RestClient restClient;

  @override
  Future<Result<UserProfileEntity, Failure>> getProfile() async {
    return asyncGuard(() async {
      final response = await restClient.getProfile();
      final model = UserProfileModel.fromJson(response.data);

      return model.toEntity();
    });
  }

  @override
  Future<Result<UserProfileEntity, Failure>> updateProfile(
    UpdateProfileEntity request,
  ) async {
    return asyncGuard(() async {
      final response = await restClient.updateProfile(body: request.toJson());
      final model = UserProfileModel.fromJson(response.data);

      return model.toEntity();
    });
  }
}
