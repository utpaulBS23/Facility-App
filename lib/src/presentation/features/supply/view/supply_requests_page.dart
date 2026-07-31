import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/common/paginated_list_entity.dart';
import '../../../../domain/entities/supply/supply_request_entity.dart';
import '../../../../domain/entities/supply/supply_request_status.dart';
import '../../../core/application_state/session_provider/session_provider.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/back_leading.dart';
import '../../../core/widgets/category_filter_chips.dart';
import '../../../core/widgets/status_dot_tag.dart';
import '../../../core/widgets/text/typography.dart';
import '../extensions/supply_status_extension.dart';
import '../models/supply_filter.dart';
import '../riverpod/supply_requests_provider.dart';
import '../widgets/shimmer/shimmer_box.dart';

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
  }

  void _onNewRequest() {
    context.pushNamed(Routes.newRequest);
  }

  void _onRequestTap(SupplyRequestEntity req) {
    context.pushNamed(Routes.requestDetails, extra: req);
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
    final allRequestsAsync = ref.watch(supplyRequestsProvider());
    final canCreateRequest = ref.watch(
      userSessionProvider.select(
        (session) => session?.can(UserPermission.supplyRequestCreate) ?? false,
      ),
    );
    final filteredRequestsAsync = ref.watch(
      supplyRequestsProvider(
        status: _selectedFilter.toRequestStatus(),
      ),
    );

    final allList = allRequestsAsync.valueOrNull?.items ?? [];
    final pendingCount = allList
        .where((r) =>
            r.status == SupplyRequestStatus.pendingSupervisor ||
            r.status == SupplyRequestStatus.pendingOperationManager)
        .length;
    final inDeliveryCount =
        allList.where((r) => r.status == SupplyRequestStatus.inDelivery).length;
    final deliveredCount =
        allList.where((r) => r.status == SupplyRequestStatus.delivered).length;
    final rejectedCount =
        allList.where((r) => r.status == SupplyRequestStatus.rejected).length;
    final approvedCount = allList
        .where((r) => r.status == SupplyRequestStatus.operationManagerApproved)
        .length;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        leading: BackLeading(onTap: () => _onBack(context)),
        leadingWidth: spacing.s100,
        title: Headline2xlTinyText(context.locale.supplyRequests),
        centerTitle: true,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: _SupplyRequestsBody(
        padding: EdgeInsets.all(spacing.s16),
        summary: allRequestsAsync.maybeWhen(
          data: (_) => _SupplySummaryRow(
            pendingCount: pendingCount,
            inDeliveryCount: inDeliveryCount,
            deliveredCount: deliveredCount,
            rejectedCount: rejectedCount,
          ),
          orElse: () => const _SupplySummaryRowShimmer(),
        ),
        pendingDeliveryAlert: approvedCount > 0
            ? PendingDeliveryAlert(
                count: approvedCount,
                onTap: () => _onFilterSelected(
                  SupplyFilter.operationManagerApproved,
                ),
              )
            : null,
        newRequestButton: canCreateRequest
            ? SizedBox(
                width: double.infinity,
                height: spacing.s44,
                child: FilledButton.icon(
                  onPressed: _onNewRequest,
                  icon: const Icon(Icons.add_rounded),
                  label: Text(context.locale.newRequest),
                ),
              )
            : null,
        filterBar: CategoryFilterChips<SupplyFilter>(
          categories: SupplyFilter.values,
          selectedCategory: _selectedFilter,
          onSelected: _onFilterSelected,
          labelBuilder: (filter) => filter.localizedName(context),
        ),
        list: _SupplyRequestsListSection(
          requestsAsync: filteredRequestsAsync,
          onRequestTap: _onRequestTap,
          onRetry: () => ref.invalidate(
            supplyRequestsProvider(status: _selectedFilter.toRequestStatus()),
          ),
        ),
      ),
    );
  }
}
