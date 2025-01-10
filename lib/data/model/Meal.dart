class Meal {
  late String id;
  late String childId;
  late String foodId;
  late String mealTime;
  late DateTime dateTime;
  late int qty;

  Meal(
      {required this.id,
      required this.childId,
      required this.foodId,
      required this.mealTime,
      required this.dateTime,
      required this.qty});

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

  Meal.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    childId = map['childId'];
    foodId = map['foodId'];
    mealTime = map['mealTime'];
    dateTime = map['dateTime'];
    qty = map['qty'];
  }
}
