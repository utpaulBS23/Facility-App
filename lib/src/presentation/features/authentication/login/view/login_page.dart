// Author: Md. Shahin Bashar
// Created: 2026-04-02

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/base/base.dart';
import '../../../../../core/extensions/app_localization.dart';
import '../../../../../core/extensions/failure_localization.dart';
import '../../../../../domain/entities/login_entity.dart';
import '../../../../../domain/entities/saved_account/credential_rejection.dart';
import '../../../../../domain/entities/saved_account/saved_account_entity.dart';
import '../../../../core/application_state/localization_provider/localization_provider.dart';
import '../../../../core/application_state/menu_configuration_provider/menu_configuration_provider.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/router/shell_tab_config.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/application_logo.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/text/typography.dart';
import '../../../../features/authentication/login/riverpod/login_provider.dart';
import '../models/login_flow_state.dart';
import '../models/saved_accounts_state.dart';
import '../riverpod/login_flow_provider.dart';
import '../riverpod/saved_accounts_provider.dart';
import '../widgets/account_avatar.dart';

part '../widgets/account_picker_sheet.dart';
part '../widgets/direct_login_loader.dart';
part '../widgets/login_form.dart';
part '../widgets/login_form_footer.dart';
part '../widgets/login_header.dart';
part '../widgets/login_language_toggle.dart';
part '../widgets/login_sign_in_body.dart';
part '../widgets/manage_accounts_view.dart';
part '../widgets/remove_account_confirm_dialog.dart';
part '../widgets/selected_account_card.dart';
part '../widgets/welcome_back_card.dart';

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

  LoginFlow get _flow => ref.read(loginFlowProvider.notifier);

  // WHY refresh first: the tabs are exactly what the server sends, so the
  // first tab is unknown until the layout for this login has arrived.
  Future<void> _landOnFirstTab(Set<UserPermission> permissions) async {
    // WHY a cap: a slow layout request must not hold the user on this screen.
    // It keeps running and the shell picks the layout up when it arrives.
    await ref
        .read(menuConfigProvider.notifier)
        .refresh()
        .timeout(const Duration(seconds: 3), onTimeout: () {});
    if (!mounted) return;

    context.goNamed(
      firstPermittedShellRoute(
        permissions,
        menuConfig: ref.read(menuConfigProvider),
      ),
    );
  }

  void _onLoginStateChanged(AsyncValue? previous, AsyncValue next) {
    final direct = ref.read(loginFlowProvider).directAccount;

    switch (next) {
      case AsyncData(:final value) when value != null:
        // WHY not endDirect: the loader must stay up until the first screen
        // replaces this page, or the login form flashes back in between.
        _flow.startLanding();
        final entity = (value as Success<LoginResponseEntity, Failure>).data;
        final permissions = entity?.permissions ?? const <UserPermission>{};
        // WHY: the landing tab is whatever the user's first permitted tab is,
        // not necessarily Shift — each page guards itself, so login must not
        // assume or check any one feature's permission.
        _landOnFirstTab(permissions);
      case AsyncError(:final error):
        _flow.endDirect();

        if (direct != null && error is Failure && error.isCredentialRejection) {
          _fallBackToForm(direct);
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.localizedMessage(context))),
        );
      case AsyncData():
        // Cancelled: nobody is waiting for a result any more.
        _flow.endDirect();
    }
  }

  void _fallBackToForm(SavedAccountEntity account) {
    _uidController.text = account.uid;
    _passwordController.clear();
    _flow.showAdd();
    ref.read(savedAccountsProvider.notifier).reload();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.locale.savedLoginFailedSignInAgain)),
    );
  }

  void _onLogin() {
    if (!_formKey.currentState!.validate()) return;
    ref
        .read(loginProvider.notifier)
        .login(
          uid: _uidController.text.trim(),
          password: _passwordController.text,
          saveAccount: ref.read(loginFlowProvider).saveAccount,
        );
  }

  void _onDirectLogin(SavedAccountEntity account) {
    ref.read(savedAccountsProvider.notifier).select(account.uid);
    _flow.startDirect(account);
    ref.read(loginProvider.notifier).directLogin(account.uid);
  }

  void _onCancelDirectLogin() => ref.read(loginProvider.notifier).cancel();

  void _onForgotPassword() => context.pushNamed(Routes.resetPassword);

  void _showAddAccount() {
    _uidController.clear();
    _passwordController.clear();
    _flow.showAdd();
  }

  void _openPicker(SavedAccountsState saved) {
    _showAccountPickerSheet(
      context,
      accounts: saved.accounts,
      selectedUid: saved.selected?.uid,
      onPick: _onDirectLogin,
      onManage: _flow.showManage,
    );
  }

  Future<void> _confirmRemove(SavedAccountEntity account) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => _RemoveAccountConfirmDialog(accountName: account.name),
    );
    if (confirmed != true || !mounted) return;

    await ref.read(savedAccountsProvider.notifier).remove(account.uid);
    if (!mounted) return;

    // WHY: with nothing left to manage, the only useful screen is the form.
    if (ref.read(savedAccountsProvider).isEmpty) _showAddAccount();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginProvider);
    final saved = ref.watch(savedAccountsProvider);
    final flow = ref.watch(loginFlowProvider);

    final direct = flow.directAccount;
    final isLoaderShown = direct != null;

    final Widget body;
    if (isLoaderShown) {
      body = _DirectLoginLoader(
        account: direct,
        onCancel: state.isLoading ? _onCancelDirectLogin : null,
      );
    } else if (flow.view == LoginView.manage) {
      body = _ManageAccountsView(
        accounts: saved.accounts,
        onRemove: _confirmRemove,
        onAddAnother: _showAddAccount,
        onDone: _flow.showAccounts,
      );
    } else {
      body = _SignInBody(
        saved: saved,
        flow: flow,
        isSigningIn: state.isLoading || flow.isLanding,
        formKey: _formKey,
        uidController: _uidController,
        passwordController: _passwordController,
        onBack: _flow.showAccounts,
        onSaveAccountChanged: _flow.setSaveAccount,
        onLogin: _onLogin,
        onForgotPassword: _onForgotPassword,
        onSignInWith: _onDirectLogin,
        onOpenPicker: () => _openPicker(saved),
        onUseAnother: _showAddAccount,
        onManage: _flow.showManage,
      );
    }

    // WHY: back is a step inside this page (loader -> cancel, form or manage ->
    // accounts) and only leaves the page from the accounts screen, or from the
    // form when there are no accounts to go back to.
    final canLeavePage =
        !isLoaderShown && (flow.view == LoginView.accounts || saved.isEmpty);

    return PopScope(
      canPop: canLeavePage,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (isLoaderShown) {
          if (state.isLoading) _onCancelDirectLogin();
        } else {
          _flow.showAccounts();
        }
      },
      child: Scaffold(
        backgroundColor: context.color.scaffoldBackground,
        body: SafeArea(child: body),
      ),
    );
  }
}
