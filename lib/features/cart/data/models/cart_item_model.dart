import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/cart_item_entity.dart';

part 'cart_item_model.freezed.dart';
part 'cart_item_model.g.dart';

@freezed
abstract class CartItemModel with _$CartItemModel {
  const CartItemModel._();

  const factory CartItemModel({
    required String id,
    required String productId,
    required String name,
    required String imagePath,
    required double price,
    required int quantity,
    String? color,
    String? size,
  }) = _CartItemModel;

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);

  factory CartItemModel.fromEntity(CartItemEntity e) => CartItemModel(
        id: e.id,
        productId: e.productId,
        name: e.name,
        imagePath: e.imagePath,
        price: e.price,
        quantity: e.quantity,
        color: e.color,
        size: e.size,
      );

  CartItemEntity toEntity() => CartItemEntity(
        id: id,
        productId: productId,
        name: name,
        imagePath: imagePath,
        price: price,
        quantity: quantity,
        color: color,
        size: size,
      );
}
