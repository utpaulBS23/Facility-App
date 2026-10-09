import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/cash_collection/cash_collection_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/text/typography.dart';

/// Read-only view of one entry: its service lines and the evidence photo.
class ManualIncomeEntryDetailsSheet extends StatelessWidget {
  const ManualIncomeEntryDetailsSheet({super.key, required this.entry});

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
