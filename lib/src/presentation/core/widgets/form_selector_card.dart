import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../theme/theme.dart';

/// The one tap-to-pick card of the app: a small title, then an optional icon,
/// the value and a chevron. Every card style dropdown (leave type, facility,
/// income type, a date field...) is this card, so they all look and behave the
/// same.
///
/// Use [FormSelectorCard.text] for the usual "value or placeholder" content,
/// and the main constructor only when the content is more than text.
class FormSelectorCard extends StatelessWidget {
  const FormSelectorCard({
    super.key,
    required this.title,
    required this.content,
    required this.onTap,
    this.icon,
    this.enabled = true,
    this.errorText,
  });

  /// A card showing [value], or [placeholder] in a muted colour while there is
  /// no value.
  FormSelectorCard.text({
    Key? key,
    required String title,
    required String? value,
    required String placeholder,
    required VoidCallback? onTap,
    IconData? icon,
    bool enabled = true,
    String? errorText,
  }) : this(
         key: key,
         title: title,
         icon: icon,
         onTap: onTap,
         enabled: enabled,
         errorText: errorText,
         content: _CardText(value: value, placeholder: placeholder),
       );

  final String title;
  final Widget content;
  final VoidCallback? onTap;

  /// Left of the value. Optional, but the app puts one on every card.
  final IconData? icon;

  /// Also treated as false while [onTap] is null.
  final bool enabled;

  /// Shown under the card, and turns the border red.
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;
    final icon = this.icon;
    final errorText = this.errorText;
    // WHY: a card with nothing to do on tap reads as disabled too.
    final active = enabled && onTap != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: active ? onTap : null,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: spacing.s16,
              vertical: spacing.s10,
            ),
            decoration: BoxDecoration(
              color: active
                  ? color.onPrimary
                  : color.borderSubtle.withValues(alpha: 0.1),
              border: Border.all(
                color: errorText == null ? color.borderSubtle : color.error,
              ),
              borderRadius: BorderRadius.circular(
                context.dimensions.radius.r12,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textStyle.bodySmall.copyWith(
                    color: color.text.secondary,
                  ),
                ),
                Gap(spacing.s6),
                Row(
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: spacing.s20, color: color.icon),
                      Gap(spacing.s8),
                    ],
                    Expanded(child: content),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: spacing.s20,
                      color: color.primary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (errorText != null) ...[
          Gap(spacing.s4),
          Padding(
            padding: EdgeInsets.only(left: spacing.s4),
            child: Text(
              errorText,
              style: textStyle.bodySmall.copyWith(color: color.error),
            ),
          ),
        ],
      ],
    );
  }
}

class _CardText extends StatelessWidget {
  const _CardText({required this.value, required this.placeholder});

  final String? value;
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    final color = context.color;
    final value = this.value;

    return Text(
      value ?? placeholder,
      overflow: TextOverflow.ellipsis,
      style: context.textStyle.titleSmall.copyWith(
        color: value == null ? color.backgroundMuted : color.text.secondary,
      ),
    );
  }
}
