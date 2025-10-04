import 'package:aurora_app/features/auth/domain/entites/user_enntity.dart';

class LoginParams {
  final String? name;
  final String? password;
  final String? email;
  final String? rememberToken;
  final String? token;
  final String? withExtra;

  LoginParams({required this.email, this.name, this.rememberToken, this.password, this.token, this.withExtra,});

  Map<String, dynamic> toJson() {
    return {'email': email.toString(),
      'name': name,
      'password': password.toString(),
      'token': token,
      'withExtra': withExtra};
  }
}
