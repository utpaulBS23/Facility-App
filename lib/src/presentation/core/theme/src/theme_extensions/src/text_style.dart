// Author: Md. Shahin Bashar
// Created: 2026-04-02

import 'package:flutter/material.dart';

// WHY: Centralises font-family names so pubspec family strings are never
// scattered across the codebase, and forLocale() is the single place that
// decides which font to use for a given language.
abstract final class AppFonts {
  static const String english = 'MyriadPro';
  static const String bengali = 'Kalpurush';

  static String forLocale(String languageCode) =>
      languageCode == 'bn' ? bengali : english;
}

/// Figma Font Weight → Flutter FontWeight
/// Thin         → w100  |  Extra Light → w200  |  Light     → w300
/// Regular      → w400  |  Medium      → w500  |  Semi Bold → w600
/// Bold         → w700  |  Extra Bold  → w800  |  Black     → w900
class TextWeight {
  static const regular = FontWeight.w400;
  static const medium = FontWeight.w500;
  static const semibold = FontWeight.w600;
  static const bold = FontWeight.w700;
}

// WHY: All type styles map 1-to-1 to the Figma type scale.
// height  = lineHeight_px / fontSize_px
// No fontFamily is set here — it falls through to ThemeData.fontFamily,
// which is set per-locale in $LightThemeData / $DarkThemeData.
class TextStyleExtension extends ThemeExtension<TextStyleExtension> {
  const TextStyleExtension();

  double _ls({required double percentage, required double fontSize}) =>
      (percentage / 100) * fontSize;

  // ── Display ──────────────────────────────────────────────────────────────

  /// display/large — 57 · w500 · lh 64 · ls -0.25
  TextStyle get displayLarge => const TextStyle(
        fontSize: 57,
        fontWeight: TextWeight.medium,
        height: 64 / 57,
        letterSpacing: -0.25,
      );

  /// display/medium — 45 · w500 · lh 52
  TextStyle get displayMedium => TextStyle(
        fontSize: 45,
        fontWeight: TextWeight.medium,
        height: 52 / 45,
        letterSpacing: _ls(percentage: -1.8, fontSize: 45),
      );

  /// display/small — 34 · w600 · lh 48
  TextStyle get displaySmall => const TextStyle(
        fontSize: 34,
        fontWeight: TextWeight.semibold,
        height: 48 / 34,
      );

  // ── Headline ─────────────────────────────────────────────────────────────

  /// headline/large — 32 · w600 · lh 40
  TextStyle get headlineLarge => const TextStyle(
        fontSize: 32,
        fontWeight: TextWeight.semibold,
        height: 40 / 32,
      );

  /// headline/medium — 26 · w500 · lh 34
  TextStyle get headlineMedium => TextStyle(
        fontSize: 26,
        fontWeight: TextWeight.medium,
        height: 34 / 26,
        letterSpacing: _ls(percentage: -1.8, fontSize: 26),
      );

  /// headline/small — 23 · w600 · lh 24
  TextStyle get headlineSmall => const TextStyle(
        fontSize: 23,
        fontWeight: TextWeight.semibold,
        height: 24 / 23,
      );

  /// headline/tiny — 21 · w600 · lh 24
  TextStyle get headlineTiny => const TextStyle(
        fontSize: 21,
        fontWeight: TextWeight.semibold,
        height: 24 / 21,
      );

  /// headline/1xl-tiny — 17 · w600 · lh 24
  TextStyle get headline1xlTiny => const TextStyle(
        fontSize: 17,
        fontWeight: TextWeight.semibold,
        height: 24 / 17,
      );

  /// headline/2xl-tiny — 15 · w600 · lh 24
  TextStyle get headline2xlTiny => const TextStyle(
        fontSize: 15,
        fontWeight: TextWeight.semibold,
        height: 24 / 15,
      );

  // ── Title ─────────────────────────────────────────────────────────────────

  /// title/large — 20 · w500 · lh 24
  TextStyle get titleLarge => const TextStyle(
        fontSize: 20,
        fontWeight: TextWeight.medium,
        height: 24 / 20,
      );

  /// title/xl uppercase — 16 · w500 · lh 24 · ls 2%
  TextStyle get titleXlUppercase => TextStyle(
        fontSize: 16,
        fontWeight: TextWeight.medium,
        height: 24 / 16,
        letterSpacing: _ls(percentage: 2, fontSize: 16),
      );

  /// title/medium — 16 · w600 · lh 16
  TextStyle get titleMedium => const TextStyle(
        fontSize: 16,
        fontWeight: TextWeight.semibold,
        height: 16 / 16,
      );

  /// title/medium-uppercase — 16 · w500 · lh 20 · ls 1.2%
  TextStyle get titleMediumUppercase => TextStyle(
        fontSize: 16,
        fontWeight: TextWeight.medium,
        height: 20 / 16,
        letterSpacing: _ls(percentage: 1.2, fontSize: 16),
      );

  /// title/small — 14 · w600 · lh 20 · ls 0.1
  TextStyle get titleSmall => const TextStyle(
        fontSize: 14,
        fontWeight: TextWeight.semibold,
        height: 20 / 14,
        letterSpacing: 0.1,
      );

  /// title/sm uppercase — 14 · w500 · lh 20 · ls 0.2
  TextStyle get titleSmUppercase => const TextStyle(
        fontSize: 14,
        fontWeight: TextWeight.medium,
        height: 20 / 14,
        letterSpacing: 0.2,
      );

  /// title/tiny uppercase — 12 · w500 · lh 16 · ls 0.2
  TextStyle get titleTinyUppercase => const TextStyle(
        fontSize: 12,
        fontWeight: TextWeight.medium,
        height: 16 / 12,
        letterSpacing: 0.2,
      );

  // ── Body ──────────────────────────────────────────────────────────────────

  /// body/large — 16 · w400 · lh 24
  TextStyle get bodyLarge => const TextStyle(
        fontSize: 16,
        fontWeight: TextWeight.regular,
        height: 24 / 16,
      );

  /// body/medium — 14 · w400 · lh 20
  TextStyle get bodyMedium => const TextStyle(
        fontSize: 14,
        fontWeight: TextWeight.regular,
        height: 20 / 14,
      );

  /// body/regular — 14 · w400 · lh 20
  TextStyle get bodyRegular => const TextStyle(
        fontSize: 14,
        fontWeight: TextWeight.regular,
        height: 20 / 14,
      );

  /// body/small-uppercase — 14 · w500 · lh 16 · ls 2%
  TextStyle get bodySmallUppercase => TextStyle(
        fontSize: 14,
        fontWeight: TextWeight.medium,
        height: 16 / 14,
        letterSpacing: _ls(percentage: 2, fontSize: 14),
      );

  /// body/small — 12 · w400 · lh 16 · ls 0.6%
  TextStyle get bodySmall => TextStyle(
        fontSize: 12,
        fontWeight: TextWeight.regular,
        height: 16 / 12,
        letterSpacing: _ls(percentage: 0.6, fontSize: 12),
      );

  // ── Label ─────────────────────────────────────────────────────────────────

  /// label/xl — 16 · w500 · lh 20 · ls 0.1
  TextStyle get labelXl => const TextStyle(
        fontSize: 16,
        fontWeight: TextWeight.medium,
        height: 20 / 16,
        letterSpacing: 0.1,
      );

  /// label/large — 14 · w500 · lh 20 · ls 0.1
  TextStyle get labelLarge => const TextStyle(
        fontSize: 14,
        fontWeight: TextWeight.medium,
        height: 20 / 14,
        letterSpacing: 0.1,
      );

  /// label/medium — 13 · w500 · lh 16 · ls 0.2
  TextStyle get labelMedium => const TextStyle(
        fontSize: 13,
        fontWeight: TextWeight.medium,
        height: 16 / 13,
        letterSpacing: 0.2,
      );

  /// label/regular — 13 · w400 · lh 16 · ls 0.2
  TextStyle get labelRegular => const TextStyle(
        fontSize: 13,
        fontWeight: TextWeight.regular,
        height: 16 / 13,
        letterSpacing: 0.2,
      );

  /// label/small — 11 · w500 · lh 11 · ls 0.5
  TextStyle get labelSmall => const TextStyle(
        fontSize: 11,
        fontWeight: TextWeight.medium,
        height: 11 / 11,
        letterSpacing: 0.5,
      );

  /// label/tiny — 11 · w500 · lh 11 · ls -2.5%
  TextStyle get labelTiny => TextStyle(
        fontSize: 11,
        fontWeight: TextWeight.medium,
        height: 11 / 11,
        letterSpacing: _ls(percentage: -2.5, fontSize: 11),
      );

  @override
  TextStyleExtension copyWith() => const TextStyleExtension();

  @override
  ThemeExtension<TextStyleExtension> lerp(other, t) =>
      const TextStyleExtension();
}
