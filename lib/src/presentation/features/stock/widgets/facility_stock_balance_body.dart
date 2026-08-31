import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/stock/facility_stock_balance_entity.dart';
import '../../../core/theme/theme.dart';
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
      data: (page) {
        final items = page.items;
        final summary = page.summary;

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

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (summary != null)
              Row(
                children: [
                  Expanded(
                    child: StockStatTile(
                      value: '${summary.outCount}',
                      label: context.locale.outOfStock,
                    ),
                  ),
                  Gap(spacing.s12),
                  Expanded(
                    child: StockStatTile(
                      value: '${summary.lowCount}',
                      label: context.locale.lowStock,
                    ),
                  ),
                  Gap(spacing.s12),
                  Expanded(
                    child: StockStatTile(
                      value: '${summary.okCount}',
                      label: context.locale.healthy,
                    ),
                  ),
                ],
              )
            else
              StockSummaryRow(
                totalItems: sortedItems.length,
                lastUpdated: _formatDate(sortedItems.first.lastCountedAt),
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

  String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return 'N/A';
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return raw.length >= 10 ? raw.substring(0, 10) : raw;
    final y = parsed.year;
    final m = parsed.month.toString().padLeft(2, '0');
    final d = parsed.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}
