import 'package:injectable/injectable.dart';
import '../../domain/entities/url_entity.dart';
import '../../domain/repositories/i_url_repository.dart';
import '../datasources/url_remote_datasource.dart';

@Injectable(as: IUrlRepository)
class UrlRepository implements IUrlRepository {
  final IUrlRemoteDataSource _remoteDataSource;

  UrlRepository(this._remoteDataSource);

  @override
  Future<UrlEntity> createUrl(String longUrl, String? urlCode) async {
    final urlModel = await _remoteDataSource.createUrl(longUrl, urlCode);
    return urlModel.toEntity();
  }

  @override
  Future<List<UrlEntity>> getUrls() async {
    final urlModels = await _remoteDataSource.getUrls();
    return urlModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<UrlEntity> updateUrl(String? id, String? newLongUrl, String? newUrlCode) async {
    final urlModel = await _remoteDataSource.updateUrl(id, newLongUrl, newUrlCode);
    return urlModel.toEntity();
  }

  @override
  Future<void> deleteUrl(String? id) {
    return _remoteDataSource.deleteUrl(id);
  }
}