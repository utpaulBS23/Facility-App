part of '../colors.dart';

abstract class IconColors {
  const IconColors();

  Color get enable;
  Color get hover;
  Color get focused;
  Color get baseSecondary;
  Color get subdued;
  Color get accent;
  Color get disabled;
  Color get black;
  Color get white;
  Color get warning;
  Color get error;
  Color get success;
}

class _LightIconColors extends IconColors {
  const _LightIconColors();

  @override
  Color get enable => _Primitive.primary50; // brand/primary-50

  @override
  Color get hover => _Primitive.primary50; // brand/primary-50

  @override
  Color get focused => _Primitive.primary50; // brand/primary-50

  @override
  Color get baseSecondary => _Primitive.primary60; // brand/primary-60

  @override
  Color get subdued => _Primitive.neutral60; // neutral/neutral-60

  @override
  Color get accent => _Primitive.neutral40; // neutral/neutral-40

  @override
  Color get disabled => _Primitive.neutral50; // neutral/neutral-50

  @override
  Color get black => _Primitive.neutral90; // neutral/neutral-90

  @override
  Color get white => _Primitive.white; // other/white

  @override
  Color get warning => _Primitive.warning50; // warning/warning-50

  @override
  Color get error => _Primitive.error50; // error/error-50

  @override
  Color get success => _Primitive.success60; // success/success-60
}

class _DarkIconColors extends IconColors {
  const _DarkIconColors();

  @override
  Color get enable => _Primitive.white; // other/white

  @override
  Color get hover => _Primitive.white; // other/white

  @override
  Color get focused => _Primitive.white; // other/white

  @override
  Color get baseSecondary => _Primitive.primary60; // brand/secondary-60

  @override
  Color get subdued => _Primitive.neutral10; // neutral/neutral-10

  @override
  Color get accent => _Primitive.neutral40; // neutral/neutral-40

  @override
  Color get disabled => _Primitive.neutral30; // neutral/neutral-30

  @override
  Color get black => _Primitive.white; // other/white

  @override
  Color get white => _Primitive.neutral90; // neutral/neutral-90

  @override
  Color get warning => _Primitive.warning30; // warning/warning-30

  @override
  Color get error => _Primitive.error30; // error/error-30

  @override
  Color get success => _Primitive.success30; // success/success-30
}
