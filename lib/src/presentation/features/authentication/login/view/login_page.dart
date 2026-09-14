// Author: Md. Shahin Bashar
// Created: 2026-04-02

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/base/base.dart';
import '../../../../../core/extensions/app_localization.dart';
import '../../../../../core/extensions/failure_localization.dart';
import '../../../../../core/gen/l10n/app_localizations.dart';
import '../../../../../domain/entities/login_entity.dart';
import '../../../../core/application_state/localization_provider/localization_provider.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/router/shell_tab_config.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/application_logo.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/text/typography.dart';
import '../../../../features/authentication/login/riverpod/login_provider.dart';

part '../widgets/login_form.dart';
part '../widgets/login_form_footer.dart';
part '../widgets/login_language_toggle.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  // Keys
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _uidController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.listenManual(loginProvider, _onLoginStateChanged);
  }

  @override
  void dispose() {
    _uidController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginStateChanged(AsyncValue? previous, AsyncValue next) {
    switch (next) {
      case AsyncData(:final value) when value != null:
        final entity = (value as Success<LoginResponseEntity, Failure>).data;
        final permissions = entity?.permissions ?? const <UserPermission>{};
        // WHY: landing tab is permission-driven — a user without shift.view
        // goes straight to their first permitted tab; the shift-status flow
        // below only applies to shift-capable attendants.
        if (permissions.contains(UserPermission.shiftView) ||
            permissions.contains(UserPermission.shiftSlotView)) {
          context.goNamed(firstPermittedShellRoute(permissions));
          return;
        }
      case AsyncError(:final error):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.localizedMessage(context))),
        );
    }
  }

  void _onLogin() {
    if (!_formKey.currentState!.validate()) return;
    ref
        .read(loginProvider.notifier)
        .login(uid: _uidController.text, password: _passwordController.text);
  }

  void _onForgotPassword() => context.pushNamed(Routes.resetPassword);

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginProvider);
    final colors = context.color;
    final dimensions = context.dimensions;

    return Scaffold(
      backgroundColor: colors.scaffoldBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: dimensions.padding.p16,
            vertical: dimensions.padding.p24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Directionality.of(context) == TextDirection.ltr
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: _LoginLanguageToggle(),
              ),
              Gap(dimensions.spacing.s40),
              ApplicationLogo(height: dimensions.spacing.s80),
              Gap(dimensions.spacing.s6),
              HeadlineLargeText(
                context.locale.appName,
                textAlign: TextAlign.center,
              ),
              Gap(dimensions.spacing.s4),
              BodyRegularText(
                context.locale.appSubtitle,
                color: colors.text.secondary,
                textAlign: TextAlign.center,
              ),
              Gap(dimensions.spacing.s40),
              Form(
                key: _formKey,
                child: _LoginCard(
                  uidController: _uidController,
                  passwordController: _passwordController,
                  isLoading: state.isLoading,
                  onLogin: _onLogin,
                  onForgotPassword: _onForgotPassword,
                ),
              ),
              Gap(dimensions.spacing.s24),
            ],
          ),
        ),
      ),
    );
  }
}
