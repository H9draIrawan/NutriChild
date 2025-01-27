import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nutrichild/model/ArticleResult.dart';
import 'package:nutrichild/model/Category.dart';

class ApiService {
  static const String apiKey = "41e1f1b636539e82c15d60b757958247";

  Future<ArticleResult> topHeadlines(String item) async {
    final url = Uri.parse(
        "https://trackapi.nutritionix.com/v2/search/instant/?query=$item");
    final headers = {
      'x-app-id': 'b55062a2',
      'x-app-key': apiKey,
      'Content-Type': 'application/json'
    };

    try {
      final response = await http.get(url, headers: headers);
      print("Raw Response: ${response.body}"); // Untuk debugging

      if (response.statusCode == 200) {
        final searchResult = ArticleResult.fromJson(json.decode(response.body));

        // Get nutrition data for all items
        for (var article in searchResult.articles) {
          final nutrientUrl = Uri.parse(
              "https://trackapi.nutritionix.com/v2/natural/nutrients");
          try {
            final nutrientResponse = await http.post(nutrientUrl,
                headers: headers,
                body: json.encode({"query": article.Food_Name}));

            if (nutrientResponse.statusCode == 200) {
              final nutrientData = json.decode(nutrientResponse.body);
              if (nutrientData['foods'] != null &&
                  nutrientData['foods'].isNotEmpty) {
                final food = nutrientData['foods'][0];
                article.Calories = food['nf_calories']?.toDouble();
                article.Protein = food['nf_protein']?.toDouble();
                article.Fats = food['nf_total_fat']?.toDouble();
                article.Carbohydrate =
                    food['nf_total_carbohydrate']?.toDouble();
                article.Serving_Qty = food['serving_qty']?.toDouble();
                article.Serving_Unit = food['serving_unit'];
              }
            }
          } catch (e) {
            print("Error getting nutrients for ${article.Food_Name}: $e");
            continue;
          }
        }

        return searchResult;
      } else {
        throw Exception(
            'Failed to load data from Nutritionix: ${response.statusCode}');
      }
    } catch (e) {
      print("API Error: $e");
      throw Exception('Failed to connect to the server');
    }
  }

  Future<List<Category>> fetchCategories() async {
    final url =
        Uri.parse("https://www.themealdb.com/api/json/v1/1/categories.php");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Category> categories = (data['categories'] as List)
            .map((category) => Category.fromJson(category))
            .toList();

        // Add custom categories
        categories.addAll([
          Category(
              idCategory: "custom1",
              strCategory: "Healthy Breakfast",
              strCategoryThumb:
                  "https://images.unsplash.com/photo-1494859802809-d069c3b71a8a?w=500&h=500&fit=crop"),
          Category(
              idCategory: "custom2",
              strCategory: "Quick & Easy",
              strCategoryThumb:
                  "https://images.unsplash.com/photo-1498837167922-ddd27525d352?w=500&h=500&fit=crop"),
          Category(
              idCategory: "custom3",
              strCategory: "Kids Favorite",
              strCategoryThumb:
                  "https://images.unsplash.com/photo-1606787366850-de6330128bfc?w=500&h=500&fit=crop"),
          Category(
              idCategory: "custom4",
              strCategory: "Low Calorie",
              strCategoryThumb:
                  "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=500&h=500&fit=crop"),
          Category(
              idCategory: "custom5",
              strCategory: "High Protein",
              strCategoryThumb:
                  "https://images.unsplash.com/photo-1432139555190-58524dae6a55?w=500&h=500&fit=crop"),
          Category(
              idCategory: "custom6",
              strCategory: "Vegetarian",
              strCategoryThumb:
                  "https://images.unsplash.com/photo-1540420773420-3366772f4999?w=500&h=500&fit=crop"),
          Category(
              idCategory: "custom7",
              strCategory: "Snacks",
              strCategoryThumb:
                  "https://images.unsplash.com/photo-1621939514649-280e2ee25f60?w=500&h=500&fit=crop"),
          Category(
              idCategory: "custom8",
              strCategory: "Smoothies",
              strCategoryThumb:
                  "https://images.unsplash.com/photo-1553530666-ba11a7da3888?w=500&h=500&fit=crop"),
        ]);

        return categories;
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      print("API Error: $e");
      throw Exception('Failed to connect to the server');
    }
  }
}
