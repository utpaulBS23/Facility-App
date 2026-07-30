part of '../view/shift_tab.dart';

/// One selfie: round thumbnail beside its direction icon and label.
class _SlotSelfieEntry extends StatelessWidget {
  const _SlotSelfieEntry({
    required this.url,
    required this.label,
    required this.icon,
    required this.iconColor,
  });

  final String url;
  final String label;
  final IconData icon;

  /// WHY passed in: the design marks direction by colour as much as by glyph —
  /// arriving reads green, leaving reads brand red.
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Row(
      children: [
        _SlotSelfieAvatar(url: url),
        Gap(spacing.s8),
        Icon(icon, size: spacing.s16, color: iconColor),
        Gap(spacing.s4),
        Flexible(
          child: Text(
            label,
            style: context.textStyle.labelMedium12.copyWith(
              color: context.color.text.primary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
