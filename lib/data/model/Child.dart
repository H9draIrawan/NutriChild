class Child {
  late int? id;
  late String name;
  late int age;
  late String gender;
  late double weight;
  late double height;
  late double bmi;

  Child({
    this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.weight,
    required this.height,
    required this.bmi,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'weight': weight,
      'height': height,
      'bmi': bmi,
    };
  }

  Child.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    age = map['age'];
    gender = map['gender'];
    weight = map['weight'];
    height = map['height'];
    bmi = map['bmi'];
  }
}
