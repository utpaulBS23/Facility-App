import 'package:flutter/material.dart';

class MockSupplyRequest {
  const MockSupplyRequest({
    required this.id,
    required this.status,
    required this.facilityName,
    required this.requesterName,
    required this.itemCount,
    required this.priority,
    required this.categoryIcon,
    this.isApprovedForDelivery = false,
  });

  final String id;
  final String status;
  final String facilityName;
  final String requesterName;
  final int itemCount;
  final String priority;
  final IconData categoryIcon;
  final bool isApprovedForDelivery;
}

const mockSupplyRequests = [
  MockSupplyRequest(
    id: '1',
    status: 'Pending',
    facilityName: 'Mirpur-10 Public Toilet Complex',
    requesterName: 'Shafiqul Alam',
    itemCount: 3,
    priority: 'Urgent',
    categoryIcon: Icons.water_drop_outlined,
  ),
  MockSupplyRequest(
    id: '2',
    status: 'In Progress',
    facilityName: 'Dhanmondi Market Restroom',
    requesterName: 'Nusrat Jahan',
    itemCount: 7,
    priority: 'High Priority',
    categoryIcon: Icons.sanitizer_outlined,
    isApprovedForDelivery: true,
  ),
  MockSupplyRequest(
    id: '3',
    status: 'Completed',
    facilityName: 'Gulshan Park Sanitation Facility',
    requesterName: 'Rafiq Islam',
    itemCount: 5,
    priority: 'Normal',
    categoryIcon: Icons.soap_outlined,
  ),
];

class MockRequestedItem {
  const MockRequestedItem({
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.icon,
  });

  final String name;
  final String category;
  final int quantity;
  final String unit;
  final IconData icon;
}

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

class MockRequestDetailsPayload {
  const MockRequestDetailsPayload({
    required this.status,
    required this.submittedDate,
    required this.facilityName,
    required this.facilityLocation,
    required this.requesterName,
    required this.requesterRole,
    required this.fullSubmittedDateTime,
    required this.priority,
    required this.notes,
    this.isApprovedStage = false,
  });

  final String status;
  final String submittedDate;
  final String facilityName;
  final String facilityLocation;
  final String requesterName;
  final String requesterRole;
  final String fullSubmittedDateTime;
  final String priority;
  final String notes;
  final bool isApprovedStage;
}

const mockReceivedItemsList = [
  MockReceivedItem(
    name: 'Toilet paper',
    code: 'ST-001',
    expectedQuantity: 50,
    receivedQuantity: 50,
    unit: 'rolls',
    icon: Icons.sanitizer_outlined,
  ),
  MockReceivedItem(
    name: 'Hand soap',
    code: 'ST-001',
    expectedQuantity: 25,
    receivedQuantity: 24,
    unit: 'rolls',
    icon: Icons.water_drop_outlined,
  ),
];

class VerifiableItem {
  const VerifiableItem({
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.icon,
    this.isVerified = false,
  });

  final String name;
  final String category;
  final int quantity;
  final String unit;
  final IconData icon;
  final bool isVerified;

  VerifiableItem copyWith({bool? isVerified}) {
    return VerifiableItem(
      name: name,
      category: category,
      quantity: quantity,
      unit: unit,
      icon: icon,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}

class RequestItemEntry {
  const RequestItemEntry({
    this.itemId,
    this.itemName,
    this.quantity = 1,
    this.unit = 'Rolls',
  });

  final String? itemId;
  final String? itemName;
  final int quantity;
  final String unit;

  RequestItemEntry copyWith({
    String? itemId,
    String? itemName,
    int? quantity,
    String? unit,
  }) {
    return RequestItemEntry(
      itemId: itemId ?? this.itemId,
      itemName: itemName ?? this.itemName,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
    );
  }
}

class MockStockItem {
  const MockStockItem({
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.icon,
    required this.statusLabel,
  });

  final String name;
  final String category;
  final int quantity;
  final String unit;
  final IconData icon;
  final String statusLabel;

  Color statusColor(dynamic themeColor) {
    switch (statusLabel.toLowerCase()) {
      case 'in stock':
        return themeColor.success;
      case 'low stock':
        return themeColor.warning;
      case 'reorder needed':
      case 'critical':
        return themeColor.primary;
      default:
        return themeColor.text.secondary;
    }
  }
}

const mockStockItems = [
  MockStockItem(
    name: 'Liquid Hand Soap',
    category: 'Consumables',
    quantity: 25,
    unit: 'Liters',
    icon: Icons.water_drop_outlined,
    statusLabel: 'In Stock',
  ),
  MockStockItem(
    name: 'Antibacterial Gel',
    category: 'Consumables',
    quantity: 15,
    unit: 'Liters',
    icon: Icons.sanitizer_outlined,
    statusLabel: 'Low Stock',
  ),
  MockStockItem(
    name: 'Scented Shampoo',
    category: 'Consumables',
    quantity: 10,
    unit: 'Liters',
    icon: Icons.clean_hands_outlined,
    statusLabel: 'Reorder Needed',
  ),
  MockStockItem(
    name: 'Jumbo Toilet Roll',
    category: 'Consumables',
    quantity: 40,
    unit: 'Rolls',
    icon: Icons.description_outlined,
    statusLabel: 'In Stock',
  ),
  MockStockItem(
    name: 'Floor Cleaner Liquid',
    category: 'Cleaning',
    quantity: 5,
    unit: 'Liters',
    icon: Icons.cleaning_services_outlined,
    statusLabel: 'Reorder Needed',
  ),
];
