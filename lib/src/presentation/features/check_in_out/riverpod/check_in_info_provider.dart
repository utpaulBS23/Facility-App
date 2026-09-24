import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/check_in_info_entity.dart';

part 'check_in_info_provider.g.dart';

/// Holds the auto-detected check-in information (location and supervisor).
@riverpod
class CheckInInfo extends _$CheckInInfo {
  @override
  AsyncValue<CheckInInfoEntity?> build() {
    // WHY: Start in loading so the UI never flashes an empty data state
    // before _loadCheckInInfo resolves.
    _loadCheckInInfo();
    return const AsyncValue.loading();
  }

  /// Re-runs location detection — the retry hook for the "location off"
  /// prompt. Time/supervisor are unaffected by location and never need it.
  Future<void> refresh() => _loadCheckInInfo();

  Future<void> _loadCheckInInfo() async {
    state = const AsyncValue.loading();
    final locationResult = await ref
        .read(getCurrentLocationUseCaseProvider)
        .call();
    final user = ref.read(getCurrentUserUseCaseProvider).call();
    final now = DateTime.now();

    // WHY: time/supervisor don't depend on location — a location failure
    // must not block them, so state is always `.data`, never `.error`.
    state = AsyncValue.data(
      locationResult.when(
        success: (data) => CheckInInfoEntity(
          checkInTime: DateFormat('EEE, MMM d, y, h:mm a').format(now),
          checkInTimeRaw: DateFormat('yyyy-MM-dd HH:mm:ss').format(now),
          supervisorName: user?.supervisor ?? '—',
          location: data?.address,
          latitude: data?.latitude,
          longitude: data?.longitude,
        ),
        error: (failure) => CheckInInfoEntity(
          checkInTime: DateFormat('EEE, MMM d, y, h:mm a').format(now),
          checkInTimeRaw: DateFormat('yyyy-MM-dd HH:mm:ss').format(now),
          supervisorName: user?.supervisor ?? '—',
          locationFailure: failure,
        ),
      ),
    );
  }
}
