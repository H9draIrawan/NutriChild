import 'package:nutrichild/domain/entities/allergy.dart';

class AllergyModel extends Allergy {
  const AllergyModel({required super.id, required super.name});

  factory AllergyModel.fromJson(Map<String, dynamic> json) {
    return AllergyModel(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
