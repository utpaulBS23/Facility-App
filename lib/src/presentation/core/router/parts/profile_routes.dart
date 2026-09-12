part of '../router.dart';



List<GoRoute> _profileRoutes(Ref ref) {
  return [
    GoRoute(
      path: Routes.myProfile,
      name: Routes.myProfile,
      pageBuilder: (context, state) {
        return const MaterialPage(child: MyProfilePage());
      },
    ),
    GoRoute(
      path: Routes.editProfile,
      name: Routes.editProfile,
      pageBuilder: (context, state) {
        return const MaterialPage(child: EditProfilePage());
      },
    ),
    GoRoute(
      path: Routes.changePassword,
      name: Routes.changePassword,
      pageBuilder: (context, state) {
        return const MaterialPage(child: ChangePasswordPage());
      },
    ),
    GoRoute(
      path: Routes.passwordReset,
      name: Routes.passwordReset,
      pageBuilder: (context, state) {
        return const MaterialPage(child: PasswordResetPage());
      },
    ),
    GoRoute(
      path: Routes.otpVerification,
      name: Routes.otpVerification,
      pageBuilder: (context, state) {
        return const MaterialPage(child: OtpVerificationPage());
      },
    ),
  ];
}
