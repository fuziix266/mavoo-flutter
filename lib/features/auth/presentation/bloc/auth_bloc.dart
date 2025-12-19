import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/social_login_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final CheckAuthStatusUseCase checkAuthStatusUseCase;
  final LogoutUseCase logoutUseCase;
  final SocialLoginUseCase socialLoginUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.checkAuthStatusUseCase,
    required this.logoutUseCase,
    required this.socialLoginUseCase,
  }) : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthGoogleLoginRequested>(_onGoogleLoginRequested);
  }


  Future<void> _onLoginRequested(AuthLoginRequested event, Emitter<AuthState> emit) async {
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

  Future<void> _onRegisterRequested(AuthRegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await registerUseCase(event.email, event.password, event.username, event.fullName);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onCheckRequested(AuthCheckRequested event, Emitter<AuthState> emit) async {
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

  Future<void> _onLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) async {
    await logoutUseCase();
    emit(AuthUnauthenticated());
  }

  Future<void> _onGoogleLoginRequested(AuthGoogleLoginRequested event, Emitter<AuthState> emit) async {
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
      (user) => emit(AuthAuthenticated(user)),
    );
  }


}
