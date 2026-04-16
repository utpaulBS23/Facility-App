part of '../colors.dart';

abstract class BackgroundColors {
  const BackgroundColors();

  Color get brand;
  Color get completed;
  Color get ongoing;
  Color get cancelled;
  Color get active;
  Color get brandSecondary;
  Color get overlay;
  Color get surface;
  Color get brandTertiary;
  Color get secondary;
  Color get disable;
  Color get white;
  Color get accentAlt;
  Color get accent;
  Color get neutral;
  Color get neutralAlt;
  Color get info;
  Color get errorAlt;
  Color get successAlt;
  Color get warningAlt;
  Color get error;
  Color get success;
  Color get warning;
  Color get disbursementAlt;
  Color get disbursement;
  Color get dark;
  Color get lightDark;
  Color get darkBlue;
}

class _LightBackgroundColors extends BackgroundColors {
  const _LightBackgroundColors();

  @override
  Color get brand => _Primitive.primary50; // brand/primary-50

  @override
  Color get completed => _Primitive.primary50; // brand/primary-50

  @override
  Color get ongoing => _Primitive.warning50; // warning/warning-50

  @override
  Color get cancelled => _Primitive.error50; // error/error-50

  @override
  Color get active => _Primitive.darkBlue; // other/darkBlue

  @override
  Color get brandSecondary => _Primitive.primary10; // brand/primary-10

  @override
  Color get overlay => _Primitive.gray80; // transparent/gray (using gray80 as fallback)

  @override
  Color get surface => _Primitive.neutral0; // neutral/neutral-0

  @override
  Color get brandTertiary => _Primitive.darkBlue; // other/ocan (using darkBlue as fallback)

  @override
  Color get secondary => _Primitive.neutral10; // neutral/neutral-10

  @override
  Color get disable => _Primitive.neutral10; // neutral/neutral-10

  @override
  Color get white => _Primitive.white; // other/white

  @override
  Color get accentAlt => _Primitive.neutral20; // neutral/neutral-20

  @override
  Color get accent => _Primitive.primary20; // brand/primary-20

  @override
  Color get neutral => _Primitive.neutral30; // neutral/neutral-30

  @override
  Color get neutralAlt => _Primitive.neutral40; // neutral/neutral-40

  @override
  Color get info => _Primitive.primary60; // brand/primary-60

  @override
  Color get errorAlt => _Primitive.error10; // error/error-10

  @override
  Color get successAlt => _Primitive.success10; // sucess/sucess-10

  @override
  Color get warningAlt => _Primitive.warning10; // warning/warning-10

  @override
  Color get error => _Primitive.error50; // error/error-50

  @override
  Color get success => _Primitive.success60; // sucess/sucess-60

  @override
  Color get warning => _Primitive.warning50; // warning/warning-50

  @override
  Color get disbursementAlt => _Primitive.darkBlue; // other/blue/blue-10 (using darkBlue as fallback)

  @override
  Color get disbursement => _Primitive.darkBlue; // other/blue/blue-60 (using darkBlue as fallback)

  @override
  Color get dark => _Primitive.black; // other/black

  @override
  Color get lightDark => _Primitive.neutral60; // neutral/neutral-60

  @override
  Color get darkBlue => _Primitive.darkBlue; // other/darkBlue
}

class _DarkBackgroundColors extends BackgroundColors {
  const _DarkBackgroundColors();

  @override
  Color get brand => _Primitive.primary60; // brand/secondary-60 (using primary60 as fallback)

  @override
  Color get completed => _Primitive.primary60; // brand/secondary-60 (using primary60 as fallback)

  @override
  Color get ongoing => _Primitive.primary60; // brand/secondary-60 (using primary60 as fallback)

  @override
  Color get cancelled => _Primitive.primary60; // brand/secondary-60 (using primary60 as fallback)

  @override
  Color get active => _Primitive.primary60; // brand/secondary-60 (using primary60 as fallback)

  @override
  Color get brandSecondary => _Primitive.primary60; // brand/secondary-60 (using primary60 as fallback)

  @override
  Color get overlay => _Primitive.primary60; // brand/secondary-60 (using primary60 as fallback)

  @override
  Color get surface => _Primitive.primary60; // brand/secondary-60 (using primary60 as fallback)

  @override
  Color get brandTertiary => _Primitive.darkBlue; // other/ocan (using darkBlue as fallback)

  @override
  Color get secondary => _Primitive.neutral80; // neutral/neutral-80

  @override
  Color get disable => _Primitive.neutral80; // neutral/neutral-80

  @override
  Color get white => _Primitive.neutral90; // neutral/neutral-90

  @override
  Color get accentAlt => _Primitive.neutral70; // neutral/neutral-70

  @override
  Color get accent => _Primitive.primary20; // brand/primary-20

  @override
  Color get neutral => _Primitive.neutral30; // neutral/neutral-30

  @override
  Color get neutralAlt => _Primitive.neutral40; // neutral/neutral-40

  @override
  Color get info => _Primitive.primary60; // brand/primary-60

  @override
  Color get errorAlt => _Primitive.error10; // error/error-10

  @override
  Color get successAlt => _Primitive.success90; // sucess/sucess-90

  @override
  Color get warningAlt => _Primitive.warning90; // warning/90

  @override
  Color get error => _Primitive.error50; // error/error-50

  @override
  Color get success => _Primitive.success30; // sucess/sucess-30

  @override
  Color get warning => _Primitive.warning50; // warning/warning-50

  @override
  Color get disbursementAlt => _Primitive.darkBlue; // other/blue/blue-90 (using darkBlue as fallback)

  @override
  Color get disbursement => _Primitive.darkBlue; // other/blue/blue-60 (using darkBlue as fallback)

  @override
  Color get dark => _Primitive.black; // other/black

  @override
  Color get lightDark => _Primitive.black; // other/black

  @override
  Color get darkBlue => _Primitive.darkBlue; // other/darkBlue
}
