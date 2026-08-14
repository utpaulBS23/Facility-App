import 'package:flutter/material.dart';

import '../../../../domain/entities/supply/delivery_entity.dart';
import '../../../../domain/entities/supply/supply_request_entity.dart';
import '../models/received_item_ui_model.dart';

extension DeliveryItemsDisplayExt on DeliveryEntity {
  List<ReceivedItemUiModel> get displayItems => items.map((item) {
        return ReceivedItemUiModel(
          stockItemId: item.stockItemId,
          name: item.itemName,
          code: item.itemCode,
          expectedQuantity: item.qtyExpected.round(),
          receivedQuantity: item.qtyReceived.round(),
          unit: item.unit,
          icon: Icons.inventory_2_outlined,
          deliveryId: id,
          deliveryItemId: item.id,
        );
      }).toList();
}

extension RequestItemsDisplayExt on SupplyRequestEntity {
  List<ReceivedItemUiModel> get displayItems => items.map((item) {
        final qty = item.qtyRequested.round();

        return ReceivedItemUiModel(
          stockItemId: item.stockItemId,
          name: item.itemName,
          code: item.itemCode,
          expectedQuantity: qty,
          receivedQuantity: qty,
          unit: item.unit,
          icon: Icons.inventory_2_outlined,
        );
      }).toList();
}
