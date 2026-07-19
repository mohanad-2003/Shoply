import 'package:injectable/injectable.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/asset_paths.dart';
import '../../../../core/mock/mock_catalog.dart';
import '../../domain/entities/banner_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/home_data_entity.dart';

/// Mocked home backend. Builds the home payload from the shared [MockCatalog]
/// with a simulated delay. A real datasource would deserialize JSON models.
abstract class HomeRemoteDataSource {
  Future<HomeDataEntity> getHomeData();
}

@LazySingleton(as: HomeRemoteDataSource)
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  @override
  Future<HomeDataEntity> getHomeData() async {
    await Future<void>.delayed(AppConstants.mockDelay);

    final products = MockCatalog.products;

    return HomeDataEntity(
      banners: _banners,
      categories: _categories,
      featured: products.take(6).toList(),
      flashSale: products.where((p) => p.hasDiscount).take(6).toList(),
      newArrivals: products.reversed.take(6).toList(),
      bestSellers: [...products]
          .where((p) => p.rating >= 4.5)
          .take(6)
          .toList(),
    );
  }

  static const List<CategoryEntity> _categories = [
    CategoryEntity(id: 'men', name: 'Men', iconPath: AssetPaths.catMen),
    CategoryEntity(id: 'women', name: 'Women', iconPath: AssetPaths.catWomen),
    CategoryEntity(id: 'kids', name: 'Kids', iconPath: AssetPaths.catKids),
    CategoryEntity(
        id: 'beauty', name: 'Beauty', iconPath: AssetPaths.catBeauty),
    CategoryEntity(
        id: 'fashion', name: 'Fashion', iconPath: AssetPaths.catFashion),
    CategoryEntity(id: 'gifts', name: 'Gifts', iconPath: AssetPaths.catGifts),
  ];

  static const List<BannerEntity> _banners = [
    BannerEntity(
      id: 'b1',
      title: 'Summer Collection',
      subtitle: 'Up to 50% off selected styles',
      imagePath: AssetPaths.hero,
    ),
    BannerEntity(
      id: 'b2',
      title: 'Flash Sale',
      subtitle: 'Ends soon — grab it fast',
      imagePath: AssetPaths.sale,
    ),
    BannerEntity(
      id: 'b3',
      title: 'New Arrivals',
      subtitle: 'Fresh drops every week',
      imagePath: AssetPaths.shopping,
    ),
  ];
}
