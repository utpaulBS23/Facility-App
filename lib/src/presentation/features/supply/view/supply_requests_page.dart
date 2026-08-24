import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../core/utils/number_formatter.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/common/paginated_list_entity.dart';
import '../../../../domain/entities/supply/supply_filters.dart';
import '../../../../domain/entities/supply/supply_request_entity.dart';
import '../../../../domain/entities/supply/supply_request_status.dart';
import '../../../../domain/entities/supply/supply_request_summary_entity.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/category_filter_chips.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/status_dot_tag.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/supply_request_summary_provider.dart';
import '../riverpod/supply_requests_list_provider.dart';
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
    ref.read(supplyRequestsListProvider.notifier).filter(filter);
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
    final requestsAsync = ref.watch(supplyRequestsListProvider);
    final summaryAsync = ref.watch(supplyRequestSummaryProvider);

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        leading: AppBackButton(onTap: () => _onBack(context)),
        leadingWidth: AppBackButton.width,
        title: Headline2xlTinyText(context.locale.supplyRequests),
        centerTitle: true,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: _SupplyRequestsBody(
        summaryAsync: summaryAsync,
        selectedFilter: _selectedFilter,
        filteredRequestsAsync: requestsAsync,
        onFilterSelected: _onFilterSelected,
        onNewRequest: _onNewRequest,
        onRequestTap: _onRequestTap,
        onRetry: () {
          ref.invalidate(supplyRequestSummaryProvider);
          ref.read(supplyRequestsListProvider.notifier).fetch(filter: _selectedFilter);
        },
      ),
    );
  }
}
