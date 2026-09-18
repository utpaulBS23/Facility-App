/// One editable item row in the new-request form. Not a domain entity —
/// `stockItemId`/`unit` are only populated once the user picks an item from
/// the catalog dropdown.
class RequestItemEntry {
  const RequestItemEntry({
    this.stockItemId,
    this.itemName,
    this.unit = '',
    this.quantity = 1,
  });

  final int? stockItemId;
  final String? itemName;
  final String unit;
  final int quantity;

  RequestItemEntry copyWith({
    int? stockItemId,
    String? itemName,
    String? unit,
    int? quantity,
  }) {
    return RequestItemEntry(
      stockItemId: stockItemId ?? this.stockItemId,
      itemName: itemName ?? this.itemName,
      unit: unit ?? this.unit,
      quantity: quantity ?? this.quantity,
    );
  }
}
