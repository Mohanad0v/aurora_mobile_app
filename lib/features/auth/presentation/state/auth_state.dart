part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserEntity user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthProfileLoaded extends AuthState {
  final UserProfile profile;

  const AuthProfileLoaded({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class AuthUnauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthTokenExpired extends AuthState {}
class ContactFormLoading extends AuthState {}
class ContactFormSuccess extends AuthState {}
class ContactFormFailure extends AuthState {
  final String message;
  const ContactFormFailure({required this.message});
}
