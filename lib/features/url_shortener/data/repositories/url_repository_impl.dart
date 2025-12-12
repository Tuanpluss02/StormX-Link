import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:link/core/error/failures.dart';
import 'package:link/features/url_shortener/data/datasources/url_remote_datasource.dart';
import 'package:link/features/url_shortener/domain/entities/shortened_url.dart';
import 'package:link/features/url_shortener/domain/repositories/url_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: UrlRepository)
class UrlRepositoryImpl implements UrlRepository {
  final UrlRemoteDataSource remoteDataSource;

  UrlRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, ShortenedUrl>> shortenUrl(String originalUrl) async {
    try {
      final model = await remoteDataSource.shortenUrl({'originalUrl': originalUrl});
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Unknown Error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ShortenedUrl>>> getUrls() async {
    try {
      final models = await remoteDataSource.getUrls();
      return Right(models.map((e) => e.toEntity()).toList());
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Unknown Error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUrl(String id) async {
    try {
      await remoteDataSource.deleteUrl(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Unknown Error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
