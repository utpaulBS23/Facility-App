import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/leave/leave_request_entity.dart';
import '../../../core/application_state/session_provider/session_provider.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/back_leading.dart';
import '../../../core/widgets/status_dot_tag.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/leave_approvals_provider.dart';
import '../utils/leave_action_helper.dart';
import '../widgets/shimmer/shimmer_box.dart';
import '../widgets/shimmer/stat_tile_shimmer.dart';
import '../widgets/stat_tile.dart';

part '../widgets/leave_filter_bar.dart';
part '../widgets/leave_request_action_card.dart';
part '../widgets/leave_requests_app_bar.dart';
part '../widgets/leave_requests_body.dart';
part '../widgets/leave_requests_list.dart';
part '../widgets/leave_supervisor_summary_card.dart';
part '../widgets/shimmer/leave_request_shimmer.dart';

const _kLeaveFilters = ['All', 'Pending', 'Manager Approval', 'Approved', 'Rejected'];

const _kStatusForFilter = {
  'Pending': 'pending_supervisor',
  'Manager Approval': 'pending_manager',
  'Approved': 'approved',
  'Rejected': 'rejected',
};

class LeaveRequestsPage extends ConsumerStatefulWidget {
  const LeaveRequestsPage({super.key});

  @override
  ConsumerState<LeaveRequestsPage> createState() => _LeaveRequestsPageState();
}

class _LeaveRequestsPageState extends ConsumerState<LeaveRequestsPage> {
  final _searchController = TextEditingController();
  String _selectedFilter = 'All';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() => _searchQuery = _searchController.text.toLowerCase());
  }

  void _onBack(BuildContext context) {
    // WHY: reachable via LeaveSubmittedPage's goNamed reset (empty stack).
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed(Routes.shift);
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final padding =
        EdgeInsets.symmetric(horizontal: spacing.s16, vertical: spacing.s8);
    final status = _kStatusForFilter[_selectedFilter];
    final approvalsState = ref.watch(leaveApprovalsProvider(status: status));
    final canApplyLeave = ref.watch(
      userSessionProvider.select(
        (session) =>
            (session?.can(AppPermission.leaveRequest) ?? false) ||
            (session?.can(AppPermission.leaveFileOnBehalf) ?? false),
      ),
    );

    return Scaffold(
      backgroundColor: color.scaffoldBackground,
      appBar: _LeaveRequestsAppBar(onBack: () => _onBack(context)),
      body: approvalsState.when(
        loading: () => _LeaveRequestsBody(
          padding: padding,
          searchController: _searchController,
          selectedFilter: _selectedFilter,
          onFilterSelected: (_) {},
          summary: const LeaveSupervisorSummaryCardShimmer(),
          list: _LeaveRequestListShimmer(
            showActionButtons:
                _selectedFilter != 'Approved' && _selectedFilter != 'Rejected',
          ),
        ),
        error: (err, _) => Center(
          child: Text(
            err.toString().replaceAll('Exception: ', ''),
            style:
                context.textStyle.bodyMedium.copyWith(color: color.text.secondary),
          ),
        ),
        data: (requests) => _LeaveRequestsBody(
          padding: padding,
          searchController: _searchController,
          selectedFilter: _selectedFilter,
          onFilterSelected: (filter) => setState(() => _selectedFilter = filter),
          summary: _LeaveSupervisorSummaryCard(
            pendingCount:
                requests.where((r) => r.status == 'pending_supervisor').length,
            managerCount:
                requests.where((r) => r.status == 'pending_manager').length,
          ),
          list: _LeaveRequestsList(
            requests: requests,
            selectedFilter: _selectedFilter,
            searchQuery: _searchQuery,
          ),
        ),
      ),
      floatingActionButton: canApplyLeave
          ? FloatingActionButton(
              onPressed: () => context.pushNamed(Routes.applyLeave),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
              ),
              backgroundColor: color.primary,
              child: const Icon(Icons.add, size: 28),
            )
          : null,
    );
  }
}
