import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/app_localization.dart';
import '../../../../../domain/entities/app_permission.dart';
import '../../../../../domain/entities/stock/shift_stock_count_entity.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/permission_gate.dart';
import '../../../../core/widgets/text/typography.dart';
import '../riverpod/shift_stock_counts_provider.dart';
import '../utils/stock_count_utils.dart';
import 'update_stock_page.dart';

part '../widgets/stock_footer_bar.dart';
part '../widgets/stock_item_card.dart';
part '../widgets/stock_summary_row.dart';

class StockPageArgs {
  const StockPageArgs({
    required this.facilityId,
    this.shiftAssignmentId,
  });

  final int facilityId;

  /// Null when the caller isn't on an active slot — the update button hides.
  final int? shiftAssignmentId;
}

class StockPage extends ConsumerWidget {
  const StockPage({super.key, required this.args});

  final StockPageArgs args;

  void _onBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed(Routes.shift);
    }
  }

  void _onUpdateStockBalances(BuildContext context, int shiftAssignmentId) {
    context.pushNamed(
      Routes.updateStock,
      extra: UpdateStockPageArgs(
        facilityId: args.facilityId,
        shiftAssignmentId: shiftAssignmentId,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = context.color;
    final shiftAssignmentId = args.shiftAssignmentId;

    return Scaffold(
      backgroundColor: color.scaffoldBackground,
      appBar: AppBar(
        leading: AppBackButton(onTap: () => _onBack(context)),
        leadingWidth: AppBackButton.width,
        title: Headline2xlTinyText(context.locale.stock),
        centerTitle: true,
        backgroundColor: color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: _StockBody(facilityId: args.facilityId),
      bottomNavigationBar: shiftAssignmentId == null
          ? null
          : PermissionGate(
              permissions: const [UserPermission.shiftStockCountCreate],
              child: _StockFooterBar(
                onUpdateStockBalances: () =>
                    _onUpdateStockBalances(context, shiftAssignmentId),
              ),
            ),
    );
  }
}

class _StockBody extends ConsumerWidget {
  const _StockBody({required this.facilityId});

  final int facilityId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final countsAsync = ref.watch(
      shiftStockCountsProvider(facilityId: facilityId),
    );

    return countsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => AppErrorWidget(
        message: err.toString(),
        onRetry: () =>
            ref.invalidate(shiftStockCountsProvider(facilityId: facilityId)),
      ),
      data: (history) {
        final latestItems = latestStockCountPerItem(history);

        if (latestItems.isEmpty) {
          return Center(
            child: Text(
              context.locale.noStockCountRecorded,
              style: context.textStyle.bodyMedium.copyWith(
                color: color.text.secondary,
              ),
            ),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(spacing.s16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _StockSummaryRow(
                totalItems: latestItems.length,
                lastUpdated: latestItems.first.reportedDate,
              ),
              Gap(spacing.s16),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: latestItems.length,
                separatorBuilder: (context, index) => Gap(spacing.s12),
                itemBuilder: (context, index) =>
                    _StockItemCard(item: latestItems[index]),
              ),
            ],
          ),
        );
      },
    );
  }
}
