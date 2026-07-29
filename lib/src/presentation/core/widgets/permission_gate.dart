import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/login_entity.dart';
import '../application_state/session_provider/session_provider.dart';

/// Builds against the answer to a permission question: [isGranted] is true
/// when the logged-in user holds at least one of the gate's permissions.
typedef PermissionGateBuilder =
    Widget Function(BuildContext context, bool isGranted);

/// Answers "does this user hold any of [permissions]?".
///
/// Pass [child] to show it only when granted — the overwhelmingly common case,
/// where being denied means showing nothing:
///
/// ```dart
/// PermissionGate(
///   permissions: [UserPermission.rosterCreate],
///   child: FloatingActionButton(onPressed: _onCreate, ...),
/// )
/// ```
///
/// Pass [builder] instead when the answer itself is the input — a flag handed
/// to a child, or content that shows *because* a permission is missing:
///
/// ```dart
/// PermissionGate(
///   permissions: [UserPermission.leaveRequest],
///   builder: (context, isGranted) => _Body(showApplyLeave: isGranted),
/// )
/// ```
///
/// WHY the gate owns the empty case but not the general one: hiding is the
/// default every caller wanted, and spelling out `: const SizedBox.shrink()`
/// at each site was ceremony around an answer that is always "nothing". A
/// caller that needs a real denied state still writes it, via [builder].
///
/// Client-side gating is UX only; the server remains the enforcement
/// authority via 403 responses.
class PermissionGate extends ConsumerWidget {
  const PermissionGate({
    super.key,
    required this.permissions,
    this.child,
    this.builder,
  }) : assert(permissions.length > 0, 'Provide at least one permission'),
       assert(
         (child == null) != (builder == null),
         'Provide exactly one of child or builder',
       );

  /// Holding any one of these grants the gate — an OR, never an AND.
  final List<UserPermission> permissions;

  /// Shown when granted, nothing when denied. Mutually exclusive with
  /// [builder].
  final Widget? child;

  /// Builds both cases from the answer. Mutually exclusive with [child].
  final PermissionGateBuilder? builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // WHY select(): only gates whose answer changed rebuild when the session
    // is swapped, rather than every gate on screen.
    final isGranted = ref.watch(
      userSessionProvider.select((session) {
        return session?.permissions.any((p) => permissions.contains(p)) ??
            false;
      }),
    );

    final build = builder;
    if (build != null) return build(context, isGranted);

    return isGranted ? child! : const SizedBox.shrink();
  }
}

/// Builds against the user's whole permission set.
typedef PermissionSetBuilder =
    Widget Function(BuildContext context, Set<UserPermission> permissions);

/// Hands [builder] every permission the logged-in user holds.
///
/// WHY this exists alongside [PermissionGate]: a few callers can't ask a
/// yes/no question — the navigation shell filters a whole tab list by
/// permission. They need the set, and this keeps the session provider from
/// leaking into feature widgets to get it. Reach for [PermissionGate] first;
/// this is the exception, not the pattern.
class PermissionSetScope extends ConsumerWidget {
  const PermissionSetScope({super.key, required this.builder});

  final PermissionSetBuilder builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissions = ref.watch(
      userSessionProvider.select((session) => session?.permissions),
    );

    return builder(context, permissions ?? const <UserPermission>{});
  }
}
