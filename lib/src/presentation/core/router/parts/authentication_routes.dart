part of '../router.dart';

List<GoRoute> _authenticationRoutes(Ref ref) {
  return [
    GoRoute(
      path: Routes.login,
      name: Routes.login,
      pageBuilder: (context, state) {
        return const MaterialPage(child: LoginPage());
      },
      routes: [
        GoRoute(
          path: Routes.resetPassword,
          name: Routes.resetPassword,
          pageBuilder: (context, state) =>
              const MaterialPage(child: ResetPasswordPage()),
          routes: [
            GoRoute(
              path: Routes.emailVerification,
              name: Routes.emailVerification,
              pageBuilder: (context, state) {
                final phone = state.extra as String?;
                return MaterialPage(
                  child: ForgotPasswordOtpVerificationPage(phoneNumber: phone),
                );
              },
            ),
            GoRoute(
              path: Routes.createNewPassword,
              name: Routes.createNewPassword,
              pageBuilder: (context, state) {
                final extra = state.extra as Map<String, String>?;
                return MaterialPage(
                  child: CreateNewPasswordPage(
                    phoneNumber: extra?['phoneNumber'],
                    resetToken: extra?['resetToken'],
                  ),
                );
              },
              routes: [
                GoRoute(
                  path: Routes.resetPasswordSuccess,
                  name: Routes.resetPasswordSuccess,
                  pageBuilder: (context, state) =>
                      const MaterialPage(child: ResetPasswordSuccessPage()),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ];
}
