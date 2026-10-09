import 'package:facility_management_app/src/core/base/failure.dart';
import 'package:facility_management_app/src/core/base/result.dart';
import 'package:facility_management_app/src/core/di/dependency_injection.dart';
import 'package:facility_management_app/src/data/extension/notification_preferences_mapper.dart';
import 'package:facility_management_app/src/data/models/notification/notification_preferences_model.dart';
import 'package:facility_management_app/src/domain/entities/notification_preference_entity.dart';
import 'package:facility_management_app/src/domain/repositories/notification_preferences_repository.dart';
import 'package:facility_management_app/src/presentation/features/notification/riverpod/notification_preferences_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _channel(bool enabled, {bool locked = false}) => {
  'enabled': enabled,
  'locked': locked,
};

Map<String, dynamic> _category(
  String key, {
  Map<String, dynamic>? push,
  Object? email = 'default',
}) => {
  'key': key,
  'title': 'Title $key',
  'description': 'About $key',
  'push': push ?? _channel(true),
  'email': email == 'default' ? _channel(true) : email,
};

Map<String, dynamic> _supervisor() => {
  'role': 'supervisor',
  'banner': 'Always on.',
  'categories': [
    _category('odour_breach', push: _channel(true, locked: true)),
    _category('staffing'),
    _category('stock_low', email: _channel(true, locked: true)),
  ],
  'digest': {'enabled': true, 'cadence': 'Weekly, Monday 10:00 AM'},
  'retention_days': 90,
};

NotificationPreferencesEntity _parse(Map<String, dynamic> json) =>
    NotificationPreferencesModel.fromJson(json).toEntity();

final class _FakeRepository extends NotificationPreferencesRepository {
  Failure? failure;
  final saved = <(String, NotificationChannel, bool)>[];
  var loads = 0;

  @override
  Future<Result<NotificationPreferencesEntity, Failure>> getPreferences() async {
    loads++;

    return Success(data: _parse(_supervisor()));
  }

  @override
  Future<Result<NotificationPreferencesEntity, Failure>> setPreference({
    required String category,
    required NotificationChannel channel,
    required bool enabled,
  }) async {
    final error = failure;
    if (error != null) return Error(error);
    saved.add((category, channel, enabled));

    // The server answers with the whole screen, switch applied.
    return Success(
      data: _parse(_supervisor()).withChannel(category, channel, enabled),
    );
  }
}

void main() {
  group('parsing', () {
    test('a locked push is always on and a locked email is digest only', () {
      final settings = _parse(_supervisor());
      final odour = settings.categories[0];
      final stock = settings.categories[2];

      expect(odour.modeOf(NotificationChannel.push),
          NotificationChannelMode.alwaysOn);
      expect(odour.modeOf(NotificationChannel.email),
          NotificationChannelMode.toggle);
      expect(stock.modeOf(NotificationChannel.email),
          NotificationChannelMode.digestOnly);
    });

    test('a null email hides the email tile', () {
      final settings = _parse({
        ..._supervisor(),
        'categories': [_category('issue', email: null)],
        'digest': null,
      });

      expect(settings.categories.single.modeOf(NotificationChannel.email),
          isNull);
      expect(settings.categories.single.modeOf(NotificationChannel.push),
          NotificationChannelMode.toggle);
      expect(settings.digest, isNull);
    });

    test('keeps the server order and the retention days', () {
      final settings = _parse(_supervisor());

      expect(settings.categories.map((item) => item.key),
          ['odour_breach', 'staffing', 'stock_low']);
      expect(settings.retentionDays, 90);
      expect(settings.digest?.cadence, 'Weekly, Monday 10:00 AM');
    });

    test('an unknown category key still parses', () {
      final settings = _parse({
        ..._supervisor(),
        'categories': [_category('brand_new')],
      });

      expect(settings.categories.single.key, 'brand_new');
    });
  });

  group('toggle', () {
    late _FakeRepository repository;
    late ProviderContainer container;

    setUp(() {
      repository = _FakeRepository();
      container = ProviderContainer(
        overrides: [
          notificationPreferencesRepositoryProvider
              .overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);
    });

    Future<NotificationPreferences> load() async {
      await container.read(notificationPreferencesProvider.future);

      return container.read(notificationPreferencesProvider.notifier);
    }

    NotificationPreferencesEntity current() =>
        container.read(notificationPreferencesProvider).requireValue;

    test('a saved switch shows the server answer', () async {
      final notifier = await load();

      final failure = await notifier.setEnabled(
        category: 'staffing',
        channel: NotificationChannel.push,
        enabled: false,
      );

      expect(failure, isNull);
      expect(current().categories[1].push.enabled, isFalse);
      expect(repository.saved, [('staffing', NotificationChannel.push, false)]);
    });

    test('the digest switch changes the digest and no category', () async {
      final notifier = await load();

      await notifier.setEnabled(
        category: NotificationPreferencesEntity.digestKey,
        channel: NotificationChannel.email,
        enabled: false,
      );

      expect(current().digest?.enabled, isFalse);
      expect(current().categories.every((item) => item.email?.enabled ?? true),
          isTrue);
    });

    test('a refusal puts the switch back, reloads and returns why', () async {
      final notifier = await load();
      repository.failure = const Failure(
        type: FailureType.validation,
        message: 'Push for critical alerts is always on.',
      );

      final failure = await notifier.setEnabled(
        category: 'odour_breach',
        channel: NotificationChannel.push,
        enabled: false,
      );

      expect(failure?.message, 'Push for critical alerts is always on.');
      expect(current().categories[0].push.enabled, isTrue);
      expect(repository.loads, 2);
    });
  });
}
