part of '../typography.dart';

class DisplayLargeText extends _Typography {
  const DisplayLargeText(
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
        style: context.textStyle.displayLarge.copyWith(
          color: color ?? context.color.text.primary,
        ),
      );
}

class DisplayMediumText extends _Typography {
  const DisplayMediumText(
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
        style: context.textStyle.displayMedium.copyWith(
          color: color ?? context.color.text.primary,
        ),
      );
}

class DisplayMediumSecondaryText extends _Typography {
  const DisplayMediumSecondaryText(
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
        style: context.textStyle.displayMedium.copyWith(
          color: color ?? context.color.text.secondary,
        ),
      );
}

class DisplaySmallText extends _Typography {
  const DisplaySmallText(
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
        style: context.textStyle.displaySmall.copyWith(
          color: color ?? context.color.text.primary,
        ),
      );
}
