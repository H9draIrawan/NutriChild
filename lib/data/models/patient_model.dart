import 'package:nutrichild/domain/entities/patient.dart';

class PatientModel extends Patient {
  const PatientModel(
      {required super.id, required super.childId, required super.allergyId});

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'],
      childId: json['childId'],
      allergyId: json['allergyId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'childId': childId,
      'allergyId': allergyId,
    };
  }
}
