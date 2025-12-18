part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({required this.email, required this.password});
  @override
  List<Object> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String username;
  final String fullName;

  const AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.username,
    required this.fullName,
  });
  @override
  List<Object> get props => [email, password, username, fullName];
}

class AuthCheckRequested extends AuthEvent {}

class AuthLogoutRequested extends AuthEvent {}

class AuthGoogleLoginRequested extends AuthEvent {
  final String email;
  final String firstName;
  final String lastName;
  final String profilePic;

  const AuthGoogleLoginRequested({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.profilePic,
  });

  @override
  List<Object> get props => [email, firstName, lastName, profilePic];
}


