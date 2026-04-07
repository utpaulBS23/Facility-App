// ignore_for_file: max_file_lines
// ignore_for_file: max_method_lines
part of '../theme_data.dart';

/// Filled Button
///
/// Light Theme
class _FilledButtonLightThemeData with ThemeExtensions {
  FilledButtonThemeData call() {
    return FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return lightColor.disabled;
          }
          return lightColor.primary;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return lightColor.primary; // Figma: text-black
          }
          return lightColor.onPrimary;
        }),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(dimensions.spacing.s12),
          ),
        ),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(horizontal: dimensions.spacing.s24),
        ),
        minimumSize: WidgetStateProperty.all(
          Size(double.infinity, dimensions.spacing.s48),
        ),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.24,
          ),
        ),
      ),
    );
  }
}

/// Dark Theme
class _FilledButtonDarkThemeData with ThemeExtensions {
  FilledButtonThemeData call() {
    return FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return darkColor.disabled;
          }
          return darkColor.primary;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return darkColor.primary; // Figma: text-black
          }
          return darkColor.onPrimary;
        }),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(dimensions.spacing.s12),
          ),
        ),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(horizontal: dimensions.spacing.s24),
        ),
        minimumSize: WidgetStateProperty.all(
          Size(double.infinity, dimensions.spacing.s48),
        ),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.24,
          ),
        ),
      ),
    );
  }
}

/// Outlined Button
///
/// Light Theme
class _OutlinedButtonLightThemeData with ThemeExtensions {
  OutlinedButtonThemeData call() {
    return OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(lightColor.primary),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(dimensions.spacing.s12),
          ),
        ),
        side: WidgetStateProperty.all(BorderSide(color: lightColor.primary)),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(horizontal: dimensions.spacing.s24),
        ),
        minimumSize: WidgetStateProperty.all(
          Size(double.infinity, dimensions.spacing.s48),
        ),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.24,
          ),
        ),
      ),
    );
  }
}

/// Dark Theme
class _OutlinedButtonDarkThemeData with ThemeExtensions {
  OutlinedButtonThemeData call() {
    return OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(darkColor.primary),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(dimensions.spacing.s12),
          ),
        ),
        side: WidgetStateProperty.all(BorderSide(color: darkColor.primary)),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(horizontal: dimensions.spacing.s24),
        ),
        minimumSize: WidgetStateProperty.all(
          Size(double.infinity, dimensions.spacing.s48),
        ),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.24,
          ),
        ),
      ),
    );
  }
}

/// Elevated Button
///
/// Light Theme
class _ElevatedButtonLightThemeData with ThemeExtensions {
  ElevatedButtonThemeData call() {
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: WidgetStateProperty.all(0),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(dimensions.spacing.s12),
          ),
        ),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(horizontal: dimensions.spacing.s24),
        ),
        minimumSize: WidgetStateProperty.all(
          Size(double.infinity, dimensions.spacing.s48),
        ),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.24,
          ),
        ),
      ),
    );
  }
}

/// Dark Theme
class _ElevatedButtonDarkThemeData with ThemeExtensions {
  ElevatedButtonThemeData call() {
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: WidgetStateProperty.all(0),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(dimensions.spacing.s12),
          ),
        ),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(horizontal: dimensions.spacing.s24),
        ),
        minimumSize: WidgetStateProperty.all(
          Size(double.infinity, dimensions.spacing.s48),
        ),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.24,
          ),
        ),
      ),
    );
  }
}

/// Text Button
///
/// Light Theme
class _TextButtonLightThemeData with ThemeExtensions {
  TextButtonThemeData call() {
    return TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(lightColor.text.secondary),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

/// Dark Theme
class _TextButtonDarkThemeData with ThemeExtensions {
  TextButtonThemeData call() {
    return TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(darkColor.text.secondary),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
