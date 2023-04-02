class Urls {
  String? longUrl;
  String? shortUrl;
  String? shortname;

  Urls({this.longUrl, this.shortUrl, this.shortname});

  Urls.fromJson(Map<String, dynamic> json) {
    longUrl = json['long_url'];
    shortUrl = json['short_url'];
    shortname = json['shortname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['long_url'] = longUrl;
    data['short_url'] = shortUrl;
    data['shortname'] = shortname;
    return data;
  }
}
