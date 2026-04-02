import 'src/colors/colors.dart';
import 'src/dimensions.dart';
import 'src/text_style.dart';

export 'src/colors/colors.dart';
export 'src/dimensions.dart';
export 'src/text_style.dart';

// WHY: getters instead of final fields so $LightThemeData / $DarkThemeData
// can override textStyle with a locale-specific font family.
mixin ThemeExtensions {
  LightColorExtension get lightColor => const LightColorExtension();
  DarkColorExtension get darkColor => const DarkColorExtension();
  TextStyleExtension get textStyle => const TextStyleExtension();
  Dimensions get dimensions => const Dimensions();
}
