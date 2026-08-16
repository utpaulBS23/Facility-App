import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/door_lock_entity.dart';

part 'door_status_provider.g.dart';

@riverpod
Future<DoorLockEntity> doorStatus(Ref ref, String facilityId) async {
  final result = await ref
      .read(getDoorStatusUseCaseProvider)
      .call(facilityId: facilityId);

  return switch (result) {
    Success(:final data) when data != null => data,
    Error(:final error) => throw error,
    _ => throw Failure.emptyResponse('get door status'),
  };
}
