import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import '../../common/constant.dart';
import 'injection.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
void configureDependencies() => getIt.init();

@module
abstract class RegisterModule {
  @singleton
  Dio get dio => Dio(
    BaseOptions(
      headers: {
        'Allow-Control-Allow-Origin': '*',
      },
      followRedirects: false,
      validateStatus: (status) {
        return status! < 500;
      },
      contentType: 'application/json',
      receiveDataWhenStatusError: true,
    ),
  );
}