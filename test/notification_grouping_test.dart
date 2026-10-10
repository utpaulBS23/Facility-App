import 'package:facility_management_app/src/domain/entities/notification/app_notification_entity.dart';
import 'package:facility_management_app/src/presentation/features/notification/extensions/notification_grouping_extension.dart';
import 'package:flutter_test/flutter_test.dart';

AppNotificationEntity _at(int id, DateTime createdAt) => AppNotificationEntity(
  id: id,
  type: AppNotificationType.info,
  severity: AppNotificationSeverity.low,
  category: null,
  title: 'Title $id',
  body: '',
  data: const {},
  createdAt: createdAt,
  isRead: false,
);

void main() {
  test('an empty list has no groups', () {
    expect(<AppNotificationEntity>[].groupByDay(), isEmpty);
  });

  test('items on one day share a group, newest first', () {
    final groups = [
      _at(1, DateTime(2026, 10, 9, 8)),
      _at(2, DateTime(2026, 10, 9, 18)),
      _at(3, DateTime(2026, 10, 9, 12)),
    ].groupByDay();

    expect(groups, hasLength(1));
    expect(groups.single.day, DateTime(2026, 10, 9));
    expect(groups.single.items.map((item) => item.id), [2, 3, 1]);
  });

  test('days are split at local midnight, newest day first', () {
    final groups = [
      _at(1, DateTime(2026, 10, 8, 23, 59)),
      _at(2, DateTime(2026, 10, 9, 0, 0)),
      _at(3, DateTime(2026, 10, 7, 12)),
    ].groupByDay();

    expect(groups.map((group) => group.day), [
      DateTime(2026, 10, 9),
      DateTime(2026, 10, 8),
      DateTime(2026, 10, 7),
    ]);
    expect(groups.map((group) => group.items.single.id), [2, 1, 3]);
  });

  test('items given out of order still group correctly', () {
    final groups = [
      _at(1, DateTime(2026, 10, 9, 9)),
      _at(2, DateTime(2026, 10, 8, 9)),
      _at(3, DateTime(2026, 10, 9, 10)),
      _at(4, DateTime(2026, 10, 8, 10)),
    ].groupByDay();

    expect(groups, hasLength(2));
    expect(groups[0].items.map((item) => item.id), [3, 1]);
    expect(groups[1].items.map((item) => item.id), [4, 2]);
  });

  test('the input list is left as it was', () {
    final items = [
      _at(1, DateTime(2026, 10, 8, 9)),
      _at(2, DateTime(2026, 10, 9, 9)),
    ];

    items.groupByDay();

    expect(items.map((item) => item.id), [1, 2]);
  });
}
