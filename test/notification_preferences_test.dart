import 'package:facility_management_app/src/core/base/result.dart';
import 'package:facility_management_app/src/data/repositories/notification_preferences_repository_impl.dart';
import 'package:facility_management_app/src/data/services/cache/cache_service.dart';
import 'package:facility_management_app/src/domain/entities/notification_preference_entity.dart';
import 'package:flutter_test/flutter_test.dart';

class _MemoryCache implements CacheService {
  final values = <CacheKey, Object>{};

  @override
  Future<void> save<T>(CacheKey key, T value) async =>
      values[key] = value as Object;

  @override
  T? get<T>(CacheKey key) => values[key] as T?;

  @override
  Future<void> remove(List<CacheKey> keys) async => keys.forEach(values.remove);

  @override
  Future<void> clear() async => values.clear();
}

void main() {
  late _MemoryCache cache;
  late NotificationPreferencesRepositoryImpl repository;

  setUp(() {
    cache = _MemoryCache();
    repository = NotificationPreferencesRepositoryImpl(local: cache);
  });

  Future<Map<NotificationCategory, NotificationPreferenceEntity>> load() async {
    final result = await repository.getPreferences();

    return {
      for (final pref
          in (result as Success).data as List<NotificationPreferenceEntity>)
        pref.category: pref,
    };
  }

  test('starts with each category default', () async {
    final prefs = await load();

    expect(prefs.length, NotificationCategory.values.length);
    expect(prefs[NotificationCategory.cameraDown]!.emailEnabled, isTrue);
    expect(prefs[NotificationCategory.issueRaised]!.emailEnabled, isFalse);
    expect(prefs[NotificationCategory.issueRaised]!.pushEnabled, isTrue);
    expect(prefs[NotificationCategory.weeklyDigest]!.emailEnabled, isTrue);
  });

  test('remembers a changed switch and leaves the others alone', () async {
    await repository.setPreference(
      category: NotificationCategory.issueRaised,
      channel: NotificationChannel.email,
      enabled: true,
    );
    await repository.setPreference(
      category: NotificationCategory.stockLow,
      channel: NotificationChannel.push,
      enabled: false,
    );

    final prefs = await load();
    expect(prefs[NotificationCategory.issueRaised]!.emailEnabled, isTrue);
    expect(prefs[NotificationCategory.issueRaised]!.pushEnabled, isTrue);
    expect(prefs[NotificationCategory.stockLow]!.pushEnabled, isFalse);
    expect(prefs[NotificationCategory.understaffedSlot]!.pushEnabled, isTrue);
  });

  test('refuses to change a locked or digest-only channel', () async {
    final locked = await repository.setPreference(
      category: NotificationCategory.cameraDown,
      channel: NotificationChannel.push,
      enabled: false,
    );
    final digestOnly = await repository.setPreference(
      category: NotificationCategory.stockLow,
      channel: NotificationChannel.email,
      enabled: true,
    );

    expect(locked, isA<Error>());
    expect(digestOnly, isA<Error>());
    final prefs = await load();
    expect(prefs[NotificationCategory.cameraDown]!.pushEnabled, isTrue);
    expect(prefs[NotificationCategory.stockLow]!.emailEnabled, isFalse);
  });

  test('a locked channel stays on even if the stored entry says off', () async {
    cache.values[CacheKey.notificationPreferences] =
        '{"odour_breach":{"push":false,"email":false}}';

    final prefs = await load();

    expect(prefs[NotificationCategory.odourBreach]!.pushEnabled, isTrue);
    expect(prefs[NotificationCategory.odourBreach]!.emailEnabled, isFalse);
  });

  test('a damaged stored value falls back to the defaults', () async {
    cache.values[CacheKey.notificationPreferences] = 'not json';

    final prefs = await load();

    expect(prefs[NotificationCategory.cameraDown]!.emailEnabled, isTrue);
  });
}
