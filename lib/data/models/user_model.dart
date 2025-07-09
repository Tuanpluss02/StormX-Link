import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    super.uID,
    super.username,
    super.urls,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uID: json['_id'],
      username: json['username'],
      urls: json['urls']?.cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': uID,
      'username': username,
      'urls': urls,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      uID: uID,
      username: username,
      urls: urls,
    );
  }
}