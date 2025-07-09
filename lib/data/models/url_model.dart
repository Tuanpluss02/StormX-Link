import '../../domain/entities/url_entity.dart';

class UrlModel extends UrlEntity {
  const UrlModel({
    super.id,
    super.longUrl,
    super.urlCode,
  });

  factory UrlModel.fromJson(Map<String, dynamic> json) {
    return UrlModel(
      id: json['_id'],
      longUrl: json['longUrl'],
      urlCode: json['urlCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'longUrl': longUrl,
      'urlCode': urlCode,
    };
  }

  UrlEntity toEntity() {
    return UrlEntity(
      id: id,
      longUrl: longUrl,
      urlCode: urlCode,
    );
  }
}