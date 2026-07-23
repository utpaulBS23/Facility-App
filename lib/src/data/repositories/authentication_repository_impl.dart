import 'dart:async';

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

  // WHY: repository is the single source of truth for the session. It is a
  // keepAlive DI singleton; presentation providers stay autoDispose and
  // re-derive from [currentSession] + [watchSession] on every remount.
  UserSessionEntity? _session;
  final StreamController<UserSessionEntity?> _sessionController =
      StreamController<UserSessionEntity?>.broadcast();

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
      final entity = loginResponse.toEntity();

      session.setAccessToken(entity.accessToken);
      _currentUser = entity.user;
      _session = UserSessionEntity(
        permissions: entity.permissions,
        accessibleFacilities: entity.accessibleFacilities,
        partner: entity.partner,
        // WHY: one partner per login → active partner = the user's bound
        // partner. A future switcher swaps this seed for a mutable selection
        // without touching any consumer.
        activePartnerId: entity.user.partnerId,
      );
      _sessionController.add(_session);

      return entity;
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
    _session = null;
    _sessionController.add(null);
  }

  @override
  UserEntity? getCurrentUser() => _currentUser;

  @override
  UserSessionEntity? get currentSession => _session;

  @override
  Stream<UserSessionEntity?> watchSession() => _sessionController.stream;

  @override
  Set<AppPermission> getPermissions() =>
      _session?.permissions ?? const <AppPermission>{};

  @override
  bool hasPermission(AppPermission permission) =>
      _session?.can(permission) ?? false;

  @override
  List<AccessibleFacilityEntity> getAccessibleFacilities() =>
      _session?.accessibleFacilities ?? const [];
}
