import 'dart:async';
import 'dart:convert';

import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../../core/logger/log.dart';
import '../../domain/entities/login_entity.dart';
import '../../domain/entities/sign_up_entity.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../extension/auth_mapper.dart';
import '../models/login_model.dart';
import '../services/network/rest_client.dart';
import '../services/secure_storage/secure_storage_service.dart';
import '../services/session/session_service.dart';

final class AuthenticationRepositoryImpl extends AuthenticationRepository {
  AuthenticationRepositoryImpl({
    required this.remote,
    required this.session,
    required this.secureStorage,
  }) {
    // WHY: the token is the authority on "authenticated"; this session is
    // derived from it. TokenManager clears the token from inside the Dio
    // interceptor when a refresh fails, on a path this repository cannot see —
    // without this subscription the session outlived its token and the app
    // kept rendering permitted UI that could only produce 401s.
    _tokenClearedSubscription = session.onCleared.listen((_) => _dropSession());
  }

  final RestClient remote;
  final SessionService session;
  final SecureStorageService secureStorage;

  late final StreamSubscription<void> _tokenClearedSubscription;

  UserEntity? _currentUser;

  // WHY: repository is the single source of truth for the session. It is a
  // keepAlive DI singleton; presentation providers stay autoDispose and
  // re-derive from [currentSession] + [watchSession] on every remount.
  UserSessionEntity? _session;
  final StreamController<UserSessionEntity?> _sessionController =
      StreamController<UserSessionEntity?>.broadcast();

  @override
  Future<Result<SignUpResponseEntity, Failure>> register(
    SignUpRequestEntity data,
  ) {
    // TODO: implement register
    return asyncGuard(() async => throw Exception('register not implemented'));
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

      _applySession(entity);
      // WHY: there is no "get current user" endpoint to rehydrate a session
      // from a token alone, so the raw login payload itself is what gets
      // persisted and replayed through the same fromJson/toEntity path on
      // the next cold start (see restoreSession()).
      await secureStorage.save(
        SecureStorageKey.sessionPayload,
        jsonEncode(response.data),
      );

      return entity;
    });
  }

  @override
  Future<bool> restoreSession() async {
    final raw = await secureStorage.read(SecureStorageKey.sessionPayload);
    if (raw == null) return false;

    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final entity = LoginResponseModel.fromJson(json).toEntity();
      _applySession(entity);
      return true;
    } on Exception catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      await secureStorage.delete(SecureStorageKey.sessionPayload);
      return false;
    }
  }

  void _applySession(LoginResponseEntity entity) {
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
      trackingSettings: entity.trackingSettings,
    );
    _sessionController.add(_session);
  }

  @override
  Future<Result<String, Failure>> forgotPassword(Map<String, dynamic> data) {
    // TODO: implement forgotPassword
    return asyncGuard(
      () async => throw Exception('forgotPassword not implemented'),
    );
  }

  @override
  Future<Result<String, Failure>> resetPassword(Map<String, dynamic> data) {
    // TODO: implement resetPassword
    return asyncGuard(
      () async => throw Exception('resetPassword not implemented'),
    );
  }

  @override
  Future<Result<String, Failure>> verifyOTP(Map<String, dynamic> data) {
    // TODO: implement verifyOTP
    return asyncGuard(() async => throw Exception('verifyOTP not implemented'));
  }

  @override
  Future<Result<String, Failure>> resendOTP(Map<String, dynamic> data) {
    // TODO: implement resendOTP
    return asyncGuard(() async => throw Exception('resendOTP not implemented'));
  }

  // WHY: teardown is not duplicated here — clearing the token emits on
  // [SessionService.onCleared] and [_dropSession] does the rest. One path, so
  // an explicit logout and an expired-token logout cannot diverge. The
  // backend call is best-effort: the token may already be invalid or the
  // device offline, and the local session must clear either way.
  @override
  Future<void> logout() async {
    try {
      await remote.logout();
    } on Exception catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
    session.clear();
  }

  void _dropSession() {
    _currentUser = null;
    _session = null;
    _sessionController.add(null);
    unawaited(secureStorage.delete(SecureStorageKey.sessionPayload));
  }

  @override
  void dispose() {
    _tokenClearedSubscription.cancel();
    _sessionController.close();
  }

  @override
  UserEntity? getCurrentUser() => _currentUser;

  @override
  UserSessionEntity? get currentSession => _session;

  @override
  Result<int, Failure> requireActivePartnerId() {
    final partnerId = _session?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);
    return Success(data: partnerId);
  }

  @override
  Stream<UserSessionEntity?> watchSession() => _sessionController.stream;

  @override
  Set<UserPermission> getPermissions() =>
      _session?.permissions ?? const <UserPermission>{};

  @override
  bool hasPermission(UserPermission permission) =>
      _session?.can(permission) ?? false;

  @override
  List<AccessibleFacilityEntity> getAccessibleFacilities() =>
      _session?.accessibleFacilities ?? const [];
}
