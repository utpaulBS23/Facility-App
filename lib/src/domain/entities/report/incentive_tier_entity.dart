import 'incentive_breakdown_row_entity.dart';

class IncentiveTierEntity {
  const IncentiveTierEntity({
    required this.title,
    required this.subtitle,
    required this.isActive,
    this.activeAmountText,
    this.breakdown = const [],
  });

  final String title;
  final String subtitle;
  final bool isActive;

  /// Shown inline on the row, right-aligned — for an active flat-rate tier
  /// (no per-percent bonus to break down).
  final String? activeAmountText;

  /// Populated only on an active tier that has a bonus component to break
  /// down (base + per-percent), rendered as a nested breakdown card instead
  /// of [activeAmountText].
  final List<IncentiveBreakdownRowEntity> breakdown;
}
