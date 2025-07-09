# StormX-Link Architecture Documentation

## Clean Architecture Implementation

This document outlines the clean architecture implementation for the StormX-Link application.

### Architecture Overview

The application follows Clean Architecture principles with proper separation of concerns:

```
lib/
├── core/
│   └── di/                    # Dependency Injection
│       ├── injection.dart     # DI configuration
│       └── injection.config.dart  # Generated DI code
├── domain/                    # Business Logic Layer
│   ├── entities/              # Business entities
│   ├── repositories/          # Repository interfaces
│   └── usecases/              # Business use cases
├── data/                      # Data Layer
│   ├── datasources/           # Data sources (remote/local)
│   ├── models/                # Data models
│   └── repositories/          # Repository implementations
├── blocs/                     # Presentation Layer - State Management
├── views/                     # Presentation Layer - UI
└── main.dart                  # Application entry point
```

### Layer Descriptions

#### 1. Domain Layer (`lib/domain/`)
- **Entities**: Pure business objects (UserEntity, UrlEntity)
- **Use Cases**: Business logic operations (LoginUseCase, CreateUrlUseCase, etc.)
- **Repository Interfaces**: Abstract contracts for data operations

#### 2. Data Layer (`lib/data/`)
- **Data Sources**: Handle API calls and local storage
- **Models**: Data transfer objects with JSON serialization
- **Repository Implementations**: Concrete implementations of domain interfaces

#### 3. Presentation Layer (`lib/blocs/`, `lib/views/`)
- **BLoCs/Cubits**: State management using Flutter BLoC pattern
- **Views**: UI components and screens

#### 4. Core Layer (`lib/core/`)
- **Dependency Injection**: Injectable configuration for service locator pattern

### Key Features

1. **Dependency Injection**: Uses `injectable` and `get_it` packages
2. **Clean Separation**: Each layer has single responsibility
3. **Testability**: Easy to mock dependencies for testing
4. **Maintainability**: Clear structure for future enhancements
5. **Scalability**: Easy to add new features following the established pattern

### Dependencies

```yaml
dependencies:
  get_it: ^7.6.4
  injectable: ^2.3.2
  flutter_bloc: ^8.1.3
  bloc: ^8.1.2
  equatable: ^2.0.5

dev_dependencies:
  injectable_generator: ^2.4.1
  build_runner: ^2.4.7
```

### Usage

1. **Initialize DI Container**: Called in `main.dart`
```dart
configureDependencies();
```

2. **Inject Dependencies**: BLoCs are automatically injected
```dart
BlocProvider<AuthBloc>(
  create: (context) => getIt<AuthBloc>(),
)
```

3. **Use Cases**: Business logic is handled through use cases
```dart
final response = await _loginUseCase(username, password);
```

### Migration Notes

- Maintained backward compatibility with existing views
- Entity properties match original model structure (sId, uID, etc.)
- All existing functionality preserved
- Tests updated to work with new architecture

### Benefits

1. **Maintainability**: Clear separation of concerns
2. **Testability**: Easy to unit test individual components
3. **Scalability**: Easy to add new features
4. **Flexibility**: Easy to change data sources or UI components
5. **Consistency**: Standardized approach across the application