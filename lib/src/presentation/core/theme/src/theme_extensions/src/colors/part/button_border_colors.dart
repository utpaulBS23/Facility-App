part of '../colors.dart';

abstract class ButtonBorderColors {
  const ButtonBorderColors();

  Color get enable;
  Color get hover;
  Color get pressed;
  Color get focus;
  Color get dark;
  Color get white;
  Color get accent;
  Color get accentAlt;
  Color get disable;
  Color get success;
  Color get warning;
  Color get warningAlt;
  Color get error;
  Color get errorAlt;
}

class _LightButtonBorderColors extends ButtonBorderColors {
  const _LightButtonBorderColors();

  @override
  Color get enable => _Primitive.primary50; // brand/primary-50

  @override
  Color get hover => _Primitive.primary50; // brand/primary-50

  @override
  Color get pressed => _Primitive.primary70; // brand/primary-70

  @override
  Color get focus => _Primitive.primary70; // brand/primary-70

  @override
  Color get dark => _Primitive.neutral80; // neutral/neutral-80

  @override
  Color get white => _Primitive.white; // other/white

  @override
  Color get accent => _Primitive.primary50; // brand/primary-50

  @override
  Color get accentAlt => _Primitive.neutral40; // neutral/neutral-40

  @override
  Color get disable => _Primitive.neutral30; // neutral/neutral-30

  @override
  Color get success => _Primitive.success60; // success/success-60

  @override
  Color get warning => _Primitive.warning50; // warning/warning-50

  @override
  Color get warningAlt => _Primitive.warning90; // warning/90

  @override
  Color get error => _Primitive.error50; // error/error-50

  @override
  Color get errorAlt => _Primitive.error90; // error/error-90
}

class _DarkButtonBorderColors extends ButtonBorderColors {
  const _DarkButtonBorderColors();

  @override
  Color get enable => _Primitive.primary60; // brand/primary-60

  @override
  Color get hover => _Primitive.primary50; // brand/primary-50

  @override
  Color get pressed => _Primitive.primary70; // brand/primary-70

  @override
  Color get focus => _Primitive.primary70; // brand/primary-70

  @override
  Color get dark => _Primitive.neutral40; // neutral/neutral-40

  @override
  Color get white => _Primitive.white; // other/white

  @override
  Color get accent => _Primitive.primary50; // brand/primary-50

  @override
  Color get accentAlt => _Primitive.neutral40; // neutral/neutral-40

  @override
  Color get disable => _Primitive.neutral30; // neutral/neutral-30

  @override
  Color get success => _Primitive.success60; // success/success-60

  @override
  Color get warning => _Primitive.warning50; // warning/warning-50

  @override
  Color get warningAlt => _Primitive.warning90; // warning/90

  @override
  Color get error => _Primitive.error50; // error/error-50

  @override
  Color get errorAlt => _Primitive.error90; // error/error-90
}
