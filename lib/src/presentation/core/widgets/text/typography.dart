// Author: Md. Shahin Bashar
// Created: 2026-04-02

import 'package:flutter/material.dart';

import '../../theme/theme.dart';

// WHY: One widget class per Figma type token so call sites self-document
// the intended semantic role without consulting the design spec.
// Naming mirrors the Figma token names (node 13021:15735) in PascalCase.
// Uppercase variants call .toUpperCase() internally so callers don't need to.
abstract class _Typography extends StatelessWidget {
  const _Typography(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.textDirection,
    this.semanticsLabel,
  });

  final String text;

  // WHY: optional color override — defaults to context.color.text.primary
  // inside each subclass, avoiding a hard dependency in the base.
  final Color? color;

  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final TextDirection? textDirection;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context);
}

// ── Display ───────────────────────────────────────────────────────────────────

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

// ── Headline ──────────────────────────────────────────────────────────────────

class HeadlineLargeText extends _Typography {
  const HeadlineLargeText(
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
        style: context.textStyle.headlineLarge.copyWith(
          color: color ?? context.color.text.primary,
        ),
      );
}

class HeadlineMediumText extends _Typography {
  const HeadlineMediumText(
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
        style: context.textStyle.headlineMedium.copyWith(
          color: color ?? context.color.text.primary,
        ),
      );
}

class HeadlineSmallText extends _Typography {
  const HeadlineSmallText(
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
        style: context.textStyle.headlineSmall.copyWith(
          color: color ?? context.color.text.primary,
        ),
      );
}

class HeadlineTinyText extends _Typography {
  const HeadlineTinyText(
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
        style: context.textStyle.headlineTiny.copyWith(
          color: color ?? context.color.text.primary,
        ),
      );
}

class Headline1xlTinyText extends _Typography {
  const Headline1xlTinyText(
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
        style: context.textStyle.headline1xlTiny.copyWith(
          color: color ?? context.color.text.primary,
        ),
      );
}

class Headline2xlTinyText extends _Typography {
  const Headline2xlTinyText(
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
        style: context.textStyle.headline2xlTiny.copyWith(
          color: color ?? context.color.text.primary,
        ),
      );
}

// ── Title ─────────────────────────────────────────────────────────────────────

class TitleLargeText extends _Typography {
  const TitleLargeText(
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
        style: context.textStyle.titleLarge.copyWith(
          color: color ?? context.color.text.primary,
        ),
      );
}

class TitleXlUppercaseText extends _Typography {
  const TitleXlUppercaseText(
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
        style: context.textStyle.titleXlUppercase.copyWith(
          color: color ?? context.color.text.primary,
        ),
      );
}

class TitleMediumText extends _Typography {
  const TitleMediumText(
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
        style: context.textStyle.titleMedium.copyWith(
          color: color ?? context.color.text.primary,
        ),
      );
}

class TitleMediumUppercaseText extends _Typography {
  const TitleMediumUppercaseText(
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
        style: context.textStyle.titleMediumUppercase.copyWith(
          color: color ?? context.color.text.primary,
        ),
      );
}

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

// ── Body ──────────────────────────────────────────────────────────────────────

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

// ── Label ─────────────────────────────────────────────────────────────────────

class LabelXlText extends _Typography {
  const LabelXlText(
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
        style: context.textStyle.labelXl.copyWith(
          color: color ?? context.color.text.primary,
        ),
      );
}

class LabelLargeText extends _Typography {
  const LabelLargeText(
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
        style: context.textStyle.labelLarge.copyWith(
          color: color ?? context.color.text.primary,
        ),
      );
}

class LabelMediumText extends _Typography {
  const LabelMediumText(
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
        style: context.textStyle.labelMedium.copyWith(
          color: color ?? context.color.text.primary,
        ),
      );
}

class LabelRegularText extends _Typography {
  const LabelRegularText(
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
        style: context.textStyle.labelRegular.copyWith(
          color: color ?? context.color.text.primary,
        ),
      );
}

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
