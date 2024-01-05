class Url {
  String? sId;
  String? longUrl;
  String? urlCode;

  Url({this.sId, this.longUrl, this.urlCode});

  Url.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    longUrl = json['longUrl'];
    urlCode = json['urlCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['longUrl'] = longUrl;
    data['urlCode'] = urlCode;
    return data;
  }

  @override
  String toString() {
    return 'Url{sId: $sId, longUrl: $longUrl, urlCode: $urlCode}';
  }
}
