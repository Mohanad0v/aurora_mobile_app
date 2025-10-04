part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

// Initial state
class AuthInitial extends AuthState {}

// Loading state for async operations
class AuthLoading extends AuthState {}

// State when user is authenticated (UserEntity with token)
class AuthAuthenticated extends AuthState {
  final UserEntity user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

// State when user profile is loaded (UserProfile)
class AuthProfileLoaded extends AuthState {
  final UserProfile profile;

  const AuthProfileLoaded({required this.profile});

  @override
  List<Object?> get props => [profile];
}

// State when user is not authenticated
class AuthUnauthenticated extends AuthState {}

// State for general failures
class AuthFailure extends AuthState {
  final String message;

  const AuthFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

// Optional: Token expired / 401 detected
class AuthTokenExpired extends AuthState {}
// 📩 Contact Form States
class ContactFormLoading extends AuthState {}
class ContactFormSuccess extends AuthState {}
class ContactFormFailure extends AuthState {
  final String message;
  const ContactFormFailure({required this.message});
}
