import 'package:facility_management_app/src/domain/entities/login_entity.dart';
import 'package:facility_management_app/src/presentation/core/router/routes.dart';
import 'package:facility_management_app/src/presentation/core/router/shell_tab_config.dart';
import 'package:facility_management_app/src/presentation/features/menu/widgets/menu_item_config.dart';
import 'package:flutter_test/flutter_test.dart';

/// Fixture permission sets, one per role in the source permission matrix
/// (mobile app, Part 2). Pins `permittedShellTabs`/`menuItemConfigs` against
/// the matrix so a future edit to either table can't silently drop or leak a
/// role's tabs/menu items without a test noticing.
const _attendant = {
  UserPermission.insightsDashboardView,
  UserPermission.shiftSlotView,
  UserPermission.shiftSlotCheckIn,
  UserPermission.shiftSlotCheckOut,
  UserPermission.taskView,
  UserPermission.issueView,
  UserPermission.issueCreate,
  UserPermission.profileUpdate,
  UserPermission.additionalIncomeCreate,
  UserPermission.supplyRequestView,
  UserPermission.supplyRequestCreate,
  UserPermission.leaveRequestView,
  UserPermission.leaveRequestCreateOwn,
  UserPermission.doorLockControl,
  UserPermission.facilityExpenseCreate,
  UserPermission.notificationView,
};

const _supervisor = {
  UserPermission.reportFacilityWiseView,
  UserPermission.attendanceView,
  UserPermission.shiftSlotView,
  UserPermission.shiftSlotAssign,
  UserPermission.visitTaskView,
  UserPermission.visitTaskCreate,
  UserPermission.profileUpdate,
  UserPermission.additionalIncomeApprove,
  UserPermission.supplyRequestView,
  UserPermission.supplyRequestCreate,
  UserPermission.supplyRequestApprove,
  UserPermission.facilityExpenseCreate,
  UserPermission.facilityExpenseApprove,
  UserPermission.leaveRequestCreateOwn,
  UserPermission.leaveRequestCreateForOthers,
  UserPermission.leaveRequestApprove,
  UserPermission.facilityMapView,
  UserPermission.notificationView,
};

const _operationManager = {
  UserPermission.reportFacilityWiseView,
  UserPermission.shiftSlotView,
  UserPermission.shiftSlotAssign,
  UserPermission.rosterCreate,
  UserPermission.supervisorTrackingView,
  UserPermission.profileUpdate,
  UserPermission.additionalIncomeView,
  UserPermission.supplyRequestView,
  UserPermission.deliveryTrackingView,
  UserPermission.deliveryComplaintView,
  UserPermission.leaveRequestView,
  UserPermission.leaveRequestCreateOwn,
  UserPermission.issueView,
  UserPermission.issueManage,
  UserPermission.iotGatewayConfigure,
  UserPermission.notificationView,
};

const _partnerOwner = {
  UserPermission.reportFacilityWiseView,
  UserPermission.odourMonitoringView,
  UserPermission.cameraView,
  UserPermission.supervisorTrackingView,
  UserPermission.profileUpdate,
  UserPermission.reportStockConsumptionView,
  UserPermission.leaveRequestView,
  UserPermission.leaveRequestCreateOwn,
  UserPermission.issueView,
  UserPermission.notificationView,
};

const _technician = {
  UserPermission.insightsDashboardView,
  UserPermission.taskView,
  UserPermission.ticketFacilityAccess,
};

Set<String> _tabRoutes(Set<UserPermission> permissions) =>
    permittedShellTabs(permissions).map((tab) => tab.route).toSet();

Set<String> _menuRoutes(Set<UserPermission> permissions) => {
  for (final item in menuItemConfigs)
    if (item.permissions.isEmpty || item.permissions.any(permissions.contains))
      item.route,
};

void main() {
  group('permittedShellTabs per role', () {
    test('Attendant sees exactly Dashboard, Shift, Task, Issues, Menu', () {
      expect(_tabRoutes(_attendant), {
        Routes.dashboard,
        Routes.shift,
        Routes.task,
        Routes.issue,
        Routes.menu,
      });
    });

    test(
      'Supervisor sees Dashboard, Shift, Attendance, Visit, Menu '
      '(Attendance tab leaks in — attendance.view was meant to feed Dashboard '
      'content per the matrix, not gate its own tab; see plan Open Items #1, '
      'left as-is pending a product decision)',
      () {
        expect(_tabRoutes(_supervisor), {
          Routes.dashboard,
          Routes.shift,
          Routes.attendance,
          Routes.myVisits,
          Routes.menu,
        });
      },
    );

    test(
      'Operation Manager sees Dashboard, Shift, Tracking, Issues, Menu '
      '(Issues tab leaks in — issueView is shared between the Attendant Issues '
      'tab and the Menu "Issue management" item; a role needing the Menu item '
      'necessarily also unlocks the tab under a permission-only model. New '
      'finding, not yet in plan Open Items — flag to product/backend before '
      'treating this as resolved)',
      () {
        expect(_tabRoutes(_operationManager), {
          Routes.dashboard,
          Routes.shift,
          Routes.tracking,
          Routes.issue,
          Routes.menu,
        });
      },
    );

    test(
      'Partner Owner sees Dashboard, Tracking, Issues, Menu '
      '(same Issues-tab leak as Operation Manager, see above)',
      () {
        expect(_tabRoutes(_partnerOwner), {
          Routes.dashboard,
          Routes.tracking,
          Routes.issue,
          Routes.menu,
        });
      },
    );

    test('Technician sees exactly Dashboard, Task, Menu', () {
      expect(_tabRoutes(_technician), {
        Routes.dashboard,
        Routes.task,
        Routes.menu,
      });
    });
  });

  group('menuItemConfigs per role', () {
    test(
      'Attendant menu matches matrix '
      '(plus Issue management — issueView alone satisfies that item\'s gate, '
      'same sharing as the Issues-tab leak above)',
      () {
        expect(_menuRoutes(_attendant), {
          Routes.profile,
          Routes.additionalIncome,
          Routes.supplyRequest,
          Routes.leaveRequests,
          Routes.doorLock,
          Routes.facilityExpense,
          Routes.notification,
          Routes.issueManagement,
        });
      },
    );

    test('Supervisor menu matches matrix', () {
      expect(_menuRoutes(_supervisor), {
        Routes.profile,
        Routes.additionalIncome,
        Routes.supplyRequest,
        Routes.leaveRequests,
        Routes.facilityExpense,
        Routes.notification,
        Routes.report,
        Routes.facilityMap,
      });
    });

    test('Operation Manager menu matches matrix', () {
      expect(_menuRoutes(_operationManager), {
        Routes.profile,
        Routes.additionalIncome,
        Routes.supplyRequest,
        Routes.leaveRequests,
        Routes.report,
        Routes.issueManagement,
        Routes.gatewayManagement,
        Routes.notification,
      });
    });

    test(
      'Partner Owner menu matches matrix '
      '(plus Profit report — reportFacilityWiseView is shared with the '
      'Dashboard tab gate, so it also satisfies that menu item)',
      () {
        expect(_menuRoutes(_partnerOwner), {
          Routes.profile,
          Routes.consumptionReport,
          Routes.leaveRequests,
          Routes.issueManagement,
          Routes.notification,
          Routes.report,
        });
      },
    );

    test('Technician has no menu items (matrix defines no Menu row for it)', () {
      expect(_menuRoutes(_technician), <String>{});
    });
  });
}
