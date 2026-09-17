part of '../view/toilet_details_page.dart';

/// The API only surfaces a supervisor name for a facility — no phone number,
/// shift, or multi-person roster, so this card stays a single row.
class _ToiletSupervisorCard extends StatelessWidget {
  const _ToiletSupervisorCard({
    required this.facilityName,
    required this.supervisorName,
  });

  final String facilityName;
  final String supervisorName;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final radius = context.dimensions.radius;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        border: Border.all(color: color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            facilityName,
            style: context.textStyle.headline2xlTiny.copyWith(
              fontWeight: FontWeight.bold,
              color: color.text.primary,
            ),
          ),
          Gap(spacing.s12),
          Divider(color: color.borderSubtle, height: 1),
          Gap(spacing.s12),
          Row(
            children: [
              Container(
                width: spacing.s40,
                height: spacing.s40,
                decoration: BoxDecoration(
                  color: color.errorAlt,
                  borderRadius: BorderRadius.circular(radius.r10),
                ),
                child: Icon(
                  Icons.person_outline,
                  color: color.error,
                  size: spacing.s20,
                ),
              ),
              Gap(spacing.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      supervisorName.isNotEmpty
                          ? supervisorName
                          : context.locale.notAvailable,
                      style: context.textStyle.bodyMedium.copyWith(
                        color: color.text.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      context.locale.supervisor,
                      style: context.textStyle.bodySmall.copyWith(
                        color: color.text.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
