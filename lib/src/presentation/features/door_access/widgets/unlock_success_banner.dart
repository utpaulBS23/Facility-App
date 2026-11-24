part of '../view/door_control_page.dart';

class _UnlockSuccessBanner extends StatelessWidget {
  const _UnlockSuccessBanner({
    required this.result,
    this.usageType,
    this.onBack,
  });

  final DoorUnlockResult result;
  final _UsageType? usageType;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dimensions = context.dimensions;
    final time = TimeOfDay.fromDateTime(result.timestamp).format(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(dimensions.padding.p16),
      decoration: BoxDecoration(
        color: colors.successAlt,
        border: Border.all(color: colors.success),
        borderRadius: BorderRadius.circular(dimensions.radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.verified_outlined,
                color: colors.success,
                size: dimensions.spacing.s24,
              ),
              Gap(dimensions.spacing.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${context.locale.doorUnlockedSuccessfully} — ${result.summary}',
                      style: context.textStyle.bodyRegular.copyWith(
                        color: colors.text.primary,
                        fontWeight: TextWeight.semibold,
                      ),
                    ),
                    Gap(dimensions.spacing.s4),
                    Text(
                      time,
                      style: context.textStyle.bodySmall.copyWith(
                        color: colors.text.secondary,
                      ),
                    ),
                    if (usageType != null) ...[
                      Gap(dimensions.spacing.s8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: dimensions.padding.p16,
                          vertical: dimensions.padding.p4,
                        ),
                        decoration: BoxDecoration(
                          color: colors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(dimensions.radius.r12),
                        ),
                        child: Text(
                          usageType == _UsageType.personal ? 'Personal Use' : 'Customer Use',
                          style: context.textStyle.bodySmall.copyWith(
                            color: colors.success,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (onBack != null) ...[
            Gap(dimensions.spacing.s12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onBack,
                icon: Icon(Icons.arrow_back),
                label: Text('Go Back'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.success,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
