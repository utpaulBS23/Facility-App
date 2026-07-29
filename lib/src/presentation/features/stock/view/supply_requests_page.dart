import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/common/paginated_list_entity.dart';
import '../../../../domain/entities/supply/supply_request_entity.dart';
import '../../../core/application_state/session_provider/session_provider.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/back_leading.dart';
import '../../../core/widgets/status_dot_tag.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/supply_requests_provider.dart';
import '../utils/supply_status_helper.dart';
import '../widgets/shimmer/shimmer_box.dart';

part '../widgets/pending_delivery_alert.dart';
part '../widgets/shimmer/supply_request_shimmer.dart';
part '../widgets/shimmer/supply_summary_row_shimmer.dart';
part '../widgets/supply_filter_bar.dart';
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
  String _selectedFilter = kSupplyFilterAll;
  ProviderSubscription? _requestsSub;

  @override
  void initState() {
    super.initState();
    _listenRequests();
  }

  void _listenRequests() {
    _requestsSub?.close();
    _requestsSub = ref.listenManual(
      supplyRequestsProvider(
        status: supplyStatusCodeForFilter(_selectedFilter),
      ),
      (previous, next) {
        if (next is AsyncError) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.error.toString())),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _requestsSub?.close();
    super.dispose();
  }

  void _onFilterSelected(String filter) {
    if (_selectedFilter == filter) return;
    setState(() => _selectedFilter = filter);
    _listenRequests();
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
        (session) => session?.can(AppPermission.supplyRequestCreate) ?? false,
      ),
    );
    final filteredRequestsAsync = ref.watch(
      supplyRequestsProvider(
        status: supplyStatusCodeForFilter(_selectedFilter),
      ),
    );

    final allList = allRequestsAsync.valueOrNull?.items ?? [];
    final pendingCount = allList
        .where((r) =>
            r.status == 'pending_supervisor' ||
            r.status == 'pending_operation_manager' ||
            r.status == 'operation_manager_approved')
        .length;
    final inDeliveryCount = allList.where((r) => r.status == 'in_delivery').length;
    final deliveredCount = allList.where((r) => r.status == 'delivered').length;
    final rejectedCount = allList.where((r) => r.status == 'rejected').length;

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
        pendingDeliveryAlert: inDeliveryCount > 0
            ? PendingDeliveryAlert(
                onTap: () {
                  final inDelivery = allList.firstWhere(
                    (r) => r.status == 'in_delivery',
                  );
                  _onRequestTap(inDelivery);
                },
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
        filterBar: _SupplyFilterBar(
          filters: kSupplyFilterKeys,
          selectedFilter: _selectedFilter,
          onFilterSelected: _onFilterSelected,
        ),
        list: _SupplyRequestsListSection(
          requestsAsync: filteredRequestsAsync,
          onRequestTap: _onRequestTap,
        ),
      ),
    );
  }
}
