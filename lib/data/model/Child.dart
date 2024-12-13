class Child {
  late String id;
  late String userId;
  late String name;
  late int age;
  late String gender;
  late double weight;
  late double height;

  Child(
      {required this.id,
      required this.userId,
      required this.name,
      required this.age,
      required this.gender,
      required this.weight,
      required this.height});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'age': age,
      'gender': gender,
      'weight': weight,
      'height': height
    };
  }

  Child.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    userId = map['userId'];
    name = map['name'];
    age = map['age'];
    gender = map['gender'];
    weight = map['weight'];
    height = map['height'];
  }
}
