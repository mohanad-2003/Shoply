import 'package:equatable/equatable.dart';

class PromoCodeEntity extends Equatable {
  const PromoCodeEntity({
    required this.code,
    required this.discountPercent,
  });

  final String code;
  final double discountPercent;

  @override
  List<Object?> get props => [code, discountPercent];
}
