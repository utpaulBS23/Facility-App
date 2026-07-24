import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/permission_guard.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/shift_entity.dart';

part 'publish_roster_provider.g.dart';

@riverpod
class PublishRoster extends _$PublishRoster {
  @override
  AsyncValue<RosterEntity?> build() => const AsyncValue.data(null);

  Future<void> publish({required int facilityId, required int rosterId}) async {
    if (state.isLoading) return;

    if (!ref.hasPermission(AppPermission.rosterPublish)) {
      state = AsyncValue.error(permissionDeniedMessage, StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();

    final Result<RosterEntity, String> result = await ref
        .read(publishRosterUseCaseProvider)
        .call(facilityId: facilityId, rosterId: rosterId);

    state = switch (result) {
      Success(:final data) => AsyncValue.data(data),
      Error(:final error) => AsyncValue.error(error, StackTrace.current),
      _ => AsyncValue.error('Something went wrong', StackTrace.current),
    };
  }
}
