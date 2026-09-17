part of '../view/travel_expense_details_page.dart';

class _TravelExpenseTravelInfoCard extends ConsumerWidget {
  const _TravelExpenseTravelInfoCard({required this.expense});

  final TravelExpenseEntity expense;

  String _startLabel(BuildContext context, WidgetRef ref) {
    switch (expense.startType) {
      case TravelExpenseStartType.home:
        return expense.userName.isEmpty
            ? context.locale.home
            : expense.userName;
      case TravelExpenseStartType.facility:
        final facilities =
            ref.watch(userSessionProvider)?.accessibleFacilities ??
            const <AccessibleFacilityEntity>[];
        final facility = facilities
            .cast<AccessibleFacilityEntity?>()
            .firstWhere((f) => f?.id == expense.startId, orElse: () => null);
        return facility?.name ?? context.locale.notAvailable;
      case TravelExpenseStartType.office:
        return context.locale.office;
      case null:
        return context.locale.notAvailable;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        border: Border.all(color: color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: spacing.s40,
            height: spacing.s40,
            decoration: BoxDecoration(
              color: color.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(radius.r12),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.navigation_outlined, color: color.primary),
          ),
          Gap(spacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.locale.travelInformation,
                  style: context.textStyle.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gap(spacing.s12),
                _TravelPoint(
                  dotColor: color.success,
                  label: context.locale.start,
                  value: _startLabel(context, ref),
                ),
                Gap(spacing.s8),
                _TravelPoint(
                  dotColor: color.error,
                  label: context.locale.destination,
                  value: expense.facilityName,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TravelPoint extends StatelessWidget {
  const _TravelPoint({
    required this.dotColor,
    required this.label,
    required this.value,
  });

  final Color dotColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: spacing.s4),
          child: Container(
            width: spacing.s8,
            height: spacing.s8,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Gap(spacing.s8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.textStyle.bodySmall.copyWith(
                  color: context.color.text.secondary,
                ),
              ),
              Text(
                value,
                style: context.textStyle.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
