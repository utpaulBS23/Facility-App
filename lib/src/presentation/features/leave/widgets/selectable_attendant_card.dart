part of '../view/apply_leave_page.dart';

class _SelectableAttendantCard extends StatelessWidget {
  const _SelectableAttendantCard({
    required this.staff,
    required this.index,
    required this.onTap,
  });

  final PartnerStaffEntity staff;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;

    final mockLocations = [
      'Mirpur-10 Public Toilet',
      'Dhanmondi Park Restroom',
      'Gulshan Lake Toilet',
      'Banani Bus Stop Restroom',
    ];
    final mockShifts = [
      context.locale.morningShift,
      context.locale.eveningShift,
      context.locale.nightShift,
    ];

    final location = mockLocations[index % mockLocations.length];
    final shiftName = mockShifts[index % mockShifts.length];
    final displayId = staff.uid ?? 'ATT-00${41 + index}';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
      child: Container(
        padding: EdgeInsets.all(spacing.s12),
        decoration: BoxDecoration(
          color: color.onPrimary,
          borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
          border: Border.all(
            color: color.borderSubtle,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: color.primary.withValues(alpha: 0.1),
              child: Icon(
                Icons.person,
                color: color.primary,
              ),
            ),
            Gap(spacing.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    staff.name,
                    style: textStyle.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color.text.primary,
                    ),
                  ),
                  Gap(spacing.s4),
                  Text(
                    'ID: $displayId',
                    style: textStyle.bodyMedium.copyWith(
                      color: color.text.secondary,
                    ),
                  ),
                  Gap(spacing.s4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: color.text.secondary,
                      ),
                      Gap(spacing.s4),
                      Expanded(
                        child: Text(
                          location,
                          style: textStyle.bodyMedium.copyWith(
                            color: color.text.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: spacing.s8,
                vertical: spacing.s4,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: color.primary,
                ),
                borderRadius: BorderRadius.circular(
                  context.dimensions.radius.r20,
                ),
              ),
              child: Text(
                shiftName,
                style: textStyle.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
