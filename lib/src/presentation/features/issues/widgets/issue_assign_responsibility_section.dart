import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/partner_staff_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';

class IssueAssignResponsibilitySection extends StatelessWidget {
  const IssueAssignResponsibilitySection({
    super.key,
    required this.selected,
    required this.onTap,
    required this.onClear,
  });

  final PartnerStaffEntity? selected;
  final VoidCallback onTap;
  final VoidCallback onClear;

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
          borderRadius: BorderRadius.circular(radius.r12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (selected == null)
              BodySmallText(
                context.locale.noResponsibilityAdded,
                color: context.color.text.secondary,
              )
            else
              BodySmallText(
                context.locale.assignResponsibility,
                color: context.color.text.secondary,
              ),
            Gap(spacing.s12),
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: selected != null
                      ? context.color.primary
                      : context.color.brandAccent,
                  child: Icon(
                    selected != null
                        ? Icons.check_rounded
                        : Icons.person_outline_rounded,
                    size: 18,
                    color: selected != null
                        ? context.color.onPrimary
                        : context.color.text.primary,
                  ),
                ),
                Gap(spacing.s8),
                Expanded(
                  child: selected != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LabelLargeText(selected!.name),
                            Gap(spacing.s2),
                            BodySmallText(
                              selected!.phoneNumber ?? selected!.email,
                              color: context.color.text.secondary,
                            ),
                          ],
                        )
                      : LabelLargeText(context.locale.assignResponsibility),
                ),
                if (selected != null)
                  GestureDetector(
                    onTap: onClear,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: context.color.error),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.close_rounded,
                        size: 14,
                        color: context.color.error,
                      ),
                    ),
                  )
                else
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: context.color.primary,
                            width: 1.5,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.add_rounded,
                          size: 18,
                          color: context.color.primary,
                        ),
                      ),
                      Gap(spacing.s6),
                      LabelLargeText(
                        context.locale.add,
                        color: context.color.primary,
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
