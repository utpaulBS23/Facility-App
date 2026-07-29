import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/supply/supply_request_entity.dart';
import '../../../core/application_state/session_provider/session_provider.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/back_leading.dart';
import '../../../core/widgets/category_filter_chips.dart';
import '../../../core/widgets/status_dot_tag.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/supply_requests_provider.dart';
import '../utils/supply_status_helper.dart';
import '../widgets/shimmer/shimmer_box.dart';

part '../widgets/pending_delivery_alert.dart';
part '../widgets/shimmer/supply_request_shimmer.dart';
part '../widgets/supply_request_list_card.dart';
part '../widgets/supply_summary_row.dart';

class SupplyRequestsPage extends ConsumerStatefulWidget {
  const SupplyRequestsPage({super.key});

  @override
  ConsumerState<SupplyRequestsPage> createState() => _SupplyRequestsPageState();
}

class _SupplyRequestsPageState extends ConsumerState<SupplyRequestsPage> {
  String? _selectedFilter;
  ProviderSubscription? _requestsSub;
  bool _didInitListener = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // WHY: _listenRequests/_selectedFilter default need context.locale,
    // unavailable in initState (InheritedWidget not attached yet). Run once
    // on first dependency pass.
    if (!_didInitListener) {
      _didInitListener = true;
      _selectedFilter = context.locale.all;
      _listenRequests();
    }
  }

  String get _effectiveFilter => _selectedFilter ?? context.locale.all;

  void _listenRequests() {
    _requestsSub?.close();
    _requestsSub = ref.listenManual(
      supplyRequestsProvider(
        status: supplyStatusCodeForFilter(context, _effectiveFilter),
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
        status: supplyStatusCodeForFilter(context, _effectiveFilter),
      ),
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
        leading: BackLeading(onTap: () => _onBack(context)),
        leadingWidth: spacing.s100,
        title: Headline2xlTinyText(context.locale.supplyRequests),
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
            if (canCreateRequest) ...[
              SizedBox(
                width: double.infinity,
                height: spacing.s44,
                child: FilledButton.icon(
                  onPressed: _onNewRequest,
                  icon: const Icon(Icons.add_rounded),
                  label: Text(context.locale.newRequest),
                ),
              ),
              Gap(spacing.s16),
            ],
            CategoryFilterChips(
              categories: supplyFilterLabels(context),
              selectedCategory: _effectiveFilter,
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
                        context.locale.noSupplyRequestsFound,
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
              loading: () => const _SupplyRequestListShimmer(),
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
