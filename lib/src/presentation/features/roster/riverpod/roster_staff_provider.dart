import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/partner_staff_entity.dart';

part 'roster_staff_provider.g.dart';

/// Partner staff directory for the roster feature's assign-staff flow.
///
/// WHY: a separate provider from the shift feature's `partnerStaffProvider`
/// — features don't read each other's providers — even though both wrap the
/// same `GetPartnerStaffUseCase`.
@riverpod
class RosterStaff extends _$RosterStaff {
  @override
  AsyncValue<List<PartnerStaffEntity>> build() => const AsyncValue.data([]);

  Future<void> fetch() async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    final Result<List<PartnerStaffEntity>, String> result = await ref
        .read(getPartnerStaffUseCaseProvider)
        .call();

    state = result.when(
      success: (data) => AsyncValue.data(data ?? []),
      error: (error) => AsyncValue.error(error, StackTrace.current),
    );
  }
}
