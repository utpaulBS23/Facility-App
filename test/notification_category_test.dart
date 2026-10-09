import 'package:facility_management_app/src/data/services/notification/push_notification_service_impl.dart';
import 'package:facility_management_app/src/domain/entities/notification/notification_category.dart';
import 'package:facility_management_app/src/presentation/features/notification/widgets/notification_category_config.dart';
import 'package:facility_management_app/src/presentation/features/notification/widgets/notification_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every known key resolves to its category', () {
    for (final category in NotificationCategory.values) {
      expect(NotificationCategory.fromKey(category.key), category);
    }
  });

  test('an unknown or missing key resolves to nothing', () {
    expect(NotificationCategory.fromKey('brand_new'), isNull);
    expect(NotificationCategory.fromKey(null), isNull);
  });

  test('each category has its own push channel, plus a general one', () {
    final ids = PushNotificationServiceImpl.channels.map((c) => c.id).toList();

    expect(ids, [
      ...NotificationCategory.values.map((category) => category.key),
      PushNotificationServiceImpl.defaultChannelId,
    ]);
    expect(ids.toSet(), hasLength(ids.length));
  });

  test('a push channel is chosen by category, else the general one', () {
    for (final category in NotificationCategory.values) {
      expect(
        PushNotificationServiceImpl.channelFor(category.key).id,
        category.key,
      );
    }
    for (final key in [null, 'brand_new']) {
      expect(
        PushNotificationServiceImpl.channelFor(key).id,
        PushNotificationServiceImpl.defaultChannelId,
      );
    }
  });

  test('every category has an inbox icon, and the rest are the digest', () {
    for (final category in NotificationCategory.values) {
      expect(NotificationListItem.iconKind(category.key), isNot('digest'));
    }
    expect(NotificationListItem.iconKind(null), 'digest');
    expect(NotificationListItem.iconKind('brand_new'), 'digest');
  });

  test('an unknown settings key gets the plain bell', () {
    expect(
      notificationCategoryStyle('brand_new').icon,
      Icons.notifications_none_rounded,
    );
    for (final category in NotificationCategory.values) {
      expect(
        notificationCategoryStyle(category.key).icon,
        isNot(Icons.notifications_none_rounded),
      );
    }
  });
}
