part of '../view/claim_expense_page.dart';

class _ClaimExpenseTotalBar extends StatelessWidget {
  const _ClaimExpenseTotalBar({
    required this.totalDistanceKm,
    required this.totalAmount,
  });

  final double totalDistanceKm;
  final double totalAmount;

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
            '${context.locale.totalLabel}: '
            '${totalDistanceKm.toStringAsFixed(1)} km',
            style: context.textStyle.bodyMedium.copyWith(
              color: context.color.text.secondary,
            ),
          ),
          Text(
            '৳ ${totalAmount.toStringAsFixed(0)}',
            style: context.textStyle.titleMedium.copyWith(
              color: context.color.text.primary,
            ),
          ),
        ],
      ),
    );
  }
}
