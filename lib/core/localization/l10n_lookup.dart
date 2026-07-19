import 'package:flutter/widgets.dart';

import '../extensions/context_extensions.dart';
import 'l10n/app_localizations.dart';

/// Resolves a stable string key (from failures / validators / onboarding
/// entities) to its localized value. Keeps copy in the ARB files while letting
/// non-widget layers pass keys around.
String tr(BuildContext context, String key) => _lookup(context.l10n, key);

String _lookup(AppLocalizations l, String key) {
  switch (key) {
    // Validation.
    case 'fieldRequired':
      return l.fieldRequired;
    case 'invalidEmail':
      return l.invalidEmail;
    case 'passwordTooShort':
      return l.passwordTooShort;
    case 'passwordsDoNotMatch':
      return l.passwordsDoNotMatch;
    case 'nameTooShort':
      return l.nameTooShort;
    // Failures.
    case 'serverError':
      return l.serverError;
    case 'cacheError':
      return l.cacheError;
    case 'noConnection':
      return l.noConnection;
    case 'somethingWentWrong':
      return l.somethingWentWrong;
    case 'unexpectedError':
      return l.unexpectedError;
    // Onboarding.
    case 'onboardingTitle1':
      return l.onboardingTitle1;
    case 'onboardingBody1':
      return l.onboardingBody1;
    case 'onboardingTitle2':
      return l.onboardingTitle2;
    case 'onboardingBody2':
      return l.onboardingBody2;
    case 'onboardingTitle3':
      return l.onboardingTitle3;
    case 'onboardingBody3':
      return l.onboardingBody3;
    default:
      return l.somethingWentWrong;
  }
}
