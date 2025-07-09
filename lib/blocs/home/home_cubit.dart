import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../common/enums.dart';
import '../../domain/entities/url_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/url_usecases.dart';
import '../../domain/usecases/user_usecases.dart';

part 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final GetUserInfoUseCase _getUserInfoUseCase;
  final GetUrlsUseCase _getUrlsUseCase;
  final CreateUrlUseCase _createUrlUseCase;
  final UpdateUrlUseCase _updateUrlUseCase;
  final DeleteUrlUseCase _deleteUrlUseCase;

  HomeCubit(
    this._getUserInfoUseCase,
    this._getUrlsUseCase,
    this._createUrlUseCase,
    this._updateUrlUseCase,
    this._deleteUrlUseCase,
  ) : super(HomeState.initial());

  Future<void> getHomeData() async {
    try {
      emit(state.copyWith(getDataState: GetDataState.loading));
      final user = await _getUserInfoUseCase();
      final urls = await _getUrlsUseCase();
      emit(state.copyWith(
          user: user, urls: urls, getDataState: GetDataState.success));
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
        getDataState: GetDataState.failure,
      ));
    } finally {
      emit(state.copyWith(
        getDataState: GetDataState.initial,
      ));
    }
  }

  Future<void> createUrl({required String longUrl, String? urlCode}) async {
    try {
      emit(state.copyWith(urlActionState: UrlActionState.loading));
      final url = await _createUrlUseCase(longUrl, urlCode);
      final urls = [url, ...state.urls!];
      emit(state.copyWith(urls: urls, urlActionState: UrlActionState.success));
    } catch (e) {
      emit(state.copyWith(
        urlActionState: UrlActionState.failure,
      ));
    } finally {
      emit(state.copyWith(
        urlActionState: UrlActionState.initial,
      ));
    }
  }

  Future<void> updateUrl(
      {required String id, String? newLongUrl, String? newUrlCode}) async {
    try {
      emit(state.copyWith(urlActionState: UrlActionState.loading));
      final url = await _updateUrlUseCase(id, newLongUrl, newUrlCode);
      final urls = [...state.urls!];
      final index = urls.indexWhere((element) => element.sId == url.sId);
      urls[index] = url;
      emit(state.copyWith(urls: urls, urlActionState: UrlActionState.success));
    } catch (e) {
      emit(state.copyWith(
        urlActionState: UrlActionState.failure,
      ));
    } finally {
      emit(state.copyWith(
        urlActionState: UrlActionState.initial,
      ));
    }
  }

  Future<void> deleteUrl({
    required String id,
  }) async {
    try {
      emit(state.copyWith(urlActionState: UrlActionState.loading));
      await _deleteUrlUseCase(id);
      final urls = [...state.urls!];
      final index = urls.indexWhere((element) => element.sId == id);
      urls.removeAt(index);
      emit(state.copyWith(urls: urls, urlActionState: UrlActionState.success));
    } catch (e) {
      emit(state.copyWith(
        urlActionState: UrlActionState.failure,
      ));
    } finally {
      emit(state.copyWith(
        urlActionState: UrlActionState.initial,
      ));
    }
  }
}
