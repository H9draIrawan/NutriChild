import 'package:equatable/equatable.dart';

class Allergy extends Equatable {
  final String id;
  final String name;

  const Allergy({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
