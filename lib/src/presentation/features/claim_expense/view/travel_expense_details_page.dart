import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/login_entity.dart';
import '../../../../domain/entities/travel_expense_entity.dart';
import '../../../core/application_state/session_provider/session_provider.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../../../core/widgets/status_pill.dart';
import '../extensions/travel_expense_status_extension.dart';
import '../riverpod/travel_expense_detail_provider.dart';

part '../widgets/travel_expense_travel_info_card.dart';

class TravelExpenseDetailsPage extends ConsumerWidget {
  const TravelExpenseDetailsPage({super.key, required this.travelExpenseId});

  final int travelExpenseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(
      travelExpenseDetailProvider(travelExpenseId),
    );

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(title: context.locale.transportationDetails),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => AppErrorWidget(
          message: err.localizedMessage(context),
          onRetry: () => ref.invalidate(
            travelExpenseDetailProvider(travelExpenseId),
          ),
        ),
        data: (expense) => _TravelExpenseDetailsBody(expense: expense),
      ),
    );
  }
}

class _TravelExpenseDetailsBody extends StatelessWidget {
  const _TravelExpenseDetailsBody({required this.expense});

  final TravelExpenseEntity expense;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final submittedAt = DateTime.tryParse(expense.submittedAt)?.toLocal();

    return ListView(
        padding: EdgeInsets.all(spacing.s16),
        children: [
          Container(
            padding: EdgeInsets.all(spacing.s16),
            decoration: BoxDecoration(
              color: color.onPrimary,
              border: Border.all(color: color.borderSubtle),
              borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.locale.status,
                      style: context.textStyle.bodyMedium.copyWith(
                        color: color.text.secondary,
                      ),
                    ),
                    StatusPill(
                      label: expense.status
                          .localizedName(context)
                          .toUpperCase(),
                      background: expense.status
                          .statusColor(context)
                          .withValues(alpha: 0.12),
                      foreground: expense.status.statusColor(context),
                    ),
                  ],
                ),
                Gap(spacing.s12),
                Text(
                  '৳${expense.claimedAmount.toStringAsFixed(0)}',
                  style: context.textStyle.displaySmall.copyWith(
                    color: color.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(spacing.s4),
                Text(
                  context.locale.travelExpenseCaption,
                  style: context.textStyle.bodyMedium.copyWith(
                    color: color.text.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Gap(spacing.s16),
          _TravelExpenseTravelInfoCard(expense: expense),
          Gap(spacing.s16),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.s16,
              vertical: spacing.s4,
            ),
            decoration: BoxDecoration(
              color: color.onPrimary,
              border: Border.all(color: color.borderSubtle),
              borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
            ),
            child: Column(
              children: [
                _DetailRow(
                  icon: Icons.calendar_today_outlined,
                  label: context.locale.dateAndTime,
                  value: submittedAt == null
                      ? context.locale.notAvailable
                      : '${DateFormatter.shortDate(submittedAt)} | '
                            '${DateFormatter.timeOnly(submittedAt)}',
                ),
                if (expense.purpose.isNotEmpty)
                  _DetailRow(
                    icon: Icons.person_outline_rounded,
                    label: context.locale.purposeLabel,
                    value: expense.purpose,
                  ),
              ],
            ),
          ),
        ],
      );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing.s12),
      child: Row(
        children: [
          Icon(icon, size: spacing.s20, color: color.text.secondary),
          Gap(spacing.s8),
          Expanded(
            child: Text(
              label,
              style: context.textStyle.bodyMedium.copyWith(
                color: color.text.secondary,
              ),
            ),
          ),
          Text(
            value,
            style: context.textStyle.bodyMedium.copyWith(
              color: color.text.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
