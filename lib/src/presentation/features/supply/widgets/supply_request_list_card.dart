part of '../view/supply_requests_page.dart';

class _SupplyRequestListCard extends StatelessWidget {
  const _SupplyRequestListCard({
    required this.request,
    required this.onTap,
  });

  final SupplyRequestEntity request;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(spacing.s16),
        decoration: BoxDecoration(
          color: context.color.onPrimary,
          border: Border.all(color: context.color.borderSubtle),
          borderRadius: BorderRadius.circular(radius.r12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(spacing.s12),
              decoration: BoxDecoration(
                color: context.color.brandSubtle,
                borderRadius: BorderRadius.circular(radius.r12),
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                color: context.color.primary,
                size: spacing.s24,
              ),
            ),
            Gap(spacing.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      StatusDotTag(
                        dotColor: _getStatusColor(context, request.status),
                        label: _getStatusLabel(context, request.status),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: context.color.text.secondary,
                      ),
                    ],
                  ),
                  Gap(spacing.s6),
                  Text(
                    request.facilityName,
                    style: context.textStyle.titleMedium.copyWith(
                      color: context.color.text.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gap(spacing.s4),
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline_rounded,
                        size: spacing.s14,
                        color: context.color.text.secondary,
                      ),
                      Gap(spacing.s4),
                      Text(
                        request.requestedByName,
                        style: context.textStyle.bodySmall.copyWith(
                          color: context.color.text.secondary,
                        ),
                      ),
                    ],
                  ),
                  Gap(spacing.s6),
                  Row(
                    children: [
                      Text(
                        context.locale.supplyItemsCount(
                          NumberFormatter.format(context, request.itemCount),
                        ),
                        style: context.textStyle.bodySmall.copyWith(
                          color: context.color.text.secondary,
                        ),
                      ),
                      Text(
                        ' • ',
                        style: context.textStyle.bodySmall.copyWith(
                          color: context.color.text.secondary,
                        ),
                      ),
                      Container(
                        width: spacing.s8,
                        height: spacing.s8,
                        decoration: BoxDecoration(
                          color: _getUrgencyColor(context, request.urgency),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Gap(spacing.s4),
                      Text(
                        _getUrgencyLabel(context, request.urgency),
                        style: context.textStyle.bodySmall.copyWith(
                          color: _getUrgencyColor(context, request.urgency),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusLabel(BuildContext context, SupplyRequestStatus status) {
    return switch (status) {
      SupplyRequestStatus.pendingSupervisor => context.locale.pendingSupervisor,
      SupplyRequestStatus.pendingOperationManager =>
        context.locale.pendingOperationManager,
      SupplyRequestStatus.operationManagerApproved =>
        context.locale.operationManagerApproved,
      SupplyRequestStatus.inDelivery => context.locale.inDelivery,
      SupplyRequestStatus.delivered => context.locale.delivered,
      SupplyRequestStatus.rejected => context.locale.rejected,
      SupplyRequestStatus.completed => context.locale.completed,
      SupplyRequestStatus.unknown => context.locale.notAvailable,
    };
  }

  Color _getStatusColor(BuildContext context, SupplyRequestStatus status) {
    return switch (status) {
      SupplyRequestStatus.pendingSupervisor => context.color.warning,
      SupplyRequestStatus.pendingOperationManager => context.color.info,
      SupplyRequestStatus.operationManagerApproved => context.color.primary,
      SupplyRequestStatus.inDelivery => context.color.text.secondary,
      SupplyRequestStatus.delivered => context.color.success,
      SupplyRequestStatus.rejected => context.color.error,
      SupplyRequestStatus.completed => context.color.success,
      SupplyRequestStatus.unknown => context.color.text.secondary,
    };
  }

  String _getUrgencyLabel(BuildContext context, SupplyUrgency urgency) {
    return switch (urgency) {
      SupplyUrgency.urgent => context.locale.urgencyUrgent,
      SupplyUrgency.high => context.locale.urgencyHigh,
      SupplyUrgency.normal => context.locale.urgencyNormal,
      SupplyUrgency.low => context.locale.urgencyLow,
    };
  }

  Color _getUrgencyColor(BuildContext context, SupplyUrgency urgency) {
    return switch (urgency) {
      SupplyUrgency.urgent => context.color.primary,
      SupplyUrgency.high => context.color.warning,
      SupplyUrgency.normal => context.color.success,
      SupplyUrgency.low => context.color.text.secondary,
    };
  }
}
