class ListUrls {
  List<Urls>? urls;

  ListUrls({this.urls});

  ListUrls.fromJson(Map<String, dynamic> json) {
    if (json['urls'] != null) {
      urls = <Urls>[];
      json['urls'].forEach((v) {
        urls!.add(Urls.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (urls != null) {
      data['urls'] = urls!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Urls {
  String? id;
  String? shortUrl;
  String? longUrl;

  Urls({this.id, this.shortUrl, this.longUrl});

  Urls.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shortUrl = json['short_url'];
    longUrl = json['long_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['short_url'] = shortUrl;
    data['long_url'] = longUrl;
    return data;
  }
}
