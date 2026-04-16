part of '../typography.dart';

// WHY: labelMedium12 (12px w600) was removed from the type scale.
// Mapped to labelSmall (11px w500) — the closest remaining semibold label.
class LabelMedium12Text extends _Typography {
  const LabelMedium12Text(
    super.text, {
    super.key,
    super.color,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.softWrap,
    super.textDirection,
    super.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) => Text(
        text,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        softWrap: softWrap,
        textDirection: textDirection,
        semanticsLabel: semanticsLabel,
        style: context.textStyle.labelSmall.copyWith(
          color: color ?? context.color.text.primary,
        ),
      );
}

class LabelSmallText extends _Typography {
  const LabelSmallText(
    super.text, {
    super.key,
    super.color,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.softWrap,
    super.textDirection,
    super.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) => Text(
        text,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        softWrap: softWrap,
        textDirection: textDirection,
        semanticsLabel: semanticsLabel,
        style: context.textStyle.labelSmall.copyWith(
          color: color ?? context.color.text.primary,
        ),
      );
}

class LabelTinyText extends _Typography {
  const LabelTinyText(
    super.text, {
    super.key,
    super.color,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.softWrap,
    super.textDirection,
    super.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) => Text(
        text,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        softWrap: softWrap,
        textDirection: textDirection,
        semanticsLabel: semanticsLabel,
        style: context.textStyle.labelTiny.copyWith(
          color: color ?? context.color.text.primary,
        ),
      );
}
