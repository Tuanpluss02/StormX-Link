# Developer Quick Reference

## Adding New Features

### 1. Add a New Entity
```dart
// lib/domain/entities/new_entity.dart
import 'package:equatable/equatable.dart';

class NewEntity extends Equatable {
  final String? id;
  final String? name;

  const NewEntity({this.id, this.name});

  @override
  List<Object?> get props => [id, name];
}
```

### 2. Create Repository Interface
```dart
// lib/domain/repositories/i_new_repository.dart
import '../entities/new_entity.dart';

abstract class INewRepository {
  Future<NewEntity> getEntity(String id);
  Future<List<NewEntity>> getAllEntities();
}
```

### 3. Create Use Cases
```dart
// lib/domain/usecases/new_usecases.dart
import 'package:injectable/injectable.dart';
import '../entities/new_entity.dart';
import '../repositories/i_new_repository.dart';

@injectable
class GetEntityUseCase {
  final INewRepository _repository;

  GetEntityUseCase(this._repository);

  Future<NewEntity> call(String id) {
    return _repository.getEntity(id);
  }
}
```

### 4. Create Data Model
```dart
// lib/data/models/new_model.dart
import '../../domain/entities/new_entity.dart';

class NewModel extends NewEntity {
  const NewModel({super.id, super.name});

  factory NewModel.fromJson(Map<String, dynamic> json) {
    return NewModel(
      id: json['id'],
      name: json['name'],
    );
  }

  NewEntity toEntity() {
    return NewEntity(id: id, name: name);
  }
}
```

### 5. Create Data Source
```dart
// lib/data/datasources/new_remote_datasource.dart
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import '../models/new_model.dart';

abstract class INewRemoteDataSource {
  Future<NewModel> getEntity(String id);
}

@Injectable(as: INewRemoteDataSource)
class NewRemoteDataSource implements INewRemoteDataSource {
  final Dio _dio;

  NewRemoteDataSource(this._dio);

  @override
  Future<NewModel> getEntity(String id) async {
    final response = await _dio.get('/entity/$id');
    return NewModel.fromJson(response.data);
  }
}
```

### 6. Implement Repository
```dart
// lib/data/repositories/new_repository.dart
import 'package:injectable/injectable.dart';
import '../../domain/entities/new_entity.dart';
import '../../domain/repositories/i_new_repository.dart';
import '../datasources/new_remote_datasource.dart';

@Injectable(as: INewRepository)
class NewRepository implements INewRepository {
  final INewRemoteDataSource _remoteDataSource;

  NewRepository(this._remoteDataSource);

  @override
  Future<NewEntity> getEntity(String id) async {
    final model = await _remoteDataSource.getEntity(id);
    return model.toEntity();
  }
}
```

### 7. Create BLoC/Cubit
```dart
// lib/blocs/new/new_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/new_usecases.dart';

@injectable
class NewCubit extends Cubit<NewState> {
  final GetEntityUseCase _getEntityUseCase;

  NewCubit(this._getEntityUseCase) : super(NewState.initial());

  Future<void> loadEntity(String id) async {
    emit(state.copyWith(isLoading: true));
    try {
      final entity = await _getEntityUseCase(id);
      emit(state.copyWith(entity: entity, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }
}
```

### 8. Regenerate DI Configuration
```bash
dart run build_runner build
```

### 9. Use in UI
```dart
BlocProvider<NewCubit>(
  create: (context) => getIt<NewCubit>(),
  child: YourWidget(),
)
```

## Testing

### Unit Test Example
```dart
// test/domain/usecases/new_usecases_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('GetEntityUseCase', () {
    test('should return entity when repository succeeds', () async {
      // Arrange
      final mockRepository = MockNewRepository();
      final useCase = GetEntityUseCase(mockRepository);
      
      // Act & Assert
      // ... test implementation
    });
  });
}
```

## Best Practices

1. **Always use dependency injection** for services and repositories
2. **Keep entities pure** - no external dependencies
3. **Use use cases** for business logic
4. **Test each layer** independently
5. **Follow naming conventions** consistently
6. **Keep data models separate** from entities