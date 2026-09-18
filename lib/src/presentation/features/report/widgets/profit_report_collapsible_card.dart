part of '../view/profit_report_page.dart';

class _ProfitReportCollapsibleCard extends StatefulWidget {
  const _ProfitReportCollapsibleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.child,
    this.initiallyExpanded = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget child;
  final bool initiallyExpanded;

  @override
  State<_ProfitReportCollapsibleCard> createState() =>
      _ProfitReportCollapsibleCardState();
}

class _ProfitReportCollapsibleCardState
    extends State<_ProfitReportCollapsibleCard> {
  late bool _isExpanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    return Container(
      decoration: BoxDecoration(
        color: color.onPrimary,
        border: Border.all(color: color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(radius.r16),
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding: EdgeInsets.all(spacing.s16),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(spacing.s8),
                    decoration: BoxDecoration(
                      color: color.brandSubtle,
                      borderRadius: BorderRadius.circular(radius.r10),
                    ),
                    child: Icon(
                      widget.icon,
                      color: color.primary,
                      size: spacing.s20,
                    ),
                  ),
                  Gap(spacing.s10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: context.textStyle.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          widget.subtitle,
                          style: context.textStyle.bodySmall.copyWith(
                            color: color.text.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: color.text.muted,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: EdgeInsets.fromLTRB(
                spacing.s16,
                0,
                spacing.s16,
                spacing.s16,
              ),
              child: widget.child,
            ),
        ],
      ),
    );
  }
}
