import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/core/constants/asset_paths.dart';
import 'package:ui_kit/core/extensions/context_extensions.dart';
import 'package:ui_kit/core/routing/route_names.dart';
import 'package:ui_kit/core/theme/app_colors.dart';
import 'package:ui_kit/core/theme/app_radius.dart';
import 'package:ui_kit/core/theme/app_spacing.dart';
import 'package:ui_kit/core/widgets/app_button.dart';
import 'package:ui_kit/core/widgets/staggered_reveal.dart';
import 'package:ui_kit/features/auth/presentation/widgets/social_login_buttons.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.screenH,
                vertical: AppSpacing.vXl,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      constraints.maxHeight - AppSpacing.vXl - AppSpacing.vXl,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    StaggeredReveal(child: _Hero()),
                    SizedBox(height: AppSpacing.vXxxl),
                    StaggeredReveal(
                      delay: const Duration(milliseconds: 120),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AppButton(
                            label: l10n.createAccount,
                            onPressed: () =>
                                context.pushNamed(RouteNames.nRegister),
                          ),
                          SizedBox(height: AppSpacing.vLg),
                          AppButton(
                            label: l10n.login,
                            variant: AppButtonVariant.outline,
                            onPressed: () =>
                                context.pushNamed(RouteNames.nLogin),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.vXxl),
                    StaggeredReveal(
                      delay: const Duration(milliseconds: 220),
                      child: Column(
                        children: [
                          _OrDivider(label: l10n.orContinueWith),
                          SizedBox(height: AppSpacing.vXl),
                          const SocialLoginButtons(),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.vXl),
                    StaggeredReveal(
                      delay: const Duration(milliseconds: 300),
                      child: Column(
                        children: [
                          Center(
                            child: TextButton(
                              onPressed: () =>
                                  context.goNamed(RouteNames.nHome),
                              child: Text(l10n.continueAsGuest),
                            ),
                          ),
                          SizedBox(height: AppSpacing.vSm),
                          Text.rich(
                            TextSpan(
                              style: context.textTheme.bodySmall,
                              children: [
                                TextSpan(text: l10n.agreeToTerms),
                                TextSpan(
                                  text: l10n.termsAndPrivacy,
                                  style: context.textTheme.bodySmall
                                      ?.copyWith(
                                        color: context.colors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => context.pushNamed(
                                          RouteNames.nTermsPrivacy,
                                        ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
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

class _Hero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(AppSpacing.xxl),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.seed, AppColors.seed.withValues(alpha: 0.7)],
            ),
            borderRadius: AppRadius.rXxl,
            boxShadow: [
              BoxShadow(
                color: AppColors.seed.withValues(alpha: 0.35),
                blurRadius: 32,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Image.asset(
            AssetPaths.logoIcon,
            width: 64.r,
            height: 64.r,
            errorBuilder: (_, _, _) => Icon(
              Icons.shopping_bag_rounded,
              size: 64.r,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: AppSpacing.vXxl),
        Text(
          context.l10n.welcomeTitle,
          style: context.textTheme.displayLarge,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: AppSpacing.vMd),
        Text(
          context.l10n.welcomeTagline,
          style: context.textTheme.bodyLarge?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
      ],
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
