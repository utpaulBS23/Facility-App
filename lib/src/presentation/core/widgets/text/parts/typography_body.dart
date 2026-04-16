part of '../typography.dart';

class BodyLargeText extends _Typography {
  const BodyLargeText(
    super.text, {
    super.key,
    super.color,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.softWrap,
    super.textDirection,
    super.semanticsLabel,
  }) : _secondary = false;

  const BodyLargeText.secondary(
    super.text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.softWrap,
    super.textDirection,
    super.semanticsLabel,
  })  : _secondary = true,
        super(color: null);

  final bool _secondary;

  @override
  Widget build(BuildContext context) => Text(
        text,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        softWrap: softWrap,
        textDirection: textDirection,
        semanticsLabel: semanticsLabel,
        style: context.textStyle.bodyLarge.copyWith(
          color: _secondary
              ? context.color.text.secondary
              : color ?? context.color.text.primary,
        ),
      );
}

class BodyMediumText extends _Typography {
  const BodyMediumText(
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
        style: context.textStyle.bodyMedium.copyWith(
          color: color ?? context.color.text.primary,
        ),
      );
}

// WHY: BodyRegularText exposes a .secondary named constructor for the common
// case of muted descriptive text, matching the product design's usage pattern.
class BodyRegularText extends _Typography {
  const BodyRegularText(
    super.text, {
    super.key,
    super.color,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.softWrap,
    super.textDirection,
    super.semanticsLabel,
  }) : _secondary = false;

  const BodyRegularText.secondary(
    super.text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.softWrap,
    super.textDirection,
    super.semanticsLabel,
  })  : _secondary = true,
        super(color: null);

  final bool _secondary;

  @override
  Widget build(BuildContext context) => Text(
        text,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        softWrap: softWrap,
        textDirection: textDirection,
        semanticsLabel: semanticsLabel,
        style: context.textStyle.bodyRegular.copyWith(
          color: _secondary
              ? context.color.text.secondary
              : color ?? context.color.text.primary,
        ),
      );
}

class BodySmallUppercaseText extends _Typography {
  const BodySmallUppercaseText(
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
        text.toUpperCase(),
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        softWrap: softWrap,
        textDirection: textDirection,
        semanticsLabel: semanticsLabel,
        style: context.textStyle.bodySmallUppercase.copyWith(
          color: color ?? context.color.text.primary,
        ),
      );
}

class BodySmallText extends _Typography {
  const BodySmallText(
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
        style: context.textStyle.bodySmall.copyWith(
          color: color ?? context.color.text.primary,
        ),
      );
}
