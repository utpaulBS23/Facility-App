part of 'session_service.dart';

class InMemorySessionService implements SessionService {
  String? _accessToken;
  int _weekStartDay = 6;
  bool _hasNotifiedUnauthorized = false;
  // WHY sync: an async broadcast controller delivers to listeners on a
  // microtask, not inside add() itself. AuthenticationRepositoryImpl's
  // teardown (including clearing the persisted session payload) runs from
  // this stream's listener — with async delivery, code that runs right
  // after clear() (e.g. resetRepositories() invalidating and disposing the
  // repository, which cancels this subscription) can race out that pending
  // microtask entirely, so the listener never fires and the persisted
  // session survives a logout. sync:true makes clear() deliver to the
  // listener before it returns.
  final StreamController<void> _clearedController =
      StreamController<void>.broadcast(sync: true);
  final StreamController<void> _unauthorizedController =
      StreamController<void>.broadcast(sync: true);

  @override
  String? get accessToken => _accessToken;

  @override
  bool get isAuthenticated => _accessToken != null;

  @override
  int get weekStartDay => _weekStartDay;

  @override
  void setAccessToken(String token) {
    _accessToken = token;
    _hasNotifiedUnauthorized = false;
  }

  @override
  void setWeekStartDay(int day) {
    _weekStartDay = day;
  }

  // WHY: guard on the already-null case so a logout that races a failed token
  // refresh emits once, not twice — listeners tear down session state on this
  // signal and a second emission would fire against an already-empty session.
  @override
  void clear() {
    if (_accessToken == null) return;
    _accessToken = null;
    _hasNotifiedUnauthorized = false;
    _clearedController.add(null);
  }

  @override
  void notifyUnauthorized() {
    if (_accessToken == null || _hasNotifiedUnauthorized) return;
    _hasNotifiedUnauthorized = true;
    _unauthorizedController.add(null);
  }

  @override
  Stream<void> get onCleared => _clearedController.stream;

  @override
  Stream<void> get onUnauthorized => _unauthorizedController.stream;

  @override
  void dispose() {
    _clearedController.close();
    _unauthorizedController.close();
  }
}
