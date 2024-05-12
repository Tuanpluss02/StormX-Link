import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../common/enums.dart';
import '../../repositories/auth_repository.dart';
import '../../repositories/url_repository.dart';
import '../../repositories/user_repository.dart';
import '../../utils/shared_pref.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthState.initial()) {
    on<LoginEvent>(_login);
    on<CreateAccountEvent>(_createAccount);
    on<LogoutEvent>(_logout);
    on<ChangeAuthStatusEvent>(_changeAppStatus);
    on<ChangeProcessStatusEvent>(_changeAuthStatus);
    on<AppStartedEvent>(_startedEvent);
  }

  get userRepository => UserRepository();

  get urlRepository => UrlRepository();

  FutureOr<void> _changeAppStatus(
      ChangeAuthStatusEvent event, Emitter<AuthState> emit) {
    emit(state.copyWith(authStatus: event.authStatus));
  }

  FutureOr<void> _changeAuthStatus(
      ChangeProcessStatusEvent event, Emitter<AuthState> emit) {
    emit(state.copyWith(processStatus: event.processStatus));
  }

  Future<void> _createAccount(
      CreateAccountEvent event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(processStatus: ProcessStatus.loading));
      final response = await AuthRepository().createAccount(
        event.username,
        event.password,
      );
      if (response.statusCode == 200) {
        final token = response.data['data']['accessToken'] as String;
        setAccessToken(token);
        emit(state.copyWith(processStatus: ProcessStatus.success));
      } else {
        emit(state.copyWith(
            processStatus: ProcessStatus.failure,
            errorMessage: response.data['message']));
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          processStatus: ProcessStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _login(LoginEvent event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(processStatus: ProcessStatus.loading));
      final response = await AuthRepository().login(
        event.username,
        event.password,
      );
      if (response.statusCode == 200) {
        final token = response.data['data']['accessToken'] as String;
        setAccessToken(token);
        emit(state.copyWith(
            processStatus: ProcessStatus.success,
            authStatus: AuthStatus.authenticated));
      } else {
        emit(state.copyWith(
            processStatus: ProcessStatus.failure,
            errorMessage: response.data['message']));
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          processStatus: ProcessStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _startedEvent(
      AppStartedEvent event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(processStatus: ProcessStatus.loading));
      final isLoggedIn = await AuthRepository().checkUserLoggedIn();
      debugPrint('isLoggedIn: $isLoggedIn');
      if (isLoggedIn) {
        emit(state.copyWith(authStatus: AuthStatus.authenticated));
        debugPrint('authStatus: ${state.authStatus}');
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          processStatus: ProcessStatus.failure, errorMessage: e.toString()));
    } finally {
      emit(state.copyWith(processStatus: ProcessStatus.initial));
    }
  }

  Future<void> _logout(LogoutEvent event, Emitter<AuthState> emit) async {
    await userRepository.logout();
    emit(state.copyWith(
        processStatus: ProcessStatus.initial,
        authStatus: AuthStatus.unauthenticated));
  }
}
