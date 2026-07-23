import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/login_entity.dart';

part 'session_provider.g.dart';

// WHY: repository (keepAlive DI singleton) is the single source of truth for
// the session. This provider stays autoDispose: it seeds synchronously from
// the snapshot and subscribes for changes, so any remount re-derives identical
// state. Logout unmounts the shell, disposing this provider, so the next
// login always rebinds to the (possibly recreated) repository instance.
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
