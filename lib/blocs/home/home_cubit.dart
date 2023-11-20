import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:url_shortener_flutter/models/user_model.dart';
import 'package:url_shortener_flutter/repositories/url_repository.dart';
import 'package:url_shortener_flutter/repositories/user_repository.dart';

import '../../../models/url_model.dart';
import '../../common/enums.dart';

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
      emit(state.copyWith(urlActionState: UrlActionState.loading));
      final user = await userRepository.getUserInfo();
      final urls = await urlRepository.getUrls();
      emit(state.copyWith(
          user: user, urls: urls, urlActionState: UrlActionState.success));
    } catch (e) {
      emit(state.copyWith(
        urlActionState: UrlActionState.failure,
      ));
    }
  }

  Future<void> createUrl({required String longUrl, String? urlCode}) async {
    try {
      emit(state.copyWith(urlActionState: UrlActionState.loading));
      final url = await urlRepository.createUrl(longUrl, urlCode);
      final urls = [...state.urls!, url];
      emit(state.copyWith(urls: urls, urlActionState: UrlActionState.success));
    } catch (e) {
      emit(state.copyWith(
        urlActionState: UrlActionState.failure,
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
    }
  }
}
