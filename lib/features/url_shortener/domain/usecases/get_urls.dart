import 'package:dartz/dartz.dart';
import 'package:link/core/error/failures.dart';
import 'package:link/core/usecases/usecase.dart';
import 'package:link/features/url_shortener/domain/entities/shortened_url.dart';
import 'package:link/features/url_shortener/domain/repositories/url_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetUrls implements UseCase<List<ShortenedUrl>, NoParams> {
  final UrlRepository repository;

  GetUrls(this.repository);

  @override
  Future<Either<Failure, List<ShortenedUrl>>> call(NoParams params) async {
    return await repository.getUrls();
  }
}
