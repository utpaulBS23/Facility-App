part of '../view/claim_expense_page.dart';

// WHY distance only, no amount: claimed_amount is computed server-side from
// the partner's currently configured rate, which this app never fetches —
// showing a client-guessed total would just be wrong.
class _ClaimExpenseTotalBar extends StatelessWidget {
  const _ClaimExpenseTotalBar({required this.totalDistanceKm});

  final double totalDistanceKm;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.dimensions.padding.p16),
      decoration: BoxDecoration(
        color: context.color.subtle,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${context.locale.totalLabel}:',
            style: context.textStyle.bodyMedium.copyWith(
              color: context.color.text.secondary,
            ),
          ),
          Text(
            '${totalDistanceKm.toStringAsFixed(1)} km',
            style: context.textStyle.titleMedium.copyWith(
              color: context.color.text.primary,
            ),
          ),
        ],
      ),
    );
  }
}
