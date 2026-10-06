import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';
import 'dashboard_icons.dart';
import 'dashboard_tone.dart';

/// Two big buttons, Check In and Check Out, with the shift status below.
///
/// WHY stateless: whether the user has checked in lives in the attendance
/// state, not here. A null callback disables that button.
class CheckInOutCard extends StatelessWidget {
  const CheckInOutCard({
    super.key,
    required this.checkInText,
    required this.checkOutText,
    required this.statusText,
    required this.statusTone,
    this.onCheckIn,
    this.onCheckOut,
  });

  /// Shown under "Check In", e.g. "08:02 AM" or "--:--".
  final String checkInText;
  final String checkOutText;

  /// e.g. "Mirpur morning shift - not checked in yet".
  final String statusText;

  /// Colour of the status dot: neutral (not in), green (working), blue (done).
  final DashboardTone statusTone;
  final VoidCallback? onCheckIn;
  final VoidCallback? onCheckOut;

  @override
  Widget build(BuildContext context) {
    final c = context.color;
    final spacing = context.dimensions.spacing;

    return Container(
      padding: EdgeInsets.all(spacing.s12),
      decoration: BoxDecoration(
        color: c.onPrimary,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r16),
        border: Border.all(color: c.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: DashboardIconPaths.checkIn,
                  label: context.locale.checkIn,
                  time: checkInText,
                  tone: DashboardTone.green,
                  onTap: onCheckIn,
                ),
              ),
              SizedBox(width: spacing.s10),
              Expanded(
                child: _ActionButton(
                  icon: DashboardIconPaths.checkOut,
                  label: context.locale.checkOut,
                  time: checkOutText,
                  tone: DashboardTone.red,
                  onTap: onCheckOut,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.s10),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: statusTone.accent(context),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: spacing.s8),
              Expanded(
                child: Text(
                  statusText,
                  style: context.textStyle.bodySmall.copyWith(
                    color: c.text.secondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.time,
    required this.tone,
    required this.onTap,
  });

  final String icon;
  final String label;
  final String time;
  final DashboardTone tone;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    final spacing = context.dimensions.spacing;
    final radius = BorderRadius.circular(context.dimensions.radius.r12);
    final bg = enabled
        ? tone.background(context)
        : DashboardTone.neutral.background(context);
    final fg = enabled
        ? tone.foreground(context)
        : context.color.text.secondary;

    return Material(
      color: bg,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          constraints: const BoxConstraints(minHeight: 56),
          padding: EdgeInsets.all(spacing.s12),
          child: Row(
            children: [
              DashboardIcon(icon, color: fg),
              SizedBox(width: spacing.s10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: context.textStyle.labelLarge.copyWith(
                        color: fg,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      time,
                      style: context.textStyle.bodySmall.copyWith(color: fg),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
