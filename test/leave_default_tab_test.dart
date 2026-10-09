import 'package:facility_management_app/src/domain/entities/app_permission.dart';
import 'package:facility_management_app/src/domain/entities/login_entity.dart';
import 'package:facility_management_app/src/presentation/core/application_state/session_provider/session_provider.dart';
import 'package:facility_management_app/src/presentation/features/leave/riverpod/leave_requests_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _Session extends UserSession {
  _Session(this._permissions);

  final Set<UserPermission> _permissions;

  @override
  UserSessionEntity? build() =>
      UserSessionEntity(permissions: _permissions, accessibleFacilities: const []);
}

LeaveTab _defaultTab(Set<UserPermission> permissions) {
  final container = ProviderContainer(
    overrides: [userSessionProvider.overrideWith(() => _Session(permissions))],
  );
  addTearDown(container.dispose);

  return container.read(selectedLeaveTabProvider);
}

void main() {
  test('an approver starts on leave approvals, at any step', () {
    for (final p in leaveApprovalPermissions) {
      expect(_defaultTab({p}), LeaveTab.leaveApprovals);
    }
  });

  test('anyone else starts on my leave', () {
    expect(_defaultTab({UserPermission.leaveRequest}), LeaveTab.myLeave);
    expect(_defaultTab(const {}), LeaveTab.myLeave);
  });
}
