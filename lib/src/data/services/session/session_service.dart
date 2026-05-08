part 'in_memory_session_service.dart';

abstract class SessionService {
  String? get accessToken;

  void setAccessToken(String token);

  void clear();
}
