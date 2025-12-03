part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckStatus extends AuthEvent {}

class SignInRequested extends AuthEvent {
  final LoginParams loginParams;

  const SignInRequested({required this.loginParams});

  @override
  List<Object?> get props => [loginParams];
}

class SignUpRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const SignUpRequested({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
}

class GetUserProfile extends AuthEvent {}

class SignOutRequested extends AuthEvent {}

class TokenExpiredDetected extends AuthEvent {}

class SubmitContactForm extends AuthEvent {
  final String name;
  final String email;
  final String? phone;
  final String message;

  const SubmitContactForm({
    required this.name,
    required this.email,
    this.phone,
    required this.message,
  });
}
