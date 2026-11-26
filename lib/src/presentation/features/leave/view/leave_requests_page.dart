import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/approval/approval_config_entity.dart';
import '../../../../domain/entities/leave/leave_filter.dart';
import '../../../../domain/entities/leave/leave_request_entity.dart';
import '../../../../domain/entities/leave/leave_summary_entity.dart';
import '../../../core/application_state/approval_groups_provider/approval_groups_provider.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/app_bar_filter_button.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/category_filter_chips.dart';
import '../../../core/widgets/category_filter_chips_shimmer.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/status_dot_tag.dart';
import '../extensions/leave_presentation_extension.dart';
import '../riverpod/leave_requests_provider.dart';
import '../riverpod/leave_summary_provider.dart';
import '../widgets/shimmer/shimmer_box.dart';
import '../widgets/shimmer/stat_tile_shimmer.dart';
import '../widgets/stat_tile.dart';
import '../../../core/widgets/menu_item_app_bar.dart';
import '../../../../domain/entities/menu_item_key.dart';

part '../widgets/leave_request_action_buttons.dart';
part '../widgets/leave_request_action_card.dart';
part '../widgets/leave_requests_body.dart';
part '../widgets/leave_requests_list.dart';
part '../widgets/leave_supervisor_summary_card.dart';
part '../widgets/shimmer/leave_request_shimmer.dart';

class LeaveRequestsPage extends ConsumerStatefulWidget {
  const LeaveRequestsPage({super.key});

  @override
  ConsumerState<LeaveRequestsPage> createState() => _LeaveRequestsPageState();
}

class _LeaveRequestsPageState extends ConsumerState<LeaveRequestsPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  LeaveFilter _selectedFilter = LeaveFilter.all;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 240) {
      ref.read(leaveRequestsProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final padding = EdgeInsets.symmetric(
      horizontal: spacing.s16,
      vertical: spacing.s8,
    );

    final leaveRequestsState = ref.watch(leaveRequestsProvider);
    final currentTab = ref.watch(selectedLeaveTabProvider);
    ref.listen(selectedLeaveTabProvider, (previous, next) {
      if (previous != next) setState(() => _selectedFilter = LeaveFilter.all);
    });
    // WHY only on the approvals tab: the configuration endpoint needs a
    // permission plain users lack, and My leave has no group chips.
    final groupsAsync = currentTab == LeaveTab.leaveApprovals
        ? ref.watch(approvalGroupsProvider(ApprovalModule.leave))
        : null;
    final groups =
        groupsAsync?.valueOrNull ?? const <ApprovalGroupEntity>[];
    // WHY chips wait for the call to finish, with or without a result: the
    // labels depend on it, and showing the fallback first would swap chips.
    final filtersLoading = groupsAsync?.isLoading ?? false;
    final filters = currentTab == LeaveTab.myLeave
        ? LeaveFilter.myLeaveOptions
        : [
            LeaveFilter.all,
            // WHY a plain "Pending" without groups: the configuration may be
            // unavailable to this user or not loaded yet.
            if (groups.isEmpty)
              LeaveFilter.pending
            else
              for (final group in groups)
                LeaveFilter.pendingFor(role: group.role, label: group.label),
            ...LeaveFilter.terminal,
          ];
    // WHY only on the approvals tab: the endpoint needs an approval
    // permission, which a plain attendant does not have.
    final summaryState = currentTab == LeaveTab.leaveApprovals
        ? ref.watch(leaveSummaryProvider)
        : null;

    return Scaffold(
      backgroundColor: color.scaffoldBackground,
      appBar: MenuItemAppBar(
        itemKey: MenuItemKey.leave,
        fallbackTitle: context.locale.leaveRequests,
        actions: [
          PermissionGate(
            permissions: leaveApprovalPermissions,
            builder: (context, canSeeApprovals) {
              if (!canSeeApprovals) {
                if (currentTab != LeaveTab.myLeave) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ref.read(selectedLeaveTabProvider.notifier).selectTab(LeaveTab.myLeave);
                  });
                }
                return const SizedBox.shrink();
              }

              return AppBarFilterButton<LeaveTab>(
                title: context.locale.filters,
                icon: Icons.filter_list_rounded,
                currentValue: currentTab,
                options: [
                  (
                    value: LeaveTab.leaveApprovals,
                    label: context.locale.leaveApprovals,
                  ),
                  (
                    value: LeaveTab.myLeave,
                    label: context.locale.myLeave,
                  ),
                ],
                onSelected: (tab) {
                  ref.read(selectedLeaveTabProvider.notifier).selectTab(tab);
                },
              );
            },
          ),
        ],
      ),
      body: _LeaveRequestsBody(
        padding: padding,
        searchController: _searchController,
        selectedFilter: _selectedFilter,
        filters: filters,
        filtersLoading: filtersLoading,
        currentTab: currentTab,
        onFilterSelected: (filter) {
          setState(() => _selectedFilter = filter);
          ref.read(leaveRequestsProvider.notifier).filter(filter);
        },
        onSearchChanged: () {
          setState(() {});
          ref
              .read(leaveRequestsProvider.notifier)
              .search(_searchController.text.trim());
        },
        leaveRequestsState: leaveRequestsState,
        scrollController: _scrollController,
        hasMore: ref.read(leaveRequestsProvider.notifier).hasMore,
        summaryState: summaryState,
        onRetry: () => ref.read(leaveRequestsProvider.notifier).fetch(),
      ),
      floatingActionButton: PermissionGate(
        permissions: const [
          UserPermission.leaveRequest,
          UserPermission.leaveFileOnBehalf,
        ],
        child: FloatingActionButton(
          onPressed: () => context.pushNamed(Routes.applyLeave),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
          ),
          backgroundColor: color.primary,
          child: Icon(Icons.add, size: context.dimensions.spacing.s30),
        ),
      ),
    );
  }
}
