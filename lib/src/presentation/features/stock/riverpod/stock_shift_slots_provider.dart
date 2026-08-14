import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/shift_slot_entity.dart';

/// Stock module's own copy of the shift-slots lookup — used only to resolve
/// the caller's active `facilityId`/`shiftAssignmentId` for the stock-count
/// endpoints. Deliberately not a re-export of the shift feature's own
/// provider: features don't reach into each other's presentation layer,
/// only the shared domain use case underneath.
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
