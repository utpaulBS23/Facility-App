import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/cash_collection/cash_collection_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/cash_collections_provider.dart';

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
              child: _StatCard(
                value: context.numbers.number(result.summary.entriesCount),
                label: context.locale.entriesSubmitted,
              ),
            ),
            Gap(spacing.s8),
            Expanded(
              child: _StatCard(
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
            itemBuilder: (context, index) => _EntryCard(entry: entries[index]),
          ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    this.emphasize = false,
  });

  final String value;
  final String label;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      padding: EdgeInsets.all(spacing.s12),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        border: Border.all(color: context.color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: context.textStyle.labelLarge.copyWith(
              color: emphasize
                  ? context.color.primary
                  : context.color.text.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Gap(spacing.s4),
          BodySmallText(label, color: context.color.text.secondary),
        ],
      ),
    );
  }
}

class _EntryCard extends StatelessWidget {
  const _EntryCard({required this.entry});

  final CashCollectionEntity entry;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;
    final note = entry.note;

    Widget iconLine(IconData icon, String text) => Row(
      children: [
        Icon(icon, size: spacing.s14, color: color.text.secondary),
        Gap(spacing.s4),
        Expanded(child: BodySmallText(text, color: color.text.secondary)),
      ],
    );

    return Material(
      color: color.onPrimary,
      borderRadius: BorderRadius.circular(radius.r12),
      child: InkWell(
        borderRadius: BorderRadius.circular(radius.r12),
        onTap: () => _showDetails(context),
        child: Container(
          padding: EdgeInsets.all(spacing.s16),
          decoration: BoxDecoration(
            border: Border.all(color: color.borderSubtle),
            borderRadius: BorderRadius.circular(radius.r12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              iconLine(
                Icons.access_time_rounded,
                DateFormatter.shortDate(entry.collectionDate),
              ),
              Gap(spacing.s4),
              iconLine(
                Icons.location_on_outlined,
                entry.localizedFacilityName(context.languageCode),
              ),
              Gap(spacing.s8),
              Text(
                context.numbers.currency(entry.totalCashAmount),
                style: context.textStyle.headlineTiny.copyWith(
                  color: color.primary,
                ),
              ),
              if (entry.productSellingAmount > 0 ||
                  entry.rentingOthersAmount > 0) ...[
                Gap(spacing.s4),
                BodySmallText(
                  '${context.locale.productSellingBdt}: '
                  '${context.numbers.currency(entry.productSellingAmount)} · '
                  '${context.locale.rentingOthersBdt}: '
                  '${context.numbers.currency(entry.rentingOthersAmount)}',
                  color: color.text.secondary,
                ),
              ],
              if (note != null && note.isNotEmpty) ...[
                Gap(spacing.s4),
                BodySmallText(note, color: color.text.secondary),
              ],
              Gap(spacing.s12),
              iconLine(
                Icons.person_outline_rounded,
                '${context.locale.recordedBy}: '
                '${entry.localizedSubmittedByName(context.languageCode)}',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EntryDetailsSheet(entry: entry),
    );
  }
}

/// Read-only view of one entry: its service lines and the evidence photo.
class _EntryDetailsSheet extends StatelessWidget {
  const _EntryDetailsSheet({required this.entry});

  final CashCollectionEntity entry;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;
    final photoUrl = entry.photoUrl;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.85,
      ),
      decoration: BoxDecoration(
        color: color.scaffoldBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(radius.r12)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(spacing.s16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${entry.localizedFacilityName(context.languageCode)} · '
                '${DateFormatter.shortDate(entry.collectionDate)}',
                style: context.textStyle.titleMedium.copyWith(
                  color: color.text.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(spacing.s16),
              for (final item in entry.items)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: spacing.s4),
                  child: Row(
                    children: [
                      Expanded(
                        child: BodySmallText(
                          '${item.serviceName} · ${item.gender} · '
                          '${context.numbers.number(item.quantity)} × '
                          '${context.numbers.currency(item.unitPrice)}',
                          color: color.text.secondary,
                        ),
                      ),
                      Text(
                        context.numbers.currency(item.amount),
                        style: context.textStyle.labelLarge.copyWith(
                          color: color.text.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              Divider(color: color.borderSubtle, height: spacing.s24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.locale.totalCounted,
                    style: context.textStyle.labelLarge.copyWith(
                      color: color.text.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    context.numbers.currency(entry.totalCashAmount),
                    style: context.textStyle.labelLarge.copyWith(
                      color: color.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (photoUrl != null && photoUrl.isNotEmpty) ...[
                Gap(spacing.s16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(radius.r12),
                  child: Image.network(
                    photoUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const SizedBox.shrink(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
