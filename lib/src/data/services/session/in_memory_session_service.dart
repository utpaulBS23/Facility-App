part of 'session_service.dart';

class InMemorySessionService implements SessionService {
  String? _accessToken;
  final StreamController<void> _clearedController =
      StreamController<void>.broadcast();

  @override
  String? get accessToken => _accessToken;

  @override
  bool get isAuthenticated => _accessToken != null;

  @override
  void setAccessToken(String token) => _accessToken = token;

  // WHY: guard on the already-null case so a logout that races a failed token
  // refresh emits once, not twice — listeners tear down session state on this
  // signal and a second emission would fire against an already-empty session.
  @override
  void clear() {
    if (_accessToken == null) return;
    _accessToken = null;
    _clearedController.add(null);
  }

  @override
  Stream<void> get onCleared => _clearedController.stream;

  @override
  void dispose() => _clearedController.close();
}
