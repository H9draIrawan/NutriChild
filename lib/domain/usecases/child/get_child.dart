import 'package:dartz/dartz.dart';
import 'package:nutrichild/core/error/failures.dart';
import 'package:nutrichild/domain/entities/child.dart';
import 'package:nutrichild/domain/repositories/child_repository.dart';

class GetChild {
  final ChildRepository _childRepository;

  GetChild(this._childRepository);

  Future<Either<Failure, List<Child>>> call(String userId) async {
    return await _childRepository.get(userId);
  }
}
