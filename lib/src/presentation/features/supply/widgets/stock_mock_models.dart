import 'package:flutter/material.dart';

class MockReceivedItem {
  const MockReceivedItem({
    required this.name,
    required this.code,
    required this.expectedQuantity,
    required this.receivedQuantity,
    required this.unit,
    required this.icon,
  });

  final String name;
  final String code;
  final int expectedQuantity;
  final int receivedQuantity;
  final String unit;
  final IconData icon;

  bool get hasDiscrepancy => expectedQuantity != receivedQuantity;
  int get missingQuantity => expectedQuantity - receivedQuantity;
}

class RequestItemEntry {
  const RequestItemEntry({
    this.stockItemId,
    this.itemName,
    this.quantity = 1,
    this.unit = '',
  });

  final int? stockItemId;
  final String? itemName;
  final int quantity;
  final String unit;

  RequestItemEntry copyWith({
    int? stockItemId,
    String? itemName,
    int? quantity,
    String? unit,
  }) {
    return RequestItemEntry(
      stockItemId: stockItemId ?? this.stockItemId,
      itemName: itemName ?? this.itemName,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
    );
  }
}
