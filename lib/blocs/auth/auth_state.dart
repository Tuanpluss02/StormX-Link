part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final AuthStatus authStatus;
  final AppStatus appStatus;
  final String? errorMessage;

  const AuthState({
    this.appStatus = AppStatus.unknown,
    this.authStatus = AuthStatus.initial,
    this.errorMessage,
  });
  factory AuthState.initial() => const AuthState(
      appStatus: AppStatus.unknown, authStatus: AuthStatus.initial);

  @override
  List<Object> get props => [authStatus];

  AuthState copyWith({
    AppStatus? appStatus,
    AuthStatus? authStatus,
    String? errorMessage,
  }) {
    return AuthState(
      appStatus: appStatus ?? this.appStatus,
      authStatus: authStatus ?? this.authStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
