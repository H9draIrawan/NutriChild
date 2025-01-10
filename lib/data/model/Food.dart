class Food {
  final String id;
  final String name;
  final double calories;
  final String imageUrl;

  Food({
    required this.id,
    required this.name,
    required this.calories,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
      'imageUrl': imageUrl,
    };
  }

  factory Food.fromMap(Map<String, dynamic> map) {
    return Food(
      id: map['id'],
      name: map['name'],
      calories: map['calories'],
      imageUrl: map['imageUrl'],
    );
  }
}
