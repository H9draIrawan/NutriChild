import 'package:nutrichild/domain/entities/patient.dart';

class PatientModel extends Patient {
  const PatientModel(
      {required super.id, required super.userId, required super.allergyId});

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'],
      userId: json['userId'],
      allergyId: json['allergyId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'allergyId': allergyId,
    };
  }
}
