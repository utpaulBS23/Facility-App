import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/login_entity.dart';
import '../application_state/session_provider/session_provider.dart';

/// Shows [child] only when the logged-in user holds [permission]
/// (or any of [anyOf]). Renders [fallback] — default nothing — otherwise.
///
/// Client-side gating is UX only; the server remains the enforcement
/// authority via 403 responses.
class PermissionGate extends ConsumerWidget {
  const PermissionGate({
    super.key,
    this.permission,
    this.anyOf,

    /// single list of permissions thakbe
    this.fallback,
    required this.child,
  }) : assert(
         permission != null || anyOf != null,
         'Provide permission or anyOf',
       );

  final UserPermission? permission;
  final List<UserPermission>? anyOf;
  final Widget? fallback;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // WHY: select() so only gates whose answer changed rebuild on session swap.
    final allowed = ref.watch(
      userSessionProvider.select((session) {
        if (session == null) return false;
        if (permission != null) return session.can(permission!);

        return session.canAny(anyOf!);
      }),
    );

    if (!allowed) return fallback ?? const SizedBox.shrink();

    return child;
  }
}
