import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/assignment_entity.dart';
import '../../../../domain/entities/shift_entity.dart';

part 'assignment_provider.g.dart';

@riverpod
class Assignment extends _$Assignment {
  @override
  AsyncValue<AssignmentResponseEntity?> build() => const AsyncValue.data(null);

  Future<void> assign({
    required ShiftEntity shift,
    required int attendantId,
  }) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    final Result<AssignmentResponseEntity, String> result = await ref
        .read(assignStaffUseCaseProvider)
        .call(shift: shift, attendantId: attendantId);

    state = result.when(
      success: (data) => AsyncValue.data(data),
      error: (error) => AsyncValue.error(error, StackTrace.current),
    );
  }
}
