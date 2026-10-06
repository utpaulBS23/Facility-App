import 'package:facility_management_app/src/core/gen/l10n/app_localizations.dart';
import 'package:facility_management_app/src/domain/entities/dashboard_entity.dart';
import 'package:facility_management_app/src/domain/entities/login_entity.dart';
import 'package:facility_management_app/src/presentation/core/application_state/session_provider/session_provider.dart';
import 'package:facility_management_app/src/presentation/core/router/routes.dart';
import 'package:facility_management_app/src/presentation/core/theme/theme.dart';
import 'package:facility_management_app/src/presentation/core/widgets/category_filter_chips.dart';
import 'package:facility_management_app/src/presentation/features/dashboard/riverpod/dashboard_provider.dart';
import 'package:facility_management_app/src/presentation/features/dashboard/view/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

class _FakeSession extends UserSession {
  _FakeSession(this.role, {this.permissions = const {}});

  final UserRole? role;
  final Set<UserPermission> permissions;

  @override
  UserSessionEntity? build() => UserSessionEntity(
    permissions: permissions,
    accessibleFacilities: const [],
    role: role,
  );
}

final _user = UserEntity(
  id: 1,
  name: 'Rahim Uddin',
  email: 'r@x.com',
  userType: 'backend',
  permissionVersion: 1,
  twoFactorEnabled: false,
);

const _shortage = DashboardStaffShortageEntity(
  totalShortage: 3,
  facilityCount: 2,
  items: [
    DashboardShortageItemEntity(
      shiftSlotId: 145,
      weeklyRosterId: 52,
      facilityId: 1,
      facilityName: 'Mirpur 1',
      facilityNameBn: null,
      shiftLabel: 'Mirpur 1 Morning shift',
      shiftStartTime: '08:00',
      shortageCount: 3,
    ),
  ],
);

const _issues = DashboardIssuesEntity(
  totalIssues: 9,
  byStatus: [
    DashboardIssueStatusEntity(
      status: DashboardIssueStatus.open,
      label: 'Open',
      count: 2,
      percentage: 22.2,
    ),
  ],
  summary: DashboardIssueSummaryEntity(
    critical: 2,
    medium: 4,
    total: 9,
    solved: 3,
  ),
  recent: [],
);

const _visitors = DashboardVisitorsEntity(
  date: null,
  male: 142,
  female: 96,
  total: 238,
);

final _supervisor = SupervisorDashboardEntity(
  staffShortage: _shortage,
  month: '2026-10',
  checkInOut: DashboardCheckInOutEntity(
    status: DashboardCheckInStatus.checkedIn,
    checkInAt: DateTime(2026, 10, 6, 8, 15),
    checkOutAt: null,
    facilityName: 'Mirpur-10',
    visitCount: 1,
  ),
  stats: const DashboardStatsEntity(
    todayWorking: 18,
    todayRostered: 23,
    pendingApproval: 4,
    notCheckedIn: 3,
    late: 2,
  ),
  dailyTarget: 2000,
  collection: const [],
  visitorsPerDay: const [],
  facilities: [
    for (final name in ['Mirpur-10', 'Gulshan-2'])
      DashboardFacilitySummaryEntity(
        facilityId: 1,
        facilityName: name,
        facilityNameBn: null,
        targetRevenue: 15000,
        achievedRevenue: 9450,
        achievementPct: 63,
        expense: 3200,
        visitors: _visitors,
        issues: const DashboardIssueBucketsEntity(
          inProgress: 3,
          completed: 1,
          pending: 1,
        ),
      ),
  ],
);

const _ops = OpsManagerDashboardEntity(
  staffShortage: _shortage,
  month: '2026-10',
  executiveTargets: [
    DashboardExecutiveTargetEntity(
      executiveId: 7,
      name: 'Tania Akter',
      target: 30000,
      achieved: 19100,
    ),
  ],
  issues: _issues,
  executives: [
    DashboardExecutiveDetailEntity(
      executiveId: 8,
      name: 'Karim Uddin',
      totalFacility: 1,
      monthlyTarget: 42000,
      facilities: [
        DashboardExecutiveFacilityEntity(
          facilityId: 10,
          facilityName: 'Mirpur-10',
          facilityNameBn: null,
          achievementPct: 63,
          expense: 3200,
          visitorsToday: _visitors,
        ),
      ],
    ),
  ],
);

const _owner = PartnerOwnerDashboardEntity(
  staffShortage: _shortage,
  totalRevenue: DashboardTotalRevenueEntity(
    amount: 45000,
    changePct: 4,
    facilityCount: 6,
  ),
  revenueTrend: [
    DashboardRevenueTrendEntity(label: 'Oct', revenue: 45000, target: 42000),
  ],
  topFacilities: [
    DashboardFacilityRevenueEntity(
      facilityId: 11,
      facilityName: 'Dhanmondi',
      facilityNameBn: null,
      revenue: 12500,
      targetPct: 83,
      changePct: 6,
    ),
  ],
  lowestFacilities: [
    DashboardFacilityRevenueEntity(
      facilityId: 13,
      facilityName: 'Uttara',
      facilityNameBn: null,
      revenue: 1900,
      targetPct: 26,
      changePct: -2,
    ),
  ],
  issues: _issues,
);

String _thisMonth() {
  final now = DateTime.now();

  return '${now.year.toString().padLeft(4, '0')}-'
      '${now.month.toString().padLeft(2, '0')}';
}

Future<void> _pump(
  WidgetTester tester, {
  required UserRole? role,
  required Future<DashboardEntity> Function() load,
}) async {
  tester.view.physicalSize = const Size(390 * 3, 900 * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        userSessionProvider.overrideWith(() => _FakeSession(role)),
        dashboardUserProvider.overrideWithValue(_user),
        dashboardProvider(month: _thisMonth()).overrideWith((ref) => load()),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        theme: $LightThemeData('').call(),
        home: const DashboardPage(),
      ),
    ),
  );
  await tester.pump();
  await tester.pump();
}

void main() {
  testWidgets('supervisor sees own sections only and filters facilities', (
    tester,
  ) async {
    await _pump(
      tester,
      role: UserRole.supervisor,
      load: () async => _supervisor,
    );

    expect(find.text('Welcome, Rahim Uddin'), findsOneWidget);
    expect(find.text('Supervisor'), findsOneWidget);
    expect(find.text('Staff shortage'), findsOneWidget);
    expect(find.textContaining('Mirpur-10 · working since'), findsOneWidget);
    expect(find.text('Today working'), findsOneWidget);
    expect(find.text('Executive details'), findsNothing);
    expect(find.text('Revenue by facility'), findsNothing);
    expect(find.text('Issues by status'), findsNothing);

    await tester.scrollUntilVisible(
      find.text('Facility summary'),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('2 of 2 facilities'), findsOneWidget);

    final chip = find.descendant(
      of: find.byType(CategoryFilterChips<String>),
      matching: find.text('Gulshan-2'),
    );
    await tester.ensureVisible(chip);
    await tester.tap(chip);
    await tester.pump();

    expect(find.text('1 of 2 facilities'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('operations manager sees executives and issues', (tester) async {
    await _pump(tester, role: UserRole.opsManager, load: () async => _ops);

    expect(find.text('Operations Manager'), findsOneWidget);
    expect(find.text('Today working'), findsNothing);

    await tester.scrollUntilVisible(
      find.text('Executive details'),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.scrollUntilVisible(
      find.text('Issues by status'),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Facility summary'), findsNothing);
    expect(find.text('Revenue by facility'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('partner owner sees revenue and issues', (tester) async {
    await _pump(tester, role: UserRole.partnerOwner, load: () async => _owner);

    expect(find.text('Partner Owner'), findsOneWidget);
    expect(find.textContaining('Total revenue'), findsOneWidget);
    expect(find.text('Today working'), findsNothing);
    expect(find.text('Executive details'), findsNothing);

    await tester.scrollUntilVisible(
      find.text('Issues by status'),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Revenue by facility'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('attendant never requests a dashboard', (tester) async {
    var called = false;
    await _pump(
      tester,
      role: UserRole.attendant,
      load: () async {
        called = true;

        return _supervisor;
      },
    );

    expect(find.text('No dashboard for your role.'), findsOneWidget);
    expect(find.text('Staff shortage'), findsNothing);
    expect(called, isFalse);
  });

  testWidgets('a session without role key still asks the server', (
    tester,
  ) async {
    await _pump(tester, role: null, load: () async => _supervisor);

    expect(find.text('Today working'), findsOneWidget);
  });

  testWidgets('a failed load shows retry', (tester) async {
    await _pump(
      tester,
      role: UserRole.supervisor,
      load: () async => throw Exception('boom'),
    );

    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('Assign opens the shift details with path params', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390 * 3, 900 * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, _) => const DashboardPage()),
        GoRoute(
          path: '${Routes.shiftDetails}/:facilityId/:date/:slotId',
          name: Routes.shiftDetails,
          builder: (_, state) => Text(
            'shift ${state.pathParameters['slotId']} '
            'at ${state.pathParameters['facilityId']}',
          ),
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userSessionProvider.overrideWith(
            () => _FakeSession(
              UserRole.supervisor,
              permissions: const {UserPermission.shiftAssignAttendant},
            ),
          ),
          dashboardUserProvider.overrideWithValue(_user),
          dashboardProvider(
            month: _thisMonth(),
          ).overrideWith((ref) async => _supervisor),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          theme: $LightThemeData('').call(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    await tester.tap(find.text('Assign Staff'));
    await tester.pumpAndSettle();

    expect(find.text('shift 145 at 1'), findsOneWidget);
  });

  testWidgets('without shift access Assign does nothing', (tester) async {
    await _pump(tester, role: UserRole.opsManager, load: () async => _ops);

    final button = find.text('Assign Staff');
    expect(button, findsOneWidget);
    await tester.tap(button);
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('owner can switch between top and lowest revenue', (
    tester,
  ) async {
    await _pump(tester, role: UserRole.partnerOwner, load: () async => _owner);

    await tester.scrollUntilVisible(
      find.text('Lowest revenue'),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Dhanmondi'), findsOneWidget);
    expect(find.text('Uttara'), findsNothing);

    await tester.tap(find.text('Lowest revenue'));
    await tester.pump();
    expect(find.text('Uttara'), findsOneWidget);
    expect(find.text('Dhanmondi'), findsNothing);

    await tester.tap(find.text('Top revenue'));
    await tester.pump();
    expect(find.text('Dhanmondi'), findsOneWidget);
  });
}
