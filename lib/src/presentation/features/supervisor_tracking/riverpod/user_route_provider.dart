import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/user_route_entity.dart';

part 'user_route_provider.g.dart';

/// One user's travel legs for [date] (only the calendar day matters).
@riverpod
Future<UserRouteEntity> userRoute(
  Ref ref, {
  required int userId,
  required DateTime date,
}) async {
  final result = await ref
      .read(getUserRouteUseCaseProvider)
      .call(userId: userId, date: date);
  return switch (result) {
    Success(:final data?) => data,
    Error(:final error) => throw error,
    _ => throw StateError('Empty user route response'),
  };
}
