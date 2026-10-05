import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/user_tracking_entity.dart';

part 'user_tracking_provider.g.dart';

/// Every user's last known position for the active partner.
@riverpod
Future<UserTrackingEntity> userTracking(Ref ref) async {
  final result = await ref.read(getLivePositionsUseCaseProvider).call();
  return switch (result) {
    Success(:final data?) => data,
    Error(:final error) => throw error,
    _ => throw StateError('Empty live positions response'),
  };
}
