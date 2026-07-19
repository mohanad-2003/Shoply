import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  const CartItemEntity({
    required this.id,
    required this.productId,
    required this.name,
    required this.imagePath,
    required this.price,
    required this.quantity,
    this.color,
    this.size,
  });

  /// Unique per product + variant combination.
  final String id;
  final String productId;
  final String name;
  final String imagePath;
  final double price;
  final int quantity;
  final String? color;
  final String? size;

  double get lineTotal => price * quantity;

  CartItemEntity copyWith({int? quantity}) => CartItemEntity(
        id: id,
        productId: productId,
        name: name,
        imagePath: imagePath,
        price: price,
        quantity: quantity ?? this.quantity,
        color: color,
        size: size,
      );

  @override
  List<Object?> get props =>
      [id, productId, name, imagePath, price, quantity, color, size];
}
