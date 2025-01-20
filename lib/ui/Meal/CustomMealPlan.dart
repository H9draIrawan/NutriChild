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

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Background image
            SizedBox(
              height: 250,
              width: double.infinity,
              child: Image.asset(
                'assets/images/pic1.png',
                fit: BoxFit.cover,
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 200), // Push card below the image
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      color: Colors.white,
                      shadowColor: Colors.black.withOpacity(0.2),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'My mealplan',
                                  style: TextStyle(
                                    fontFamily: 'WorkSans',
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.red[800],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Description',
                              style: TextStyle(
                                fontFamily: 'WorkSans',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Thin and lean. Plan for a "skinny guy" who have a hard time gaining weight.',
                              style: TextStyle(
                                fontFamily: 'WorkSans',
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Amount of meals',
                              style: TextStyle(
                                fontFamily: 'WorkSans',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: mealController,
                              decoration: InputDecoration(
                                hintText: 'Fill amount of meals',
                                hintStyle: const TextStyle(
                                    fontFamily: 'WorkSans',
                                    fontSize: 16,
                                    color: Colors.grey),
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 32),
                    child: SizedBox(
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
                            final prefs = await SharedPreferences.getInstance();

                            if (foodBloc.state is InitialBreakfastState) {
                              await prefs.setString('breakfast_name', name);
                              await prefs.setString(
                                  'breakfast_calories', calories);
                              await prefs.setString(
                                  'breakfast_protein', protein);
                              await prefs.setString(
                                  'breakfast_carbs', carbs);
                              await prefs.setString(
                                  'breakfast_fat', fat);
                              await prefs.setString(
                                  'breakfast_image', imageUrl);
                              await prefs.setInt('breakfast_amount',
                                  int.parse(mealController.text.trim()));
                            } else if (foodBloc.state is InitialLunchState) {
                              await prefs.setString('lunch_name', name);
                              await prefs.setString('lunch_calories', calories);
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
                              await prefs.setString(
                                  'dinner_image', imageUrl);
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealCard(String name, String calories, String imageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        color: Colors.white,
        shadowColor: Colors.black.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontFamily: 'WorkSans',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Calories: $calories',
                style: const TextStyle(
                  fontFamily: 'WorkSans',
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              Image.network(imageUrl),
            ],
          ),
        ),
      ),
    );
  }
}
