import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../../domain/entities/login_entity.dart';
import '../../domain/entities/sign_up_entity.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../extension/auth_mapper.dart';
import '../models/login_model.dart';
import '../services/cache/cache_service.dart';
import '../services/network/rest_client.dart';

final class AuthenticationRepositoryImpl extends AuthenticationRepository {
  AuthenticationRepositoryImpl({required this.remote, required this.local});

  final RestClient remote;
  final CacheService local;

  @override
  Future<SignUpResponseEntity> register(SignUpRequestEntity data) async {
    // TODO: implement register
    throw UnimplementedError();
  }

  @override
  Future<Result<LoginResponseEntity, Failure>> login(
    LoginRequestEntity data,
  ) async {
    return asyncGuard(() async {
      final model = data.toModel();
      final response = await remote.login(model.toJson());
      final loginResponse = LoginResponseModel.fromJson(response.data);

      await local.save(CacheKey.accessToken, loginResponse.token.accessToken);

      if (data.shouldRemember ?? false) {
        await local.save(CacheKey.isLoggedIn, true);
      }

      return loginResponse.toEntity();
    });
  }

  @override
  Future<bool> rememberMe({bool? rememberMe}) async {
    try {
      if (rememberMe == null) {
        return local.get<bool>(CacheKey.rememberMe) ?? false;
      }

      await local.save(CacheKey.rememberMe, rememberMe);

      return rememberMe;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String> forgotPassword(Map<String, dynamic> data) {
    // TODO: implement forgotPassword
    throw UnimplementedError();
  }

  @override
  Future<String> resetPassword(Map<String, dynamic> data) {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }

  @override
  Future<String> verifyOTP(Map<String, dynamic> data) {
    // TODO: implement verifyOTP
    throw UnimplementedError();
  }

  @override
  Future<String> resendOTP(Map<String, dynamic> data) {
    // TODO: implement resendOTP
    throw UnimplementedError();
  }

  @override
  Future<void> logout() async {
    await local.remove([
      CacheKey.isLoggedIn,
      CacheKey.rememberMe,
      CacheKey.accessToken,
    ]);
  }
}
