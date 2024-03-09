part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final ProcessStatus processStatus;
  final AuthStatus authStatus;
  final String? errorMessage;

  const AuthState({
    this.authStatus = AuthStatus.unauthenticated,
    this.processStatus = ProcessStatus.initial,
    this.errorMessage,
  });
  factory AuthState.initial() => const AuthState(
      authStatus: AuthStatus.unauthenticated,
      processStatus: ProcessStatus.initial);

  @override
  List<Object> get props => [processStatus];

  AuthState copyWith({
    AuthStatus? authStatus,
    ProcessStatus? processStatus,
    String? errorMessage,
  }) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
      processStatus: processStatus ?? this.processStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
