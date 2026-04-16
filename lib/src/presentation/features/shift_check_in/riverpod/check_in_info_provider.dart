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

  Future<void> _loadCheckInInfo() async {
    state = const AsyncValue.loading();
    final locationResult = await ref
        .read(getCurrentLocationUseCaseProvider)
        .call();

    state = locationResult.when(
      success: (locationData) => AsyncValue.data(
        CheckInInfoEntity(
          location: locationData?.address ?? 'Unknown location',
          checkInTime: _formatCurrentTime(),
          supervisorName: 'Md. Shahin Bashar',
        ),
      ),
      error: (error) => AsyncValue.error(error, StackTrace.current),
    );
  }

  String _formatCurrentTime() {
    final now = DateTime.now();
    return DateFormat('EEE, MMM d, y, h:mm a').format(now);
  }
}
