import 'package:equatable/equatable.dart';

abstract class AllergyState extends Equatable {
  const AllergyState();

  @override
  List<Object?> get props => [];
}

class InitialAllergyState extends AllergyState {}

class LoadingAllergyState extends AllergyState {}

class GetAllergyState extends AllergyState {}

class ErrorAllergyState extends AllergyState {
  final String message;

  const ErrorAllergyState(this.message);

  @override
  List<Object?> get props => [message];
}
