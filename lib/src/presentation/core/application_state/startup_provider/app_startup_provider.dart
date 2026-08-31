import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../firebase_options.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/logger/log.dart';
import '../localization_provider/localization_provider.dart';

part 'app_startup_provider.g.dart';

@Riverpod(keepAlive: true)
Future<void> appStartup(Ref ref) async {
  ref.onDispose(() {
    ref.invalidate(sharedPreferencesProvider);
  });

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await ref.watch(sharedPreferencesProvider.future);

  // WHY here: must resolve before RouterState's post-splash redirect runs,
  // so a still-valid previous login is already applied by the time the
  // router decides between the login screen and a shell tab.
  await ref.read(restoreSessionUseCaseProvider).call();

  await ref.read(localizationProvider.notifier).setCurrentLocal();

  await ref.read(initializePushNotificationUseCaseProvider).call();

  await ref.read(getInitialPushNotificationMessageUseCaseProvider).call();

  final initialPayload = ref.read(getNotificationPayloadUseCaseProvider).call();
  if (initialPayload != null) {
    Log.info('Consumed initial payload: $initialPayload');
  }

  // WHY: no deep-link routing yet — backend hasn't defined a notification
  // type/route contract. Log taps so the payload shape is visible until
  // that contract lands and this can route like the other use cases already
  // support.
  final payloadSubscription = ref
      .read(getNotificationPayloadStreamUseCaseProvider)
      .call()
      .listen((payload) => Log.info('Notification tapped: $payload'));
  ref.onDispose(payloadSubscription.cancel);
}
