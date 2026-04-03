part of '../theme_data.dart';

class _InputDecorationLightTheme with ThemeExtensions {
  InputDecorationTheme call() {
    final borderRadius = BorderRadius.circular(dimensions.radius.r6);
    final borderSide = BorderSide(color: lightColor.border, width: dimensions.spacing.s1);

    return InputDecorationTheme(
      hintStyle: textStyle.bodyLarge.copyWith(color: lightColor.text.muted),
      labelStyle: textStyle.bodyLarge.copyWith(color: lightColor.text.secondary),
      floatingLabelStyle: textStyle.bodySmall.copyWith(color: lightColor.text.secondary),
      errorStyle: textStyle.bodySmall.copyWith(color: lightColor.error),
      contentPadding: EdgeInsets.all(dimensions.spacing.s16),
      prefixIconColor: lightColor.icon,
      suffixIconColor: lightColor.icon,
      border: OutlineInputBorder(borderRadius: borderRadius, borderSide: borderSide),
      enabledBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: borderSide),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: lightColor.borderBrandFocus, width: dimensions.spacing.s1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: lightColor.error, width: dimensions.spacing.s1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: lightColor.error, width: dimensions.spacing.s1),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: lightColor.inactive, width: dimensions.spacing.s1),
      ),
    );
  }
}

class _InputDecorationDarkTheme with ThemeExtensions {
  InputDecorationTheme call() {
    final borderRadius = BorderRadius.circular(dimensions.radius.r6);
    final borderSide = BorderSide(color: darkColor.border, width: dimensions.spacing.s1);

    return InputDecorationTheme(
      hintStyle: textStyle.bodyLarge.copyWith(color: darkColor.text.muted),
      labelStyle: textStyle.bodyLarge.copyWith(color: darkColor.text.secondary),
      floatingLabelStyle: textStyle.bodySmall.copyWith(color: darkColor.text.secondary),
      errorStyle: textStyle.bodySmall.copyWith(color: darkColor.error),
      contentPadding: EdgeInsets.symmetric(
        vertical: dimensions.spacing.s12,
        horizontal: dimensions.spacing.s16,
      ),
      prefixIconColor: darkColor.icon,
      suffixIconColor: darkColor.icon,
      border: OutlineInputBorder(borderRadius: borderRadius, borderSide: borderSide),
      enabledBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: borderSide),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: darkColor.borderBrandFocus, width: dimensions.spacing.s1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: darkColor.error, width: dimensions.spacing.s1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: darkColor.error, width: dimensions.spacing.s1),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: darkColor.inactive, width: dimensions.spacing.s1),
      ),
    );
  }
}
