part of '../colors.dart';

abstract class ButtonLabelColors {
  const ButtonLabelColors();

  Color get enable;
  Color get hovered;
  Color get focused;
  Color get pressedSecondary;
  Color get darkAlt;
  Color get white;
  Color get dark;
  Color get errorAlt;
  Color get baseSecondary;
  Color get successAlt;
  Color get error;
  Color get hoveredSecondary;
  Color get focusedSecondary;
  Color get success;
  Color get warningAlt;
  Color get warning;
  Color get disable;
}

class _LightButtonLabelColors extends ButtonLabelColors {
  const _LightButtonLabelColors();

  @override
  Color get enable => _Primitive.primary50; // brand/primary-50

  @override
  Color get hovered => _Primitive.primary50; // brand/primary-50

  @override
  Color get focused => _Primitive.primary70; // brand/primary-70

  @override
  Color get pressedSecondary => _Primitive.primary70; // brand/secondary-70 (using primary70 as fallback)

  @override
  Color get darkAlt => _Primitive.neutral60; // neutral/neutral-60

  @override
  Color get white => _Primitive.white; // other/white

  @override
  Color get dark => _Primitive.neutral80; // neutral/neutral-80

  @override
  Color get errorAlt => _Primitive.error90; // error/error-90

  @override
  Color get baseSecondary => _Primitive.primary60; // brand/primary-60

  @override
  Color get successAlt => _Primitive.success10; // success/success-10

  @override
  Color get error => _Primitive.error50; // error/error-50

  @override
  Color get hoveredSecondary => _Primitive.primary50; // brand/secondary-50 (using primary50 as fallback)

  @override
  Color get focusedSecondary => _Primitive.primary50; // brand/secondary-50 (using primary50 as fallback)

  @override
  Color get success => _Primitive.success60; // success/success-60

  @override
  Color get warningAlt => _Primitive.warning90; // warning/90

  @override
  Color get warning => _Primitive.warning50; // warning/warning-50

  @override
  Color get disable => _Primitive.neutral50; // neutral/neutral-50
}

class _DarkButtonLabelColors extends ButtonLabelColors {
  const _DarkButtonLabelColors();

  @override
  Color get enable => _Primitive.primary60; // brand/secondary-60

  @override
  Color get hovered => _Primitive.primary50; // brand/primary-50

  @override
  Color get focused => _Primitive.primary70; // brand/primary-70

  @override
  Color get pressedSecondary => _Primitive.primary70; // brand/secondary-70 (using primary70 as fallback)

  @override
  Color get darkAlt => _Primitive.neutral10; // neutral/neutral-10

  @override
  Color get white => _Primitive.neutral90; // neutral/neutral-90

  @override
  Color get dark => _Primitive.neutral90; // neutral/neutral-90

  @override
  Color get errorAlt => _Primitive.error10; // error/error-10

  @override
  Color get baseSecondary => _Primitive.primary60; // brand/secondary-60

  @override
  Color get successAlt => _Primitive.success10; // success/success-10

  @override
  Color get error => _Primitive.error30; // error/error-30

  @override
  Color get hoveredSecondary => _Primitive.primary50; // brand/secondary-50 (using primary50 as fallback)

  @override
  Color get focusedSecondary => _Primitive.primary50; // brand/secondary-50 (using primary50 as fallback)

  @override
  Color get success => _Primitive.success30; // success/success-30

  @override
  Color get warningAlt => _Primitive.warning10; // warning/warning-10

  @override
  Color get warning => _Primitive.warning30; // warning/warning-30

  @override
  Color get disable => _Primitive.neutral50; // neutral/neutral-50
}
