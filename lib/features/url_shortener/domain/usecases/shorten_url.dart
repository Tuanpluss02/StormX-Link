import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:link/core/error/failures.dart';
import 'package:link/core/usecases/usecase.dart';
import 'package:link/features/url_shortener/domain/entities/shortened_url.dart';
import 'package:link/features/url_shortener/domain/repositories/url_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ShortenUrl implements UseCase<ShortenedUrl, ShortenUrlParams> {
  final UrlRepository repository;

  ShortenUrl(this.repository);

  @override
  Future<Either<Failure, ShortenedUrl>> call(ShortenUrlParams params) async {
    return await repository.shortenUrl(params.originalUrl);
  }
}

class ShortenUrlParams extends Equatable {
  final String originalUrl;

  const ShortenUrlParams({required this.originalUrl});

  @override
  List<Object> get props => [originalUrl];
}
