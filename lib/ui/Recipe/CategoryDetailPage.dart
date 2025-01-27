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

      final recipe = await _apiService.getRecipeDetails(mealId);
      setState(() {
        selectedRecipe = recipe;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          if (selectedRecipe != null)
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                setState(() {
                  selectedRecipe = null;
                });
              },
            ),
        ],
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
          childAspectRatio = 0.85;
          padding = 12;
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
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () => _loadRecipeDetails(meal['idMeal']),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 3,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12)),
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
        Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  recipe.imageUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildNutritionInfo(
                              'Calories',
                              '${recipe.nutritionInfo.calories.round()}',
                              'kcal'),
                          _buildNutritionInfo('Protein',
                              '${recipe.nutritionInfo.protein.round()}', 'g'),
                          _buildNutritionInfo('Carbs',
                              '${recipe.nutritionInfo.carbs.round()}', 'g'),
                          _buildNutritionInfo('Fat',
                              '${recipe.nutritionInfo.fat.round()}', 'g'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Ingredients',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
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
                    const Text(
                      'Instructions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...recipe.instructions
                        .asMap()
                        .entries
                        .map((entry) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${entry.key + 1}.',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(entry.value)),
                                ],
                              ),
                            )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionInfo(String label, String value, String unit) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          unit,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
