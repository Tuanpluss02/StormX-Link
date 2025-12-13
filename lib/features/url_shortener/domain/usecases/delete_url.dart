import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:link/core/error/failures.dart';
import 'package:link/core/usecases/usecase.dart';
import 'package:link/features/url_shortener/domain/repositories/url_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DeleteUrl implements UseCase<void, DeleteUrlParams> {
  final UrlRepository repository;

  DeleteUrl(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteUrlParams params) async {
    return await repository.deleteUrl(params.id);
  }
}

class DeleteUrlParams extends Equatable {
  final String id;

  const DeleteUrlParams({required this.id});

  @override
  List<Object> get props => [id];
}
