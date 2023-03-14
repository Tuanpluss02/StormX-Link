class URLRes {
  String? messages;
  String? shortUrl;

  URLRes({this.messages, this.shortUrl});

  URLRes.fromJson(Map<String, dynamic> json) {
    messages = json['messages'];
    shortUrl = json['short_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['messages'] = messages;
    data['short_url'] = shortUrl;
    return data;
  }
}
