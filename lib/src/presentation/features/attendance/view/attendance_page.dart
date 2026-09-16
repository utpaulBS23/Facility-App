import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/attendance_entity.dart';
import '../../../../domain/entities/login_entity.dart';
import '../../../core/application_state/session_provider/session_provider.dart';
import '../../../core/gen/assets.gen.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../../../core/widgets/facility_picker_sheet.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/month_filter_button.dart';
import '../../../core/widgets/picker_sheet_states.dart';
import '../../../core/widgets/selection_picker_sheet.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/attendance_provider.dart';

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
part '../widgets/attendance_status_tag.dart';
part 'attendance_details_page.dart';

class AttendancePage extends ConsumerStatefulWidget {
  const AttendancePage({super.key});

  @override
  ConsumerState<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends ConsumerState<AttendancePage> {
  late String _selectedMonth;
  int? _selectedFacilityId;
  int? _selectedUserId;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    _selectedFacilityId = _defaultFacilityId;
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
    final state = ref.watch(
      monthlyAttendanceOverviewProvider(
        _selectedMonth,
        facilityId: _selectedFacilityId,
        userId: _selectedUserId,
      ),
    );
    final facilities =
        ref.watch(userSessionProvider)?.accessibleFacilities ??
        const <AccessibleFacilityEntity>[];
    final hasFacilityFilter = _selectedFacilityId != _defaultFacilityId;
    final hasAttendantFilter = _selectedUserId != null;
    final spacing = context.dimensions.spacing;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        title: DisplaySmallText(context.locale.attendance),
        titleSpacing: spacing.s16,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
        actions: [
          MonthFilterButton(
            selectedMonth: _selectedMonth,
            onChanged: (month) => setState(() => _selectedMonth = month),
          ),
          if (facilities.length > 1)
            _FilterIconButton(
              icon: Icons.location_on_outlined,
              hasActiveFilter: hasFacilityFilter,
              onPressed: () => _pickFacility(facilities),
            ),
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
      body: state.when(
        data: (summary) => PermissionGate(
          permissions: [UserPermission.leaveRequest],
          builder: (context, isGranted) => _AttendanceBody(
            summary: summary,
            onItemTap: _onItemTap,
            onApplyLeave: _onApplyLeave,
            showApplyLeave: isGranted,
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text(err.localizedMessage(context))),
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
