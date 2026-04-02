part of '../theme_data.dart';

class _InputDecorationLightTheme with ThemeExtensions {
  InputDecorationTheme call() {
    final borderRadius = BorderRadius.circular(dimensions.radius.r6);
    final fillColor = lightColor.border.withValues(alpha: 0.1);

    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      hintStyle: textStyle.bodyRegular.copyWith(
        color: lightColor.text.secondary,
      ),
      contentPadding: EdgeInsets.symmetric(
        vertical: dimensions.spacing.s12,
        horizontal: dimensions.spacing.s16,
      ),
      border: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: lightColor.primary, width: 1),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: lightColor.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: lightColor.error, width: 1.5),
      ),
      suffixIconColor: lightColor.icon,
    );
  }
}

class _InputDecorationDarkTheme with ThemeExtensions {
  InputDecorationTheme call() {
    final borderRadius = BorderRadius.circular(dimensions.radius.r6);
    final fillColor = darkColor.border.withValues(alpha: 0.1);

    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      hintStyle: textStyle.bodyRegular.copyWith(color: darkColor.text.secondary),
      contentPadding: EdgeInsets.symmetric(
        vertical: dimensions.spacing.s12,
        horizontal: dimensions.spacing.s16,
      ),
      border: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: darkColor.primary, width: 1.5),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: darkColor.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: darkColor.error, width: 1.5),
      ),
      suffixIconColor: darkColor.icon,
    );
  }
}
