part of '../typography.dart';

class TitleSmallText extends _Typography {
  const TitleSmallText(
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
        style: context.textStyle.titleSmall.copyWith(
          color: color ?? context.color.text.primary,
        ),
      );
}

class TitleSmUppercaseText extends _Typography {
  const TitleSmUppercaseText(
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
        style: context.textStyle.titleSmUppercase.copyWith(
          color: color ?? context.color.text.primary,
        ),
      );
}

class TitleTinyUppercaseText extends _Typography {
  const TitleTinyUppercaseText(
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
        style: context.textStyle.titleTinyUppercase.copyWith(
          color: color ?? context.color.text.primary,
        ),
      );
}
