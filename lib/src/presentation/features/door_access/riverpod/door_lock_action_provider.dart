import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import 'door_status_provider.dart';

part 'door_lock_action_provider.g.dart';

/// Context for the success banner shown right after an unlock — cleared once
/// the door is locked again or a new facility page is opened.
class DoorUnlockResult {
  DoorUnlockResult({required this.summary, required this.timestamp});

  final String summary;
  final DateTime timestamp;
}

@riverpod
class DoorLockAction extends _$DoorLockAction {
  @override
  AsyncValue<DoorUnlockResult?> build() => const AsyncValue.data(null);

  Future<void> unlock({
    required String facilityId,
    required String summary,
  }) async {
    if (state.isLoading) return;
    state = const AsyncValue.loading();

    final result = await ref
        .read(unlockDoorUseCaseProvider)
        .call(facilityId: facilityId);
    state = switch (result) {
      Success() => AsyncValue.data(
        DoorUnlockResult(summary: summary, timestamp: DateTime.now()),
      ),
      Error(:final error) => AsyncValue.error(error, StackTrace.current),
      _ => AsyncValue.error('Something went wrong', StackTrace.current),
    };

    ref.invalidate(doorStatusProvider(facilityId));
  }

  Future<void> lock({required String facilityId}) async {
    if (state.isLoading) return;
    state = const AsyncValue.loading();

    final result = await ref
        .read(lockDoorUseCaseProvider)
        .call(facilityId: facilityId);
    state = switch (result) {
      Success() => const AsyncValue.data(null),
      Error(:final error) => AsyncValue.error(error, StackTrace.current),
      _ => AsyncValue.error('Something went wrong', StackTrace.current),
    };

    ref.invalidate(doorStatusProvider(facilityId));
  }
}
