part of '../view/add_additional_income_page.dart';

class _ProductLegRow extends StatelessWidget {
  const _ProductLegRow({
    required this.leg,
    required this.products,
    required this.showErrors,
    required this.onChanged,
    required this.onRemove,
    required this.showRemove,
  });

  final _ProductLegDraft leg;
  final List<FacilityProductEntity> products;
  final bool showErrors;
  final VoidCallback onChanged;
  final VoidCallback? onRemove;
  final bool showRemove;

  Future<void> _onPickProduct(BuildContext context) async {
    final result = await showModalBottomSheet<FacilityProductEntity?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProductListSheet(
        products: products,
        selectedProductId: leg.product?.id,
      ),
    );
    if (result == null) return;
    leg.product = result;
    if (leg.unitPriceController.text.trim().isEmpty) {
      leg.unitPriceController.text = result.price.toString();
    }
    onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final product = leg.product;
    final exceedsStock =
        product != null && leg.unitsSold > product.stockQuantity;
    final unitsSoldError = exceedsStock
        ? context.locale.unitsSoldExceedsStock
        : !showErrors
        ? null
        : leg.unitsSold <= 0
        ? context.locale.fieldRequired
        : null;
    final unitPriceError =
        showErrors && leg.unitPrice <= 0 ? context.locale.fieldRequired : null;

    return Container(
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        border: Border.all(color: context.color.borderSubtle),
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FormSelectorCard(
              title: context.locale.selectProduct,
              icon: Icons.inventory_2_outlined,
              enabled: products.isNotEmpty,
              onTap: () => _onPickProduct(context),
              content: Text(
                product?.productName ?? context.locale.selectProduct,
                overflow: TextOverflow.ellipsis,
                style: product == null
                    ? context.textStyle.bodyMedium.copyWith(
                        color: context.color.text.secondary,
                      )
                    : context.textStyle.bodyMedium,
              ),
            ),
            if (showErrors && product == null) ...[
              Gap(spacing.s4),
              BodySmallText(
                context.locale.fieldRequired,
                color: context.color.error,
              ),
            ],
            Gap(spacing.s12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppTextField.text(
                    controller: leg.unitsSoldController,
                    label: context.locale.unitsSold,
                    hint: context.locale.enterUnitsSold,
                    keyboardType: TextInputType.number,
                    errorText: unitsSoldError,
                    onChanged: (_) => onChanged(),
                  ),
                ),
                Gap(spacing.s8),
                Expanded(
                  child: AppTextField.text(
                    controller: leg.unitPriceController,
                    label: context.locale.unitPriceBdt,
                    hint: context.locale.enterAmount,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    errorText: unitPriceError,
                    onChanged: (_) => onChanged(),
                  ),
                ),
              ],
            ),
            if (product != null) ...[
              Gap(spacing.s4),
              BodySmallText(
                '${context.locale.availableStock}: ${product.stockQuantity}',
                color: context.color.text.secondary,
              ),
            ],
            if (showRemove) ...[
              Gap(spacing.s8),
              OutlinedButton.icon(
                onPressed: onRemove,
                icon: const Icon(Icons.delete_outline),
                label: Text(context.locale.remove),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
