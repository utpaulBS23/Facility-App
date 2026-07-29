import '../../core/base/failure.dart';
import '../../core/base/repository.dart';
import '../../core/base/result.dart';
import '../entities/login_entity.dart';
import '../entities/sign_up_entity.dart';

abstract base class AuthenticationRepository extends Repository {
  Future<SignUpResponseEntity> register(SignUpRequestEntity data);

  Future<Result<LoginResponseEntity, Failure>> login(LoginRequestEntity data);

  Future<String> forgotPassword(Map<String, dynamic> data);

  Future<String> resetPassword(Map<String, dynamic> data);

  Future<String> verifyOTP(Map<String, dynamic> data);

  Future<String> resendOTP(Map<String, dynamic> data);

  Future<void> logout();

  UserEntity? getCurrentUser();

  /// Synchronous snapshot of the logged-in session; null when logged out.
  UserSessionEntity? get currentSession;

  /// Emits after every login/logout so listeners rebuild from [currentSession].
  Stream<UserSessionEntity?> watchSession();

  Set<UserPermission> getPermissions();

  bool hasPermission(UserPermission permission);

  List<AccessibleFacilityEntity> getAccessibleFacilities();

  /// Releases the session stream and the token-cleared subscription.
  void dispose();
}
