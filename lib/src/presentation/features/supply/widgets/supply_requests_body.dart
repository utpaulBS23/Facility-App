part of '../view/supply_requests_page.dart';

class _SupplyRequestsBody extends StatelessWidget {
  const _SupplyRequestsBody({
    required this.padding,
    required this.summary,
    required this.pendingDeliveryAlert,
    required this.newRequestButton,
    required this.filterBar,
    required this.list,
  });

  final EdgeInsetsGeometry padding;
  final Widget summary;
  final Widget? pendingDeliveryAlert;
  final Widget? newRequestButton;
  final Widget filterBar;
  final Widget list;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return SingleChildScrollView(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          summary,
          Gap(spacing.s16),
          if (pendingDeliveryAlert != null) ...[
            pendingDeliveryAlert!,
            Gap(spacing.s16),
          ],
          if (newRequestButton != null) ...[
            newRequestButton!,
            Gap(spacing.s16),
          ],
          filterBar,
          Gap(spacing.s16),
          list,
        ],
      ),
    );
  }
}
