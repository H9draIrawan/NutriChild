import 'package:dartz/dartz.dart';
import 'package:nutrichild/core/error/failures.dart';
import 'package:nutrichild/domain/entities/child.dart';
import 'package:nutrichild/domain/repositories/child_repository.dart';

class GetChild {
  final ChildRepository repository;

  GetChild(this.repository);

  Future<Either<Failure, List<Child>>> call() async {
    return await repository.get();
  }
}
