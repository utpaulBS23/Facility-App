part of '../view/onboarding_page.dart';

typedef _OnboardingItem = ({
  int index,
  String title,
  Widget image,
  String description,
});

List<_OnboardingItem> _getOnboardingItems(BuildContext context) => [
  (
    index: 0,
    title: context.locale.mipTitle,
    image: FlutterLogo(size: context.dimensions.spacing.s200),
    description: context.locale.mipDescription,
  ),
  (
    index: 1,
    title: context.locale.cpsTitle,
    image: FlutterLogo(size: context.dimensions.spacing.s200),
    description: context.locale.cpsDescription,
  ),
];
