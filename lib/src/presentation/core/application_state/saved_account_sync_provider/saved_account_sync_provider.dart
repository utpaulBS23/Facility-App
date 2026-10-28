import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../features/profile/riverpod/edit_profile_provider.dart';

part 'saved_account_sync_provider.g.dart';

/// Keeps the saved account's login-screen thumbnail in step with the signed-in
/// user's profile picture, entirely in the background.
///
/// WHY here and not in the profile or login feature: neither should know the
/// other exists. This is the one place that connects them, like the other
/// session-wide listeners in this folder.
@Riverpod(keepAlive: true)
class SavedAccountSync extends _$SavedAccountSync {
  // WHY delayed: the first screen's own requests go first, so the avatar work
  // never competes with what the user is waiting on.
  static const _startDelay = Duration(seconds: 3);

  @override
  void build() {
    ref.listen(editProfileProvider, (previous, next) {
      if (previous is! AsyncLoading) return;

      final profile = next.valueOrNull;
      if (profile == null) return;

      unawaited(
        ref
            .read(refreshSavedAccountThumbnailUseCaseProvider)
            .call(userId: profile.id, imageUrl: profile.profileImageUrl),
      );
    });
  }

  /// Refreshes the thumbnail once for this signed-in session. Never awaited by
  /// callers and never reports a failure: the initials avatar is the fallback.
  void start() {
    unawaited(_syncAfterDelay());
  }

  Future<void> _syncAfterDelay() async {
    await Future<void>.delayed(_startDelay);
    await ref.read(refreshSavedAccountThumbnailUseCaseProvider).call();
  }
}
