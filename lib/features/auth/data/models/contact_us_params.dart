// lib/features/contact_us/data/models/contact_us_params.dart
class ContactUsParams {
  final String name;
  final String email;
  final String message;
  final String phone;

  ContactUsParams({
    required this.name,
    required this.email,
    required this.message,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'message': message,
    };
  }
}
