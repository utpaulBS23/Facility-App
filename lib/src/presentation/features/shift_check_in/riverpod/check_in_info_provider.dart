// Author: Claude AI Assistant
// Created: 2026-04-08

import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';

part 'check_in_info_provider.g.dart';

/// Holds the auto-detected check-in information (location and supervisor).
@riverpod
class CheckInInfo extends _$CheckInInfo {
  @override
  AsyncValue<CheckInInfoState?> build() {
    // WHY: Start in loading so the UI never flashes an empty data state
    // before _loadCheckInInfo resolves.
    _loadCheckInInfo();
    return const AsyncValue.loading();
  }

  Future<void> _loadCheckInInfo() async {
    state = const AsyncValue.loading();
    final locationResult = await ref.read(getCurrentLocationUseCaseProvider).call();
    
    state = locationResult.when(
      success: (locationData) => AsyncValue.data(
        CheckInInfoState(
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

/// State containing check-in information.
class CheckInInfoState {
  CheckInInfoState({
    required this.location,
    required this.checkInTime,
    required this.supervisorName,
  });

  final String location;
  final String checkInTime;
  final String supervisorName;
}
