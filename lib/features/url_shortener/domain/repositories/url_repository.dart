import 'package:dartz/dartz.dart';
import 'package:link/core/error/failures.dart';
import 'package:link/features/url_shortener/domain/entities/shortened_url.dart';

abstract class UrlRepository {
  Future<Either<Failure, ShortenedUrl>> shortenUrl(String originalUrl);
  Future<Either<Failure, List<ShortenedUrl>>> getUrls();
  Future<Either<Failure, void>> deleteUrl(String id);
}
