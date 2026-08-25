import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../riverpod/app_update_provider.dart';
import 'app_update_dialog.dart';

class AppUpdateChecker extends ConsumerStatefulWidget {
  const AppUpdateChecker({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AppUpdateChecker> createState() => _AppUpdateCheckerState();
}

class _AppUpdateCheckerState extends ConsumerState<AppUpdateChecker> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkForUpdates());
  }

  Future<void> _checkForUpdates() async {
    final update =
        await ref.read(appUpdateNotifierProvider.notifier).checkForUpdates();

    if (!mounted || update == null || !update.hasUpdate) return;

    AppUpdateDialog.show(context, update);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
