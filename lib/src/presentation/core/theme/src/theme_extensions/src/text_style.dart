// Author: Md. Shahin Bashar
// Created: 2026-04-02

import 'package:flutter/material.dart';

// WHY: All type styles map 1-to-1 to the Figma type scale
// (node 13021:15735, file Cd1JO8EZ9OX0XW6DB3ExPN).
// Names are the Figma token names in camelCase.
// height = lineHeight_px / fontSize_px.
// Uppercase variants require String.toUpperCase() at the call site —
// Flutter TextStyle has no text-transform property.
class TextStyleExtension extends ThemeExtension<TextStyleExtension> {
  const TextStyleExtension();

  static const _font = 'Urbanist';

  // ── Display ──────────────────────────────────────────────────────────────

  /// display/large — 57 · w600 · lh 64 · ls -0.25
  TextStyle get displayLarge => const TextStyle(
        fontFamily: _font,
        fontSize: 57,
        fontWeight: FontWeight.w600,
        height: 1.123,
        letterSpacing: -0.25,
      );

  /// display/medium — 45 · w600 · lh 52 · ls -0.81
  TextStyle get displayMedium => const TextStyle(
        fontFamily: _font,
        fontSize: 45,
        fontWeight: FontWeight.w600,
        height: 1.156,
        letterSpacing: -0.81,
      );

  /// display/small — 34 · w600 · lh 48
  TextStyle get displaySmall => const TextStyle(
        fontFamily: _font,
        fontSize: 34,
        fontWeight: FontWeight.w600,
        height: 1.412,
      );

  // ── Headline ─────────────────────────────────────────────────────────────

  /// headline/large — 32 · w600 · lh 40
  TextStyle get headlineLarge => const TextStyle(
        fontFamily: _font,
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 1.25,
      );

  /// headline/medium — 26 · w600 · lh 34 · ls -0.39
  TextStyle get headlineMedium => const TextStyle(
        fontFamily: _font,
        fontSize: 26,
        fontWeight: FontWeight.w600,
        height: 1.308,
        letterSpacing: -0.39,
      );

  /// headline/small — 23 · w600 · lh 24
  TextStyle get headlineSmall => const TextStyle(
        fontFamily: _font,
        fontSize: 23,
        fontWeight: FontWeight.w600,
        height: 1.043,
      );

  /// headline/tiny — 21 · w600 · lh 24
  TextStyle get headlineTiny => const TextStyle(
        fontFamily: _font,
        fontSize: 21,
        fontWeight: FontWeight.w600,
        height: 1.143,
      );

  /// headline/1xl-tiny — 17 · w600 · lh 24
  TextStyle get headline1xlTiny => const TextStyle(
        fontFamily: _font,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        height: 1.412,
      );

  /// headline/2xl-tiny — 15 · w600 · lh 24
  TextStyle get headline2xlTiny => const TextStyle(
        fontFamily: _font,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 1.60,
      );

  // ── Title ─────────────────────────────────────────────────────────────────

  /// title/large — 20 · w600 · lh 24
  TextStyle get titleLarge => const TextStyle(
        fontFamily: _font,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.20,
      );

  /// title/xl uppercase — 16 · w600 · lh 24 · ls 0.32
  TextStyle get titleXlUppercase => const TextStyle(
        fontFamily: _font,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.50,
        letterSpacing: 0.32,
      );

  /// title/medium — 16 · w600 · lh 16
  TextStyle get titleMedium => const TextStyle(
        fontFamily: _font,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.00,
      );

  /// title/medium-uppercase — 16 · w600 · lh 16 · ls 0.192
  TextStyle get titleMediumUppercase => const TextStyle(
        fontFamily: _font,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.00,
        letterSpacing: 0.192,
      );

  /// title/small — 14 · w600 · lh 20 · ls 0.1
  TextStyle get titleSmall => const TextStyle(
        fontFamily: _font,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.429,
        letterSpacing: 0.1,
      );

  /// title/sm uppercase — 14 · w600 · lh 20 · ls 0.2
  TextStyle get titleSmUppercase => const TextStyle(
        fontFamily: _font,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.429,
        letterSpacing: 0.2,
      );

  /// title/tiny uppercase — 12 · w600 · lh 16 · ls 0.2
  TextStyle get titleTinyUppercase => const TextStyle(
        fontFamily: _font,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.333,
        letterSpacing: 0.2,
      );

  // ── Body ──────────────────────────────────────────────────────────────────

  /// body/large — 16 · w400 · lh 24
  TextStyle get bodyLarge => const TextStyle(
        fontFamily: _font,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.50,
      );

  /// body/regular — 14 · w400 · lh 20
  TextStyle get bodyRegular => const TextStyle(
        fontFamily: _font,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.429,
      );

  /// body/smaller_uppercase — 14 · w600 · lh 16 · ls 0.28
  TextStyle get bodySmallerUppercase => const TextStyle(
        fontFamily: _font,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.143,
        letterSpacing: 0.28,
      );

  /// body/small — 12 · w400 · lh 16 · ls 0.072
  TextStyle get bodySmall => const TextStyle(
        fontFamily: _font,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.333,
        letterSpacing: 0.072,
      );

  // ── Label ─────────────────────────────────────────────────────────────────

  /// label/xl — 16 · w600 · lh 20 · ls 0.1
  TextStyle get labelXl => const TextStyle(
        fontFamily: _font,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.25,
        letterSpacing: 0.1,
      );

  /// label/large — 14 · w600 · lh 20 · ls 0.1
  TextStyle get labelLarge => const TextStyle(
        fontFamily: _font,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.429,
        letterSpacing: 0.1,
      );

  /// label/medium — 13 · w600 · lh 16 · ls 0.2
  TextStyle get labelMedium => const TextStyle(
        fontFamily: _font,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        height: 1.231,
        letterSpacing: 0.2,
      );

  /// label/regular — 13 · w400 · lh 16 · ls 0.2
  TextStyle get labelRegular => const TextStyle(
        fontFamily: _font,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.231,
        letterSpacing: 0.2,
      );

  /// label/medium-12 — 12 · w600 · lh 11
  TextStyle get labelMedium12 => const TextStyle(
        fontFamily: _font,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 0.917,
      );

  /// label/small — 11 · w600 · ls 0.5
  TextStyle get labelSmall => const TextStyle(
        fontFamily: _font,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      );

  /// label/tiny — 11 · w600 · lh 11 · ls -0.275
  TextStyle get labelTiny => const TextStyle(
        fontFamily: _font,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        height: 1.00,
        letterSpacing: -0.275,
      );

  @override
  ThemeExtension<TextStyleExtension> copyWith() => const TextStyleExtension();

  @override
  ThemeExtension<TextStyleExtension> lerp(other, t) =>
      const TextStyleExtension();
}
