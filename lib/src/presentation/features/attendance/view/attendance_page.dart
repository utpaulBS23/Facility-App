import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/attendance_entity.dart';
import '../../../../domain/entities/login_entity.dart';
import '../../../../domain/entities/my_attendance_entity.dart';
import '../../../../core/utils/api_date.dart';
import '../../../core/application_state/session_provider/session_provider.dart';
import '../../../core/gen/assets.gen.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/duration_formatter.dart';
import '../../../core/widgets/app_bar_filter_button.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../../../core/widgets/facility_picker_sheet.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/month_filter_button.dart';
import '../../../core/widgets/picker_sheet_states.dart';
import '../../../core/widgets/selection_picker_sheet.dart';
import '../../../core/widgets/app_time_field.dart';
import '../../my_attendance/widgets/my_attendance_item.dart';
import '../riverpod/attendance_provider.dart';
import '../riverpod/supervisor_attendance_provider.dart';
import '../../../core/widgets/menu_item_app_bar.dart';
import '../../../../domain/entities/menu_item_key.dart';

part '../widgets/attendance_approve_reject_bar.dart';
part '../widgets/attendance_body.dart';
part '../widgets/attendant_filter_sheet.dart';
part '../widgets/attendance_detail_check_card.dart';
part '../widgets/attendance_detail_info_card.dart';
part '../widgets/attendance_detail_main_card.dart';
part '../widgets/attendance_detail_selfie_card.dart';
part '../widgets/attendance_detail_supervisor_card.dart';
part '../widgets/attendance_detail_tiles.dart';
part '../widgets/attendance_details_body.dart';
part '../widgets/attendance_list_item.dart';
part '../widgets/attendance_stats_card.dart';
part '../widgets/attendance_supervisors_body.dart';
part '../widgets/attendance_status_tag.dart';
part 'attendance_details_page.dart';

class AttendancePage extends ConsumerStatefulWidget {
  const AttendancePage({super.key});

  @override
  ConsumerState<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends ConsumerState<AttendancePage>
    with WidgetsBindingObserver {
  late String _selectedMonth;
  // WHY nullable, separate from _selectedMonth: picking a specific day
  // overrides the month range for that query; picking a month (via
  // MonthFilterButton) clears it back to whole-month mode. Both filters
  // stay visible — only one is active at a time.
  DateTime? _selectedDate;
  int? _selectedFacilityId;
  int? _selectedUserId;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final now = DateTime.now();
    _selectedMonth = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    // WHY today by default: the page opens on who is in right now, not on a
    // whole month. Picking a month clears it.
    _selectedDate = DateTime(now.year, now.month, now.day);
    _selectedFacilityId = _defaultFacilityId;
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    super.dispose();
  }

  // WHY month derives from the picked date, not _selectedMonth: the API
  // clamps from_day/to_day inside month — a day outside the currently
  // selected month would otherwise be clamped away to an empty result (see
  // Attendance Monthly Overview API reference §"Query parameters").
  String get _month {
    if (_selectedDate != null) {
      return '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}';
    }
    return _selectedMonth;
  }

  String? get _fromDay =>
      _selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : null;

  String? get _toDay => _fromDay;

  // WHY a separate range for supervisors: that endpoint has no `month`
  // param, only a day range. A picked day is a one-day range; a month runs
  // to its last day, capped at today since nothing exists in the future.
  ({String from, String to}) get _supervisorRange {
    final date = _selectedDate;
    if (date != null) {
      final day = ApiDate.date(date);
      return (from: day, to: day);
    }
    final parts = _selectedMonth.split('-');
    final start = DateTime(int.parse(parts[0]), int.parse(parts[1]));
    final monthEnd = DateTime(start.year, start.month + 1, 0);
    final now = DateTime.now();
    return (
      from: ApiDate.date(start),
      to: ApiDate.date(monthEnd.isAfter(now) ? now : monthEnd),
    );
  }

  // WHY: a picked day counts only when it is today; otherwise the selected
  // month counts, so the current month still includes today.
  bool get _includesToday {
    final now = DateTime.now();
    final date = _selectedDate;
    if (date != null) {
      return date.year == now.year &&
          date.month == now.month &&
          date.day == now.day;
    }
    return _selectedMonth ==
        '${now.year}-${now.month.toString().padLeft(2, '0')}';
  }

  void _onScroll() {
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 240) {
      if (ref.read(selectedAttendanceTabProvider) ==
          AttendanceTab.supervisors) {
        final range = _supervisorRange;
        ref
            .read(
              supervisorAttendanceProvider(
                fromDay: range.from,
                toDay: range.to,
                facilityId: _selectedFacilityId,
              ).notifier,
            )
            .loadMore();
        return;
      }
      ref
          .read(
            monthlyAttendanceOverviewProvider(
              _month,
              facilityId: _selectedFacilityId,
              userId: _selectedUserId,
              fromDay: _fromDay,
              toDay: _toDay,
            ).notifier,
          )
          .loadMore(
            month: _month,
            facilityId: _selectedFacilityId,
            userId: _selectedUserId,
            fromDay: _fromDay,
            toDay: _toDay,
          );
    }
  }

  // WHY: the app can sit backgrounded for a while — check-ins/outs done
  // elsewhere in that time (or on another device) would otherwise show stale
  // until the user manually changes the month filter.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _onRefresh();
  }

  Future<void> _onRefresh() async {
    ref.invalidate(monthlyAttendanceOverviewProvider);
    try {
      await ref.read(
        monthlyAttendanceOverviewProvider(
          _month,
          facilityId: _selectedFacilityId,
          userId: _selectedUserId,
          fromDay: _fromDay,
          toDay: _toDay,
        ).future,
      );
    } catch (_) {
      // WHY swallowed: a failed background refresh (expired session, no
      // network) shouldn't crash the app — a 401 is already handled globally
      // by the token interceptor (logout/redirect); other failures just
      // leave the list showing its last-known state, same as before this
      // refresh was attempted.
    }
  }

  int? get _defaultFacilityId {
    final facilities = ref.read(userSessionProvider)?.accessibleFacilities;
    if (facilities == null || facilities.isEmpty) return null;
    for (final facility in facilities) {
      if (facility.isPrimary) return facility.id;
    }
    return facilities.first.id;
  }

  void _onItemTap(AttendanceItemEntity item) {
    context.pushNamed(Routes.attendanceDetails, extra: item);
  }

  void _onSupervisorTap(MyAttendanceItemEntity item) {
    context.pushNamed(
      Routes.supervisorAttendanceDetails,
      extra: (userId: item.userId, date: item.date),
    );
  }

  void _onApplyLeave() {
    context.pushNamed(Routes.applyLeave);
  }

  Future<void> _pickFacility(List<AccessibleFacilityEntity> facilities) async {
    final result = await showModalBottomSheet<({int? facilityId})>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FacilityPickerSheet(
        facilities: facilities,
        selectedFacilityId: _selectedFacilityId,
        includeAllOption: true,
      ),
    );
    if (result == null || result.facilityId == _selectedFacilityId) return;
    // WHY reset attendant: the attendant list is scoped to the selected
    // facility — a previously picked attendant may not belong to the newly
    // picked one.
    setState(() {
      _selectedFacilityId = result.facilityId;
      _selectedUserId = null;
    });
  }

  Future<void> _pickAttendant() async {
    final result = await showModalBottomSheet<({int? value})>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AttendantFilterSheet(
        facilityId: _selectedFacilityId,
        selectedUserId: _selectedUserId,
      ),
    );
    if (result == null || result.value == _selectedUserId) return;
    setState(() => _selectedUserId = result.value);
  }

  @override
  Widget build(BuildContext context) {
    final tab = ref.watch(selectedAttendanceTabProvider);
    final isSupervisors = tab == AttendanceTab.supervisors;
    ref.listen(selectedAttendanceTabProvider, (previous, next) {
      // WHY: the attendant picked on one tab means nothing on the other.
      if (previous != next) setState(() => _selectedUserId = null);
    });
    // WHY only the active tab's provider is watched: the other one would
    // fetch in the background for nothing.
    final state = isSupervisors
        ? null
        : ref.watch(
            monthlyAttendanceOverviewProvider(
              _month,
              facilityId: _selectedFacilityId,
              userId: _selectedUserId,
              fromDay: _fromDay,
              toDay: _toDay,
            ),
          );
    final range = _supervisorRange;
    final supervisorsProvider = supervisorAttendanceProvider(
      fromDay: range.from,
      toDay: range.to,
      facilityId: _selectedFacilityId,
    );
    final supervisorsState = isSupervisors
        ? ref.watch(supervisorsProvider)
        : null;
    final facilities =
        ref.watch(userSessionProvider)?.accessibleFacilities ??
        const <AccessibleFacilityEntity>[];
    final hasFacilityFilter = _selectedFacilityId != _defaultFacilityId;
    final hasAttendantFilter = _selectedUserId != null;
    final spacing = context.dimensions.spacing;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: MenuItemAppBar(
        itemKey: MenuItemKey.attendance,
        fallbackTitle: context.locale.attendance,
        isTabByDefault: true,
        actions: [
          PermissionGate(
            permissions: const [UserPermission.supervisorAttendanceView],
            child: AppBarFilterButton<AttendanceTab>(
              title: context.locale.filters,
              icon: Icons.filter_list_rounded,
              currentValue: tab,
              options: [
                (
                  value: AttendanceTab.attendants,
                  label: context.locale.attendants,
                ),
                (
                  value: AttendanceTab.supervisors,
                  label: context.locale.supervisors,
                ),
              ],
              onSelected: (value) => ref
                  .read(selectedAttendanceTabProvider.notifier)
                  .selectTab(value),
            ),
          ),
          MonthOrDateFilterButton(
            month: DateTime(
              int.parse(_selectedMonth.split('-')[0]),
              int.parse(_selectedMonth.split('-')[1]),
            ),
            date: _selectedDate,
            lastDate: DateTime.now(),
            onMonthSelected: (date) => setState(() {
              _selectedMonth =
                  '${date.year}-${date.month.toString().padLeft(2, '0')}';
              _selectedDate = null;
            }),
            onDateSelected: (date) => setState(() => _selectedDate = date),
          ),
          if (facilities.length > 1)
            _FilterIconButton(
              icon: Icons.apartment_outlined,
              hasActiveFilter: hasFacilityFilter,
              onPressed: () => _pickFacility(facilities),
            ),
          // WHY hidden on Supervisors: that endpoint has no person filter.
          if (!isSupervisors)
          PermissionGate(
            permissions: const [
              UserPermission.supervisorAttendanceView,
              UserPermission.attendanceApprove,
            ],
            child: _FilterIconButton(
              icon: Icons.person_outline_rounded,
              hasActiveFilter: hasAttendantFilter,
              onPressed: _pickAttendant,
            ),
          ),
          Gap(spacing.s8),
        ],
      ),
      body: isSupervisors
          ? supervisorsState!.when(
              data: (overview) => _AttendanceSupervisorsBody(
                overview: overview,
                singleDay: range.from == range.to,
                scrollController: _scrollController,
                onItemTap: _onSupervisorTap,
                onRefresh: () async => ref.invalidate(supervisorsProvider),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) =>
                  Center(child: Text(err.localizedMessage(context))),
            )
          : state!.when(
              data: (summary) => PermissionGate(
                permissions: [UserPermission.leaveRequest],
                builder: (context, isGranted) => _AttendanceBody(
                  summary: summary,
                  showNotCheckedIn: _includesToday,
                  onItemTap: _onItemTap,
                  onApplyLeave: _onApplyLeave,
                  showApplyLeave: isGranted,
                  onRefresh: _onRefresh,
                  scrollController: _scrollController,
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) =>
                  Center(child: Text(err.localizedMessage(context))),
            ),
    );
  }
}

class _FilterIconButton extends StatelessWidget {
  const _FilterIconButton({
    required this.icon,
    required this.hasActiveFilter,
    required this.onPressed,
  });

  final IconData icon;
  final bool hasActiveFilter;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(onPressed: onPressed, icon: Icon(icon)),
        if (hasActiveFilter)
          Positioned(
            top: spacing.s8,
            right: spacing.s8,
            child: Container(
              width: spacing.s8,
              height: spacing.s8,
              decoration: BoxDecoration(
                color: context.color.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}
