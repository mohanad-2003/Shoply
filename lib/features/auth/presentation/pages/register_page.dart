import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/core/di/injection.dart';
import 'package:ui_kit/core/extensions/context_extensions.dart';
import 'package:ui_kit/core/localization/l10n_lookup.dart';
import 'package:ui_kit/core/routing/route_names.dart';
import 'package:ui_kit/core/theme/app_spacing.dart';
import 'package:ui_kit/core/utils/input_validators.dart';
import 'package:ui_kit/core/widgets/app_bar_widget.dart';
import 'package:ui_kit/core/widgets/app_button.dart';
import 'package:ui_kit/core/widgets/app_text_field.dart';
import 'package:ui_kit/core/widgets/auth_error_banner.dart';
import 'package:ui_kit/core/widgets/custom_snackbar.dart';
import 'package:ui_kit/core/widgets/terms_checkbox.dart';
import 'package:ui_kit/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ui_kit/features/auth/presentation/widgets/auth_header.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _agreedToTerms = false;
  bool _showBanner = false;
  String? _bannerKey;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    context.hideKeyboard();
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        AuthRegisterRequested(
          name: _nameController.text,
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
      appBar: const AppBarWidget(),
      body: SafeArea(
        top: false,
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
                vertical: AppSpacing.vSm,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AuthHeader(
                      title: l10n.createAccount,
                      subtitle: l10n.registerSubtitle,
                    ),
                    if (_showBanner && _bannerKey != null)
                      AuthErrorBanner(
                        failureKey: _bannerKey!,
                        onDismiss: () => setState(() => _showBanner = false),
                      ),
                    AppTextField(
                      controller: _nameController,
                      label: l10n.fullName,
                      prefixIcon: Icons.person_outline_rounded,
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        final key = InputValidators.name(v);
                        return key == null ? null : tr(context, key);
                      },
                    ),
                    SizedBox(height: AppSpacing.vLg),
                    AppTextField(
                      controller: _emailController,
                      label: l10n.email,
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
                      prefixIcon: Icons.lock_outline_rounded,
                      obscureText: true,
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        final key = InputValidators.password(v);
                        return key == null ? null : tr(context, key);
                      },
                    ),
                    SizedBox(height: AppSpacing.vLg),
                    AppTextField(
                      controller: _confirmController,
                      label: l10n.confirmPassword,
                      prefixIcon: Icons.lock_outline_rounded,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _submit(),
                      validator: (v) {
                        final key = InputValidators.confirmPassword(
                          v,
                          _passwordController.text,
                        );
                        return key == null ? null : tr(context, key);
                      },
                    ),
                    SizedBox(height: AppSpacing.vLg),
                    TermsCheckbox(
                      value: _agreedToTerms,
                      onChanged: (v) => setState(() => _agreedToTerms = v),
                      onTermsTap: () =>
                          context.pushNamed(RouteNames.nTermsPrivacy),
                    ),
                    SizedBox(height: AppSpacing.vXl),
                    AppButton(
                      label: l10n.register,
                      isLoading: state.isLoading,
                      onPressed: _agreedToTerms ? _submit : null,
                    ),
                    SizedBox(height: AppSpacing.vLg),
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          l10n.alreadyHaveAccount,
                          style: context.textTheme.bodyMedium,
                        ),
                        TextButton(
                          onPressed: () => context.pop(),
                          child: Text(l10n.login),
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
