import '../../domain/entites/user_enntity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.roles,
    required super.token,
  });

  /// 🏗️ Factory from API JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>? ?? {};

    return UserModel(
      id: user['_id']?.toString() ?? '',       // fallback to empty string
      name: user['name']?.toString() ?? '',
      email: user['email']?.toString() ?? '',
      roles: (user['roles'] as List<dynamic>?)
          ?.map((role) => role.toString())
          .toList() ??
          [],
      token: json['token']?.toString() ?? '',  // ensure token is not null
    );
  }

  /// 🔄 Convert back to JSON (optional)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'roles': roles,
      'token': token,
    };
  }
}
