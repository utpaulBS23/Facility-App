import '../../core/base/failure.dart';
import '../../core/base/repository.dart';
import '../../core/base/result.dart';
import '../entities/login_entity.dart';
import '../entities/sign_up_entity.dart';

abstract base class AuthenticationRepository extends Repository {
  Future<Result<SignUpResponseEntity, Failure>> register(
    SignUpRequestEntity data,
  );

  Future<Result<LoginResponseEntity, Failure>> login(LoginRequestEntity data);

  Future<Result<String, Failure>> forgotPassword(Map<String, dynamic> data);

  Future<Result<String, Failure>> resetPassword(Map<String, dynamic> data);

  Future<Result<String, Failure>> verifyOTP(Map<String, dynamic> data);

  Future<Result<String, Failure>> resendOTP(Map<String, dynamic> data);

  Future<void> logout();

  UserEntity? getCurrentUser();

  /// Synchronous snapshot of the logged-in session; null when logged out.
  UserSessionEntity? get currentSession;

  /// Resolves the session's active partner, or [Failure.partnerUnavailable]
  /// when logged out. Use cases call this instead of re-deriving
  /// `currentSession?.activePartnerId` and its null guard individually.
  Result<int, Failure> requireActivePartnerId();

  /// Emits after every login/logout so listeners rebuild from [currentSession].
  Stream<UserSessionEntity?> watchSession();

  Set<UserPermission> getPermissions();

  bool hasPermission(UserPermission permission);

  List<AccessibleFacilityEntity> getAccessibleFacilities();

  /// Releases the session stream and the token-cleared subscription.
  void dispose();
}
