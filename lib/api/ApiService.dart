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
    final url = Uri.parse("https://www.themealdb.com/api/json/v1/1/categories.php");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Category> categories = (data['categories'] as List)
            .map((category) => Category.fromJson(category))
            .toList();
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
