import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/partner_staff_entity.dart';

part 'partner_staff_provider.g.dart';

@riverpod
class PartnerStaff extends _$PartnerStaff {
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
