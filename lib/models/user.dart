import 'package:url_shortener_flutter/models/urls.dart';

class User {
  String? sId;
  String? username;
  String? hashedPassword;
  String? salt;
  bool? disabled;
  List<Urls>? urls;

  User(
      {this.sId,
      this.username,
      this.hashedPassword,
      this.salt,
      this.disabled,
      this.urls});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    username = json['username'];
    hashedPassword = json['hashed_password'];
    salt = json['salt'];
    disabled = json['disabled'];
    if (json['urls'] != null) {
      urls = <Urls>[];
      json['urls'].forEach((v) {
        urls!.add(Urls.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['username'] = username;
    data['hashed_password'] = hashedPassword;
    data['salt'] = salt;
    data['disabled'] = disabled;
    if (urls != null) {
      data['urls'] = urls!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
