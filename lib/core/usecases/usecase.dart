import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../error/failures.dart';

// Interface untuk semua use case
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

// Use case tanpa parameter
abstract class UseCaseNoParams<Type> {
  Future<Either<Failure, Type>> call();
}

// Use case dengan parameter stream
abstract class StreamUseCase<Type, Params> {
  Stream<Either<Failure, Type>> call(Params params);
}

// Use case tanpa parameter stream
abstract class StreamUseCaseNoParams<Type> {
  Stream<Either<Failure, Type>> call();
}

// Class untuk use case yang tidak memerlukan parameter
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
