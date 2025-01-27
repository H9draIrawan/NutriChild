import 'package:equatable/equatable.dart';

abstract class AllergyEvent extends Equatable {}

class InitAllergyEvent extends AllergyEvent {
  @override
  List<Object?> get props => [];
}

class GetAllergyEvent extends AllergyEvent {
  final String id;

  GetAllergyEvent(this.id);

  @override
  List<Object?> get props => [id];
}
