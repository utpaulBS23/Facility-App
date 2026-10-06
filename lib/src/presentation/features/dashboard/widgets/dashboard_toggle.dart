import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';
import 'dashboard_icons.dart';

/// A labelled on/off switch in a grey box. A locked switch is always on and
/// shows a padlock in the knob.
class DashboardToggle extends StatelessWidget {
  const DashboardToggle({
    super.key,
    required this.label,
    required this.on,
    this.locked = false,
    this.onChanged,
  });

  final String label;
  final bool on;
  final bool locked;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.color;
    final spacing = context.dimensions.spacing;
    final locale = context.locale;
    final status = locked
        ? locale.alwaysOn
        : on
        ? locale.toggleOn
        : locale.toggleOff;
    final track = on
        ? (locked ? c.primary.withValues(alpha: 0.55) : c.primary)
        : c.backgroundMuted;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.s12,
        vertical: spacing.s10,
      ),
      decoration: BoxDecoration(
        color: c.subtle,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.textStyle.labelMedium12.copyWith(
              color: c.text.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: spacing.s6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  status,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyle.labelMedium12.copyWith(
                    color: on ? c.text.brand : c.text.secondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Semantics(
                toggled: on,
                enabled: !locked,
                label: locked ? '$label ${locale.alwaysOn}' : label,
                child: InkWell(
                  onTap: locked || onChanged == null
                      ? null
                      : () => onChanged!(!on),
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 44),
                    padding: EdgeInsets.only(left: spacing.s8),
                    alignment: Alignment.center,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 44,
                      height: 26,
                      decoration: BoxDecoration(
                        color: track,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: AnimatedAlign(
                        duration: const Duration(milliseconds: 150),
                        alignment: on
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          width: 22,
                          height: 22,
                          margin: const EdgeInsets.all(2),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: c.onPrimary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: c.shadow,
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: locked
                              ? DashboardIcon(
                                  DashboardIconPaths.lock,
                                  color: c.text.brand,
                                  size: 12,
                                  strokeWidth: 2.5,
                                )
                              : null,
                        ),
                      ),
                    ),
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
