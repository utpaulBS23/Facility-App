import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/cash_collection/cash_collection_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/stat_card.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/cash_collections_provider.dart';
import 'manual_income_entry_card.dart';

/// "Manual Income" tab of the expense page: the month's cash collection
/// entries with their summary cards. Facility and month come from the page's
/// own filters.
class ManualIncomeTab extends ConsumerWidget {
  const ManualIncomeTab({
    super.key,
    required this.facilityId,
    required this.month,
  });

  final int? facilityId;
  final String month;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.dimensions.spacing;
    final provider = cashCollectionsProvider(
      facilityId: facilityId,
      month: month,
    );
    final async = ref.watch(provider);

    return RefreshIndicator(
      onRefresh: () async => ref.refresh(provider.future),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(spacing.s16),
        child: switch (async) {
          AsyncData(:final value) => _Content(result: value),
          AsyncError(:final error) => AppErrorWidget(
            message: error.localizedMessage(context),
            onRetry: () => ref.invalidate(provider),
          ),
          _ => const Padding(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: Center(child: CircularProgressIndicator()),
          ),
        },
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.result});

  final CashCollectionListResultEntity result;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final entries = result.list.items;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: StatCard(
                value: context.numbers.number(result.summary.entriesCount),
                label: context.locale.entriesSubmitted,
              ),
            ),
            Gap(spacing.s8),
            Expanded(
              child: StatCard(
                value: context.numbers.currency(result.summary.manualTotal),
                label: context.locale.manualTotal,
                emphasize: true,
              ),
            ),
          ],
        ),
        Gap(spacing.s16),
        if (entries.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: spacing.s32),
            child: Center(
              child: BodySmallText(
                context.locale.noManualIncomeFound,
                color: context.color.text.secondary,
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: entries.length,
            separatorBuilder: (_, _) => Gap(spacing.s12),
            itemBuilder: (context, index) =>
                ManualIncomeEntryCard(entry: entries[index]),
          ),
      ],
    );
  }
}
