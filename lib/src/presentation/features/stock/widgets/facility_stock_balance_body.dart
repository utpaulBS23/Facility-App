import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/stock/facility_stock_balance_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../riverpod/facility_stock_balance_provider.dart';
import 'facility_balance_card.dart';
import 'stock_summary_row.dart';

class FacilityStockBalanceBody extends ConsumerWidget {
  const FacilityStockBalanceBody({super.key, required this.facilityId});

  final int? facilityId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.dimensions.spacing;
    final color = context.color;

    if (facilityId == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final balanceAsync = ref.watch(
      facilityStockBalanceProvider(facilityId: facilityId),
    );

    return balanceAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => AppErrorWidget(
        message: err.toString(),
        onRetry: () => ref.invalidate(
          facilityStockBalanceProvider(facilityId: facilityId),
        ),
      ),
      data: (items) {
        if (items.isEmpty) {
          return Center(
            child: Text(
              context.locale.noStockCountRecorded,
              style: context.textStyle.bodyMedium.copyWith(
                color: color.text.secondary,
              ),
            ),
          );
        }

        int statusPriority(FacilityStockStatus status) {
          return switch (status) {
            FacilityStockStatus.out => 0,
            FacilityStockStatus.low => 1,
            FacilityStockStatus.ok => 2,
            FacilityStockStatus.unknown => 3,
          };
        }

        final sortedItems = List<FacilityStockBalanceEntity>.from(items)
          ..sort((a, b) =>
              statusPriority(a.status).compareTo(statusPriority(b.status)));

        final outCount = items.where((i) => i.status == FacilityStockStatus.out).length;
        final lowCount = items.where((i) => i.status == FacilityStockStatus.low).length;
        final okCount = items.where((i) => i.status == FacilityStockStatus.ok).length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: StockStatTile(
                    value: '$outCount',
                    label: context.locale.outOfStock,
                  ),
                ),
                Gap(spacing.s12),
                Expanded(
                  child: StockStatTile(
                    value: '$lowCount',
                    label: context.locale.lowStock,
                  ),
                ),
                Gap(spacing.s12),
                Expanded(
                  child: StockStatTile(
                    value: '$okCount',
                    label: context.locale.healthy,
                  ),
                ),
              ],
            ),
            StockSummaryRow(
              lastUpdated: sortedItems.first.lastCountedAt != null
                  ? DateFormatter.shortDate(
                      DateTime.parse(sortedItems.first.lastCountedAt!).toLocal(),
                    )
                  : context.locale.notAvailable,
            ),
            Gap(spacing.s16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sortedItems.length,
              separatorBuilder: (context, index) => Gap(spacing.s12),
              itemBuilder: (context, index) =>
                  FacilityBalanceCard(item: sortedItems[index]),
            ),
          ],
        );
      },
    );
  }
}
