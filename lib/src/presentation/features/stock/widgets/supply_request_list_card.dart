part of '../view/supply_requests_page.dart';

class _SupplyRequestListCard extends StatelessWidget {
  const _SupplyRequestListCard({
    required this.request,
    required this.onTap,
  });

  final SupplyRequestEntity request;
  final VoidCallback onTap;

  Color _statusDotColor(BuildContext context) => switch (request.status) {
        'pending_supervisor' => context.color.warning,
        'pending_operation_manager' => context.color.info,
        'operation_manager_approved' => context.color.primary,
        'in_delivery' => context.color.text.secondary,
        'delivered' => context.color.success,
        'rejected' => context.color.error,
        _ => context.color.text.secondary,
      };

  Color _priorityColor(BuildContext context) => switch (request.urgency.toLowerCase()) {
        'urgent' => context.color.primary,
        'high priority' => context.color.warning,
        'high' => context.color.warning,
        _ => context.color.success,
      };

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
                color: context.color.primary.withValues(alpha: 0.1),
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
                        dotColor: _statusDotColor(context),
                        label: _supplyStatusLabel(context, request.status),
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
                        '${request.itemCount} items',
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
                          color: _priorityColor(context),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Gap(spacing.s4),
                      Text(
                        request.urgency,
                        style: context.textStyle.bodySmall.copyWith(
                          color: _priorityColor(context),
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
}
