import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:link/core/di/injection.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
void configureDependencies() => getIt.init();
