import 'package:injectable/injectable.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/promo_code_entity.dart';

/// Mocked promo validation with a hardcoded code map + simulated delay.
/// Unknown codes throw [ValidationException] to exercise the invalid-code UI.
abstract class PromoDataSource {
  Future<PromoCodeEntity> validate(String code);
}

@LazySingleton(as: PromoDataSource)
class PromoDataSourceImpl implements PromoDataSource {
  static const Map<String, double> _codes = {
    'SAVE10': 10,
    'WELCOME20': 20,
  };

  @override
  Future<PromoCodeEntity> validate(String code) async {
    await Future<void>.delayed(AppConstants.mockShortDelay);
    final normalized = code.trim().toUpperCase();
    final discount = _codes[normalized];
    if (discount == null) {
      throw const ValidationException('Invalid promo code');
    }
    return PromoCodeEntity(code: normalized, discountPercent: discount);
  }
}
