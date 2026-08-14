import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/shift_slot_entity.dart';

/// Resolves active facilityId / shiftAssignmentId for Stock Balance page.
final stockShiftSlotsProvider = FutureProvider.family<ShiftSlotsEntity, String>((
  ref,
  date,
) async {
  final result = await ref.read(getShiftSlotsUseCaseProvider).call(date: date);

  return switch (result) {
    Success(:final data) when data != null => data,
    Error(:final error) => throw error,
    _ => throw Failure.emptyResponse('load shift slots'),
  };
});
