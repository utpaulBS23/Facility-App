import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/login_entity.dart';
import '../../../../domain/entities/travel_expense_entity.dart';
import '../../../../domain/entities/travel_expense_status.dart';
import '../../../core/application_state/session_provider/session_provider.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../../../core/widgets/status_pill.dart';
import '../extensions/travel_expense_status_extension.dart';
import '../riverpod/travel_expense_detail_provider.dart';
import '../widgets/travel_expense_delete_bar.dart';
import '../widgets/travel_expense_review_bar.dart';
import '../widgets/travel_expense_system_generated_card.dart';

part '../widgets/travel_expense_travel_info_card.dart';

class TravelExpenseDetailsPage extends ConsumerWidget {
  const TravelExpenseDetailsPage({super.key, required this.travelExpenseId});

  final int travelExpenseId;

  /// A claim can be reviewed while it is waiting, by someone holding the review
  /// permission, and never by whoever filed it (the server refuses that too).
  bool _canReview(WidgetRef ref, TravelExpenseEntity expense) {
    if (expense.status != TravelExpenseStatus.waiting) return false;
    final canReview =
        ref
            .watch(userSessionProvider)
            ?.can(UserPermission.travelExpenseReview) ??
        false;
    final currentUserId = ref.read(getCurrentUserUseCaseProvider).call()?.id;

    return canReview &&
        (expense.userId == null || expense.userId != currentUserId);
  }

  /// The claimant may delete their own claim while it's still waiting review
  /// — see `Travel_Expense_Delete_API_Guide 1.md`.
  bool _canDelete(WidgetRef ref, TravelExpenseEntity expense) {
    if (expense.status != TravelExpenseStatus.waiting) return false;
    final canCreate =
        ref.watch(userSessionProvider)?.can(UserPermission.travelExpenseCreate) ??
        false;
    final currentUserId = ref.read(getCurrentUserUseCaseProvider).call()?.id;
    return canCreate && expense.userId != null && expense.userId == currentUserId;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(
      travelExpenseDetailProvider(travelExpenseId),
    );

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(title: context.locale.transportationDetails),
      bottomNavigationBar: switch (detailAsync.valueOrNull) {
        final expense? when _canReview(ref, expense) =>
          TravelExpenseReviewBar(travelExpenseId: expense.id),
        final expense? when _canDelete(ref, expense) =>
          TravelExpenseDeleteBar(travelExpenseId: expense.id),
        _ => null,
      },
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
                  context.numbers.currency(expense.claimedAmount.round()),
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
          if (expense.calculatedDistanceKm != null ||
              expense.calculatedAmount != null ||
              expense.ratePerKm != null) ...[
            Gap(spacing.s16),
            TravelExpenseSystemGeneratedCard(
              distanceKm: expense.calculatedDistanceKm,
              amount: expense.calculatedAmount,
              ratePerKm: expense.ratePerKm,
            ),
          ],
          if (expense.transportLines.isNotEmpty) ...[
            Gap(spacing.s16),
            _TransportLinesBreakdown(lines: expense.transportLines),
          ],
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
                if (expense.approvedAmount != null)
                  _DetailRow(
                    icon: Icons.check_circle_outline,
                    label: context.locale.approvedAmount,
                    value: context.numbers.currency(
                      expense.approvedAmount!.round(),
                    ),
                  ),
                if (expense.adjustmentReason != null &&
                    expense.adjustmentReason!.isNotEmpty)
                  _DetailRow(
                    icon: Icons.edit_note_rounded,
                    label: context.locale.adjustmentReason,
                    value: expense.adjustmentReason!,
                  ),
                if (expense.status == TravelExpenseStatus.rejected &&
                    expense.rejectionNote.isNotEmpty)
                  _DetailRow(
                    icon: Icons.block_rounded,
                    label: context.locale.rejectionNote,
                    value: expense.rejectionNote,
                  ),
              ],
            ),
          ),
        ],
      );
  }
}

/// Per-leg distance/amount breakdown — e.g. "Rickshaw · 5.2 km · ৳60".
class _TransportLinesBreakdown extends StatelessWidget {
  const _TransportLinesBreakdown({required this.lines});

  final List<TravelExpenseLineEntity> lines;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        border: Border.all(color: color.borderSubtle),
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.locale.distanceBreakdown,
            style: context.textStyle.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Gap(spacing.s12),
          for (final line in lines) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    line.vehicleTypeLabel.isEmpty
                        ? context.locale.notAvailable
                        : line.vehicleTypeLabel,
                    style: context.textStyle.bodyMedium,
                  ),
                ),
                if (line.distanceKm != null)
                  Text(
                    context.locale.distanceKmValue(
                      context.numbers.number(line.distanceKm!),
                    ),
                    style: context.textStyle.bodySmall.copyWith(
                      color: color.text.secondary,
                    ),
                  ),
                if (line.claimedAmount != null) ...[
                  Gap(spacing.s12),
                  Text(
                    context.numbers.currency(line.claimedAmount!.round()),
                    style: context.textStyle.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
            if (line != lines.last) Gap(spacing.s8),
          ],
        ],
      ),
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
