import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? uID;
  final String? username;
  final List<String>? urls;

  const UserEntity({
    this.uID,
    this.username,
    this.urls,
  });

  String? get userID => uID;
  String? get getUsername => username;
  List<String>? get getUrls => urls;

  @override
  List<Object?> get props => [uID, username, urls];
}