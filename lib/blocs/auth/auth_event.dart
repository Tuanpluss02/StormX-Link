part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class ChangeAppStatusEvent extends AuthEvent {
  final AppStatus appStatus;

  const ChangeAppStatusEvent({
    required this.appStatus,
  });

  @override
  List<Object> get props => [appStatus];
}

class ChangeAuthStatusEvent extends AuthEvent {
  final AuthStatus authStatus;

  const ChangeAuthStatusEvent({
    required this.authStatus,
  });

  @override
  List<Object> get props => [authStatus];
}

class CreateAccountEvent extends AuthEvent {
  final String username;
  final String password;

  const CreateAccountEvent({
    required this.username,
    required this.password,
  });

  @override
  List<Object> get props => [username, password];
}

class LoginEvent extends AuthEvent {
  final String username;
  final String password;

  const LoginEvent({
    required this.username,
    required this.password,
  });

  @override
  List<Object> get props => [username, password];
}

class LogoutEvent extends AuthEvent {}
