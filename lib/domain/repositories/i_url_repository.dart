import '../entities/url_entity.dart';

abstract class IUrlRepository {
  Future<UrlEntity> createUrl(String longUrl, String? urlCode);
  Future<List<UrlEntity>> getUrls();
  Future<UrlEntity> updateUrl(String? id, String? newLongUrl, String? newUrlCode);
  Future<void> deleteUrl(String? id);
}