import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';
import '../network/dio_client.dart';

/// Provides third-party singletons that can't be constructed via `@injectable`
/// annotations directly (external packages / async initialisation).
@module
abstract class RegisterModule {
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @lazySingleton
  InternetConnection get internetConnection => InternetConnection();

  /// Shared Dio instance derived from the configured [DioClient].
  @lazySingleton
  Dio dio(DioClient client) => client.dio;

  @Named(AppConstants.cartBox)
  @preResolve
  Future<Box> get cartBox => Hive.openBox(AppConstants.cartBox);

  @Named(AppConstants.favoritesBox)
  @preResolve
  Future<Box> get favoritesBox => Hive.openBox(AppConstants.favoritesBox);

  @Named(AppConstants.userBox)
  @preResolve
  Future<Box> get userBox => Hive.openBox(AppConstants.userBox);
}
