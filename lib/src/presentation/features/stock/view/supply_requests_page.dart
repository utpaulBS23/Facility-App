import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain/entities/supply/supply_request_entity.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/back_leading.dart';
import '../../../core/widgets/category_filter_chips.dart';
import '../../../core/widgets/status_dot_tag.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/supply_requests_provider.dart';

part '../widgets/pending_delivery_alert.dart';
part '../widgets/supply_request_list_card.dart';
part '../widgets/supply_summary_row.dart';

const List<String> _kSupplyRequestStatuses = [
  'pending_supervisor',
  'pending_operation_manager',
  'operation_manager_approved',
  'in_delivery',
  'delivered',
  'rejected',
];

String _supplyStatusLabel(String status) => switch (status) {
      'pending_supervisor' => 'Pending Supervisor',
      'pending_operation_manager' => 'Pending Operation Manager',
      'operation_manager_approved' => 'Operation Manager Approved',
      'in_delivery' => 'In Delivery',
      'delivered' => 'Delivered',
      'rejected' => 'Rejected',
      _ => status,
    };

final List<String> _kSupplyFilterLabels = [
  'All',
  ..._kSupplyRequestStatuses.map(_supplyStatusLabel),
];

String? _supplyStatusCodeForFilter(String filter) => filter == 'All'
    ? null
    : _kSupplyRequestStatuses.firstWhere((s) => _supplyStatusLabel(s) == filter);

class SupplyRequestsPage extends ConsumerStatefulWidget {
  const SupplyRequestsPage({super.key});

  @override
  ConsumerState<SupplyRequestsPage> createState() => _SupplyRequestsPageState();
}

class _SupplyRequestsPageState extends ConsumerState<SupplyRequestsPage> {
  String _selectedFilter = 'All';
  ProviderSubscription? _requestsSub;

  @override
  void initState() {
    super.initState();
    _listenRequests();
  }

  void _listenRequests() {
    _requestsSub?.close();
    _requestsSub = ref.listenManual(
      supplyRequestsProvider(status: _supplyStatusCodeForFilter(_selectedFilter)),
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

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final allRequestsAsync = ref.watch(supplyRequestsProvider());
    final filteredRequestsAsync = ref.watch(
      supplyRequestsProvider(status: _supplyStatusCodeForFilter(_selectedFilter)),
    );

    final allList = allRequestsAsync.valueOrNull?.items ?? [];
    final pendingCount = allList
        .where((r) =>
            r.status == 'pending_supervisor' ||
            r.status == 'pending_operation_manager')
        .length;
    final inDeliveryCount = allList.where((r) => r.status == 'in_delivery').length;
    final deliveredCount = allList.where((r) => r.status == 'delivered').length;
    final rejectedCount = allList.where((r) => r.status == 'rejected').length;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        leading: const BackLeading(),
        leadingWidth: spacing.s100,
        title: const Headline2xlTinyText('Supply Requests'),
        centerTitle: true,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SupplySummaryRow(
              pendingCount: pendingCount,
              inDeliveryCount: inDeliveryCount,
              deliveredCount: deliveredCount,
              rejectedCount: rejectedCount,
            ),
            Gap(spacing.s16),
            if (inDeliveryCount > 0) ...[
              PendingDeliveryAlert(
                onTap: () {
                  final inDelivery = allList.firstWhere(
                    (r) => r.status == 'in_delivery',
                  );
                  _onRequestTap(inDelivery);
                },
              ),
              Gap(spacing.s16),
            ],
            SizedBox(
              width: double.infinity,
              height: spacing.s44,
              child: FilledButton.icon(
                onPressed: _onNewRequest,
                icon: const Icon(Icons.add_rounded),
                label: const Text('New Request'),
              ),
            ),
            Gap(spacing.s16),
            CategoryFilterChips(
              categories: _kSupplyFilterLabels,
              selectedCategory: _selectedFilter,
              onSelected: _onFilterSelected,
            ),
            Gap(spacing.s16),
            filteredRequestsAsync.when(
              data: (paginated) {
                final requests = paginated.items;
                if (requests.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: spacing.s32),
                      child: Text(
                        'No supply requests found',
                        style: context.textStyle.bodyMedium.copyWith(
                          color: context.color.text.secondary,
                        ),
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: requests.length,
                  separatorBuilder: (context, index) => Gap(spacing.s12),
                  itemBuilder: (context, index) {
                    final req = requests[index];
                    return _SupplyRequestListCard(
                      request: req,
                      onTap: () => _onRequestTap(req),
                    );
                  },
                );
              },
              loading: () => Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: spacing.s32),
                  child: const CircularProgressIndicator(),
                ),
              ),
              error: (err, _) => Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: spacing.s32),
                  child: Text(
                    err.toString(),
                    style: context.textStyle.bodyMedium.copyWith(
                      color: context.color.error,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
