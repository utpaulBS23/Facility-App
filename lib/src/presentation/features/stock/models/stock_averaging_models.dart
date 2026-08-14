import 'package:flutter/material.dart';

class MonthlyDemandStat {
  const MonthlyDemandStat({
    required this.title,
    required this.totalValue,
    required this.unit,
    required this.icon,
  });

  final String title;
  final int totalValue;
  final String unit;
  final IconData icon;
}

class FacilityAveragingItem {
  const FacilityAveragingItem({
    required this.facilityName,
    required this.managerName,
    required this.lastUpdate,
    required this.statusText,
    required this.setupStatus,
  });

  final String facilityName;
  final String managerName;
  final String lastUpdate;
  final String statusText;
  final String setupStatus;
}

const List<MonthlyDemandStat> mockMonthlyDemandStats = [
  MonthlyDemandStat(
    title: 'Toilet paper',
    totalValue: 1680,
    unit: 'Rolls/Month',
    icon: Icons.inventory_2_outlined,
  ),
  MonthlyDemandStat(
    title: 'Hand wash / Soap',
    totalValue: 299,
    unit: 'Liters/Month',
    icon: Icons.water_drop_outlined,
  ),
  MonthlyDemandStat(
    title: 'Hand sanitizer',
    totalValue: 201,
    unit: 'Liters/Month',
    icon: Icons.clean_hands_outlined,
  ),
  MonthlyDemandStat(
    title: 'Floor cleaner',
    totalValue: 393,
    unit: 'Liters/Month',
    icon: Icons.cleaning_services_outlined,
  ),
  MonthlyDemandStat(
    title: 'Air freshener',
    totalValue: 81,
    unit: 'Pieces/Month',
    icon: Icons.air_outlined,
  ),
  MonthlyDemandStat(
    title: 'Trash bag',
    totalValue: 1185,
    unit: 'Pieces/Month',
    icon: Icons.delete_outline,
  ),
];

const List<FacilityAveragingItem> mockFacilityAveragingItems = [
  FacilityAveragingItem(
    facilityName: 'Mirpur-10 Public Toilet Complex',
    managerName: 'Shafiqul Alam',
    lastUpdate: '05 March 2026',
    statusText: 'Send Request',
    setupStatus: 'Set Up',
  ),
  FacilityAveragingItem(
    facilityName: 'Gulshan-2 Community Center',
    managerName: 'Nadia Rahman',
    lastUpdate: '12 April 2026',
    statusText: 'Send Request',
    setupStatus: 'Set Up',
  ),
  FacilityAveragingItem(
    facilityName: 'Dhanmondi-32 Transit Hub',
    managerName: 'Kamrul Hasan',
    lastUpdate: '18 May 2026',
    statusText: 'Send Request',
    setupStatus: 'Set Up',
  ),
];
