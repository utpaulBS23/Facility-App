import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/facility_entity.dart';

part 'facility_list_provider.g.dart';

/// Facilities for the active partner — feeds the facility picker in
/// [CreateRosterDialog].
@riverpod
class FacilityList extends _$FacilityList {
  @override
  AsyncValue<List<FacilityEntity>> build() => const AsyncValue.data([]);

  Future<void> fetch() async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    final Result<FacilityListEntity, String> result = await ref
        .read(getFacilitiesUseCaseProvider)
        .call();

    state = result.when(
      success: (data) => AsyncValue.data(data?.facilities ?? const []),
      error: (error) => AsyncValue.error(error, StackTrace.current),
    );
  }
}
