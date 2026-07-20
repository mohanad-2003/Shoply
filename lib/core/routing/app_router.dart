import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/create_new_password_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/otp_verification_page.dart';
import '../../features/auth/presentation/pages/password_reset_success_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/terms_privacy_page.dart';
import '../../features/auth/presentation/pages/welcome_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/language_select/presentation/pages/language_select_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/product/presentation/pages/product_details_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../di/injection.dart';
import '../widgets/coming_soon_page.dart';
import 'route_names.dart';

/// Central go_router configuration. Splash is the initial route and decides the
/// real destination; auth guarding is intentionally minimal in Phase 1 because
/// Home is meant to be browsable.
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    routes: [
      GoRoute(
        path: RouteNames.splash,
        name: RouteNames.nSplash,
        builder: (_, _) => const SplashPage(),
      ),
      GoRoute(
        path: RouteNames.languageSelect,
        name: RouteNames.nLanguageSelect,
        pageBuilder: (_, state) => _fade(state, const LanguageSelectPage()),
      ),
      GoRoute(
        path: RouteNames.onboarding,
        name: RouteNames.nOnboarding,
        pageBuilder: (_, state) => _fade(state, const OnboardingPage()),
      ),
      GoRoute(
        path: RouteNames.welcome,
        name: RouteNames.nWelcome,
        pageBuilder: (_, state) => _fade(state, const WelcomePage()),
      ),
      GoRoute(
        path: RouteNames.login,
        name: RouteNames.nLogin,
        pageBuilder: (_, state) => _fade(state, const LoginPage()),
      ),
      GoRoute(
        path: RouteNames.register,
        name: RouteNames.nRegister,
        pageBuilder: (_, state) => _slide(state, const RegisterPage()),
      ),
      GoRoute(
        path: RouteNames.termsPrivacy,
        name: RouteNames.nTermsPrivacy,
        pageBuilder: (_, state) => _slide(state, const TermsPrivacyPage()),
      ),

      // Password-reset chain shares a single AuthBloc so pendingEmail /
      // resetToken persist across ForgotPassword → OTP → CreateNewPassword.
      ShellRoute(
        builder: (_, _, child) => BlocProvider(
          create: (_) => sl<AuthBloc>(),
          child: child,
        ),
        routes: [
          GoRoute(
            path: RouteNames.forgotPassword,
            name: RouteNames.nForgotPassword,
            pageBuilder: (_, state) =>
                _slide(state, const ForgotPasswordPage()),
          ),
          GoRoute(
            path: RouteNames.otpVerification,
            name: RouteNames.nOtpVerification,
            pageBuilder: (_, state) =>
                _slide(state, const OtpVerificationPage()),
          ),
          GoRoute(
            path: RouteNames.createNewPassword,
            name: RouteNames.nCreateNewPassword,
            pageBuilder: (_, state) =>
                _slide(state, const CreateNewPasswordPage()),
          ),
          GoRoute(
            path: RouteNames.passwordResetSuccess,
            name: RouteNames.nPasswordResetSuccess,
            pageBuilder: (_, state) =>
                _slide(state, const PasswordResetSuccessPage()),
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.home,
        name: RouteNames.nHome,
        pageBuilder: (_, state) => _fade(state, const HomePage()),
      ),
      GoRoute(
        path: RouteNames.product,
        name: RouteNames.nProduct,
        pageBuilder: (_, state) => _slide(
          state,
          ProductDetailsPage(productId: state.pathParameters['id'] ?? ''),
        ),
      ),
      GoRoute(
        path: RouteNames.cart,
        name: RouteNames.nCart,
        pageBuilder: (_, state) => _slide(state, const CartPage()),
      ),

      // Reserved routes — placeholder pages until later phases.
      _reserved(RouteNames.wishlist, RouteNames.nWishlist),
      _reserved(RouteNames.checkout, RouteNames.nCheckout),
      _reserved(RouteNames.orders, RouteNames.nOrders),
      _reserved(RouteNames.profile, RouteNames.nProfile),
      _reserved(RouteNames.notifications, RouteNames.nNotifications),
      _reserved(RouteNames.settings, RouteNames.nSettings),
      _reserved(RouteNames.search, RouteNames.nSearch),
    ],
    errorBuilder: (_, _) => const ComingSoonPage(),
  );

  static GoRoute _reserved(String path, String name) => GoRoute(
        path: path,
        name: name,
        builder: (_, _) => const ComingSoonPage(),
      );

  static CustomTransitionPage<void> _fade(
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 350),
      transitionsBuilder: (_, animation, _, child) =>
          FadeTransition(opacity: animation, child: child),
    );
  }

  static CustomTransitionPage<void> _slide(
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 320),
      transitionsBuilder: (_, animation, _, child) {
        final offset = Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        );
        return SlideTransition(position: offset, child: child);
      },
    );
  }
}
