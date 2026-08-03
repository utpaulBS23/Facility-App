import 'package:flutter/material.dart';

import '../../../../domain/entities/supply/delivery_entity.dart';
import '../../../../domain/entities/supply/supply_request_entity.dart';
import '../widgets/stock_mock_models.dart';

extension DeliveryItemsDisplayExt on DeliveryEntity {
  List<MockReceivedItem> get displayItems => items.map((item) {
        return MockReceivedItem(
          name: item.itemName,
          code: item.itemCode,
          expectedQuantity: item.qtyExpected.round(),
          receivedQuantity: item.qtyReceived.round(),
          unit: item.unit,
          icon: Icons.inventory_2_outlined,
        );
      }).toList();
}

extension RequestItemsDisplayExt on SupplyRequestEntity {
  List<MockReceivedItem> get displayItems => items.map((item) {
        final qty = item.qtyRequested.round();

        return MockReceivedItem(
          name: item.itemName,
          code: item.itemCode,
          expectedQuantity: qty,
          receivedQuantity: qty,
          unit: item.unit,
          icon: Icons.inventory_2_outlined,
        );
      }).toList();
}
