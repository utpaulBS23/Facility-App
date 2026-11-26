import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/approval/approval_config_entity.dart';
import '../../../../domain/entities/common/paginated_list_entity.dart';
import '../../../../domain/entities/supply/supply_filters.dart';
import '../../../../domain/entities/supply/supply_request_entity.dart';
import '../../../../domain/entities/supply/supply_request_summary_entity.dart';
import '../../../core/application_state/approval_groups_provider/approval_groups_provider.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/category_filter_chips.dart';
import '../../../core/widgets/category_filter_chips_shimmer.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/status_dot_tag.dart';
import '../extensions/supply_status_extension.dart';
import '../riverpod/supply_request_summary_provider.dart';
import '../riverpod/supply_requests_list_provider.dart';
import '../widgets/shimmer/shimmer_box.dart';
import '../../../core/widgets/menu_item_app_bar.dart';
import '../../../../domain/entities/menu_item_key.dart';

part '../widgets/pending_delivery_alert.dart';
part '../widgets/shimmer/supply_request_shimmer.dart';
part '../widgets/shimmer/supply_summary_row_shimmer.dart';
part '../widgets/supply_request_list_card.dart';
part '../widgets/supply_requests_body.dart';
part '../widgets/supply_requests_list.dart';
part '../widgets/supply_summary_row.dart';

class SupplyRequestsPage extends ConsumerStatefulWidget {
  const SupplyRequestsPage({super.key});

  @override
  ConsumerState<SupplyRequestsPage> createState() => _SupplyRequestsPageState();
}

class _SupplyRequestsPageState extends ConsumerState<SupplyRequestsPage> {
  SupplyFilter _selectedFilter = SupplyFilter.all;

  void _onFilterSelected(SupplyFilter filter) {
    if (_selectedFilter == filter) {
      return;
    }

    setState(() => _selectedFilter = filter);
    ref.read(supplyRequestsListProvider.notifier).filter(filter);
  }

  void _onNewRequest() {
    context.pushNamed(Routes.newRequest);
  }

  void _onRequestTap(SupplyRequestEntity req) {
    context.pushNamed(
      Routes.requestDetails,
      pathParameters: {'id': req.id.toString()},
    );
  }

  @override
  Widget build(BuildContext context) {
    final requestsAsync = ref.watch(supplyRequestsListProvider);
    final summaryAsync = ref.watch(supplyRequestSummaryProvider);
    final groupsAsync = ref.watch(
      approvalGroupsProvider(ApprovalModule.supplyRequest),
    );
    final groups = groupsAsync.valueOrNull ?? const <ApprovalGroupEntity>[];

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: MenuItemAppBar(
        itemKey: MenuItemKey.supplyRequest,
        fallbackTitle: context.locale.supplyRequests,
      ),
      body: _SupplyRequestsBody(
        summaryAsync: summaryAsync,
        selectedFilter: _selectedFilter,
        filters: [
          SupplyFilter.all,
          // WHY a plain "Pending" without groups: the approval configuration
          // is not available to every user, or may not have loaded yet.
          if (groups.isEmpty)
            SupplyFilter.pending
          else
            for (final group in groups)
              SupplyFilter.pendingFor(role: group.role, label: group.label),
          ...SupplyFilter.terminal,
        ],
        // WHY chips wait for the call to finish, with or without a result:
        // the labels depend on it, and showing the fallback first would swap
        // chips.
        filtersLoading: groupsAsync.isLoading,
        filteredRequestsAsync: requestsAsync,
        onFilterSelected: _onFilterSelected,
        onRequestTap: _onRequestTap,
        onRetry: () {
          ref.invalidate(supplyRequestSummaryProvider);
          ref
              .read(supplyRequestsListProvider.notifier)
              .fetch(filter: _selectedFilter);
        },
      ),
      floatingActionButton: PermissionGate(
        permissions: const [UserPermission.supplyRequestCreate],
        child: FloatingActionButton(
          onPressed: _onNewRequest,
          backgroundColor: context.color.primary,
          foregroundColor: context.color.onPrimary,
          child: const Icon(Icons.add_rounded),
        ),
      ),
    );
  }
}
