// Author: Md. Shahin Bashar
// Created: 2026-04-02

part of '../colors.dart';

abstract class TextColors {
  const TextColors();

  // WHY: Mapped to semantic.text tokens from the design token system.
  Color get primary;   // semantic.text.primary   → neutral-70
  Color get brand;     // semantic.text.brand      → brand.primary-60
  Color get secondary; // semantic.text.secondary  → neutral-50
  Color get muted;     // semantic.text.muted      → neutral-40
  Color get disabled;  // semantic.text.disabled   → neutral-20
}

class _LightTextColors extends TextColors {
  const _LightTextColors();

  @override
  Color get primary => _Primitive.neutral70;

  @override
  Color get brand => _Primitive.primary60;

  @override
  Color get secondary => _Primitive.neutral50;

  @override
  Color get muted => _Primitive.neutral40;

  @override
  Color get disabled => _Primitive.neutral20;
}

class _DarkTextColors extends TextColors {
  const _DarkTextColors();

  @override
  Color get primary => _Primitive.neutral0;

  @override
  Color get brand => _Primitive.primary40;

  @override
  Color get secondary => _Primitive.neutral20;

  @override
  Color get muted => _Primitive.neutral30;

  @override
  Color get disabled => _Primitive.neutral60;
}
