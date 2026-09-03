import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/profile_entity.dart';

part 'profile_provider.g.dart';

@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  @override
  Future<UserProfileEntity> build() async {
    final result = await ref.watch(getProfileUseCaseProvider).call();
    return result.when(
      success: (data) => data!,
      error: (failure) => throw failure,
    );
  }

  Future<void> refreshProfile() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final result = await ref.read(getProfileUseCaseProvider).call();
      return result.when(
        success: (data) => data!,
        error: (failure) => throw failure,
      );
    });
  }
}

@riverpod
class EditProfileNotifier extends _$EditProfileNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<Result<UserProfileEntity, Failure>> updateProfile({
    String? name,
    String? email,
    String? phoneNumber,
  }) async {
    state = const AsyncValue.loading();
    final result = await ref.read(updateProfileUseCaseProvider).call(
          name: name,
          email: email,
          phoneNumber: phoneNumber,
        );

    result.when(
      success: (updatedEntity) {
        state = const AsyncValue.data(null);
        ref.read(profileNotifierProvider.notifier).refreshProfile();
      },
      error: (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
      },
    );

    return result;
  }
}

@riverpod
class ChangePasswordNotifier extends _$ChangePasswordNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<Result<UserProfileEntity, Failure>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    state = const AsyncValue.loading();
    final result = await ref.read(changePasswordUseCaseProvider).call(
          currentPassword: currentPassword,
          newPassword: newPassword,
          newPasswordConfirmation: newPasswordConfirmation,
        );

    result.when(
      success: (_) {
        state = const AsyncValue.data(null);
      },
      error: (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
      },
    );

    return result;
  }
}
