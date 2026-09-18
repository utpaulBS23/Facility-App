enum IncentiveRateRowStyle {
  /// Green, bold — an earned incentive amount.
  positive,

  /// Muted dash — no incentive at this slab.
  muted,

  /// Red, bold — a policy note instead of a fixed amount (e.g. an
  /// under-performance slab handled case-by-case).
  note,
}

class IncentiveRateRowEntity {
  const IncentiveRateRowEntity({
    required this.rangeLabel,
    required this.valueText,
    required this.style,
  });

  final String rangeLabel;
  final String valueText;
  final IncentiveRateRowStyle style;
}
