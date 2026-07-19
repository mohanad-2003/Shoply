import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';

/// Hive-backed favorite product ids. Shared: written from Product Details,
/// read by Home's ProductCard so the heart icon works everywhere.
abstract class FavoritesLocalDataSource {
  Set<String> getFavoriteIds();
  bool isFavorite(String id);
  Future<bool> toggle(String id);
}

@LazySingleton(as: FavoritesLocalDataSource)
class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  FavoritesLocalDataSourceImpl(
    @Named(AppConstants.favoritesBox) this._box,
  );

  final Box _box;

  @override
  Set<String> getFavoriteIds() {
    try {
      return _box.keys.map((e) => e.toString()).toSet();
    } catch (_) {
      throw const CacheException('Failed to read favorites');
    }
  }

  @override
  bool isFavorite(String id) => _box.containsKey(id);

  @override
  Future<bool> toggle(String id) async {
    try {
      if (_box.containsKey(id)) {
        await _box.delete(id);
        return false;
      }
      await _box.put(id, true);
      return true;
    } catch (_) {
      throw const CacheException('Failed to update favorites');
    }
  }
}
