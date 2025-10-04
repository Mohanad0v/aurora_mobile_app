import 'package:easy_localization/easy_localization.dart';

class EmailValidator {
  static String? validate(String email) {
    if (email.isEmpty) return "Email is required".tr();
    final regex = RegExp(r"^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$");
    if (!regex.hasMatch(email.trim())) return "Invalid email format".tr();
    return null;
  }
}

class PhoneValidator {
  static String? validate(String phone) {
    if (phone.isEmpty) return "Phone is required".tr();
    if (!RegExp(r'^[0-9]{8,15}$').hasMatch(phone)) {
      return "Invalid phone number".tr();
    }
    return null;
  }
}
class PasswordValidator {
  static String? validate(String password) {
    if (password.isEmpty) return "Password is required";
    if (password.length < 4) {
      return "Password must be at least 8 characters long";
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return "Password must contain at least one uppercase letter";
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return "Password must contain at least one lowercase letter";
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return "Password must contain at least one digit";
    }
    if (!RegExp(r'[!@#\$&*~%^(),.?":{}|<>]').hasMatch(password)) {
      return "Password must contain at least one special character";
    }
    return null; // ✅ valid
  }
}
