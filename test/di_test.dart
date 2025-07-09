import 'package:flutter_test/flutter_test.dart';
import 'package:link/core/di/injection.dart';
import 'package:link/blocs/auth/auth_bloc.dart';
import 'package:link/blocs/home/home_cubit.dart';
import 'package:link/domain/usecases/auth_usecases.dart';
import 'package:link/domain/usecases/user_usecases.dart';
import 'package:link/domain/usecases/url_usecases.dart';

void main() {
  setUp(() {
    configureDependencies();
  });

  tearDown(() {
    getIt.reset();
  });

  group('Dependency Injection Tests', () {
    test('should register all dependencies correctly', () {
      expect(getIt.isRegistered<AuthBloc>(), isTrue);
      expect(getIt.isRegistered<HomeCubit>(), isTrue);
      expect(getIt.isRegistered<LoginUseCase>(), isTrue);
      expect(getIt.isRegistered<CreateAccountUseCase>(), isTrue);
      expect(getIt.isRegistered<GetUserInfoUseCase>(), isTrue);
      expect(getIt.isRegistered<GetUrlsUseCase>(), isTrue);
      expect(getIt.isRegistered<CreateUrlUseCase>(), isTrue);
      expect(getIt.isRegistered<UpdateUrlUseCase>(), isTrue);
      expect(getIt.isRegistered<DeleteUrlUseCase>(), isTrue);
    });

    test('should create AuthBloc instance', () {
      final authBloc = getIt<AuthBloc>();
      expect(authBloc, isNotNull);
      expect(authBloc, isA<AuthBloc>());
    });

    test('should create HomeCubit instance', () {
      final homeCubit = getIt<HomeCubit>();
      expect(homeCubit, isNotNull);
      expect(homeCubit, isA<HomeCubit>());
    });
  });
}