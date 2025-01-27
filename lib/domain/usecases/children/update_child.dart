import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/child_repository.dart';
import '../../entities/child.dart';

class UpdateChild {
  final ChildRepository repository;

  UpdateChild(this.repository);

  Future<Either<Failure, void>> call(Child child) async {
    return await repository.update(child);
  }
}
