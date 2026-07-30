import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/shift_entity.dart';

part 'shift_global_config_provider.g.dart';

@riverpod
class ShiftGlobalConfig extends _$ShiftGlobalConfig {
  @override
  AsyncValue<ShiftGlobalConfigEntity?> build() => const AsyncValue.data(null);

  Future<void> fetch() async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    final Result<ShiftGlobalConfigEntity, Failure> result = await ref
        .read(getShiftGlobalConfigUseCaseProvider)
        .call();

    state = result.when(
      success: AsyncValue.data,
      error: (error) => AsyncValue.error(error, StackTrace.current),
    );
  }
}
