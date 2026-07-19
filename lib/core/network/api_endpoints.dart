/// Placeholder endpoint paths. Inert in Phase 1 (mocks drive everything) but
/// declared so a real `ApiService` slots in without touching call sites.
class ApiEndpoints {
  ApiEndpoints._();

  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';

  static const String categories = '/categories';
  static const String banners = '/banners';
  static const String products = '/products';
  static String productDetails(String id) => '/products/$id';
  static String relatedProducts(String id) => '/products/$id/related';

  static const String cart = '/cart';
  static const String promo = '/cart/promo';
}
