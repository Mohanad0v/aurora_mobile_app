class UserProfile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final bool profileCompleted;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.profileCompleted,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['_id']?.toString() ?? '',           // fallback if null
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      profileCompleted: json['profileCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profileCompleted': profileCompleted,
    };
  }
}
