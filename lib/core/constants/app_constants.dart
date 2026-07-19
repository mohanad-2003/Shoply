/// App-wide constants that are not tied to a specific feature.
class AppConstants {
  AppConstants._();

  static const String appName = 'Shoply';

  /// Placeholder base url — unused by the Phase 1 mocks but wired so a real
  /// API is a drop-in swap later.
  static const String baseUrl = 'https://api.shoply.example.com/v1';

  static const Duration connectTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 20);

  // Hive box names.
  static const String cartBox = 'cart_box';
  static const String favoritesBox = 'favorites_box';
  static const String userBox = 'user_box';

  // SharedPreferences keys.
  static const String prefThemeMode = 'pref_theme_mode';
  static const String prefLocale = 'pref_locale';
  static const String prefOnboardingSeen = 'pref_onboarding_seen';

  // Secure storage keys.
  static const String secureAuthToken = 'secure_auth_token';

  // Simulated latency for mock datasources.
  static const Duration mockDelay = Duration(milliseconds: 1200);
  static const Duration mockShortDelay = Duration(milliseconds: 800);

  /// Reserved input that deterministically triggers a failure in mock
  /// datasources so error/retry states are reachable without a backend.
  static const String reservedExistingEmail = 'existing@shoply.com';
  static const String reservedFailEmail = 'fail@shoply.com';
  static const String unknownProductId = 'unknown';
}
