// Author: Md. Shahin Bashar
// Created: 2026-04-02

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/app_localization.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/application_logo.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/text/typography.dart';
import '../../../../features/authentication/login/riverpod/login_provider.dart';
import '../widgets/language_switcher.dart';

part '../widgets/login_form.dart';
part '../widgets/login_form_footer.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  // Keys
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = 'emma.garcia@yopmail.com';
    _passwordController.text = 'password123';
    ref.listenManual(loginProvider, _onLoginStateChanged);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginStateChanged(AsyncValue? previous, AsyncValue next) {
    switch (next) {
      case AsyncData(:final value) when value != null:
        context.pushReplacementNamed(Routes.shiftCheckIn);
      case AsyncError(:final error):
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  void _onLogin() {
    if (!_formKey.currentState!.validate()) return;
    ref
        .read(loginProvider.notifier)
        .login(
          email: _emailController.text,
          password: _passwordController.text,
        );
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
              // WHY: Language switcher flips side based on text direction so it
              // always appears at the trailing edge of the screen.
              Align(
                alignment: Directionality.of(context) == TextDirection.ltr
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: const LanguageSwitcherWidget(),
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
                  emailController: _emailController,
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
