import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../dashboard/widgets/dashboard_tone.dart';

/// One person on the shift: initials avatar, name with a status pill, role and
/// phone, a note about their check in, and a call button.
class ToiletAttendeeTile extends StatelessWidget {
  const ToiletAttendeeTile({
    super.key,
    required this.initials,
    required this.name,
    required this.statusLabel,
    required this.statusTone,
    required this.roleAndPhone,
    required this.note,
    this.onCall,
    this.showDivider = true,
  });

  final String initials;
  final String name;
  final String statusLabel;
  final DashboardTone statusTone;

  /// e.g. "Lead Attendant · +880 1712-345001".
  final String roleAndPhone;

  /// e.g. "Checked in 6:02 AM".
  final String note;
  final VoidCallback? onCall;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final c = context.color;
    final spacing = context.dimensions.spacing;
    final small = context.textStyle.bodySmall.copyWith(color: c.text.secondary);

    return Container(
      padding: EdgeInsets.symmetric(vertical: spacing.s12),
      decoration: BoxDecoration(
        border: showDivider
            ? Border(bottom: BorderSide(color: c.borderSubtle))
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: c.brandAccent,
              shape: BoxShape.circle,
            ),
            child: Text(
              initials,
              style: context.textStyle.labelLarge.copyWith(
                color: c.text.brand,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(width: spacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: spacing.s8,
                  children: [
                    Text(
                      name,
                      style: context.textStyle.labelLarge.copyWith(
                        color: c.text.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: spacing.s8,
                        vertical: spacing.s2,
                      ),
                      decoration: BoxDecoration(
                        color: statusTone.background(context),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        statusLabel,
                        style: context.textStyle.labelSmall.copyWith(
                          color: statusTone.foreground(context),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: spacing.s2),
                Text(roleAndPhone, style: small),
                Text(note, style: small),
              ],
            ),
          ),
          SizedBox(width: spacing.s8),
          Semantics(
            button: true,
            child: InkWell(
              onTap: onCall,
              borderRadius: BorderRadius.circular(
                context.dimensions.radius.r12,
              ),
              child: Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: c.onPrimary,
                  borderRadius: BorderRadius.circular(
                    context.dimensions.radius.r12,
                  ),
                  border: Border.all(color: c.borderSubtle),
                ),
                child: Icon(Icons.phone_outlined, size: 20, color: c.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
