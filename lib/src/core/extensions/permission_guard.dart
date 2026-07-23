import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/app_permission.dart';
import '../di/dependency_injection.dart';

/// Shown when a mutation is attempted without the required permission —
/// reachable only via stale UI or deep links, since gated widgets are hidden.
const String permissionDeniedMessage =
    'You do not have permission to perform this action.';

/// Shown when a partner-scoped surface is opened without an active partner —
/// e.g. a platform (system) user whose login carries no partner. Distinct from
/// [permissionDeniedMessage]: the account is simply out of tenant scope here.
const String partnerUnavailableMessage =
    'This area is not available for your account.';

extension PermissionGuardRef on Ref {
  /// True when the logged-in user holds [permission].
  ///
  /// WHY: mutation notifiers guard with this before calling use cases —
  /// belt-and-suspenders behind widget-level gating; the server's 403 remains
  /// the final authority.
  bool hasPermission(AppPermission permission) =>
      read(hasPermissionUseCaseProvider).call(permission);

  /// The active partner (tenant) scope for the current session, or null when
  /// the user has none (platform/system account).
  ///
  /// WHY: single source every partner-scoped feature reads instead of reaching
  /// into `getCurrentUser().partnerId`. A future partner switcher changes only
  /// the session seed behind this — not the call sites.
  int? get activePartnerId => read(getActivePartnerUseCaseProvider).call();
}

extension PermissionGuardWidgetRef on WidgetRef {
  /// Widget-side twin of [PermissionGuardRef.activePartnerId] — view pages hold
  /// a [WidgetRef], not a [Ref], so they need their own accessor onto the same
  /// session-derived source.
  int? get activePartnerId => read(getActivePartnerUseCaseProvider).call();
}
