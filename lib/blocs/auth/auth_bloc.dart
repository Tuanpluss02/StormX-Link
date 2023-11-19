import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../common/enums.dart';
import '../../repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthState.initial()) {
    on<LoginEvent>((event, emit) => _login(event, emit));
    on<CreateAccountEvent>((event, emit) => _createAccount(event, emit));
    on<LogoutEvent>((event, emit) => _logout(event, emit));
  }

  Future<void> _createAccount(
      CreateAccountEvent event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(authStatus: AuthStatus.loading));
      final response = await AuthRepository().createAccount(
        event.username,
        event.password,
      );
      if (response.statusCode == 200) {
        emit(state.copyWith(authStatus: AuthStatus.authenticated));
      } else {
        emit(state.copyWith(
            authStatus: AuthStatus.failure,
            errorMessage: response.data['message']));
      }
    } catch (e) {
      emit(state.copyWith(
          authStatus: AuthStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _logout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(authStatus: AuthStatus.unauthenticated));
  }

  Future<void> _login(LoginEvent event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(authStatus: AuthStatus.loading));
      final response = await AuthRepository().login(
        event.username,
        event.password,
      );
      if (response.statusCode == 200) {
        emit(state.copyWith(authStatus: AuthStatus.authenticated));
      } else {
        emit(state.copyWith(
            authStatus: AuthStatus.failure,
            errorMessage: response.data['message']));
      }
    } catch (e) {
      emit(state.copyWith(
          authStatus: AuthStatus.failure, errorMessage: e.toString()));
    }
  }
}
