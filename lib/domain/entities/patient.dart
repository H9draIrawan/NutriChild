import 'package:equatable/equatable.dart';

class Patient extends Equatable {
  final String id;
  final String userId;
  final String allergyId;

  const Patient({
    required this.id,
    required this.userId,
    required this.allergyId,
  });

  @override
  List<Object?> get props => [id, userId, allergyId];
}
