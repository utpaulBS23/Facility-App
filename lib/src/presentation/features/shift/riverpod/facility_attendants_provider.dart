import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/attendant_entity.dart';

part 'facility_attendants_provider.g.dart';

@riverpod
class FacilityAttendants extends _$FacilityAttendants {
  @override
  AsyncValue<List<AttendantEntity>> build() => const AsyncValue.data([]);

  Future<void> fetch({required int facilityId}) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    final Result<List<AttendantEntity>, String> result = await ref
        .read(getFacilityAttendantsUseCaseProvider)
        .call(facilityId: facilityId);

    state = result.when(
      success: (data) => AsyncValue.data(data ?? []),
      error: (error) => AsyncValue.error(error, StackTrace.current),
    );
  }
}
