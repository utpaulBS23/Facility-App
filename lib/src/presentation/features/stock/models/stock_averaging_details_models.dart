import 'package:flutter/material.dart';

class AverageDemandItem {
  const AverageDemandItem({
    required this.itemName,
    required this.category,
    required this.unitLabel,
    required this.quantityLabel,
    required this.icon,
  });

  final String itemName;
  final String category;
  final String unitLabel;
  final String quantityLabel;
  final IconData icon;
}

class TotalSummaryItem {
  const TotalSummaryItem({
    required this.category,
    required this.totalValue,
  });

  final String category;
  final String totalValue;
}

const List<AverageDemandItem> mockAverageDemandItems = [
  AverageDemandItem(
    itemName: 'Toilet paper',
    category: 'Toilet Paper / Tissue',
    unitLabel: 'Roll/month',
    quantityLabel: '50 rolls',
    icon: Icons.inventory_2_outlined,
  ),
  AverageDemandItem(
    itemName: 'Paper towels',
    category: 'Cleaning Products',
    unitLabel: 'Roll/month',
    quantityLabel: '30 rolls',
    icon: Icons.cleaning_services_outlined,
  ),
  AverageDemandItem(
    itemName: 'Hand soap',
    category: 'Personal Care',
    unitLabel: 'Bottles/month',
    quantityLabel: '20 bottles',
    icon: Icons.water_drop_outlined,
  ),
];

const List<TotalSummaryItem> mockTotalSummaryItems = [
  TotalSummaryItem(
    category: 'Toilet Paper / Tissue',
    totalValue: '250 Rolls/Month',
  ),
  TotalSummaryItem(
    category: 'Hand Wash / Soap',
    totalValue: '45 Litres/Month',
  ),
  TotalSummaryItem(
    category: 'Hand Sanitiser',
    totalValue: '30 Litres/Month',
  ),
  TotalSummaryItem(
    category: 'Floor Cleaner',
    totalValue: '60 Litres/Month',
  ),
  TotalSummaryItem(
    category: 'Air Freshener',
    totalValue: '12 Pieces/Month',
  ),
  TotalSummaryItem(
    category: 'Trash Bags',
    totalValue: '180 Pieces/Month',
  ),
];
