import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/cash_collection/cash_collection_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/text/typography.dart';
import 'manual_income_entry_details_sheet.dart';

class ManualIncomeEntryCard extends StatelessWidget {
  const ManualIncomeEntryCard({super.key, required this.entry});

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
      builder: (_) => ManualIncomeEntryDetailsSheet(entry: entry),
    );
  }
}
