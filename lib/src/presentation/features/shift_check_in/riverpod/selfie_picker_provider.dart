// Author: Md. Shahin Bashar
// Created: 2026-04-06

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';

part 'selfie_picker_provider.g.dart';

@riverpod
class SelfiePicker extends _$SelfiePicker {
  @override
  AsyncValue<String?> build() => const AsyncValue.data(null);

  Future<void> pickSelfie() async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    final result = await ref.read(pickSelfieUseCaseProvider).call();

    state = AsyncError("error", StackTrace.current);
    return;

    state = switch (result) {
      Success(:final data) => AsyncValue.data(data),
      Error(:final error) => AsyncValue.error(
        error.message,
        StackTrace.current,
      ),
      _ => AsyncValue.error('Something went wrong', StackTrace.current),
    };
  }
}
