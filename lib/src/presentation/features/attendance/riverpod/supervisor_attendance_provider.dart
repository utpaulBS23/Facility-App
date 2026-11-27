import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/my_attendance_entity.dart';

part 'supervisor_attendance_provider.g.dart';

/// Which people the Attendance page lists.
enum AttendanceTab { attendants, supervisors }

@riverpod
class SelectedAttendanceTab extends _$SelectedAttendanceTab {
  @override
  AttendanceTab build() => AttendanceTab.attendants;

  void selectTab(AttendanceTab tab) {
    state = tab;
  }
}

@riverpod
class SupervisorAttendance extends _$SupervisorAttendance {
  bool _loadingMore = false;

  @override
  Future<MyAttendanceOverviewEntity> build({
    required String fromDay,
    required String toDay,
    int? facilityId,
  }) {
    return _load(page: 1);
  }

  Future<MyAttendanceOverviewEntity> _load({required int page}) async {
    final result = await ref
        .read(getSupervisorsAttendanceUseCaseProvider)
        .call(
          fromDay: fromDay,
          toDay: toDay,
          facilityId: facilityId,
          page: page,
        );

    return switch (result) {
      Success(:final data) => data!,
      Error(:final error) => throw error,
      _ => throw Failure.emptyResponse('get supervisors attendance'),
    };
  }

  /// Appends the next page. Does nothing while one is loading or at the end.
  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || _loadingMore) return;

    _loadingMore = true;
    try {
      final next = await _load(page: current.page + 1);

      // WHY re-check: a refresh may have landed while this awaited, and that
      // page no longer follows what is on screen.
      final latest = state.valueOrNull;
      if (latest == null || latest.page != current.page) return;
      state = AsyncData(latest.appended(next));
    } on Object {
      // WHY quiet: the next scroll to the end tries again.
    } finally {
      _loadingMore = false;
    }
  }
}
