import 'package:flutter/material.dart';

import '../localization/l10n/app_localizations.dart';

extension ContextX on BuildContext {
  /// Localized strings: `context.l10n.login`.
  AppLocalizations get l10n => AppLocalizations.of(this);

  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;

  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  bool get isRtl => Directionality.of(this) == TextDirection.rtl;

  Size get screenSize => MediaQuery.sizeOf(this);
  EdgeInsets get viewPadding => MediaQuery.viewPaddingOf(this);

  void hideKeyboard() => FocusScope.of(this).unfocus();
}
