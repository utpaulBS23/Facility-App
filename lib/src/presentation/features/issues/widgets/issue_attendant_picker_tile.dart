import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/partner_staff_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';

class IssueAttendantPickerTile extends StatelessWidget {
  const IssueAttendantPickerTile({
    super.key,
    required this.attendant,
    required this.onTap,
  });

  final PartnerStaffEntity attendant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(spacing.s16),
        decoration: BoxDecoration(
          color: context.color.onPrimary,
          border: Border.all(color: context.color.borderSubtle),
          borderRadius: BorderRadius.circular(radius.r12),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: context.color.brandAccent,
              child: Icon(
                Icons.person_outline_rounded,
                color: context.color.text.primary,
                size: 22,
              ),
            ),
            Gap(spacing.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabelLargeText(attendant.name),
                  Gap(spacing.s2),
                  BodySmallText(
                    attendant.phoneNumber ?? attendant.email,
                    color: context.color.text.secondary,
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
                color: attendant.isActive
                    ? context.color.successAlt
                    : context.color.warningAlt,
                borderRadius: BorderRadius.circular(radius.r4),
              ),
              child: BodySmallText(
                attendant.userRole ?? context.locale.status,
                color: attendant.isActive
                    ? context.color.success
                    : context.color.warning,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
