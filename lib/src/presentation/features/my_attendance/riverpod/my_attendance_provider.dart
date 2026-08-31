import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/my_attendance_entity.dart';

part 'my_attendance_provider.g.dart';

@riverpod
class MyAttendance extends _$MyAttendance {
  @override
  AsyncValue<MyAttendanceOverviewEntity> build() {
    return const AsyncValue.loading();
  }

  Future<void> fetch({
    required String fromDay,
    required String toDay,
    int? facilityId,
  }) async {
    state = const AsyncValue.loading();

    final Result<MyAttendanceOverviewEntity, Failure> result = await ref
        .read(getMyAttendanceUseCaseProvider)
        .call(fromDay: fromDay, toDay: toDay, facilityId: facilityId);

    state = result.when(
      success: (data) => data != null
          ? AsyncValue.data(data)
          : AsyncValue.error(
              Failure.emptyResponse('load my attendance'),
              StackTrace.current,
            ),
      error: (error) => AsyncValue.error(error, StackTrace.current),
    );
  }
}
