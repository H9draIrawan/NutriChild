class Allergy {
  final String id;
  final String name;
  final String description;

  Allergy(
      {required this.id,
      required this.name,
      required this.description});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  factory Allergy.fromMap(Map<String, dynamic> map) {
    return Allergy(
      id: map['id'],
      name: map['name'],
      description: map['description'],
    );
  }
}
