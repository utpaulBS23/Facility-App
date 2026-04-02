import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/core/gen/l10n/app_localizations.dart';
import 'src/core/logger/riverpod_log.dart';
import 'src/presentation/core/application_state/localization_provider/localization_provider.dart';
import 'src/presentation/core/router/router.dart';
import 'src/presentation/core/theme/theme.dart';
import 'src/presentation/core/theme/src/theme_data.dart';
import 'src/presentation/core/theme/src/theme_extensions/src/text_style.dart';

void main() {
  runApp(ProviderScope(observers: [RiverpodObserver()], child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localizationProvider);
    // WHY: font family is resolved from the active locale so MyriadPro is
    // used for English and Kalpurush for Bengali. Both themes are rebuilt
    // whenever the locale changes (ref.watch triggers a rebuild).
    final fontFamily = AppFonts.forLocale(locale.languageCode);

    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: 1.5,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: locale,
        theme: $LightThemeData(fontFamily).call(),
        darkTheme: $DarkThemeData(fontFamily).call(),
        themeMode: ThemeMode.light,
        routerConfig: ref.read(goRouterProvider),
      ),
    );
  }
}
