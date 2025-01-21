class Child {
  final String id;
  final String userId;
  final String name;
  final int age;
  final String gender;
  final double weight;
  final double height;
  final String goal;

  Child({
    required this.id,
    required this.userId,
    required this.name,
    required this.age,
    required this.gender,
    required this.weight,
    required this.height,
    required this.goal,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'age': age,
      'gender': gender,
      'weight': weight,
      'height': height,
      'goal': goal
    };
  }

  factory Child.fromMap(Map<String, dynamic> map) {
    return Child(
      id: map['id'],
      userId: map['userId'],
      name: map['name'],
      age: map['age'],
      gender: map['gender'],
      weight: map['weight'],
      height: map['height'],
      goal: map['goal'],
    );
  }
}
