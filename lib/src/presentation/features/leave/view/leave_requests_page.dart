import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/leave/leave_filter.dart';
import '../../../../domain/entities/leave/leave_request_entity.dart';
import '../../../../domain/entities/leave/leave_status.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/category_filter_chips.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/status_dot_tag.dart';
import '../../../core/widgets/text/typography.dart';
import '../extensions/leave_filter_extension.dart';
import '../extensions/leave_type_extension.dart';
import '../riverpod/leave_approvals_provider.dart';
import '../riverpod/leave_request_action_provider.dart';
import '../widgets/shimmer/shimmer_box.dart';
import '../widgets/shimmer/stat_tile_shimmer.dart';
import '../widgets/stat_tile.dart';

part '../widgets/leave_request_action_card.dart';
part '../widgets/leave_requests_app_bar.dart';
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
  LeaveFilter _selectedFilter = LeaveFilter.all;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onBack(BuildContext context) {
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
    final padding = EdgeInsets.symmetric(
      horizontal: spacing.s16,
      vertical: spacing.s8,
    );

    final approvalsState = ref.watch(leaveApprovalsProvider());

    return Scaffold(
      backgroundColor: color.scaffoldBackground,
      appBar: _LeaveRequestsAppBar(onBack: () => _onBack(context)),
      body: _LeaveRequestsBody(
        padding: padding,
        searchController: _searchController,
        selectedFilter: _selectedFilter,
        onFilterSelected: (filter) => setState(() => _selectedFilter = filter),
        onSearchChanged: () => setState(() {}),
        approvalsState: approvalsState,
        onRetry: () => ref.invalidate(leaveApprovalsProvider),
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
          child: const Icon(Icons.add, size: 28),
        ),
      ),
    );
  }
}
