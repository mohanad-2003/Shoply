import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/localization/locale_cubit.dart';

/// Thin cubit for the first-launch language gate. Tracks the tentative
/// selection (applied live so the UI mirrors RTL immediately) and persists the
/// "language chosen" flag on confirm. Delegates locale storage to
/// [LocaleCubit].
@injectable
class LanguageSelectCubit extends Cubit<Locale> {
  LanguageSelectCubit(this._localeCubit, this._prefs)
      : super(_localeCubit.state);

  final LocaleCubit _localeCubit;
  final SharedPreferences _prefs;

  /// Applies the chosen locale live and updates the highlighted card.
  Future<void> select(Locale locale) async {
    emit(locale);
    await _localeCubit.setLocale(locale);
  }

  /// Marks the first-launch language gate as satisfied.
  Future<void> confirm() async {
    await _prefs.setBool(AppConstants.prefLanguageSelected, true);
  }
}
