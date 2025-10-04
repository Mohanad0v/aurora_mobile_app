part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

// Check whether the user is authenticated
class AuthCheckStatus extends AuthEvent {}

// Trigger sign in
class SignInRequested extends AuthEvent {
  final LoginParams loginParams;

  const SignInRequested({required this.loginParams});

  @override
  List<Object?> get props => [loginParams];
}

// Trigger sign up
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

// Fetch the current user's profile
class GetUserProfile extends AuthEvent {}

// Trigger sign out
class SignOutRequested extends AuthEvent {}

// Optional: Token expired detected
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
