import '../utils/app_strings.dart';

abstract final class AuthValidators {
  static String? email(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return AppStrings.emailRequired;
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
      return AppStrings.emailInvalid;
    }
    return null;
  }

  static String? password(String? value) =>
      value == null || value.isEmpty ? AppStrings.passwordRequired : null;

  static String? newPassword(String? value) {
    final required = password(value);
    if (required != null) return required;
    return value!.length < 6 ? AppStrings.passwordWeak : null;
  }

  static String? name(String? value) {
    final name = value?.trim() ?? '';
    return name.isEmpty || name.length > 100 ? AppStrings.nameInvalid : null;
  }

  static String? phone(String? value) {
    final phone = value?.trim() ?? '';
    return !RegExp(r'^\+?[0-9][0-9 ()-]{5,23}$').hasMatch(phone)
        ? AppStrings.phoneInvalid
        : null;
  }
}
