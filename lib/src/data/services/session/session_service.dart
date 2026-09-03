import 'dart:async';

part 'in_memory_session_service.dart';

/// Owns the access token, and with it the answer to *is this app authenticated*.
///
/// WHY: authentication used to have two independent owners — the token here and
/// the session object on `AuthenticationRepositoryImpl` — cleared on separate
/// paths. A failed token refresh clears the token from inside the Dio
/// interceptor, which left the repository holding a session with full
/// permissions that could not authorise a single request. This service is now
/// the single authority: [onCleared] lets session-derived state be torn down
/// with the token that authorised it, so the two can never disagree.
abstract class SessionService {
  String? get accessToken;

  /// True while a token is held. The one source of truth for "logged in".
  bool get isAuthenticated;

  void setAccessToken(String token);

  /// Drops the token and notifies [onCleared]. Idempotent.
  void clear();

  /// Notifies listeners that an unhandled 401 occurred requiring user re-authentication.
  void notifyUnauthorized();

  /// Emits whenever the token is dropped — by an explicit logout or by a
  /// failed refresh. Anything derived from the token must reset on this.
  Stream<void> get onCleared;

  /// Emits whenever a 401 Unauthorized condition occurs.
  Stream<void> get onUnauthorized;

  void dispose();
}
