import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

/// Holds the active [Locale] and persists it. Flutter auto-applies RTL for
/// Arabic. Supported locales are English and Arabic in Phase 1.
@lazySingleton
class LocaleCubit extends Cubit<Locale> {
  LocaleCubit(this._prefs) : super(_read(_prefs));

  final SharedPreferences _prefs;

  static const supportedLocales = [Locale('en'), Locale('ar')];

  static Locale _read(SharedPreferences prefs) {
    final code = prefs.getString(AppConstants.prefLocale);
    if (code == 'ar') return const Locale('ar');
    return const Locale('en');
  }

  Future<void> setLocale(Locale locale) async {
    if (locale.languageCode == state.languageCode) return;
    emit(locale);
    await _prefs.setString(AppConstants.prefLocale, locale.languageCode);
  }

  Future<void> toggle() async {
    final next =
        state.languageCode == 'ar' ? const Locale('en') : const Locale('ar');
    await setLocale(next);
  }

  bool get isArabic => state.languageCode == 'ar';
}
