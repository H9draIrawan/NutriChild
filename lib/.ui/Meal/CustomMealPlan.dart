import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrichild/bloc/auth/auth_state.dart';
import 'package:nutrichild/bloc/food/food_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/food/food_state.dart';
import 'ChooseNewPlan.dart';

class CustomMealPlan extends StatelessWidget {
  final String name;
  final String calories;
  final String imageUrl;
  final String protein;
  final String carbs;
  final String fat;

  const CustomMealPlan({
    super.key,
    required this.name,
    required this.calories,
    required this.imageUrl,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController mealController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.local_fire_department,
                                  color: Colors.orange.shade700,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Calories',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.orange.shade700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$calories kcal',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(child: _buildNutrientInfo('Protein', protein, 'g')),
                          Expanded(child: _buildNutrientInfo('Carbs', carbs, 'g')),
                          Expanded(child: _buildNutrientInfo('Fat', fat, 'g')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Amount of meals',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: mealController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter number of meals',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[800],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    FoodBloc foodBloc =
                        BlocProvider.of<FoodBloc>(context);
                    AuthBloc authBloc =
                        BlocProvider.of<AuthBloc>(context);

                    if (authBloc.state is LoginAuthState) {
                      final prefs =
                          await SharedPreferences.getInstance();

                      if (foodBloc.state is InitialBreakfastState) {
                        await prefs.setString('breakfast_name', name);
                        await prefs.setString(
                            'breakfast_calories', calories);
                        await prefs.setString(
                            'breakfast_protein', protein);
                        await prefs.setString('breakfast_carbs', carbs);
                        await prefs.setString('breakfast_fat', fat);
                        await prefs.setString(
                            'breakfast_image', imageUrl);
                        await prefs.setInt('breakfast_amount',
                            int.parse(mealController.text.trim()));
                      } else if (foodBloc.state is InitialLunchState) {
                        await prefs.setString('lunch_name', name);
                        await prefs.setString(
                            'lunch_calories', calories);
                        await prefs.setString('lunch_protein', protein);
                        await prefs.setString('lunch_carbs', carbs);
                        await prefs.setString('lunch_fat', fat);
                        await prefs.setString('lunch_image', imageUrl);
                        await prefs.setInt('lunch_amount',
                            int.parse(mealController.text.trim()));
                      } else if (foodBloc.state is InitialDinnerState) {
                        await prefs.setString('dinner_name', name);
                        await prefs.setString(
                            'dinner_calories', calories);
                        await prefs.setString(
                            'dinner_protein', protein);
                        await prefs.setString('dinner_carbs', carbs);
                        await prefs.setString('dinner_fat', fat);
                        await prefs.setString('dinner_image', imageUrl);
                        await prefs.setInt('dinner_amount',
                            int.parse(mealController.text.trim()));
                      }
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChooseNewPlan()),
                    );
                  },
                  child: const Text(
                    'CONTINUE',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutrientInfo(String label, String value, String unit) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (label.toLowerCase()) {
      case 'protein':
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade700;
        icon = Icons.egg_outlined;
        break;
      case 'carbs':
        backgroundColor = Colors.blue.shade100;
        textColor = Colors.blue.shade700;
        icon = Icons.breakfast_dining;
        break;
      case 'fat':
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade700;
        icon = Icons.opacity;
        break;
      default:
        backgroundColor = Colors.orange.shade50;
        textColor = Colors.orange.shade700;
        icon = Icons.local_fire_department;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: textColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 24,
            color: textColor,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                TextSpan(
                  text: unit,
                  style: TextStyle(
                    fontSize: 12,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
