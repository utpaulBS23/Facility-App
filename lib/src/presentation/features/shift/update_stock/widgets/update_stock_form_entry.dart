import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  /// Optional photo for this line; uploaded with the count.
  final ValueNotifier<XFile?> photo = ValueNotifier(null);

  void dispose() {
    qtyController.dispose();
    photo.dispose();
  }
}
