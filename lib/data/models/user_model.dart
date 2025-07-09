import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    super.id,
    super.username,
    super.urls,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      username: json['username'],
      urls: json['urls']?.cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'urls': urls,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      username: username,
      urls: urls,
    );
  }
}