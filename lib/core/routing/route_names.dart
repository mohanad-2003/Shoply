/// Centralised route paths + names. Reserved paths for later phases are
/// declared so features slot in without router rework.
class RouteNames {
  RouteNames._();

  // Implemented in Phase 1.
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String product = '/product/:id';
  static const String cart = '/cart';

  static String productPath(String id) => '/product/$id';

  // Reserved for later phases (placeholder "coming soon" pages).
  static const String wishlist = '/wishlist';
  static const String checkout = '/checkout';
  static const String orders = '/orders';
  static const String profile = '/profile';
  static const String notifications = '/notifications';
  static const String settings = '/settings';
  static const String search = '/search';

  // Route names (used for context.goNamed).
  static const String nSplash = 'splash';
  static const String nOnboarding = 'onboarding';
  static const String nLogin = 'login';
  static const String nRegister = 'register';
  static const String nForgotPassword = 'forgotPassword';
  static const String nHome = 'home';
  static const String nProduct = 'product';
  static const String nCart = 'cart';
  static const String nWishlist = 'wishlist';
  static const String nCheckout = 'checkout';
  static const String nOrders = 'orders';
  static const String nProfile = 'profile';
  static const String nNotifications = 'notifications';
  static const String nSettings = 'settings';
  static const String nSearch = 'search';
}
