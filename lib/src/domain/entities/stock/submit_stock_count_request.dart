class StockCountItemInput {
  const StockCountItemInput({
    required this.stockItemId,
    required this.qtyOnHand,
    this.photoUrl,
  });

  final int stockItemId;
  final double qtyOnHand;
  final String? photoUrl;
}

class SubmitStockCountRequest {
  const SubmitStockCountRequest({required this.items});

  final List<StockCountItemInput> items;
}
