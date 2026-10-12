import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../firebase_options.dart';
import '../../../../core/di/dependency_injection.dart';
import '../localization_provider/localization_provider.dart';
import '../menu_configuration_provider/menu_configuration_provider.dart';

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

  // WHY awaited only with no cache: the menu is exactly what the server sent,
  // so a restored session with nothing cached would land on a bare Menu tab.
  // With a cache the shell refreshes in the background instead.
  if (ref.read(getUserSessionUseCaseProvider).call() != null &&
      ref.read(menuConfigProvider) == null) {
    await ref.read(menuConfigProvider.notifier).refresh();
  }

  await ref.read(localizationProvider.notifier).setCurrentLocal();

  await ref.read(initializePushNotificationUseCaseProvider).call();

  // WHY not consumed here: a push that launched the app is acted on by the
  // shell, once there is a signed-in user to show the notifications to.
  await ref.read(getInitialPushNotificationMessageUseCaseProvider).call();
}
