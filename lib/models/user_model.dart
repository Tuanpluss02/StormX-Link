class User {
  String? uID;
  String? username;
  List<String>? urls;

  User({this.uID, this.username, this.urls});

  User.fromJson(Map<String, dynamic> json) {
    uID = json['_id'];
    username = json['username'];
    urls = json['urls'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = uID;
    data['username'] = username;
    data['urls'] = urls;
    return data;
  }
}
