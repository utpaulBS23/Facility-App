import 'package:flutter/material.dart';

class ShiftStockCountItemFormEntry {
  ShiftStockCountItemFormEntry({
    required this.stockItemId,
    required this.itemName,
    required this.unit,
    double initialQty = 0.0,
  }) : qtyController = TextEditingController(
          text: initialQty > 0 ? initialQty.toStringAsFixed(0) : '0',
        );

  final int stockItemId;
  final String itemName;
  final String unit;
  final TextEditingController qtyController;

  void dispose() {
    qtyController.dispose();
  }
}
