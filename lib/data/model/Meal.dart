class Meal {
  late String id;
  late String childId;
  late String mealTime;
  late DateTime date;
  late int qty;

  Meal(
      {required this.id,
      required this.childId,
      required this.mealTime,
      required this.date,
      required this.qty});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'childId': childId,
      'mealTime': mealTime,
      'date': date,
      'qty': qty,
    };
  }

  Meal.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    childId = map['childId'];
    mealTime = map['mealTime'];
    date = map['date'];
    qty = map['qty'];
  }
}
