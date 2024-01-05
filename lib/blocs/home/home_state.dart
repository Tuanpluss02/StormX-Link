part of 'home_cubit.dart';

class HomeState extends Equatable {
  final User? user;
  final List<Url>? urls;
  final UrlActionState urlActionState;
  final GetDataState getDataState;
  const HomeState(
    this.user,
    this.urls,
    this.urlActionState,
    this.getDataState,
  );

  factory HomeState.initial({
    required UserRepository userRepository,
    required UrlRepository urlRepository,
  }) {
    return HomeState(
      userRepository.user,
      urlRepository.urls,
      UrlActionState.initial,
      GetDataState.initial,
    );
  }

  HomeState copyWith({
    User? user,
    List<Url>? urls,
    UrlActionState? urlActionState,
    GetDataState? getDataState,
  }) {
    return HomeState(
      user ?? this.user,
      urls ?? this.urls,
      urlActionState ?? this.urlActionState,
      getDataState ?? this.getDataState,
    );
  }

  @override
  List<Object> get props =>
      [user ?? User(username: "StormX"), urlActionState, urls ?? []];
}
