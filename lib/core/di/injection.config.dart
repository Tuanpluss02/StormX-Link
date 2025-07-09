// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../blocs/auth/auth_bloc.dart' as _i24;
import '../../blocs/home/home_cubit.dart' as _i25;
import '../../data/datasources/auth_local_datasource.dart' as _i4;
import '../../data/datasources/auth_remote_datasource.dart' as _i6;
import '../../data/datasources/url_remote_datasource.dart' as _i8;
import '../../data/datasources/user_remote_datasource.dart' as _i10;
import '../../data/repositories/auth_repository.dart' as _i12;
import '../../data/repositories/url_repository.dart' as _i14;
import '../../data/repositories/user_repository.dart' as _i16;
import '../../domain/repositories/i_auth_repository.dart' as _i11;
import '../../domain/repositories/i_url_repository.dart' as _i13;
import '../../domain/repositories/i_user_repository.dart' as _i15;
import '../../domain/usecases/auth_usecases.dart' as _i17;
import '../../domain/usecases/url_usecases.dart' as _i19;
import '../../domain/usecases/user_usecases.dart' as _i21;
import 'injection.dart' as _i26;

extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.singleton<_i3.Dio>(registerModule.dio);
    gh.factory<_i4.IAuthLocalDataSource>(() => _i4.AuthLocalDataSource());
    gh.factory<_i6.IAuthRemoteDataSource>(
        () => _i6.AuthRemoteDataSource(gh<_i3.Dio>()));
    gh.factory<_i8.IUrlRemoteDataSource>(
        () => _i8.UrlRemoteDataSource(gh<_i3.Dio>()));
    gh.factory<_i10.IUserRemoteDataSource>(
        () => _i10.UserRemoteDataSource(gh<_i3.Dio>()));
    gh.factory<_i11.IAuthRepository>(() => _i12.AuthRepository(
          gh<_i6.IAuthRemoteDataSource>(),
          gh<_i4.IAuthLocalDataSource>(),
        ));
    gh.factory<_i13.IUrlRepository>(
        () => _i14.UrlRepository(gh<_i8.IUrlRemoteDataSource>()));
    gh.factory<_i15.IUserRepository>(() => _i16.UserRepository(
          gh<_i10.IUserRemoteDataSource>(),
          gh<_i4.IAuthLocalDataSource>(),
        ));
    gh.factory<_i17.CheckUserLoggedInUseCase>(
        () => _i17.CheckUserLoggedInUseCase(gh<_i11.IAuthRepository>()));
    gh.factory<_i17.CreateAccountUseCase>(
        () => _i17.CreateAccountUseCase(gh<_i11.IAuthRepository>()));
    gh.factory<_i19.CreateUrlUseCase>(
        () => _i19.CreateUrlUseCase(gh<_i13.IUrlRepository>()));
    gh.factory<_i19.DeleteUrlUseCase>(
        () => _i19.DeleteUrlUseCase(gh<_i13.IUrlRepository>()));
    gh.factory<_i19.GetUrlsUseCase>(
        () => _i19.GetUrlsUseCase(gh<_i13.IUrlRepository>()));
    gh.factory<_i21.GetUserInfoUseCase>(
        () => _i21.GetUserInfoUseCase(gh<_i15.IUserRepository>()));
    gh.factory<_i17.LoginUseCase>(
        () => _i17.LoginUseCase(gh<_i11.IAuthRepository>()));
    gh.factory<_i21.LogoutUseCase>(
        () => _i21.LogoutUseCase(gh<_i15.IUserRepository>()));
    gh.factory<_i19.UpdateUrlUseCase>(
        () => _i19.UpdateUrlUseCase(gh<_i13.IUrlRepository>()));
    gh.factory<_i24.AuthBloc>(() => _i24.AuthBloc(
          gh<_i17.LoginUseCase>(),
          gh<_i17.CreateAccountUseCase>(),
          gh<_i17.CheckUserLoggedInUseCase>(),
          gh<_i21.LogoutUseCase>(),
        ));
    gh.factory<_i25.HomeCubit>(() => _i25.HomeCubit(
          gh<_i21.GetUserInfoUseCase>(),
          gh<_i19.GetUrlsUseCase>(),
          gh<_i19.CreateUrlUseCase>(),
          gh<_i19.UpdateUrlUseCase>(),
          gh<_i19.DeleteUrlUseCase>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i26.RegisterModule {}