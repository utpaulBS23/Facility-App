import 'package:facility_management_app/src/core/base/failure.dart';
import 'package:facility_management_app/src/core/base/result.dart';
import 'package:facility_management_app/src/domain/entities/notification/app_notification_entity.dart';
import 'package:facility_management_app/src/domain/entities/notification/notification_preference_entity.dart';
import 'package:facility_management_app/src/domain/repositories/app_notifications_repository.dart';
import 'package:facility_management_app/src/domain/repositories/notification_preferences_repository.dart';
import 'package:facility_management_app/src/domain/use_cases/notification/app_notifications_use_case.dart';
import 'package:facility_management_app/src/domain/use_cases/notification/notification_preferences_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

/// Answers every call with a success that carries no data.
final class _EmptyInbox extends AppNotificationsRepository {
  @override
  Future<Result<AppNotificationListEntity, Failure>> getNotifications({
    required AppNotificationFilter filter,
    required int page,
  }) async => const Success();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _EmptyPreferences extends NotificationPreferencesRepository {
  @override
  Future<Result<NotificationPreferencesEntity, Failure>> getPreferences() async =>
      const Success();

  @override
  Future<Result<NotificationPreferencesEntity, Failure>> setPreference({
    required String category,
    required NotificationChannel channel,
    required bool enabled,
  }) async => const Success();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('a feed success with no data is reported as an empty response', () async {
    final result = await GetAppNotificationsUseCase(_EmptyInbox())(
      filter: AppNotificationFilter.all,
      page: 1,
    );

    expect(result, isA<Error<AppNotificationListEntity, Failure>>());
  });

  test('preferences with no data are reported as an empty response', () async {
    final result = await GetNotificationPreferencesUseCase(
      _EmptyPreferences(),
    )();

    expect(result, isA<Error<NotificationPreferencesEntity, Failure>>());
  });

  test('a saved preference with no data is reported as an empty response',
      () async {
    final result = await SetNotificationPreferenceUseCase(_EmptyPreferences())(
      category: 'staffing',
      channel: NotificationChannel.push,
      enabled: true,
    );

    expect(result, isA<Error<NotificationPreferencesEntity, Failure>>());
  });
}
