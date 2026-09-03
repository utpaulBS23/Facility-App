import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/profile_entity.dart';
import 'edit_profile_provider.dart';

part 'profile_provider.g.dart';

@riverpod
class Profile extends _$Profile {
  @override
  Future<UserProfileEntity> build() async {
    ref.listen(editProfileProvider, (previous, next) {
      if (next is AsyncData && next.value != null) {
        ref.invalidateSelf();
      }
    });

    final result = await ref.read(getProfileUseCaseProvider)();

    return result.when(
      success: (data) => data!,
      error: (failure) => throw failure,
    );
  }

  Future<void> refreshProfile() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final result = await ref.read(getProfileUseCaseProvider)();

      return result.when(
        success: (data) => data!,
        error: (failure) => throw failure,
      );
    });
  }
}
