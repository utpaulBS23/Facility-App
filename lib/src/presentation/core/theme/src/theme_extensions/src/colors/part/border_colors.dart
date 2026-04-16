part of '../colors.dart';

abstract class BorderColors {
  const BorderColors();

  Color get focused;
  Color get hover;
  Color get type;
  Color get active;
  Color get enter;
  Color get completed;
  Color get white;
  Color get divider;
  Color get dividerAlt;
  Color get placeholder;
  Color get basePrimary;
  Color get baseSecondary;
  Color get accent;
  Color get dark;
  Color get disable;
  Color get success;
  Color get warning;
  Color get error;
  Color get productBorder;
}

class _LightBorderColors extends BorderColors {
  const _LightBorderColors();

  @override
  Color get focused => _Primitive.primary60; // brand/primary-60

  @override
  Color get hover => _Primitive.primary40; // brand/primary-40

  @override
  Color get type => _Primitive.primary60; // brand/primary-60

  @override
  Color get active => _Primitive.primary70; // brand/primary-70

  @override
  Color get enter => _Primitive.primary70; // brand/primary-70

  @override
  Color get completed => _Primitive.neutral30; // neutral/neutral-30

  @override
  Color get white => _Primitive.white; // other/white

  @override
  Color get divider => _Primitive.neutral20; // neutral/neutral-20

  @override
  Color get dividerAlt => _Primitive.neutral10; // neutral/neutral-10

  @override
  Color get placeholder => _Primitive.neutral30; // neutral/neutral-30

  @override
  Color get basePrimary => _Primitive.primary50; // brand/primary-50

  @override
  Color get baseSecondary => _Primitive.primary60; // brand/secondary-60 (using primary60 as fallback)

  @override
  Color get accent => _Primitive.primary50; // brand/primary-50

  @override
  Color get dark => _Primitive.neutral90; // neutral/neutral-90

  @override
  Color get disable => _Primitive.neutral30; // neutral/neutral-30

  @override
  Color get success => _Primitive.success60; // success/success-60

  @override
  Color get warning => _Primitive.warning50; // warning/warning-50

  @override
  Color get error => _Primitive.error50; // error/error-50

  @override
  Color get productBorder => _Primitive.darkBlue; // other/blue/blue-50 (using darkBlue as fallback)
}

class _DarkBorderColors extends BorderColors {
  const _DarkBorderColors();

  @override
  Color get focused => _Primitive.primary60; // brand/primary-60

  @override
  Color get hover => _Primitive.primary60; // brand/primary-60

  @override
  Color get type => _Primitive.primary60; // brand/primary-60

  @override
  Color get active => _Primitive.primary70; // brand/primary-70

  @override
  Color get enter => _Primitive.primary70; // brand/primary-70

  @override
  Color get completed => _Primitive.neutral30; // neutral/neutral-30

  @override
  Color get white => _Primitive.white; // other/white

  @override
  Color get divider => _Primitive.neutral50; // neutral/neutral-50

  @override
  Color get dividerAlt => _Primitive.neutral60; // neutral/neutral-60

  @override
  Color get placeholder => _Primitive.neutral30; // neutral/neutral-30

  @override
  Color get basePrimary => _Primitive.primary60; // brand/secondary-50 (using primary60 as fallback)

  @override
  Color get baseSecondary => _Primitive.primary60; // brand/secondary-60

  @override
  Color get accent => _Primitive.neutral40; // neutral/neutral-40

  @override
  Color get dark => _Primitive.neutral40; // neutral/neutral-40

  @override
  Color get disable => _Primitive.neutral30; // neutral/neutral-30

  @override
  Color get success => _Primitive.success60; // success/success-60

  @override
  Color get warning => _Primitive.warning50; // warning/warning-50

  @override
  Color get error => _Primitive.error50; // error/error-50

  @override
  Color get productBorder => _Primitive.darkBlue; // other/blue/blue-50 (using darkBlue as fallback)
}
