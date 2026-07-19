import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';

/// Where the splash screen should route to once its checks complete.
enum SplashDestination { onboarding, login, home }

/// Resolves the initial destination: onboarding (first launch) → login
/// (returning, signed out) → home (cached user present). Home is browsable in
/// Phase 1, so auth is not strictly guarded.
@injectable
class SplashCubit extends Cubit<SplashDestination?> {
  SplashCubit(
    this._prefs,
    @Named(AppConstants.userBox) this._userBox,
  ) : super(null);

  final SharedPreferences _prefs;
  final Box _userBox;

  Future<void> decide() async {
    await Future<void>.delayed(const Duration(milliseconds: 1600));

    final seenOnboarding =
        _prefs.getBool(AppConstants.prefOnboardingSeen) ?? false;
    if (!seenOnboarding) {
      emit(SplashDestination.onboarding);
      return;
    }

    final hasCachedUser = _userBox.isNotEmpty;
    emit(hasCachedUser ? SplashDestination.home : SplashDestination.login);
  }
}
