import '../../domain/entities/url_entity.dart';

class UrlModel extends UrlEntity {
  const UrlModel({
    super.sId,
    super.longUrl,
    super.urlCode,
  });

  factory UrlModel.fromJson(Map<String, dynamic> json) {
    return UrlModel(
      sId: json['_id'],
      longUrl: json['longUrl'],
      urlCode: json['urlCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'longUrl': longUrl,
      'urlCode': urlCode,
    };
  }

  UrlEntity toEntity() {
    return UrlEntity(
      sId: sId,
      longUrl: longUrl,
      urlCode: urlCode,
    );
  }
}