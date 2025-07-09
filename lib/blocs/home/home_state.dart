part of 'home_cubit.dart';

class HomeState extends Equatable {
  final UserEntity? user;
  final List<UrlEntity>? urls;
  final UrlActionState urlActionState;
  final GetDataState getDataState;
  const HomeState(
    this.user,
    this.urls,
    this.urlActionState,
    this.getDataState,
  );

  factory HomeState.initial() {
    return const HomeState(
      null,
      [],
      UrlActionState.initial,
      GetDataState.initial,
    );
  }

  HomeState copyWith({
    UserEntity? user,
    List<UrlEntity>? urls,
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
      [user ?? const UserEntity(username: "StormX"), urlActionState, urls ?? []];
}
