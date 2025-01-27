class Patient {
  final String id;
  final String childId;
  final String allergyId;

  Patient({required this.id, required this.childId, required this.allergyId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'childId': childId,
      'allergyId': allergyId,
    };
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id'],
      childId: map['childId'],
      allergyId: map['allergyId'],
    );
  }
}
