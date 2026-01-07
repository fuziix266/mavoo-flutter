import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/social_login_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final CheckAuthStatusUseCase checkAuthStatusUseCase;
  final LogoutUseCase logoutUseCase;
  final SocialLoginUseCase socialLoginUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.checkAuthStatusUseCase,
    required this.logoutUseCase,
    required this.socialLoginUseCase,
    required this.updateProfileUseCase,
  }) : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthGoogleLoginRequested>(_onGoogleLoginRequested);
    on<AuthSyncProfileConfirmed>(_onSyncProfileConfirmed);
    on<AuthUpdateProfileRequested>(_onUpdateProfileRequested);
  }

  Future<void> _onLoginRequested(
      AuthLoginRequested event, Emitter<AuthState> emit) async {
    print('[AuthBloc] Login requested for: ${event.email}');
    emit(AuthLoading());
    final result = await loginUseCase(event.email, event.password);
    result.fold(
      (failure) {
        print('[AuthBloc] Login failed: ${failure.message}');
        emit(AuthError(failure.message));
      },
      (user) {
        print('[AuthBloc] Login successful! User: ${user.email}');
        emit(AuthAuthenticated(user));
        print('[AuthBloc] AuthAuthenticated state emitted');
      },
    );
  }

  Future<void> _onRegisterRequested(
      AuthRegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await registerUseCase(
        event.email, event.password, event.username, event.fullName);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onCheckRequested(
      AuthCheckRequested event, Emitter<AuthState> emit) async {
    print('[AuthBloc] Checking auth status...');
    final result = await checkAuthStatusUseCase();
    result.fold(
      (failure) {
        print('[AuthBloc] Auth check failed (no user): ${failure.message}');
        emit(AuthUnauthenticated());
      },
      (user) {
        print('[AuthBloc] Auth check successful! User: ${user.email}');
        emit(AuthAuthenticated(user));
      },
    );
  }

  Future<void> _onLogoutRequested(
      AuthLogoutRequested event, Emitter<AuthState> emit) async {
    await logoutUseCase();
    emit(AuthUnauthenticated());
  }

  Future<void> _onGoogleLoginRequested(
      AuthGoogleLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    print('[AuthBloc] Google Login requested for: ${event.email}');

    final userData = {
      'email': event.email,
      'first_name': event.firstName,
      'last_name': event.lastName,
      'profile_pic': event.profilePic,
      'login_type': 'google',
      'platform_type': 'Website',
    };

    final result = await socialLoginUseCase(userData);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) {
        // Check for mismatch (basic logic: if profile pic is different)
        // Note: Real world logic might be more complex
        if (event.profilePic.isNotEmpty &&
            user.profileImage != event.profilePic) {
          emit(AuthUserDataMismatch(user, userData));
        } else {
          emit(AuthAuthenticated(user));
        }
      },
    );
  }

  Future<void> _onSyncProfileConfirmed(
      AuthSyncProfileConfirmed event, Emitter<AuthState> emit) async {
    // This event seems to be about confirming Google data sync, effectively an update.
    // We can reuse update logic or keep it separate.
    // For now assuming it calls update internally or we emit updated state.
    // Let's implement actual update via usecase here too if needed, but standard update is in _onUpdateProfileRequested.

    // Logic from previous code (simulated):
    emit(AuthLoading());
    final updatedUser = User(
      id: event.user.id,
      email: event.user.email,
      username: event.user.username,
      fullName: event.newData['first_name'] + ' ' + event.newData['last_name'],
      profileImage: event.newData['profile_pic'],
      token: event.user.token,
    );
    emit(AuthAuthenticated(updatedUser));
  }

  Future<void> _onUpdateProfileRequested(
      AuthUpdateProfileRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await updateProfileUseCase(event.data);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }
}
