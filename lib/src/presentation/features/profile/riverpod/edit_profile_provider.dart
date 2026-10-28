import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/profile_entity.dart';
import '../../../../domain/entities/profile_payloads.dart';

part 'edit_profile_provider.g.dart';

@riverpod
class EditProfile extends _$EditProfile {
  /// Holds the saved profile after a successful update, so session-wide
  /// listeners can react to the new values without reloading them.
  @override
  AsyncValue<UserProfileEntity?> build() => const AsyncValue.data(null);

  Future<void> updateProfile(UpdateProfileEntity request) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();
    final result = await ref.read(updateProfileUseCaseProvider)(request);

    state = result.when(
      success: (profile) => AsyncValue.data(profile),
      error: (failure) => AsyncValue.error(failure, StackTrace.current),
    );
  }
}
