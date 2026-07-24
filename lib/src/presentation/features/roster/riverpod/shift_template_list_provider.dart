import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/shift_template_entity.dart';

part 'shift_template_list_provider.g.dart';

/// Partner-wide shift template catalog — feeds the template picker in
/// [CreateShiftDialog].
@riverpod
class ShiftTemplateList extends _$ShiftTemplateList {
  @override
  AsyncValue<List<ShiftTemplateEntity>> build() => const AsyncValue.data([]);

  Future<void> fetch() async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    final Result<List<ShiftTemplateEntity>, String> result = await ref
        .read(getShiftTemplatesUseCaseProvider)
        .call();

    state = result.when(
      success: (data) => AsyncValue.data(data ?? const []),
      error: (error) => AsyncValue.error(error, StackTrace.current),
    );
  }
}
