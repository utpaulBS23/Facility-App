part of '../colors.dart';

abstract class ButtonIconColors {
  const ButtonIconColors();

  Color get accent;
  Color get basePrimary;
  Color get hovered;
  Color get focused;
  Color get disable;
  Color get disableAlt;
  Color get white;
  Color get errorAlt;
  Color get successAlt;
  Color get warningAlt;
  Color get error;
  Color get success;
  Color get pressed;
  Color get warning;
}

class _LightButtonIconColors extends ButtonIconColors {
  const _LightButtonIconColors();

  @override
  Color get accent => _Primitive.primary20; // brand/primary-20

  @override
  Color get basePrimary => _Primitive.primary60; // brand/primary-60

  @override
  Color get hovered => _Primitive.primary50; // brand/primary-50

  @override
  Color get focused => _Primitive.primary70; // brand/primary-70

  @override
  Color get disable => _Primitive.neutral50; // neutral/neutral-50

  @override
  Color get disableAlt => _Primitive.neutral10; // neutral/neutral-10

  @override
  Color get white => _Primitive.white; // other/white

  @override
  Color get errorAlt => _Primitive.error10; // error/error-10

  @override
  Color get successAlt => _Primitive.success10; // success/success-10

  @override
  Color get warningAlt => _Primitive.warning10; // warning/warning-10

  @override
  Color get error => _Primitive.error50; // error/error-50

  @override
  Color get success => _Primitive.success60; // success/success-60

  @override
  Color get pressed => _Primitive.primary70; // brand/primary-70

  @override
  Color get warning => _Primitive.warning50; // warning/warning-50
}

class _DarkButtonIconColors extends ButtonIconColors {
  const _DarkButtonIconColors();

  @override
  Color get accent => _Primitive.primary20; // brand/primary-20

  @override
  Color get basePrimary => _Primitive.primary60; // brand/primary-60

  @override
  Color get hovered => _Primitive.primary50; // brand/primary-50

  @override
  Color get focused => _Primitive.primary70; // brand/primary-70

  @override
  Color get disable => _Primitive.neutral50; // neutral/neutral-50

  @override
  Color get disableAlt => _Primitive.neutral10; // neutral/neutral-10

  @override
  Color get white => _Primitive.white; // other/white

  @override
  Color get errorAlt => _Primitive.error10; // error/error-10

  @override
  Color get successAlt => _Primitive.success10; // success/success-10

  @override
  Color get warningAlt => _Primitive.warning10; // warning/warning-10

  @override
  Color get error => _Primitive.error30; // error/error-30

  @override
  Color get success => _Primitive.success30; // success/success-30

  @override
  Color get pressed => _Primitive.primary70; // brand/primary-70

  @override
  Color get warning => _Primitive.warning30; // warning/warning-30
}
