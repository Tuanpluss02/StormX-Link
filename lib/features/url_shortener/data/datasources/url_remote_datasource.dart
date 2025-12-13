import 'package:dio/dio.dart';
import 'package:link/features/url_shortener/data/models/shortened_url_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:injectable/injectable.dart';

part 'url_remote_datasource.g.dart';

@RestApi()
@lazySingleton
abstract class UrlRemoteDataSource {
  @factoryMethod
  factory UrlRemoteDataSource(Dio dio) = _UrlRemoteDataSource;

  @POST('/api/v1/shorten')
  Future<ShortenedUrlModel> shortenUrl(@Body() Map<String, dynamic> body);

  @GET('/api/v1/urls')
  Future<List<ShortenedUrlModel>> getUrls();

  @DELETE('/api/v1/urls/{id}')
  Future<void> deleteUrl(@Path('id') String id);
}
