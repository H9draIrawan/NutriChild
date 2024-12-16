class Article {
  String Food_Name;
  double? Serving_Qty;
  String? Serving_Unit;
  double? Calories;
  double? Fats;
  double? Protein;
  double? Carbohydrate;

  Article({
    required this.Food_Name,
    this.Serving_Qty,
    this.Serving_Unit,
    this.Calories,
    this.Fats,
    this.Protein,
    this.Carbohydrate,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        Food_Name: json['food_name'] ?? '',
        Serving_Qty: json['serving_qty']?.toDouble(),
        Serving_Unit: json['serving_unit'],
        Calories: json['nf_calories']?.toDouble(),
        Fats: json['nf_total_fat']?.toDouble(),
        Protein: json['nf_protein']?.toDouble(),
        Carbohydrate: json['nf_total_carbohydrate']?.toDouble(),
      );

  @override
  String toString() {
    return 'Article(Food_Name: $Food_Name, Calories: $Calories, Protein: $Protein)';
  }
}
