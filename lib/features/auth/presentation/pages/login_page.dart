import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/core/di/injection.dart';
import 'package:ui_kit/core/extensions/context_extensions.dart';
import 'package:ui_kit/core/localization/l10n_lookup.dart';
import 'package:ui_kit/core/routing/route_names.dart';
import 'package:ui_kit/core/theme/app_spacing.dart';
import 'package:ui_kit/core/utils/input_validators.dart';
import 'package:ui_kit/core/widgets/app_button.dart';
import 'package:ui_kit/core/widgets/app_text_field.dart';
import 'package:ui_kit/core/widgets/auth_error_banner.dart';
import 'package:ui_kit/core/widgets/custom_snackbar.dart';
import 'package:ui_kit/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ui_kit/features/auth/presentation/widgets/auth_header.dart';
import 'package:ui_kit/features/auth/presentation/widgets/social_login_buttons.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _showBanner = false;
  String? _bannerKey;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    context.hideKeyboard();
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        AuthLoginRequested(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.status == AuthStatus.authenticated) {
              context.goNamed(RouteNames.nHome);
            } else if (state.status == AuthStatus.failure &&
                state.failureKey != null) {
              setState(() {
                _showBanner = true;
                _bannerKey = state.failureKey;
              });
              AppSnackbar.error(context, tr(context, state.failureKey!));
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.screenH,
                vertical: AppSpacing.vXl,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 24.h),
                    AuthHeader(
                      title: l10n.welcomeBack,
                      subtitle: l10n.loginSubtitle,
                    ),
                    if (_showBanner && _bannerKey != null)
                      AuthErrorBanner(
                        failureKey: _bannerKey!,
                        onDismiss: () => setState(() => _showBanner = false),
                      ),
                    AppTextField(
                      controller: _emailController,
                      label: l10n.email,
                      hint: 'you@example.com',
                      prefixIcon: Icons.mail_outline_rounded,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        final key = InputValidators.email(v);
                        return key == null ? null : tr(context, key);
                      },
                    ),
                    SizedBox(height: AppSpacing.vLg),
                    AppTextField(
                      controller: _passwordController,
                      label: l10n.password,
                      hint: '••••••',
                      prefixIcon: Icons.lock_outline_rounded,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _submit(),
                      validator: (v) {
                        final key = InputValidators.password(v);
                        return key == null ? null : tr(context, key);
                      },
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 24.w,
                          height: 24.w,
                          child: Checkbox(
                            value: _rememberMe,
                            onChanged: (v) =>
                                setState(() => _rememberMe = v ?? false),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                        SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _rememberMe = !_rememberMe),
                            child: Text(
                              l10n.rememberMe,
                              style: context.textTheme.bodyMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        SizedBox(width: AppSpacing.sm),
                        TextButton(
                          onPressed: () =>
                              context.pushNamed(RouteNames.nForgotPassword),
                          child: Text(
                            l10n.forgotPassword,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.vSm),
                    AppButton(
                      label: l10n.login,
                      isLoading: state.isLoading,
                      onPressed: _submit,
                    ),
                    SizedBox(height: AppSpacing.vXxl),
                    _OrDivider(label: l10n.orContinueWith),
                    SizedBox(height: AppSpacing.vXl),
                    const SocialLoginButtons(),
                    SizedBox(height: AppSpacing.vXxl),
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          l10n.dontHaveAccount,
                          style: context.textTheme.bodyMedium,
                        ),
                        TextButton(
                          onPressed: () =>
                              context.pushNamed(RouteNames.nRegister),
                          child: Text(l10n.register),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(label, style: context.textTheme.bodySmall),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
