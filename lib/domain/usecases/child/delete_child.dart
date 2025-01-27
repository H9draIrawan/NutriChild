import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/child_repository.dart';
import '../../entities/child.dart';

class DeleteChild {
  final ChildRepository repository;

  DeleteChild(this.repository);

  Future<Either<Failure, void>> call(Child child) async {
    return await repository.delete(child);
  }
}