class Meal {
  final String id;
  final String childId;
  final String foodId;
  final String mealTime;
  final String dateTime;
  final int qty;

  Meal({
    required this.id,
    required this.childId,
    required this.foodId,
    required this.mealTime,
    required this.dateTime,
    required this.qty,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'childId': childId,
      'foodId': foodId,
      'mealTime': mealTime,
      'dateTime': dateTime,
      'qty': qty,
    };
  }

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      id: map['id'],
      childId: map['childId'],
      foodId: map['foodId'],
      mealTime: map['mealTime'],
      dateTime: map['dateTime'],
      qty: map['qty'],
    );
  }
}
