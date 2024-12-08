import 'dart:ui';

class Article {
  String Food_Name;
  int Serving_Qty;
  int Serving_Unit;
  int Calories;
  int Fats;
  int Protein;
  int Carbohydrate;
  // Image Thumbnail;

  Article(
      {
        required this.Food_Name,
        required this.Serving_Qty,
        required this.Serving_Unit,
        required this.Calories,
        required this.Fats,
        required this.Protein,
        required this.Carbohydrate,
        // required this.Thumbnail,
      });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
    Food_Name : json['food_name'],
    Serving_Qty : json['serving_qty'],
    Serving_Unit : json['serving_unit'],
    Calories : json['calories'],
    Fats : json['fats'],
    Protein : json['protein'],
    Carbohydrate : json['carbohydrate'],
    // Thumbnail : json['image'], .photo.thumb
  );
}

