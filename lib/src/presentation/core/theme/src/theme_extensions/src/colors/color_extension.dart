// ignore_for_file: max_file_lines, max_method_lines
// Author: Md. Shahin Bashar
// Created: 2026-04-02

part of 'colors.dart';

// WHY: ColorExtension is the semantic color contract for the app. Every field
// maps 1-to-1 to a semantic token from the design token system, so that
// changing a token in one place propagates everywhere.
class ColorExtension {
  const ColorExtension({
    // background
    required this.primary,
    required this.brandHover,
    required this.brandSubtle,
    required this.brandAccent,
    required this.overlay,
    required this.scaffoldBackground,
    required this.subtle,
    required this.onPrimary,
    required this.backgroundMuted,
    // border
    required this.border,
    required this.borderSubtle,
    required this.borderBrand,
    required this.borderBrandFocus,
    required this.borderBrandActive,
    // status
    required this.success,
    required this.successAlt,
    required this.error,
    required this.errorAlt,
    required this.warning,
    required this.warningAlt,
    required this.info,
    // misc
    required this.icon,
    required this.disabled,
    required this.active,
    required this.inactive,
    // shadow
    required this.shadow,
    // selfie zone
    required this.selfieZoneGradientStart,
    required this.selfieZoneGradientEnd,
    required this.selfieZonePlaceholderBg,
    required this.selfieZonePlaceholderBorder,
    required this.selfieZonePlaceholderIcon,
    // sub-extensions
    required this.appBar,
    required this.bottomNavBar,
    required this.pageView,
    required this.text,
    required this.background,
    required this.borders,
    required this.buttonBackground,
    required this.buttonLabel,
    required this.buttonIcon,
    required this.buttonBorder,
    required this.icons,
  });

  // --- background tokens ---
  final Color primary; // background.brand        → brand.primary-50
  final Color brandHover; // background.brand-hover  → brand.primary-40
  final Color brandSubtle; // background.brand-subtle → brand.primary-10
  final Color brandAccent; // background.brand-accent → brand.primary-20
  final Color overlay; // background.overlay      → transparent.gray
  final Color scaffoldBackground; // background.surface      → neutral.neutral-0
  final Color subtle; // background.subtle       → neutral.neutral-10
  final Color onPrimary; // background.white        → other.white
  final Color backgroundMuted; // background.muted        → neutral.neutral-40

  // --- border tokens ---
  final Color border; // border.default          → neutral.neutral-20
  final Color borderSubtle; // border.subtle           → neutral.neutral-10
  final Color borderBrand; // border.brand            → brand.primary-50
  final Color borderBrandFocus; // border.brand-focus      → brand.primary-60
  final Color borderBrandActive; // border.brand-active     → brand.primary-70

  // --- status tokens ---
  final Color success; // status.success          → success.success-60
  final Color successAlt; // status.successAlt       → success.success-10
  final Color error; // status.error            → error.error-50
  final Color errorAlt; // status.errorAlt         → error.error-10
  final Color warning; // status.warning          → warning.warning-50
  final Color warningAlt; // status.warningAlt       → warning.warning-10
  final Color info; // status.info             → other.dark-blue

  // --- misc ---
  final Color icon; // icon color (light: neutral-40)
  final Color disabled; // disabled state
  final Color active; // active/selected indicator
  final Color inactive; // inactive/unselected indicator

  // --- shadow ---
  final Color shadow; // card drop-shadow base (neutral-90 @ 10%)

  // --- selfie zone ---
  final Color selfieZoneGradientStart; // dark gradient start (darkSurface1)
  final Color selfieZoneGradientEnd; // dark gradient end   (darkSurface2)
  final Color selfieZonePlaceholderBg; // placeholder circle fill (white @ 6%)
  final Color
  selfieZonePlaceholderBorder; // placeholder circle border (white @ 20%)
  final Color
  selfieZonePlaceholderIcon; // placeholder icon & hint text (white @ 40%)

  // --- sub-extensions ---
  final AppBarColors appBar;
  final BottomNavBarColors bottomNavBar;
  final PageViewColors pageView;
  final TextColors text;
  final BackgroundColors background;
  final BorderColors borders;
  final ButtonBackgroundColors buttonBackground;
  final ButtonLabelColors buttonLabel;
  final ButtonIconColors buttonIcon;
  final ButtonBorderColors buttonBorder;
  final IconColors icons;
}

class LightColorExtension extends ThemeExtension<LightColorExtension>
    implements ColorExtension {
  const LightColorExtension({
    // background
    this.primary = _Primitive.primary50,
    this.brandHover = _Primitive.primary40,
    this.brandSubtle = _Primitive.primary10,
    this.brandAccent = _Primitive.primary20,
    this.overlay = _Primitive.transparentGray,
    this.scaffoldBackground = _Primitive.neutral0,
    this.subtle = _Primitive.neutral10,
    this.onPrimary = _Primitive.white,
    this.backgroundMuted = _Primitive.neutral40,
    // border
    this.border = _Primitive.neutral20,
    this.borderSubtle = _Primitive.neutral10,
    this.borderBrand = _Primitive.primary50,
    this.borderBrandFocus = _Primitive.primary60,
    this.borderBrandActive = _Primitive.primary70,
    // status
    this.success = _Primitive.success60,
    this.successAlt = _Primitive.success10,
    this.error = _Primitive.error50,
    this.errorAlt = _Primitive.error10,
    this.warning = _Primitive.warning50,
    this.warningAlt = _Primitive.warning10,
    this.info = _Primitive.darkBlue,
    // misc
    this.icon = _Primitive.neutral40,
    this.disabled = _Primitive.neutral20,
    this.active = _Primitive.primary50,
    this.inactive = _Primitive.neutral30,
    // shadow
    this.shadow = _Primitive.transparentNeutral90,
    // selfie zone
    this.selfieZoneGradientStart = _Primitive.darkSurface1,
    this.selfieZoneGradientEnd = _Primitive.darkSurface2,
    this.selfieZonePlaceholderBg = _Primitive.transparentWhite06,
    this.selfieZonePlaceholderBorder = _Primitive.transparentWhite20,
    this.selfieZonePlaceholderIcon = _Primitive.transparentWhite40,
    // sub-extensions
    this.appBar = const _LightAppBarColors(),
    this.bottomNavBar = const _LightBottomNavBarColors(),
    this.pageView = const _LightPageViewColors(),
    this.text = const _LightTextColors(),
    this.background = const _LightBackgroundColors(),
    this.borders = const _LightBorderColors(),
    this.buttonBackground = const _LightButtonBackgroundColors(),
    this.buttonLabel = const _LightButtonLabelColors(),
    this.buttonIcon = const _LightButtonIconColors(),
    this.buttonBorder = const _LightButtonBorderColors(),
    this.icons = const _LightIconColors(),
  });

  // background
  @override
  final Color primary;
  @override
  final Color brandHover;
  @override
  final Color brandSubtle;
  @override
  final Color brandAccent;
  @override
  final Color overlay;
  @override
  final Color scaffoldBackground;
  @override
  final Color subtle;
  @override
  final Color onPrimary;
  @override
  final Color backgroundMuted;

  // border
  @override
  final Color border;
  @override
  final Color borderSubtle;
  @override
  final Color borderBrand;
  @override
  final Color borderBrandFocus;
  @override
  final Color borderBrandActive;

  // status
  @override
  final Color success;
  @override
  final Color successAlt;
  @override
  final Color error;
  @override
  final Color errorAlt;
  @override
  final Color warning;
  @override
  final Color warningAlt;
  @override
  final Color info;

  // misc
  @override
  final Color icon;
  @override
  final Color disabled;
  @override
  final Color active;
  @override
  final Color inactive;

  // shadow
  @override
  final Color shadow;

  // selfie zone
  @override
  final Color selfieZoneGradientStart;
  @override
  final Color selfieZoneGradientEnd;
  @override
  final Color selfieZonePlaceholderBg;
  @override
  final Color selfieZonePlaceholderBorder;
  @override
  final Color selfieZonePlaceholderIcon;

  // sub-extensions
  @override
  final AppBarColors appBar;
  @override
  final BottomNavBarColors bottomNavBar;
  @override
  final PageViewColors pageView;
  @override
  final TextColors text;
  @override
  final BackgroundColors background;
  @override
  final BorderColors borders;
  @override
  final ButtonBackgroundColors buttonBackground;
  @override
  final ButtonLabelColors buttonLabel;
  @override
  final ButtonIconColors buttonIcon;
  @override
  final ButtonBorderColors buttonBorder;
  @override
  final IconColors icons;

  @override
  LightColorExtension copyWith({
    Color? primary,
    Color? brandHover,
    Color? brandSubtle,
    Color? brandAccent,
    Color? overlay,
    Color? scaffoldBackground,
    Color? subtle,
    Color? onPrimary,
    Color? backgroundMuted,
    Color? border,
    Color? borderSubtle,
    Color? borderBrand,
    Color? borderBrandFocus,
    Color? borderBrandActive,
    Color? success,
    Color? successAlt,
    Color? error,
    Color? errorAlt,
    Color? warning,
    Color? warningAlt,
    Color? info,
    Color? icon,
    Color? disabled,
    Color? active,
    Color? inactive,
    Color? shadow,
    Color? selfieZoneGradientStart,
    Color? selfieZoneGradientEnd,
    Color? selfieZonePlaceholderBg,
    Color? selfieZonePlaceholderBorder,
    Color? selfieZonePlaceholderIcon,
    AppBarColors? appBar,
    BottomNavBarColors? bottomNavBar,
    PageViewColors? pageView,
    TextColors? text,
    BackgroundColors? background,
    BorderColors? borders,
    ButtonBackgroundColors? buttonBackground,
    ButtonLabelColors? buttonLabel,
    ButtonIconColors? buttonIcon,
    ButtonBorderColors? buttonBorder,
    IconColors? icons,
  }) {
    return LightColorExtension(
      primary: primary ?? this.primary,
      brandHover: brandHover ?? this.brandHover,
      brandSubtle: brandSubtle ?? this.brandSubtle,
      brandAccent: brandAccent ?? this.brandAccent,
      overlay: overlay ?? this.overlay,
      scaffoldBackground: scaffoldBackground ?? this.scaffoldBackground,
      subtle: subtle ?? this.subtle,
      onPrimary: onPrimary ?? this.onPrimary,
      backgroundMuted: backgroundMuted ?? this.backgroundMuted,
      border: border ?? this.border,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      borderBrand: borderBrand ?? this.borderBrand,
      borderBrandFocus: borderBrandFocus ?? this.borderBrandFocus,
      borderBrandActive: borderBrandActive ?? this.borderBrandActive,
      success: success ?? this.success,
      successAlt: successAlt ?? this.successAlt,
      error: error ?? this.error,
      errorAlt: errorAlt ?? this.errorAlt,
      warning: warning ?? this.warning,
      warningAlt: warningAlt ?? this.warningAlt,
      info: info ?? this.info,
      icon: icon ?? this.icon,
      disabled: disabled ?? this.disabled,
      active: active ?? this.active,
      inactive: inactive ?? this.inactive,
      shadow: shadow ?? this.shadow,
      selfieZoneGradientStart:
          selfieZoneGradientStart ?? this.selfieZoneGradientStart,
      selfieZoneGradientEnd:
          selfieZoneGradientEnd ?? this.selfieZoneGradientEnd,
      selfieZonePlaceholderBg:
          selfieZonePlaceholderBg ?? this.selfieZonePlaceholderBg,
      selfieZonePlaceholderBorder:
          selfieZonePlaceholderBorder ?? this.selfieZonePlaceholderBorder,
      selfieZonePlaceholderIcon:
          selfieZonePlaceholderIcon ?? this.selfieZonePlaceholderIcon,
      appBar: appBar ?? this.appBar,
      bottomNavBar: bottomNavBar ?? this.bottomNavBar,
      pageView: pageView ?? this.pageView,
      text: text ?? this.text,
      background: background ?? this.background,
      borders: borders ?? this.borders,
      buttonBackground: buttonBackground ?? this.buttonBackground,
      buttonLabel: buttonLabel ?? this.buttonLabel,
      buttonIcon: buttonIcon ?? this.buttonIcon,
      buttonBorder: buttonBorder ?? this.buttonBorder,
      icons: icons ?? this.icons,
    );
  }

  @override
  ThemeExtension<LightColorExtension> lerp(
    covariant ThemeExtension<LightColorExtension>? other,
    double t,
  ) {
    if (other is! LightColorExtension) return this;
    return LightColorExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      brandHover: Color.lerp(brandHover, other.brandHover, t)!,
      brandSubtle: Color.lerp(brandSubtle, other.brandSubtle, t)!,
      brandAccent: Color.lerp(brandAccent, other.brandAccent, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
      scaffoldBackground: Color.lerp(
        scaffoldBackground,
        other.scaffoldBackground,
        t,
      )!,
      subtle: Color.lerp(subtle, other.subtle, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      backgroundMuted: Color.lerp(backgroundMuted, other.backgroundMuted, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      borderBrand: Color.lerp(borderBrand, other.borderBrand, t)!,
      borderBrandFocus: Color.lerp(
        borderBrandFocus,
        other.borderBrandFocus,
        t,
      )!,
      borderBrandActive: Color.lerp(
        borderBrandActive,
        other.borderBrandActive,
        t,
      )!,
      success: Color.lerp(success, other.success, t)!,
      successAlt: Color.lerp(successAlt, other.successAlt, t)!,
      error: Color.lerp(error, other.error, t)!,
      errorAlt: Color.lerp(errorAlt, other.errorAlt, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningAlt: Color.lerp(warningAlt, other.warningAlt, t)!,
      info: Color.lerp(info, other.info, t)!,
      icon: Color.lerp(icon, other.icon, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
      active: Color.lerp(active, other.active, t)!,
      inactive: Color.lerp(inactive, other.inactive, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      selfieZoneGradientStart: Color.lerp(
        selfieZoneGradientStart,
        other.selfieZoneGradientStart,
        t,
      )!,
      selfieZoneGradientEnd: Color.lerp(
        selfieZoneGradientEnd,
        other.selfieZoneGradientEnd,
        t,
      )!,
      selfieZonePlaceholderBg: Color.lerp(
        selfieZonePlaceholderBg,
        other.selfieZonePlaceholderBg,
        t,
      )!,
      selfieZonePlaceholderBorder: Color.lerp(
        selfieZonePlaceholderBorder,
        other.selfieZonePlaceholderBorder,
        t,
      )!,
      selfieZonePlaceholderIcon: Color.lerp(
        selfieZonePlaceholderIcon,
        other.selfieZonePlaceholderIcon,
        t,
      )!,
      // WHY: sub-extensions are not lerpable — snap at midpoint
      appBar: t < 0.5 ? appBar : other.appBar,
      bottomNavBar: t < 0.5 ? bottomNavBar : other.bottomNavBar,
      pageView: t < 0.5 ? pageView : other.pageView,
      text: t < 0.5 ? text : other.text,
      background: t < 0.5 ? background : other.background,
      borders: t < 0.5 ? borders : other.borders,
      buttonBackground: t < 0.5 ? buttonBackground : other.buttonBackground,
      buttonLabel: t < 0.5 ? buttonLabel : other.buttonLabel,
      buttonIcon: t < 0.5 ? buttonIcon : other.buttonIcon,
      buttonBorder: t < 0.5 ? buttonBorder : other.buttonBorder,
      icons: t < 0.5 ? icons : other.icons,
    );
  }
}

class DarkColorExtension extends ThemeExtension<DarkColorExtension>
    implements ColorExtension {
  const DarkColorExtension({
    // background
    this.primary = _Primitive.primary50,
    this.brandHover = _Primitive.primary40,
    this.brandSubtle = _Primitive.primary90,
    this.brandAccent = _Primitive.primary80,
    this.overlay = _Primitive.transparentGray,
    this.scaffoldBackground = _Primitive.neutral80,
    this.subtle = _Primitive.neutral70,
    this.onPrimary = _Primitive.white,
    this.backgroundMuted = _Primitive.neutral60,
    // border
    this.border = _Primitive.neutral60,
    this.borderSubtle = _Primitive.neutral70,
    this.borderBrand = _Primitive.primary50,
    this.borderBrandFocus = _Primitive.primary60,
    this.borderBrandActive = _Primitive.primary70,
    // status
    this.success = _Primitive.success60,
    this.successAlt = _Primitive.success90,
    this.error = _Primitive.error50,
    this.errorAlt = _Primitive.error90,
    this.warning = _Primitive.warning50,
    this.warningAlt = _Primitive.warning90,
    this.info = _Primitive.darkBlue,
    // misc
    this.icon = _Primitive.neutral30,
    this.disabled = _Primitive.neutral60,
    this.active = _Primitive.primary50,
    this.inactive = _Primitive.neutral60,
    // shadow
    this.shadow = _Primitive.transparentNeutral90,
    // selfie zone
    this.selfieZoneGradientStart = _Primitive.darkSurface1,
    this.selfieZoneGradientEnd = _Primitive.darkSurface2,
    this.selfieZonePlaceholderBg = _Primitive.transparentWhite06,
    this.selfieZonePlaceholderBorder = _Primitive.transparentWhite20,
    this.selfieZonePlaceholderIcon = _Primitive.transparentWhite40,
    // sub-extensions
    this.appBar = const _DarkAppBarColors(),
    this.bottomNavBar = const _DarkBottomNavBarColors(),
    this.pageView = const _DarkPageViewColors(),
    this.text = const _DarkTextColors(),
    this.background = const _DarkBackgroundColors(),
    this.borders = const _DarkBorderColors(),
    this.buttonBackground = const _DarkButtonBackgroundColors(),
    this.buttonLabel = const _DarkButtonLabelColors(),
    this.buttonIcon = const _DarkButtonIconColors(),
    this.buttonBorder = const _DarkButtonBorderColors(),
    this.icons = const _DarkIconColors(),
  });

  // background
  @override
  final Color primary;
  @override
  final Color brandHover;
  @override
  final Color brandSubtle;
  @override
  final Color brandAccent;
  @override
  final Color overlay;
  @override
  final Color scaffoldBackground;
  @override
  final Color subtle;
  @override
  final Color onPrimary;
  @override
  final Color backgroundMuted;

  // border
  @override
  final Color border;
  @override
  final Color borderSubtle;
  @override
  final Color borderBrand;
  @override
  final Color borderBrandFocus;
  @override
  final Color borderBrandActive;

  // status
  @override
  final Color success;
  @override
  final Color successAlt;
  @override
  final Color error;
  @override
  final Color errorAlt;
  @override
  final Color warning;
  @override
  final Color warningAlt;
  @override
  final Color info;

  // misc
  @override
  final Color icon;
  @override
  final Color disabled;
  @override
  final Color active;
  @override
  final Color inactive;

  // shadow
  @override
  final Color shadow;

  // selfie zone
  @override
  final Color selfieZoneGradientStart;
  @override
  final Color selfieZoneGradientEnd;
  @override
  final Color selfieZonePlaceholderBg;
  @override
  final Color selfieZonePlaceholderBorder;
  @override
  final Color selfieZonePlaceholderIcon;

  // sub-extensions
  @override
  final AppBarColors appBar;
  @override
  final BottomNavBarColors bottomNavBar;
  @override
  final PageViewColors pageView;
  @override
  final TextColors text;
  @override
  final BackgroundColors background;
  @override
  final BorderColors borders;
  @override
  final ButtonBackgroundColors buttonBackground;
  @override
  final ButtonLabelColors buttonLabel;
  @override
  final ButtonIconColors buttonIcon;
  @override
  final ButtonBorderColors buttonBorder;
  @override
  final IconColors icons;

  @override
  DarkColorExtension copyWith({
    Color? primary,
    Color? brandHover,
    Color? brandSubtle,
    Color? brandAccent,
    Color? overlay,
    Color? scaffoldBackground,
    Color? subtle,
    Color? onPrimary,
    Color? backgroundMuted,
    Color? border,
    Color? borderSubtle,
    Color? borderBrand,
    Color? borderBrandFocus,
    Color? borderBrandActive,
    Color? success,
    Color? successAlt,
    Color? error,
    Color? errorAlt,
    Color? warning,
    Color? warningAlt,
    Color? info,
    Color? icon,
    Color? disabled,
    Color? active,
    Color? inactive,
    Color? shadow,
    Color? selfieZoneGradientStart,
    Color? selfieZoneGradientEnd,
    Color? selfieZonePlaceholderBg,
    Color? selfieZonePlaceholderBorder,
    Color? selfieZonePlaceholderIcon,
    AppBarColors? appBar,
    BottomNavBarColors? bottomNavBar,
    PageViewColors? pageView,
    TextColors? text,
    BackgroundColors? background,
    BorderColors? borders,
    ButtonBackgroundColors? buttonBackground,
    ButtonLabelColors? buttonLabel,
    ButtonIconColors? buttonIcon,
    ButtonBorderColors? buttonBorder,
    IconColors? icons,
  }) {
    return DarkColorExtension(
      primary: primary ?? this.primary,
      brandHover: brandHover ?? this.brandHover,
      brandSubtle: brandSubtle ?? this.brandSubtle,
      brandAccent: brandAccent ?? this.brandAccent,
      overlay: overlay ?? this.overlay,
      scaffoldBackground: scaffoldBackground ?? this.scaffoldBackground,
      subtle: subtle ?? this.subtle,
      onPrimary: onPrimary ?? this.onPrimary,
      backgroundMuted: backgroundMuted ?? this.backgroundMuted,
      border: border ?? this.border,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      borderBrand: borderBrand ?? this.borderBrand,
      borderBrandFocus: borderBrandFocus ?? this.borderBrandFocus,
      borderBrandActive: borderBrandActive ?? this.borderBrandActive,
      success: success ?? this.success,
      successAlt: successAlt ?? this.successAlt,
      error: error ?? this.error,
      errorAlt: errorAlt ?? this.errorAlt,
      warning: warning ?? this.warning,
      warningAlt: warningAlt ?? this.warningAlt,
      info: info ?? this.info,
      icon: icon ?? this.icon,
      disabled: disabled ?? this.disabled,
      active: active ?? this.active,
      inactive: inactive ?? this.inactive,
      shadow: shadow ?? this.shadow,
      selfieZoneGradientStart:
          selfieZoneGradientStart ?? this.selfieZoneGradientStart,
      selfieZoneGradientEnd:
          selfieZoneGradientEnd ?? this.selfieZoneGradientEnd,
      selfieZonePlaceholderBg:
          selfieZonePlaceholderBg ?? this.selfieZonePlaceholderBg,
      selfieZonePlaceholderBorder:
          selfieZonePlaceholderBorder ?? this.selfieZonePlaceholderBorder,
      selfieZonePlaceholderIcon:
          selfieZonePlaceholderIcon ?? this.selfieZonePlaceholderIcon,
      appBar: appBar ?? this.appBar,
      bottomNavBar: bottomNavBar ?? this.bottomNavBar,
      pageView: pageView ?? this.pageView,
      text: text ?? this.text,
      background: background ?? this.background,
      borders: borders ?? this.borders,
      buttonBackground: buttonBackground ?? this.buttonBackground,
      buttonLabel: buttonLabel ?? this.buttonLabel,
      buttonIcon: buttonIcon ?? this.buttonIcon,
      buttonBorder: buttonBorder ?? this.buttonBorder,
      icons: icons ?? this.icons,
    );
  }

  @override
  ThemeExtension<DarkColorExtension> lerp(
    covariant ThemeExtension<DarkColorExtension>? other,
    double t,
  ) {
    if (other is! DarkColorExtension) return this;
    return DarkColorExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      brandHover: Color.lerp(brandHover, other.brandHover, t)!,
      brandSubtle: Color.lerp(brandSubtle, other.brandSubtle, t)!,
      brandAccent: Color.lerp(brandAccent, other.brandAccent, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
      scaffoldBackground: Color.lerp(
        scaffoldBackground,
        other.scaffoldBackground,
        t,
      )!,
      subtle: Color.lerp(subtle, other.subtle, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      backgroundMuted: Color.lerp(backgroundMuted, other.backgroundMuted, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      borderBrand: Color.lerp(borderBrand, other.borderBrand, t)!,
      borderBrandFocus: Color.lerp(
        borderBrandFocus,
        other.borderBrandFocus,
        t,
      )!,
      borderBrandActive: Color.lerp(
        borderBrandActive,
        other.borderBrandActive,
        t,
      )!,
      success: Color.lerp(success, other.success, t)!,
      successAlt: Color.lerp(successAlt, other.successAlt, t)!,
      error: Color.lerp(error, other.error, t)!,
      errorAlt: Color.lerp(errorAlt, other.errorAlt, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningAlt: Color.lerp(warningAlt, other.warningAlt, t)!,
      info: Color.lerp(info, other.info, t)!,
      icon: Color.lerp(icon, other.icon, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
      active: Color.lerp(active, other.active, t)!,
      inactive: Color.lerp(inactive, other.inactive, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      selfieZoneGradientStart: Color.lerp(
        selfieZoneGradientStart,
        other.selfieZoneGradientStart,
        t,
      )!,
      selfieZoneGradientEnd: Color.lerp(
        selfieZoneGradientEnd,
        other.selfieZoneGradientEnd,
        t,
      )!,
      selfieZonePlaceholderBg: Color.lerp(
        selfieZonePlaceholderBg,
        other.selfieZonePlaceholderBg,
        t,
      )!,
      selfieZonePlaceholderBorder: Color.lerp(
        selfieZonePlaceholderBorder,
        other.selfieZonePlaceholderBorder,
        t,
      )!,
      selfieZonePlaceholderIcon: Color.lerp(
        selfieZonePlaceholderIcon,
        other.selfieZonePlaceholderIcon,
        t,
      )!,
      // WHY: sub-extensions are not lerpable — snap at midpoint
      appBar: t < 0.5 ? appBar : other.appBar,
      bottomNavBar: t < 0.5 ? bottomNavBar : other.bottomNavBar,
      pageView: t < 0.5 ? pageView : other.pageView,
      text: t < 0.5 ? text : other.text,
      background: t < 0.5 ? background : other.background,
      borders: t < 0.5 ? borders : other.borders,
      buttonBackground: t < 0.5 ? buttonBackground : other.buttonBackground,
      buttonLabel: t < 0.5 ? buttonLabel : other.buttonLabel,
      buttonIcon: t < 0.5 ? buttonIcon : other.buttonIcon,
      buttonBorder: t < 0.5 ? buttonBorder : other.buttonBorder,
      icons: t < 0.5 ? icons : other.icons,
    );
  }
}
