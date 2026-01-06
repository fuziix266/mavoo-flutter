part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;
  const AuthAuthenticated(this.user);
  @override
  List<Object> get props => [user];
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object> get props => [message];
}

class AuthUnauthenticated extends AuthState {}

class AuthUserDataMismatch extends AuthState {
  final User user;
  final Map<String, dynamic> newData;

  const AuthUserDataMismatch(this.user, this.newData);

  @override
  List<Object> get props => [user, newData];
}
