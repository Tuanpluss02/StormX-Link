part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
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
