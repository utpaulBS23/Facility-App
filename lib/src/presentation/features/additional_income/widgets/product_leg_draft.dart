part of '../view/add_additional_income_page.dart';

/// Mutable per-row form state for one product-sale line item — not a domain
/// entity; [CreateProductSaleEntryItemEntity] is built from this only at
/// submit time. Mirrors `_LegDraft` in claim_expense.
class _ProductLegDraft {
  _ProductLegDraft()
    : unitsSoldController = TextEditingController(),
      unitPriceController = TextEditingController();

  FacilityProductEntity? product;
  final TextEditingController unitsSoldController;
  final TextEditingController unitPriceController;

  int get unitsSold => int.tryParse(unitsSoldController.text.trim()) ?? 0;

  double get unitPrice => double.tryParse(unitPriceController.text.trim()) ?? 0;

  bool get isValid {
    final selected = product;
    if (selected == null) return false;
    if (unitsSold <= 0 || unitsSold > selected.stockQuantity) return false;
    return unitPrice > 0;
  }

  CreateProductSaleEntryItemEntity toEntity() => CreateProductSaleEntryItemEntity(
    productId: product!.productId,
    unitsSold: unitsSold,
    unitPrice: unitPrice,
  );

  void dispose() {
    unitsSoldController.dispose();
    unitPriceController.dispose();
  }
}
