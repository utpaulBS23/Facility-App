part of '../colors.dart';

abstract class ButtonBackgroundColors {
  const ButtonBackgroundColors();

  Color get enabled;
  Color get hover;
  Color get focused;
  Color get disable;
  Color get white;
  Color get gray;
  Color get black;
  Color get errorAlt;
  Color get error;
  Color get hoverSecondary;
  Color get focusedSecondary;
  Color get success;
  Color get successAlt;
  Color get disbursementAlt;
  Color get disbursement;
  Color get warning;
  Color get warningAlt;
}

class _LightButtonBackgroundColors extends ButtonBackgroundColors {
  const _LightButtonBackgroundColors();

  @override
  Color get enabled => _Primitive.primary50; // brand/primary-50

  @override
  Color get hover => _Primitive.primary40; // brand/primary-40

  @override
  Color get focused => _Primitive.primary70; // brand/primary-70

  @override
  Color get disable => _Primitive.neutral20; // neutral/neutral-20

  @override
  Color get white => _Primitive.white; // other/white

  @override
  Color get gray => _Primitive.neutral30; // neutral/neutral-30

  @override
  Color get black => _Primitive.neutral90; // neutral/neutral-90

  @override
  Color get errorAlt => _Primitive.error10; // error/error-10

  @override
  Color get error => _Primitive.error50; // error/error-50

  @override
  Color get hoverSecondary => _Primitive.primary40; // brand/secondary-40 (using primary40 as fallback)

  @override
  Color get focusedSecondary => _Primitive.primary70; // brand/secondary-70 (using primary70 as fallback)

  @override
  Color get success => _Primitive.success60; // success/success-60

  @override
  Color get successAlt => _Primitive.success10; // success/success-10

  @override
  Color get disbursementAlt => _Primitive.darkBlue; // other/blue/blue-10 (using darkBlue as fallback)

  @override
  Color get disbursement => _Primitive.darkBlue; // other/blue/blue-60 (using darkBlue as fallback)

  @override
  Color get warning => _Primitive.warning50; // warning/warning-50

  @override
  Color get warningAlt => _Primitive.warning10; // warning/warning-10
}

class _DarkButtonBackgroundColors extends ButtonBackgroundColors {
  const _DarkButtonBackgroundColors();

  @override
  Color get enabled => _Primitive.primary50; // brand/secondary-50 (using primary50 as fallback)

  @override
  Color get hover => _Primitive.primary50; // brand/primary-50

  @override
  Color get focused => _Primitive.primary70; // brand/primary-70

  @override
  Color get disable => _Primitive.neutral20; // neutral/neutral-20

  @override
  Color get white => _Primitive.neutral80; // neutral/neutral-80

  @override
  Color get gray => _Primitive.neutral30; // neutral/neutral-30

  @override
  Color get black => _Primitive.neutral90; // neutral/neutral-90

  @override
  Color get errorAlt => _Primitive.error10; // transparent/error (using error10 as fallback)

  @override
  Color get error => _Primitive.error50; // error/error-50

  @override
  Color get hoverSecondary => _Primitive.primary40; // brand/secondary-40 (using primary40 as fallback)

  @override
  Color get focusedSecondary => _Primitive.primary70; // brand/secondary-70 (using primary70 as fallback)

  @override
  Color get success => _Primitive.success60; // success/success-60

  @override
  Color get successAlt => _Primitive.success10; // transparent/success (using success10 as fallback)

  @override
  Color get disbursementAlt => _Primitive.darkBlue; // transparent/blue (using darkBlue as fallback)

  @override
  Color get disbursement => _Primitive.darkBlue; // other/blue/blue-60 (using darkBlue as fallback)

  @override
  Color get warning => _Primitive.warning50; // warning/warning-50

  @override
  Color get warningAlt => _Primitive.warning10; // transparent/warning (using warning10 as fallback)
}
