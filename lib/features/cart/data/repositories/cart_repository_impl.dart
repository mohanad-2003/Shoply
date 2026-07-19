import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exception_mapper.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/entities/promo_code_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_datasource.dart';
import '../datasources/promo_datasource.dart';
import '../models/cart_item_model.dart';

@LazySingleton(as: CartRepository)
class CartRepositoryImpl implements CartRepository {
  CartRepositoryImpl(this._local, this._promo);

  final CartLocalDataSource _local;
  final PromoDataSource _promo;

  @override
  Future<Either<Failure, List<CartItemEntity>>> getItems() async {
    try {
      final items = await _local.getItems();
      return Right(items.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> addItem(CartItemEntity item) async {
    try {
      await _local.addItem(CartItemModel.fromEntity(item));
      return const Right(unit);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateQuantity(
    String itemId,
    int quantity,
  ) async {
    try {
      await _local.updateQuantity(itemId, quantity);
      return const Right(unit);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeItem(String itemId) async {
    try {
      await _local.removeItem(itemId);
      return const Right(unit);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, PromoCodeEntity>> applyPromo(String code) async {
    try {
      return Right(await _promo.validate(code));
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}
