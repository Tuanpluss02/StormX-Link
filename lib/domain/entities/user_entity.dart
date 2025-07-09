import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? id;
  final String? username;
  final List<String>? urls;

  const UserEntity({
    this.id,
    this.username,
    this.urls,
  });

  @override
  List<Object?> get props => [id, username, urls];
}