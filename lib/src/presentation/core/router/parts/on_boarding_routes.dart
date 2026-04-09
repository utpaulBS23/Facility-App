part of '../router.dart';

List<GoRoute> _onboardingRoutes(Ref ref) {
  return [
    GoRoute(
      path: Routes.splash,
      name: Routes.splash,
      pageBuilder: (context, state) {
        return const NoTransitionPage(child: SplashPage());
      },
    ),
  ];
}
