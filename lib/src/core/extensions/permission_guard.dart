import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/app_permission.dart';
import '../di/dependency_injection.dart';

/// Shown when a mutation is attempted without the required permission —
/// reachable only via stale UI or deep links, since gated widgets are hidden.
const String permissionDeniedMessage =
    'You do not have permission to perform this action.';

extension PermissionGuardRef on Ref {
  /// True when the logged-in user holds [permission].
  ///
  /// WHY: mutation notifiers guard with this before calling use cases —
  /// belt-and-suspenders behind widget-level gating; the server's 403 remains
  /// the final authority.
  bool hasPermission(AppPermission permission) =>
      read(hasPermissionUseCaseProvider).call(permission);
}
