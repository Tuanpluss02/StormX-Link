import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../models/url_model.dart';
import '../../common/enums.dart';
import '../../models/user_model.dart';
import '../../repositories/url_repository.dart';
import '../../repositories/user_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final UserRepository userRepository;
  final UrlRepository urlRepository;
  HomeCubit({
    required this.userRepository,
    required this.urlRepository,
  }) : super(HomeState.initial(
          userRepository: userRepository,
          urlRepository: urlRepository,
        ));

  Future<void> getHomeData() async {
    try {
      emit(state.copyWith(getDataState: GetDataState.loading));
      final user = await userRepository.getUserInfo();
      final urls = await urlRepository.getUrls();
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
      final url = await urlRepository.createUrl(longUrl, urlCode);
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
      final url = await urlRepository.updateUrl(id, newLongUrl, newUrlCode);
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
      urlRepository.deleteUrl(id);
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
