import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/dashboard_entity.dart';
import '../../../../domain/entities/login_entity.dart';

part 'dashboard_provider.g.dart';

/// The signed-in user, for the greeting in the dashboard header.
@riverpod
UserEntity? dashboardUser(Ref ref) {
  return ref.read(getCurrentUserUseCaseProvider).call();
}

/// The home dashboard. The server picks its shape from the token's role, so
/// the page switches over the returned [DashboardEntity] subtype.
@riverpod
Future<DashboardEntity> dashboard(Ref ref, {String? month}) async {
  final result = await ref.read(getDashboardUseCaseProvider).call(month: month);
  return switch (result) {
    Success(:final data?) => data,
    Error(:final error) => throw error,
    _ => throw StateError('Empty dashboard response'),
  };
}
