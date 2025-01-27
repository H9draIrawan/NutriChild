import 'package:equatable/equatable.dart';

class Patient extends Equatable {
  final String id;
  final String childId;
  final String allergyId;

  const Patient({
    required this.id,
    required this.childId,
    required this.allergyId,
  });

  @override
  List<Object?> get props => [id, childId, allergyId];
}
