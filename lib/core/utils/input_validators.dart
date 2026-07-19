/// Pure validation helpers returning a stable l10n key on failure, or null on
/// success. The presentation layer resolves keys to localized copy.
class InputValidators {
  InputValidators._();

  static final RegExp _emailRegex =
      RegExp(r'^[\w.\-+]+@([\w\-]+\.)+[\w\-]{2,}$');

  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'fieldRequired';
    if (!_emailRegex.hasMatch(v)) return 'invalidEmail';
    return null;
  }

  static String? password(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'fieldRequired';
    if (v.length < 6) return 'passwordTooShort';
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    final v = value ?? '';
    if (v.isEmpty) return 'fieldRequired';
    if (v != original) return 'passwordsDoNotMatch';
    return null;
  }

  static String? name(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'fieldRequired';
    if (v.length < 2) return 'nameTooShort';
    return null;
  }

  static String? required(String? value) {
    if ((value?.trim() ?? '').isEmpty) return 'fieldRequired';
    return null;
  }
}
