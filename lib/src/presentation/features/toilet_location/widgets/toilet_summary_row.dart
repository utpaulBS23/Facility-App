part of '../view/toilet_location_page.dart';

/// "Open" / "Total" header stat cards, bound to `summary.active`/`summary.total`.
class _ToiletSummaryRow extends StatelessWidget {
  const _ToiletSummaryRow({required this.summary});

  final ToiletSummaryEntity summary;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Row(
      children: [
        Expanded(
          child: _SummaryTile(
            count: summary.active,
            label: context.locale.open,
          ),
        ),
        Gap(spacing.s12),
        Expanded(
          child: _SummaryTile(
            count: summary.total,
            label: context.locale.total,
          ),
        ),
      ],
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({required this.count, required this.label});

  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.s16,
        vertical: spacing.s12,
      ),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        border: Border.all(color: context.color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            NumberFormatter.format(count),
            style: context.textStyle.headline2xlTiny.copyWith(
              color: context.color.error,
              fontWeight: FontWeight.bold,
            ),
          ),
          Gap(spacing.s2),
          Text(
            label,
            style: context.textStyle.bodySmall.copyWith(
              color: context.color.text.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
