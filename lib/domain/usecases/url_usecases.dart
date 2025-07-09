import 'package:injectable/injectable.dart';
import '../entities/url_entity.dart';
import '../repositories/i_url_repository.dart';

@injectable
class CreateUrlUseCase {
  final IUrlRepository _urlRepository;

  CreateUrlUseCase(this._urlRepository);

  Future<UrlEntity> call(String longUrl, String? urlCode) {
    return _urlRepository.createUrl(longUrl, urlCode);
  }
}

@injectable
class GetUrlsUseCase {
  final IUrlRepository _urlRepository;

  GetUrlsUseCase(this._urlRepository);

  Future<List<UrlEntity>> call() {
    return _urlRepository.getUrls();
  }
}

@injectable
class UpdateUrlUseCase {
  final IUrlRepository _urlRepository;

  UpdateUrlUseCase(this._urlRepository);

  Future<UrlEntity> call(String? id, String? newLongUrl, String? newUrlCode) {
    return _urlRepository.updateUrl(id, newLongUrl, newUrlCode);
  }
}

@injectable
class DeleteUrlUseCase {
  final IUrlRepository _urlRepository;

  DeleteUrlUseCase(this._urlRepository);

  Future<void> call(String? id) {
    return _urlRepository.deleteUrl(id);
  }
}