part of '../view/claim_expense_page.dart';

// WHY totalPrice is a straight sum of per-row prices, not rate-derived: the
// backend's legs[] has no per-leg amount field, so price is entered by the
// user per row and summed client-side — the sum is what's sent as the
// top-level `amount` override (see _onSubmit).
class _ClaimExpenseTotalBar extends StatelessWidget {
  const _ClaimExpenseTotalBar({
    required this.totalDistanceKm,
    required this.totalPrice,
  });

  final double totalDistanceKm;
  final double totalPrice;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.dimensions.padding.p16),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        border: Border.all(color: context.color.subtle),
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
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
          Gap(context.dimensions.spacing.s8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${context.locale.price}:',
                style: context.textStyle.bodyMedium.copyWith(
                  color: context.color.text.secondary,
                ),
              ),
              Text(
                totalPrice.toStringAsFixed(2),
                style: context.textStyle.titleMedium.copyWith(
                  color: context.color.text.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
