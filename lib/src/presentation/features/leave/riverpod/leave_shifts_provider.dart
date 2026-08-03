import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/shift_entity.dart';

final leaveShiftsProvider =
    FutureProvider.family<List<ShiftEntity>, String>((ref, date) async {
  final result = await ref.read(getShiftsUseCaseProvider).call(date: date);

  return result.when(
    success: (data) => data ?? const [],
    error: (error) => throw Exception(error.message),
  );
});
