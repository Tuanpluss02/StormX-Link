part of 'home_cubit.dart';

class HomeState extends Equatable {
  final User? user;
  final List<Url>? urls;
  final UrlActionState urlActionState;
  const HomeState(
    this.user,
    this.urls,
    this.urlActionState,
  );

  factory HomeState.initial({
    required UserRepository userRepository,
    required UrlRepository urlRepository,
  }) {
    return HomeState(
      userRepository.user,
      urlRepository.urls,
      UrlActionState.initial,
    );
  }

  HomeState copyWith({
    User? user,
    List<Url>? urls,
    UrlActionState? urlActionState,
  }) {
    return HomeState(
      user ?? this.user,
      urls ?? this.urls,
      urlActionState ?? this.urlActionState,
    );
  }

  @override
  List<Object> get props =>
      [user ?? User(username: "StormX"), urlActionState, urls ?? []];
}
