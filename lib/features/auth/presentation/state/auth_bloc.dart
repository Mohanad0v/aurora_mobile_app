import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/injection/injection.dart';
import '../../../../core/navigation/Routes.dart';
import '../../../../core/navigation/navigation_service.dart';
import '../../data/models/login_params.dart';
import '../../data/models/contact_us_params.dart';
import '../../data/models/user_model.dart';
import '../../data/repo/auth_repo_impl.dart';
import '../../data/models/user_profile_model.dart';
import '../../domain/entites/user_enntity.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepositoryImpl authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AuthCheckStatus>(_onCheckStatus);
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<GetUserProfile>(_onGetUserProfile);
    on<SignOutRequested>(_onSignOutRequested);
    on<SubmitContactForm>(_onSubmitContactForm);
  }

  // ------------------- SIGN IN -------------------
  Future<void> _onSignInRequested(
      SignInRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    final result = await authRepository.signIn(loginParams: event.loginParams);

    result.fold(
          (failure) => emit(AuthFailure(message: failure.message)),
          (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  // ------------------- SIGN UP -------------------
  Future<void> _onSignUpRequested(
      SignUpRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    final result = await authRepository.signUp(
      name: event.name,
      email: event.email,
      password: event.password,
    );

    result.fold(
          (failure) => emit(AuthFailure(message: failure.message)),
          (user) async {
        try {
          // Fetch full profile to populate missing fields (like id)
          final profileResult = await authRepository.getUserProfile();
          profileResult.fold(
                (_) => emit(AuthAuthenticated(user: user)), // fallback
                (profile) {
              final fullUser = UserModel(
                id: profile.id,
                name: profile.name,
                email: profile.email,
                roles: user.roles,
                token: user.token!,
              );
              emit(AuthAuthenticated(user: fullUser));
            },
          );
        } catch (_) {
          // In case profile fetch fails, still emit basic user
          emit(AuthAuthenticated(user: user));
        }
      },
    );
  }
  // ------------------- CHECK AUTH STATUS -------------------
  Future<void> _onCheckStatus(
      AuthCheckStatus event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    final statusResult = await authRepository.checkAuthStatus();

    if (statusResult.isLeft()) {
      emit(AuthUnauthenticated());
      return;
    }

    final isAuthenticated = statusResult.getOrElse(() => false);
    if (!isAuthenticated) {
      emit(AuthUnauthenticated());
      return;
    }

    final profileResult = await authRepository.getUserProfile();
    profileResult.fold(
          (_) async {
        await authRepository.signOut();
        emit(AuthUnauthenticated());
      },
          (profile) => emit(AuthProfileLoaded(profile: profile)),
    );
  }

  // ------------------- GET USER PROFILE -------------------
  Future<void> _onGetUserProfile(
      GetUserProfile event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    final result = await authRepository.getUserProfile();

    result.fold(
          (_) => emit(AuthUnauthenticated()),
          (profile) => emit(AuthProfileLoaded(profile: profile)),
    );
  }

  // ------------------- SIGN OUT -------------------
  // ------------------- SIGN OUT -------------------
  Future<void> _onSignOutRequested(
      SignOutRequested event,
      Emitter<AuthState> emit,
      ) async {
    await authRepository.signOut();

    // Emit unauthenticated state (optional)
    emit(AuthUnauthenticated());

    // Restart the app at the login screen
    locator<NavigationService>()
        .pushNamedAndRemoveUntil(Routes.auth);
  }
  // ------------------- SUBMIT CONTACT FORM -------------------
  Future<void> _onSubmitContactForm(
      SubmitContactForm event,
      Emitter<AuthState> emit,
      ) async {
    emit(ContactFormLoading());

    final params = ContactUsParams(
      name: event.name,
      email: event.email,
      phone: event.phone ?? '',
      message: event.message,
    );

    final result = await authRepository.submitContact(params: params);

    result.fold(
          (failure) => emit(ContactFormFailure(message: failure.message)),
          (_) => emit(ContactFormSuccess()),
    );
  }
}
