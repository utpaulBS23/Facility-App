import 'package:flutter/material.dart';

class ReceivedItemUiModel {
  const ReceivedItemUiModel({
    required this.stockItemId,
    required this.name,
    required this.code,
    required this.expectedQuantity,
    required this.receivedQuantity,
    required this.unit,
    required this.icon,
    this.deliveryId,
    this.deliveryItemId,
  });

  final int stockItemId;
  final String name;
  final String code;
  final int expectedQuantity;
  final int receivedQuantity;
  final String unit;
  final IconData icon;

  /// Null for pre-delivery (request-only) items — only populated once a
  /// delivery exists, which is required to file a complaint (§18).
  final int? deliveryId;
  final int? deliveryItemId;

  bool get hasDiscrepancy => expectedQuantity != receivedQuantity;
  int get missingQuantity => expectedQuantity - receivedQuantity;
}
