part of '../view/travel_expenses_page.dart';

class _TravelExpenseListCard extends ConsumerWidget {
  const _TravelExpenseListCard({required this.expense});

  final TravelExpenseEntity expense;

  bool _canDelete(WidgetRef ref) {
    if (expense.status != TravelExpenseStatus.waiting) return false;
    final canCreate =
        ref.watch(userSessionProvider)?.can(UserPermission.travelExpenseCreate) ??
        false;
    final currentUserId = ref.read(getCurrentUserUseCaseProvider).call()?.id;
    return canCreate && expense.userId != null && expense.userId == currentUserId;
  }

  Future<void> _onDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const DeleteTravelExpenseConfirmDialog(),
    );
    if (confirmed != true) return;

    await ref.read(deleteTravelExpenseProvider.notifier).delete(expense.id);
    if (!context.mounted) return;

    final state = ref.read(deleteTravelExpenseProvider);
    if (state.hasError) {
      AppSnackBar.showError(context, state.error!.localizedMessage(context));
    } else {
      AppSnackBar.showSuccess(context, context.locale.deleteClaimSuccess);
    }
  }

  String? _submittedDateLabel() {
    final parsed = DateTime.tryParse(expense.submittedAt)?.toLocal();
    return parsed == null ? null : DateFormatter.shortDate(parsed);
  }

  String? _submittedTimeLabel() {
    final parsed = DateTime.tryParse(expense.submittedAt)?.toLocal();
    return parsed == null ? null : DateFormatter.timeOnly(parsed);
  }

  String get _transportModeLabel => expense.transportLines
      .map((line) => line.vehicleTypeLabel)
      .where((label) => label.isNotEmpty)
      .join(' + ');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;
    final dateLabel = _submittedDateLabel();
    final timeLabel = _submittedTimeLabel();
    final canDelete = _canDelete(ref);

    return GestureDetector(
      onTap: () => context.pushNamed(
        Routes.travelExpenseDetails,
        pathParameters: {'id': '${expense.id}'},
      ),
      child: Container(
        padding: EdgeInsets.all(spacing.s16),
        decoration: BoxDecoration(
          color: color.onPrimary,
          border: Border.all(color: color.borderSubtle),
          borderRadius: BorderRadius.circular(radius.r12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    expense.localizedDestinationName(context.languageCode),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textStyle.bodyLarge.copyWith(
                      color: color.text.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Gap(spacing.s8),
                StatusDotTag(
                  dotColor: expense.status.statusColor(context),
                  label: expense.status.localizedName(context),
                ),
                if (canDelete) ...[
                  Gap(spacing.s4),
                  InkWell(
                    onTap: () => _onDelete(context, ref),
                    borderRadius: BorderRadius.circular(radius.r6),
                    child: Padding(
                      padding: EdgeInsets.all(spacing.s4),
                      child: Icon(
                        Icons.delete_outline,
                        size: spacing.s20,
                        color: color.error,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            if (dateLabel != null || timeLabel != null) ...[
              Gap(spacing.s8),
              Row(
                children: [
                  if (dateLabel != null) ...[
                    Icon(
                      Icons.calendar_today_outlined,
                      size: spacing.s14,
                      color: color.text.secondary,
                    ),
                    Gap(spacing.s4),
                    Text(
                      dateLabel,
                      style: context.textStyle.bodySmall.copyWith(
                        color: color.text.secondary,
                      ),
                    ),
                  ],
                  if (timeLabel != null) ...[
                    Gap(spacing.s12),
                    Icon(
                      Icons.access_time_rounded,
                      size: spacing.s14,
                      color: color.text.secondary,
                    ),
                    Gap(spacing.s4),
                    Text(
                      timeLabel,
                      style: context.textStyle.bodySmall.copyWith(
                        color: color.text.secondary,
                      ),
                    ),
                  ],
                ],
              ),
            ],
            Gap(spacing.s12),
            Row(
              children: [
                Icon(
                  Icons.person_outline_rounded,
                  size: spacing.s14,
                  color: color.text.secondary,
                ),
                Gap(spacing.s4),
                Expanded(
                  child: Text(
                    expense.localizedUserName(context.languageCode),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textStyle.bodySmall.copyWith(
                      color: color.text.secondary,
                    ),
                  ),
                ),
              ],
            ),
            if (expense.purpose.isNotEmpty ||
                _transportModeLabel.isNotEmpty) ...[
              Gap(spacing.s4),
              Text(
                [
                  if (expense.purpose.isNotEmpty) expense.purpose,
                  if (_transportModeLabel.isNotEmpty)
                    if (expense.claimedDistanceKm > 0)
                      '${context.locale.distanceKmValue(context.numbers.number(expense.claimedDistanceKm))} · $_transportModeLabel'
                    else
                      _transportModeLabel,
                ].join(' • '),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textStyle.bodySmall.copyWith(
                  color: color.text.secondary,
                ),
              ),
            ],
            Divider(height: spacing.s24, color: color.borderSubtle),
            Text(
              context.numbers.currency(expense.claimedAmount.round()),
              style: context.textStyle.headlineSmall.copyWith(
                color: color.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
