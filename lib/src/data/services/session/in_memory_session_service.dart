part of 'session_service.dart';

class InMemorySessionService implements SessionService {
  String? _accessToken;

  @override
  String? get accessToken => _accessToken;

  @override
  void setAccessToken(String token) => _accessToken = token;

  @override
  void clear() => _accessToken = null;
}
