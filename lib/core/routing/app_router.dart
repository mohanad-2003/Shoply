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
import '../../features/cart/domain/entities/promo_code_entity.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/catalog/presentation/pages/catalog_page.dart';
import '../../features/catalog/presentation/pages/search_page.dart';
import '../../features/checkout/presentation/pages/checkout_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/language_select/presentation/pages/language_select_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/product/presentation/pages/product_details_page.dart';
import '../../features/auth/domain/entities/user_entity.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/profile/presentation/pages/payment_methods_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/saved_addresses_page.dart';
import '../../features/profile/presentation/pages/security_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/wishlist/presentation/pages/wishlist_page.dart';
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
      GoRoute(
        path: RouteNames.catalog,
        name: RouteNames.nCatalog,
        pageBuilder: (_, state) {
          final args = state.extra as CatalogArgs?;
          return _slide(
            state,
            CatalogPage(
              title: args?.title ?? '',
              categoryId: args?.categoryId,
            ),
          );
        },
      ),
      GoRoute(
        path: RouteNames.search,
        name: RouteNames.nSearch,
        pageBuilder: (_, state) => _fade(state, const SearchPage()),
      ),

      GoRoute(
        path: RouteNames.wishlist,
        name: RouteNames.nWishlist,
        pageBuilder: (_, state) => _fade(state, const WishlistPage()),
      ),
      GoRoute(
        path: RouteNames.profile,
        name: RouteNames.nProfile,
        pageBuilder: (_, state) => _fade(state, const ProfilePage()),
      ),
      GoRoute(
        path: RouteNames.editProfile,
        name: RouteNames.nEditProfile,
        pageBuilder: (_, state) => _slide(
          state,
          EditProfilePage(user: state.extra as UserEntity?),
        ),
      ),
      GoRoute(
        path: RouteNames.savedAddresses,
        name: RouteNames.nSavedAddresses,
        pageBuilder: (_, state) => _slide(state, const SavedAddressesPage()),
      ),
      GoRoute(
        path: RouteNames.paymentMethods,
        name: RouteNames.nPaymentMethods,
        pageBuilder: (_, state) => _slide(state, const PaymentMethodsPage()),
      ),
      GoRoute(
        path: RouteNames.security,
        name: RouteNames.nSecurity,
        pageBuilder: (_, state) => _slide(state, const SecurityPage()),
      ),

      GoRoute(
        path: RouteNames.checkout,
        name: RouteNames.nCheckout,
        pageBuilder: (_, state) => _slide(
          state,
          CheckoutPage(promo: state.extra as PromoCodeEntity?),
        ),
      ),

      // Reserved routes — placeholder pages until later phases.
      _reserved(RouteNames.orders, RouteNames.nOrders),
      _reserved(RouteNames.notifications, RouteNames.nNotifications),
      _reserved(RouteNames.settings, RouteNames.nSettings),
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
