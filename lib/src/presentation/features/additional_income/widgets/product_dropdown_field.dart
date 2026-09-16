part of '../view/add_additional_income_page.dart';

// Product options come from the facility-scoped offering list
// (`GET /partners/{partner}/facility-products?facility_id=...`), not the
// global product catalog — a product must currently be offered at the
// selected facility to be sold there (facility_products, doc §3.4). This is
// why the product picker is gated on facility selection: facility must be
// picked first.
class _ProductDropdownSection extends ConsumerWidget {
  const _ProductDropdownSection({
    required this.enabled,
    required this.hasError,
    required this.onSelected,
  });

  final bool enabled;
  final bool hasError;
  final VoidCallback onSelected;

  Future<void> _onPickProduct(
    BuildContext context,
    WidgetRef ref,
    List<FacilityProductEntity> products,
  ) async {
    final result = await showModalBottomSheet<FacilityProductEntity?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProductListSheet(
        products: products,
        selectedProductId: ref.read(selectedProductProvider)?.id,
      ),
    );
    if (result == null) return;
    ref.read(selectedProductProvider.notifier).select(result);
    onSelected();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!enabled) {
      return _DropdownField(
        value: null,
        hint: context.locale.selectProduct,
        hasError: hasError,
        onTap: null,
      );
    }

    final productsAsync = ref.watch(facilityProductOptionsProvider);
    final selected = ref.watch(selectedProductProvider);

    return productsAsync.when(
      loading: () => const LinearProgressIndicator(),
      error: (_, _) => BodySmallText(
        context.locale.selectProduct,
        color: context.color.error,
      ),
      data: (products) => _DropdownField(
        value: selected?.productName,
        hint: context.locale.selectProduct,
        hasError: hasError,
        onTap: products.isEmpty
            ? null
            : () => _onPickProduct(context, ref, products),
      ),
    );
  }
}

class _ProductListSheet extends StatelessWidget {
  const _ProductListSheet({
    required this.products,
    required this.selectedProductId,
  });

  final List<FacilityProductEntity> products;
  final int? selectedProductId;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.75,
      ),
      decoration: BoxDecoration(
        color: context.color.scaffoldBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(radius.r12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Gap(spacing.s12),
          Container(
            width: spacing.s40,
            height: spacing.s4,
            decoration: BoxDecoration(
              color: context.color.borderSubtle,
              borderRadius: BorderRadius.circular(radius.r4),
            ),
          ),
          Gap(spacing.s16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing.s16),
            child: LabelLargeText(context.locale.selectProduct),
          ),
          Gap(spacing.s16),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.fromLTRB(
                spacing.s16,
                0,
                spacing.s16,
                spacing.s16,
              ),
              itemCount: products.length,
              separatorBuilder: (_, _) => Gap(spacing.s12),
              itemBuilder: (context, index) {
                final product = products[index];
                final isSelected = product.id == selectedProductId;
                return GestureDetector(
                  onTap: () => Navigator.of(context).pop(product),
                  child: Container(
                    padding: EdgeInsets.all(spacing.s16),
                    decoration: BoxDecoration(
                      color: context.color.onPrimary,
                      border: Border.all(
                        color: isSelected
                            ? context.color.primary
                            : context.color.borderSubtle,
                      ),
                      borderRadius: BorderRadius.circular(radius.r12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LabelLargeText(
                                product.productName,
                                color: isSelected
                                    ? context.color.primary
                                    : context.color.text.primary,
                              ),
                              BodySmallText(
                                product.category,
                                color: context.color.text.secondary,
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle_rounded,
                            color: context.color.primary,
                            size: spacing.s20,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
