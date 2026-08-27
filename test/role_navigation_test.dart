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
    test(
      'Attendant sees exactly Dashboard, Shift, Issue, Menu '
      '(Task tab slot now requires taskOccurrenceView — the board content it '
      'shows post-reshuffle — which Attendant does not hold; Attendant\'s '
      'taskView instead unlocks the Issue tab slot, which now shows the task '
      'list)',
      () {
        expect(_tabRoutes(_attendant), {
          Routes.dashboard,
          Routes.shift,
          Routes.issue,
          Routes.menu,
        });
      },
    );

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
      'Operation Manager sees Dashboard, Shift, Tracking, Menu '
      '(the old Issues-tab leak — issueView shared with the Menu "Issue '
      'management" item — no longer applies: the Issue tab slot is now gated '
      'on taskView, which Operation Manager does not hold)',
      () {
        expect(_tabRoutes(_operationManager), {
          Routes.dashboard,
          Routes.shift,
          Routes.tracking,
          Routes.menu,
        });
      },
    );

    test(
      'Partner Owner sees Dashboard, Tracking, Menu '
      '(same resolved Issues-tab leak as Operation Manager, see above)',
      () {
        expect(_tabRoutes(_partnerOwner), {
          Routes.dashboard,
          Routes.tracking,
          Routes.menu,
        });
      },
    );

    test(
      'Technician sees exactly Dashboard, Issue, Menu '
      '(Task tab slot now requires taskOccurrenceView, which Technician does '
      'not hold; taskView instead unlocks the Issue tab slot)',
      () {
        expect(_tabRoutes(_technician), {
          Routes.dashboard,
          Routes.issue,
          Routes.menu,
        });
      },
    );
  });

  group('menuItemConfigs per role', () {
    test('Attendant menu matches matrix', () {
      expect(_menuRoutes(_attendant), {
        Routes.profile,
        Routes.additionalIncome,
        Routes.supplyRequest,
        Routes.leaveRequests,
        Routes.doorLock,
        Routes.facilityExpense,
        Routes.notification,
      });
    });

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
