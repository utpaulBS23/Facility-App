import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/login_entity.dart';

part 'session_provider.g.dart';

@riverpod
class UserSession extends _$UserSession {
  @override
  UserSessionEntity? build() {
    final subscription = ref
        .read(watchUserSessionUseCaseProvider)
        .call()
        .listen(_onSessionChanged);
    ref.onDispose(subscription.cancel);
    return ref.read(getUserSessionUseCaseProvider).call();
  }

  void _onSessionChanged(UserSessionEntity? session) => state = session;
}
