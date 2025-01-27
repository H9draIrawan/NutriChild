import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nutrichild/model/ArticleResult.dart';
import 'package:nutrichild/model/Category.dart';
import 'package:nutrichild/model/Recipe.dart';

class ApiService {
  static const String apiKey = "41e1f1b636539e82c15d60b757958247";
  static const String cohereApiKey =
      "YOUR_COHERE_API_KEY"; // Replace with your Cohere API key

  final client = http.Client();

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

  Future<List<Recipe>> getRecipesByCategory(String category) async {
    final url = Uri.parse(
        "https://www.themealdb.com/api/json/v1/1/filter.php?c=$category");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Recipe> recipes = [];

        if (data['meals'] != null) {
          for (var meal in data['meals']) {
            // Get full recipe details
            final recipeDetails = await getRecipeDetails(meal['idMeal']);
            if (recipeDetails != null) {
              recipes.add(recipeDetails);
            }
          }
        }

        return recipes;
      } else {
        throw Exception('Failed to load recipes: ${response.statusCode}');
      }
    } catch (e) {
      print("API Error: $e");
      throw Exception('Failed to connect to the server');
    }
  }

  Future<Recipe?> getRecipeDetails(String id) async {
    final url =
        Uri.parse("https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null && data['meals'].isNotEmpty) {
          var mealData = data['meals'][0];

          // Get nutrition info using Nutritionix
          var nutritionInfo = await getNutritionInfo(mealData['strMeal']);
          mealData.addAll(nutritionInfo);

          // If nutrition info is not available, generate it using Cohere
          if (nutritionInfo['calories'] == 0) {
            nutritionInfo = await generateNutritionInfo(mealData['strMeal'],
                List<String>.from(_extractIngredients(mealData)));
            mealData.addAll(nutritionInfo);
          }

          return Recipe.fromJson(mealData);
        }
      }
    } catch (e) {
      print("API Error: $e");
    }
    return null;
  }

  Future<Map<String, dynamic>> getNutritionInfo(String recipeName) async {
    final url =
        Uri.parse("https://trackapi.nutritionix.com/v2/natural/nutrients");
    final headers = {
      'x-app-id': 'b55062a2',
      'x-app-key': apiKey,
      'Content-Type': 'application/json'
    };

    try {
      final response = await http.post(url,
          headers: headers, body: json.encode({"query": recipeName}));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['foods'] != null && data['foods'].isNotEmpty) {
          final food = data['foods'][0];
          return {
            'calories': food['nf_calories'] ?? 0,
            'protein': food['nf_protein'] ?? 0,
            'carbs': food['nf_total_carbohydrate'] ?? 0,
            'fat': food['nf_total_fat'] ?? 0,
          };
        }
      }
    } catch (e) {
      print("Error getting nutrition info: $e");
    }
    return {
      'calories': 0,
      'protein': 0,
      'carbs': 0,
      'fat': 0,
    };
  }

  Future<Map<String, dynamic>> generateNutritionInfo(
      String recipeName, List<String> ingredients) async {
    final url = Uri.parse("https://api.cohere.ai/v1/generate");
    final headers = {
      'Authorization': 'Bearer $cohereApiKey',
      'Content-Type': 'application/json'
    };

    final prompt = '''
    Given this recipe name and ingredients, estimate its nutritional value per serving:
    Recipe: $recipeName
    Ingredients: ${ingredients.join(', ')}
    
    Provide nutritional estimates in this format:
    Calories: [number]
    Protein: [number]g
    Carbs: [number]g
    Fat: [number]g
    ''';

    try {
      final response = await http.post(url,
          headers: headers,
          body: json.encode({
            "model": "command",
            "prompt": prompt,
            "max_tokens": 100,
            "temperature": 0.3,
          }));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final generatedText = data['generations'][0]['text'];

        // Parse the generated nutrition info
        final caloriesMatch =
            RegExp(r'Calories: (\d+)').firstMatch(generatedText);
        final proteinMatch =
            RegExp(r'Protein: (\d+)g').firstMatch(generatedText);
        final carbsMatch = RegExp(r'Carbs: (\d+)g').firstMatch(generatedText);
        final fatMatch = RegExp(r'Fat: (\d+)g').firstMatch(generatedText);

        return {
          'calories': double.tryParse(caloriesMatch?.group(1) ?? '0') ?? 0,
          'protein': double.tryParse(proteinMatch?.group(1) ?? '0') ?? 0,
          'carbs': double.tryParse(carbsMatch?.group(1) ?? '0') ?? 0,
          'fat': double.tryParse(fatMatch?.group(1) ?? '0') ?? 0,
        };
      }
    } catch (e) {
      print("Error generating nutrition info: $e");
    }

    return {
      'calories': 0,
      'protein': 0,
      'carbs': 0,
      'fat': 0,
    };
  }

  static List<String> _extractIngredients(Map<String, dynamic> json) {
    List<String> ingredients = [];
    for (int i = 1; i <= 20; i++) {
      String? ingredient = json['strIngredient$i'];
      String? measure = json['strMeasure$i'];
      if (ingredient != null && ingredient.trim().isNotEmpty) {
        ingredients.add('${measure?.trim() ?? ''} ${ingredient.trim()}');
      }
    }
    return ingredients;
  }
}
