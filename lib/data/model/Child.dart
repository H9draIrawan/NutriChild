class Child {
  final String name;
  final int age;
  final String gender;
  final int height;
  final int weight;

  Child(
      {required this.name,
      required this.age,
      required this.gender,
      required this.height,
      required this.weight});

  factory Child.fromJson(Map<String, dynamic> json) => Child(
        name: json['name'],
        age: json['age'],
        gender: json['gender'],
        height: json['height'],
        weight: json['weight'],
      );
}
