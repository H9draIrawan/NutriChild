import 'package:flutter/material.dart';
import 'package:nutrichild/api/ApiService.dart';
import 'package:nutrichild/model/Recipe.dart';
import 'dart:convert';

class CategoryDetailPage extends StatefulWidget {
  final String category;

  const CategoryDetailPage({super.key, required this.category});

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  final ApiService _apiService = ApiService();
  List<dynamic> meals = [];
  Recipe? selectedRecipe;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadMeals();
  }

  Future<void> _loadMeals() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final url = Uri.parse(
          "https://www.themealdb.com/api/json/v1/1/filter.php?c=${widget.category}");
      final response = await _apiService.client.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          meals = data['meals'] ?? [];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load meals');
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _loadRecipeDetails(String mealId) async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final url = Uri.parse(
          "https://www.themealdb.com/api/json/v1/1/lookup.php?i=$mealId");
      final response = await _apiService.client.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null && data['meals'].isNotEmpty) {
          final mealData = data['meals'][0];
          print("Meal Data: $mealData"); // Debug print

          // Extract ingredients and measures
          List<String> ingredients = [];
          for (int i = 1; i <= 20; i++) {
            final ingredient = mealData['strIngredient$i'];
            final measure = mealData['strMeasure$i'];

            if (ingredient != null &&
                ingredient.toString().trim().isNotEmpty &&
                ingredient.toString() != "null") {
              if (measure != null &&
                  measure.toString().trim().isNotEmpty &&
                  measure.toString() != "null") {
                ingredients.add('$measure $ingredient');
              } else {
                ingredients.add(ingredient.toString());
              }
            }
          }

          // Split instructions into steps and clean them
          final instructions = mealData['strInstructions']
              .toString()
              .split(RegExp(r'(?:\r\n|\r|\n|\.)\s*'))
              .where((step) => step.trim().isNotEmpty)
              .map((step) => step.trim())
              .toList();

          setState(() {
            selectedRecipe = Recipe(
              id: mealId,
              name: mealData['strMeal'] ?? '',
              category: widget.category,
              imageUrl: mealData['strMealThumb'] ?? '',
              ingredients: ingredients,
              instructions: instructions,
              nutritionInfo: NutritionInfo(
                calories: 0,
                protein: 0,
                carbs: 0,
                fat: 0,
              ),
            );
            isLoading = false;
          });
        } else {
          throw Exception('No recipe details found');
        }
      } else {
        throw Exception(
            'Failed to load recipe details: ${response.statusCode}');
      }
    } catch (e) {
      print("Error loading recipe: $e"); // Debug print
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<Map<String, double>> _getNutritionFromCohere(Recipe recipe) async {
    try {
      final prompt = '''
Analyze this recipe and estimate its nutritional values per serving:

Ingredients:
${recipe.ingredients.join('\n')}

Instructions:
${recipe.instructions.join('\n')}

Based on these ingredients and cooking method, provide only the following nutritional values per serving.
Return ONLY the values in this exact format (numbers only, no text):
calories: [number]
protein: [number]
carbs: [number]
fat: [number]
fiber: [number]
''';

      final url = Uri.parse('https://api.cohere.ai/v1/generate');
      final response = await _apiService.client.post(
        url,
        headers: {
          'Authorization': 'Bearer 7DNoJE0QGQI0roKdN4shT9JW0SU7FNUldPcYyr0V',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'model': 'command',
          'prompt': prompt,
          'max_tokens': 100,
          'temperature': 0.3,
          'stop_sequences': ['\\n\\n']
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final generatedText = data['generations'][0]['text'].toString().trim();

        // Parse the response
        final Map<String, double> nutrition = {};
        final lines = generatedText.split('\n');

        for (var line in lines) {
          if (line.contains(':')) {
            final parts = line.split(':');
            if (parts.length == 2) {
              final key = parts[0].trim();
              final value = double.tryParse(parts[1].trim()) ?? 0.0;
              nutrition[key] = value;
            }
          }
        }

        // Ensure all required fields are present
        return {
          'calories': nutrition['calories'] ?? 0.0,
          'protein': nutrition['protein'] ?? 0.0,
          'carbs': nutrition['carbs'] ?? 0.0,
          'fat': nutrition['fat'] ?? 0.0,
          'fiber': nutrition['fiber'] ?? 0.0,
        };
      } else {
        print('Cohere API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to get nutrition information');
      }
    } catch (e) {
      print('Error getting nutrition info: $e');
      return {
        'calories': 0,
        'protein': 0,
        'carbs': 0,
        'fat': 0,
        'fiber': 0,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedRecipe?.name ?? widget.category),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: selectedRecipe != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    selectedRecipe = null;
                  });
                },
              )
            : null,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          size: 48, color: Colors.red[300]),
                      const SizedBox(height: 16),
                      Text(error!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: selectedRecipe == null
                            ? _loadMeals
                            : () => _loadRecipeDetails(selectedRecipe!.id),
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                )
              : selectedRecipe != null
                  ? _buildRecipeDetails(selectedRecipe!)
                  : _buildMealsList(),
    );
  }

  Widget _buildMealsList() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate number of columns based on screen width
        int crossAxisCount;
        double childAspectRatio;
        double padding;

        if (constraints.maxWidth > 1800) {
          // Extra large desktop
          crossAxisCount = 8;
          childAspectRatio = 0.85;
          padding = 24;
        } else if (constraints.maxWidth > 1400) {
          // Large desktop
          crossAxisCount = 6;
          childAspectRatio = 0.85;
          padding = 20;
        } else if (constraints.maxWidth > 1100) {
          // Desktop
          crossAxisCount = 4;
          childAspectRatio = 0.85;
          padding = 16;
        } else if (constraints.maxWidth > 800) {
          // Tablet landscape
          crossAxisCount = 3;
          childAspectRatio = 0.85;
          padding = 16;
        } else if (constraints.maxWidth > 600) {
          // Tablet portrait
          crossAxisCount = 2;
          childAspectRatio = 0.85;
          padding = 16;
        } else {
          // Mobile
          crossAxisCount = 2;
          childAspectRatio = 0.7;
          padding = 8;
        }

        return GridView.builder(
          padding: EdgeInsets.all(padding),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: padding,
            mainAxisSpacing: padding,
          ),
          itemCount: meals.length,
          itemBuilder: (context, index) {
            final meal = meals[index];
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: InkWell(
                onTap: () => _loadRecipeDetails(meal['idMeal']),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 2,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8)),
                        child: Image.network(
                          meal['strMealThumb'],
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          meal['strMeal'],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRecipeDetails(Recipe recipe) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Ingredients Section
        const Text(
          'Ingredients',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...recipe.ingredients.map((ingredient) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.fiber_manual_record, size: 8),
                  const SizedBox(width: 8),
                  Expanded(child: Text(ingredient)),
                ],
              ),
            )),

        const SizedBox(height: 24),

        // Instructions Section
        const Text(
          'Instructions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...recipe.instructions.asMap().entries.map((entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${entry.key + 1}.',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: const TextStyle(height: 1.5),
                    ),
                  ),
                ],
              ),
            )),

        const SizedBox(height: 24),

        // Nutrition Section
        const Text(
          'Nutrition Information (per serving)',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        FutureBuilder<Map<String, double>>(
          future: _getNutritionFromCohere(recipe),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return const Text('Unable to load nutrition information');
            }

            final nutrition = snapshot.data!;
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  _buildNutritionRow('Calories',
                      '${nutrition['calories']?.round() ?? 0}', 'kcal'),
                  _buildNutritionRow(
                      'Protein', '${nutrition['protein']?.round() ?? 0}', 'g'),
                  _buildNutritionRow('Carbohydrates',
                      '${nutrition['carbs']?.round() ?? 0}', 'g'),
                  _buildNutritionRow(
                      'Fat', '${nutrition['fat']?.round() ?? 0}', 'g'),
                  _buildNutritionRow(
                      'Fiber', '${nutrition['fiber']?.round() ?? 0}', 'g'),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNutritionRow(String label, String value, String unit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            '$value $unit',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
