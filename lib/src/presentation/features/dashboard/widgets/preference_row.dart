import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';
import 'dashboard_icons.dart';
import 'dashboard_toggle.dart';
import 'dashboard_tone.dart';

/// How a preference reaches the user by email.
enum EmailMode {
  /// A switch the user can flip.
  toggle,

  /// Only in the daily digest; not configurable.
  digest,

  /// No email channel: the row shows the Push switch alone.
  none,
}

/// One notification preference: icon, title, hint, and its channel switches.
class PreferenceRow extends StatelessWidget {
  const PreferenceRow({
    super.key,
    required this.kind,
    required this.tone,
    required this.title,
    required this.hint,
    required this.pushOn,
    this.pushLocked = false,
    this.emailMode = EmailMode.toggle,
    this.emailOn = false,
    this.onPushChanged,
    this.onEmailChanged,
  });

  /// Icon key, e.g. "camera". See [DashboardIconPaths.byKind].
  final String kind;
  final DashboardTone tone;
  final String title;
  final String hint;
  final bool pushOn;
  final bool pushLocked;
  final EmailMode emailMode;
  final bool emailOn;
  final ValueChanged<bool>? onPushChanged;
  final ValueChanged<bool>? onEmailChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.color;
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final two = emailMode != EmailMode.none;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: c.onPrimary,
        borderRadius: BorderRadius.circular(radius.r16),
        border: Border.all(color: c.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: tone.background(context),
                  borderRadius: BorderRadius.circular(radius.r12),
                ),
                child: DashboardIcon(
                  DashboardIconPaths.byKind[kind] ?? DashboardIconPaths.warning,
                  color: tone.foreground(context),
                ),
              ),
              SizedBox(width: spacing.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.textStyle.labelLarge.copyWith(
                        color: c.text.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: spacing.s2),
                    Text(
                      hint,
                      style: context.textStyle.bodySmall.copyWith(
                        color: c.text.secondary,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.s12),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: DashboardToggle(
                    label: context.locale.pushChannel,
                    on: pushOn,
                    locked: pushLocked,
                    onChanged: onPushChanged,
                  ),
                ),
                if (two) SizedBox(width: spacing.s10),
                if (emailMode == EmailMode.toggle)
                  Expanded(
                    child: DashboardToggle(
                      label: context.locale.email,
                      on: emailOn,
                      onChanged: onEmailChanged,
                    ),
                  ),
                if (emailMode == EmailMode.digest)
                  Expanded(child: _DigestBox(label: context.locale.email)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DigestBox extends StatelessWidget {
  const _DigestBox({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.color;
    final spacing = context.dimensions.spacing;

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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: context.textStyle.labelMedium12.copyWith(
              color: c.text.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            constraints: const BoxConstraints(minHeight: 44),
            alignment: Alignment.centerLeft,
            child: Text(
              context.locale.digestOnly,
              style: context.textStyle.labelMedium12.copyWith(
                color: c.text.secondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
