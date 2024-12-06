class Nutrition {
  String? name;
  double? calories;
  double? servingSizeG;
  double? fatTotalG;
  double? fatSaturatedG;
  int? proteinG;
  int? sodiumMg;
  int? potassiumMg;
  int? cholesterolMg;
  int? carbohydratesTotalG;
  int? fiberG;
  int? sugarG;

  Nutrition(
      {this.name,
      this.calories,
      this.servingSizeG,
      this.fatTotalG,
      this.fatSaturatedG,
      this.proteinG,
      this.sodiumMg,
      this.potassiumMg,
      this.cholesterolMg,
      this.carbohydratesTotalG,
      this.fiberG,
      this.sugarG});

  Nutrition.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    calories = json['calories'];
    servingSizeG = json['serving_size_g'];
    fatTotalG = json['fat_total_g'];
    fatSaturatedG = json['fat_saturated_g'];
    proteinG = json['protein_g'];
    sodiumMg = json['sodium_mg'];
    potassiumMg = json['potassium_mg'];
    cholesterolMg = json['cholesterol_mg'];
    carbohydratesTotalG = json['carbohydrates_total_g'];
    fiberG = json['fiber_g'];
    sugarG = json['sugar_g'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['calories'] = this.calories;
    data['serving_size_g'] = this.servingSizeG;
    data['fat_total_g'] = this.fatTotalG;
    data['fat_saturated_g'] = this.fatSaturatedG;
    data['protein_g'] = this.proteinG;
    data['sodium_mg'] = this.sodiumMg;
    data['potassium_mg'] = this.potassiumMg;
    data['cholesterol_mg'] = this.cholesterolMg;
    data['carbohydrates_total_g'] = this.carbohydratesTotalG;
    data['fiber_g'] = this.fiberG;
    data['sugar_g'] = this.sugarG;
    return data;
  }
}
