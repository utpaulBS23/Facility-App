import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/dependency_injection.dart';
import '../../../core/extensions/app_localization.dart';
import '../application_state/logout_provider/logout_provider.dart';
import '../router/routes.dart';
import '../theme/theme.dart';

class SessionExpiredDialog extends ConsumerStatefulWidget {
  const SessionExpiredDialog({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<SessionExpiredDialog> createState() =>
      _SessionExpiredDialogState();
}

class _SessionExpiredDialogState
    extends ConsumerState<SessionExpiredDialog> {
  StreamSubscription<void>? _subscription;
  bool _isDialogShowing = false;

  @override
  void initState() {
    super.initState();
    final sessionService = ref.read(sessionServiceProvider);
    _subscription = sessionService.onUnauthorized.listen((_) {
      _showSessionExpiredDialog();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _showSessionExpiredDialog() {
    if (_isDialogShowing || !mounted) return;
    _isDialogShowing = true;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: dialogContext.color.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(dialogContext.radius.r12),
        ),
        title: Text(
          dialogContext.locale.sessionExpired,
          style: dialogContext.textStyle.titleMedium.copyWith(
            color: dialogContext.color.text.primary,
          ),
        ),
        content: Text(
          dialogContext.locale.sessionExpiredMessage,
          style: dialogContext.textStyle.bodyRegular.copyWith(
            color: dialogContext.color.text.secondary,
          ),
        ),
        actions: [
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: dialogContext.color.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(dialogContext.radius.r6),
              ),
            ),
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              _isDialogShowing = false;
              try {
                await ref.read(logoutProvider.notifier).call();
              } catch (_) {
                // Ignore errors during network logout call
              } finally {
                if (mounted) {
                  context.goNamed(Routes.login);
                }
              }
            },
            child: Text(
              dialogContext.locale.ok,
              style: dialogContext.textStyle.labelLarge.copyWith(
                color: dialogContext.color.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
