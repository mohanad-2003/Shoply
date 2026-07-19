// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:hive/hive.dart' as _i979;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart'
    as _i161;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/auth/data/datasources/auth_local_datasource.dart'
    as _i992;
import '../../features/auth/data/datasources/auth_remote_datasource.dart'
    as _i161;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/forgot_password_usecase.dart'
    as _i560;
import '../../features/auth/domain/usecases/get_cached_user_usecase.dart'
    as _i389;
import '../../features/auth/domain/usecases/login_usecase.dart' as _i188;
import '../../features/auth/domain/usecases/logout_usecase.dart' as _i48;
import '../../features/auth/domain/usecases/register_usecase.dart' as _i941;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../../features/cart/data/datasources/cart_local_datasource.dart'
    as _i339;
import '../../features/cart/data/datasources/promo_datasource.dart' as _i905;
import '../../features/cart/data/repositories/cart_repository_impl.dart'
    as _i642;
import '../../features/cart/domain/repositories/cart_repository.dart' as _i322;
import '../../features/cart/domain/usecases/add_to_cart_usecase.dart' as _i659;
import '../../features/cart/domain/usecases/apply_promo_usecase.dart' as _i759;
import '../../features/cart/domain/usecases/get_cart_usecase.dart' as _i179;
import '../../features/cart/domain/usecases/remove_from_cart_usecase.dart'
    as _i355;
import '../../features/cart/domain/usecases/update_quantity_usecase.dart'
    as _i107;
import '../../features/cart/presentation/bloc/cart_bloc.dart' as _i517;
import '../../features/home/data/datasources/home_remote_datasource.dart'
    as _i278;
import '../../features/home/data/repositories/home_repository_impl.dart'
    as _i76;
import '../../features/home/domain/repositories/home_repository.dart' as _i0;
import '../../features/home/domain/usecases/get_home_data_usecase.dart'
    as _i1033;
import '../../features/home/presentation/bloc/home_bloc.dart' as _i202;
import '../../features/onboarding/presentation/cubit/onboarding_cubit.dart'
    as _i807;
import '../../features/product/data/datasources/favorites_local_datasource.dart'
    as _i10;
import '../../features/product/data/datasources/product_remote_datasource.dart'
    as _i963;
import '../../features/product/data/repositories/favorites_repository_impl.dart'
    as _i981;
import '../../features/product/data/repositories/product_repository_impl.dart'
    as _i1040;
import '../../features/product/domain/repositories/favorites_repository.dart'
    as _i843;
import '../../features/product/domain/repositories/product_repository.dart'
    as _i39;
import '../../features/product/domain/usecases/get_favorite_ids_usecase.dart'
    as _i946;
import '../../features/product/domain/usecases/get_product_details_usecase.dart'
    as _i133;
import '../../features/product/domain/usecases/get_related_products_usecase.dart'
    as _i511;
import '../../features/product/domain/usecases/toggle_favorite_usecase.dart'
    as _i714;
import '../../features/product/presentation/bloc/product_detail_bloc.dart'
    as _i1052;
import '../../features/splash/presentation/cubit/splash_cubit.dart' as _i125;
import '../localization/locale_cubit.dart' as _i960;
import '../network/dio_client.dart' as _i667;
import '../network/interceptors/auth_interceptor.dart' as _i745;
import '../network/network_info.dart' as _i932;
import '../theme/theme_cubit.dart' as _i611;
import 'register_modules.dart' as _i8;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => registerModule.secureStorage,
    );
    gh.lazySingleton<_i161.InternetConnection>(
      () => registerModule.internetConnection,
    );
    gh.lazySingleton<_i963.ProductRemoteDataSource>(
      () => _i963.ProductRemoteDataSourceImpl(),
    );
    await gh.factoryAsync<_i979.Box<dynamic>>(
      () => registerModule.userBox,
      instanceName: 'user_box',
      preResolve: true,
    );
    gh.lazySingleton<_i905.PromoDataSource>(() => _i905.PromoDataSourceImpl());
    await gh.factoryAsync<_i979.Box<dynamic>>(
      () => registerModule.favoritesBox,
      instanceName: 'favorites_box',
      preResolve: true,
    );
    gh.lazySingleton<_i745.AuthInterceptor>(
      () => _i745.AuthInterceptor(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i161.AuthRemoteDataSource>(
      () => _i161.AuthRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i667.DioClient>(
      () => _i667.DioClient(gh<_i745.AuthInterceptor>()),
    );
    gh.lazySingleton<_i278.HomeRemoteDataSource>(
      () => _i278.HomeRemoteDataSourceImpl(),
    );
    await gh.factoryAsync<_i979.Box<dynamic>>(
      () => registerModule.cartBox,
      instanceName: 'cart_box',
      preResolve: true,
    );
    gh.lazySingleton<_i932.NetworkInfo>(
      () => _i932.NetworkInfoImpl(gh<_i161.InternetConnection>()),
    );
    gh.factory<_i807.OnboardingCubit>(
      () => _i807.OnboardingCubit(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i960.LocaleCubit>(
      () => _i960.LocaleCubit(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i611.ThemeCubit>(
      () => _i611.ThemeCubit(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i992.AuthLocalDataSource>(
      () => _i992.AuthLocalDataSourceImpl(
        gh<_i979.Box<dynamic>>(instanceName: 'user_box'),
        gh<_i558.FlutterSecureStorage>(),
      ),
    );
    gh.lazySingleton<_i339.CartLocalDataSource>(
      () => _i339.CartLocalDataSourceImpl(
        gh<_i979.Box<dynamic>>(instanceName: 'cart_box'),
      ),
    );
    gh.factory<_i125.SplashCubit>(
      () => _i125.SplashCubit(
        gh<_i460.SharedPreferences>(),
        gh<_i979.Box<dynamic>>(instanceName: 'user_box'),
      ),
    );
    gh.lazySingleton<_i361.Dio>(
      () => registerModule.dio(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i10.FavoritesLocalDataSource>(
      () => _i10.FavoritesLocalDataSourceImpl(
        gh<_i979.Box<dynamic>>(instanceName: 'favorites_box'),
      ),
    );
    gh.lazySingleton<_i787.AuthRepository>(
      () => _i153.AuthRepositoryImpl(
        gh<_i161.AuthRemoteDataSource>(),
        gh<_i992.AuthLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i843.FavoritesRepository>(
      () => _i981.FavoritesRepositoryImpl(gh<_i10.FavoritesLocalDataSource>()),
    );
    gh.lazySingleton<_i322.CartRepository>(
      () => _i642.CartRepositoryImpl(
        gh<_i339.CartLocalDataSource>(),
        gh<_i905.PromoDataSource>(),
      ),
    );
    gh.lazySingleton<_i39.ProductRepository>(
      () => _i1040.ProductRepositoryImpl(
        gh<_i963.ProductRemoteDataSource>(),
        gh<_i843.FavoritesRepository>(),
      ),
    );
    gh.factory<_i133.GetProductDetailsUseCase>(
      () => _i133.GetProductDetailsUseCase(gh<_i39.ProductRepository>()),
    );
    gh.factory<_i511.GetRelatedProductsUseCase>(
      () => _i511.GetRelatedProductsUseCase(gh<_i39.ProductRepository>()),
    );
    gh.factory<_i946.GetFavoriteIdsUseCase>(
      () => _i946.GetFavoriteIdsUseCase(gh<_i843.FavoritesRepository>()),
    );
    gh.factory<_i714.ToggleFavoriteUseCase>(
      () => _i714.ToggleFavoriteUseCase(gh<_i843.FavoritesRepository>()),
    );
    gh.factory<_i659.AddToCartUseCase>(
      () => _i659.AddToCartUseCase(gh<_i322.CartRepository>()),
    );
    gh.factory<_i759.ApplyPromoUseCase>(
      () => _i759.ApplyPromoUseCase(gh<_i322.CartRepository>()),
    );
    gh.factory<_i179.GetCartUseCase>(
      () => _i179.GetCartUseCase(gh<_i322.CartRepository>()),
    );
    gh.factory<_i355.RemoveFromCartUseCase>(
      () => _i355.RemoveFromCartUseCase(gh<_i322.CartRepository>()),
    );
    gh.factory<_i107.UpdateQuantityUseCase>(
      () => _i107.UpdateQuantityUseCase(gh<_i322.CartRepository>()),
    );
    gh.factory<_i560.ForgotPasswordUseCase>(
      () => _i560.ForgotPasswordUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i389.GetCachedUserUseCase>(
      () => _i389.GetCachedUserUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i188.LoginUseCase>(
      () => _i188.LoginUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i48.LogoutUseCase>(
      () => _i48.LogoutUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i941.RegisterUseCase>(
      () => _i941.RegisterUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i517.CartBloc>(
      () => _i517.CartBloc(
        gh<_i179.GetCartUseCase>(),
        gh<_i107.UpdateQuantityUseCase>(),
        gh<_i355.RemoveFromCartUseCase>(),
        gh<_i759.ApplyPromoUseCase>(),
      ),
    );
    gh.factory<_i797.AuthBloc>(
      () => _i797.AuthBloc(
        gh<_i188.LoginUseCase>(),
        gh<_i941.RegisterUseCase>(),
        gh<_i560.ForgotPasswordUseCase>(),
        gh<_i389.GetCachedUserUseCase>(),
        gh<_i48.LogoutUseCase>(),
      ),
    );
    gh.lazySingleton<_i0.HomeRepository>(
      () => _i76.HomeRepositoryImpl(
        gh<_i278.HomeRemoteDataSource>(),
        gh<_i843.FavoritesRepository>(),
      ),
    );
    gh.factory<_i1033.GetHomeDataUseCase>(
      () => _i1033.GetHomeDataUseCase(gh<_i0.HomeRepository>()),
    );
    gh.factory<_i202.HomeBloc>(
      () => _i202.HomeBloc(
        gh<_i1033.GetHomeDataUseCase>(),
        gh<_i714.ToggleFavoriteUseCase>(),
      ),
    );
    gh.factory<_i1052.ProductDetailBloc>(
      () => _i1052.ProductDetailBloc(
        gh<_i133.GetProductDetailsUseCase>(),
        gh<_i511.GetRelatedProductsUseCase>(),
        gh<_i714.ToggleFavoriteUseCase>(),
        gh<_i659.AddToCartUseCase>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i8.RegisterModule {}
