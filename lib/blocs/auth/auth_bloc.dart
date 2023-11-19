import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../common/enums.dart';
import '../../repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthState.initial()) {
    on<LoginEvent>(_login);
    on<CreateAccountEvent>(_createAccount);
    on<LogoutEvent>(_logout);
    on<ChangeAppStatusEvent>(_changeAppStatus);
    on<ChangeAuthStatusEvent>(_changeAuthStatus);
  }

  FutureOr<void> _changeAppStatus(
      ChangeAppStatusEvent event, Emitter<AuthState> emit) {
    emit(state.copyWith(appStatus: event.appStatus));
  }

  FutureOr<void> _changeAuthStatus(
      ChangeAuthStatusEvent event, Emitter<AuthState> emit) {
    emit(state.copyWith(authStatus: event.authStatus));
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
        emit(state.copyWith(authStatus: AuthStatus.success));
      } else {
        emit(state.copyWith(
            authStatus: AuthStatus.failure,
            errorMessage: response.data['message']));
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          authStatus: AuthStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _login(LoginEvent event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(authStatus: AuthStatus.loading));
      final response = await AuthRepository().login(
        event.username,
        event.password,
      );
      if (response.statusCode == 200) {
        emit(state.copyWith(authStatus: AuthStatus.success));
      } else {
        emit(state.copyWith(
            authStatus: AuthStatus.failure,
            errorMessage: response.data['message']));
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          authStatus: AuthStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _logout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(authStatus: AuthStatus.initial));
  }
}
