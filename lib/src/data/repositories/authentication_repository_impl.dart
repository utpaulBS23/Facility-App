import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../../domain/entities/login_entity.dart';
import '../../domain/entities/sign_up_entity.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../extension/auth_mapper.dart';
import '../models/login_model.dart';
import '../services/network/rest_client.dart';
import '../services/session/session_service.dart';

final class AuthenticationRepositoryImpl extends AuthenticationRepository {
  AuthenticationRepositoryImpl({
    required this.remote,
    required this.session,
  });

  final RestClient remote;
  final SessionService session;

  UserEntity? _currentUser;

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

      session.setAccessToken(loginResponse.token.accessToken);
      _currentUser = loginResponse.user.toEntity();

      return loginResponse.toEntity();
    });
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
    session.clear();
    _currentUser = null;
  }

  @override
  UserEntity? getCurrentUser() => _currentUser;
}
