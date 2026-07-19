/// Centralised references to bundled image assets.
///
/// Only assets declared in `pubspec.yaml` are referenced here. There is no
/// backend, so these are given semantic meaning by the mock-data layer.
class AssetPaths {
  AssetPaths._();

  static const String _base = 'assets';

  // Branding / decorative.
  static const String logo = '$_base/app.png';
  static const String logoIcon = '$_base/icon.png';
  static const String vector = '$_base/vector.png';
  static const String hero = '$_base/main.png';
  static const String heroAlt = '$_base/image.png';
  static const String shopping = '$_base/shope1.png';
  static const String sale = '$_base/sales.png';
  static const String order = '$_base/order.png';
  static const String hand = '$_base/hand.png';
  static const String check = '$_base/check.png';
  static const String star = '$_base/star.png';
  static const String profile = '$_base/profile.png';

  // Onboarding illustrations.
  static const List<String> onboarding = [hero, sale, order];

  // Category icons.
  static const String catMen = '$_base/mens.png';
  static const String catWomen = '$_base/womens.png';
  static const String catKids = '$_base/kids.png';
  static const String catBeauty = '$_base/beauty.png';
  static const String catFashion = '$_base/fashion.png';
  static const String catGifts = '$_base/grifts.png';

  // Social login icons.
  static const String socialFacebook = '$_base/facebook.png';
  static const String socialApple = '$_base/apple.png';
  static const String socialGoogle = '$_base/google.png';

  // Payment icons.
  static const String payVisa = '$_base/visa.png';
  static const String payPaypal = '$_base/paypal.png';
  static const String payMaestro = '$_base/maestro.png';

  // Product photography.
  static const List<String> products = [
    '$_base/p1.png',
    '$_base/p2.png',
    '$_base/p3.png',
    '$_base/p4.png',
    '$_base/p5.png',
    '$_base/p6.png',
    '$_base/p7.png',
    '$_base/p8.png',
    '$_base/p9.png',
    '$_base/p10.png',
    '$_base/p11.png',
    '$_base/p12.png',
    '$_base/p13.png',
    '$_base/p14.png',
  ];

  // Shoe photography (used for gallery / related products).
  static const List<String> shoes = [
    '$_base/sh1.png',
    '$_base/sh2.png',
    '$_base/sh3.png',
    '$_base/sh4.png',
    '$_base/sh5.png',
    '$_base/nike1.png',
    '$_base/nike2.png',
    '$_base/nike3.png',
    '$_base/nike4.png',
  ];

  // Banner artwork.
  static const List<String> banners = [
    '$_base/main.png',
    '$_base/sales.png',
    '$_base/shope1.png',
  ];
}
