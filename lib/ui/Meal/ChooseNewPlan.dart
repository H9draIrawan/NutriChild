import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrichild/database/database_food.dart';
import 'package:nutrichild/database/database_meal.dart';
import 'package:nutrichild/model/Food.dart';
import 'package:nutrichild/model/Meal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../bloc/food/food_bloc.dart';
import '../../bloc/food/food_event.dart';
import '../../bloc/child/child_bloc.dart';
import '../../bloc/child/child_state.dart';
import 'SearchMealCustom.dart';

class ChooseNewPlan extends StatefulWidget {
  const ChooseNewPlan({super.key});

  @override
  State<ChooseNewPlan> createState() => _ChooseNewPlanState();
}

class _ChooseNewPlanState extends State<ChooseNewPlan> {
  final CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final FoodSqflite foodSqflite = FoodSqflite();
  final MealSqflite mealSqflite = MealSqflite();

  Meal? selectedBreakfast;
  Meal? selectedLunch;
  Meal? selectedDinner;

  // Tambahkan variabel untuk menyimpan data dari SharedPreferences
  Map<String, String> breakfastData = {};
  Map<String, String> lunchData = {};
  Map<String, String> dinnerData = {};
  Map<String, int> mealAmounts = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _loadMealsForSelectedDay();
    _loadSavedMeals(); // Tambahkan ini
  }

  Future<void> _loadMealsForSelectedDay() async {
    if (_selectedDay == null) return;

    final dateStr =
        "${_selectedDay!.year}-${_selectedDay!.month.toString().padLeft(2, '0')}-${_selectedDay!.day.toString().padLeft(2, '0')}";
    final meals = await mealSqflite.getMealsByDate('default', dateStr);

    setState(() {
      selectedBreakfast =
          meals.where((meal) => meal.mealTime == 'Breakfast').isEmpty
              ? null
              : meals.firstWhere((meal) => meal.mealTime == 'Breakfast');

      selectedLunch = meals.where((meal) => meal.mealTime == 'Lunch').isEmpty
          ? null
          : meals.firstWhere((meal) => meal.mealTime == 'Lunch');

      selectedDinner = meals.where((meal) => meal.mealTime == 'Dinner').isEmpty
          ? null
          : meals.firstWhere((meal) => meal.mealTime == 'Dinner');
    });
  }

  // Tambahkan fungsi untuk memuat data dari SharedPreferences
  Future<void> _loadSavedMeals() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      // Load breakfast data
      breakfastData = {
        'name': prefs.getString('breakfast_name') ?? '',
        'calories': prefs.getString('breakfast_calories') ?? '',
        'protein': prefs.getString('breakfast_protein') ?? '',
        'carbs': prefs.getString('breakfast_carbs') ?? '',
        'fat': prefs.getString('breakfast_fat') ?? '',
        'image': prefs.getString('breakfast_image') ?? '',
      };

      // Load lunch data
      lunchData = {
        'name': prefs.getString('lunch_name') ?? '',
        'calories': prefs.getString('lunch_calories') ?? '',
        'protein': prefs.getString('lunch_protein') ?? '',
        'carbs': prefs.getString('lunch_carbs') ?? '',
        'fat': prefs.getString('lunch_fat') ?? '',
        'image': prefs.getString('lunch_image') ?? '',
      };

      // Load dinner data
      dinnerData = {
        'name': prefs.getString('dinner_name') ?? '',
        'calories': prefs.getString('dinner_calories') ?? '',
        'protein': prefs.getString('dinner_protein') ?? '',
        'carbs': prefs.getString('dinner_carbs') ?? '',
        'fat': prefs.getString('dinner_fat') ?? '',
        'image': prefs.getString('dinner_image') ?? '',
      };

      // Load meal amounts
      mealAmounts = {
        'breakfast': prefs.getInt('breakfast_amount') ?? 0,
        'lunch': prefs.getInt('lunch_amount') ?? 0,
        'dinner': prefs.getInt('dinner_amount') ?? 0,
      };
    });
  }

  Future<void> _clearSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    // Clear breakfast data
    await prefs.remove('breakfast_name');
    await prefs.remove('breakfast_calories');
    await prefs.remove('breakfast_protein');
    await prefs.remove('breakfast_carbs');
    await prefs.remove('breakfast_fat');
    await prefs.remove('breakfast_image');
    await prefs.remove('breakfast_amount');

    // Clear lunch data
    await prefs.remove('lunch_name');
    await prefs.remove('lunch_calories');
    await prefs.remove('lunch_protein');
    await prefs.remove('lunch_carbs');
    await prefs.remove('lunch_fat');
    await prefs.remove('lunch_image');
    await prefs.remove('lunch_amount');

    // Clear dinner data
    await prefs.remove('dinner_name');
    await prefs.remove('dinner_calories');
    await prefs.remove('dinner_protein');
    await prefs.remove('dinner_carbs');
    await prefs.remove('dinner_fat');
    await prefs.remove('dinner_image');
    await prefs.remove('dinner_amount');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            await _clearSharedPreferences();
            Navigator.popUntil(context, (route) {
              return route.isFirst || route.settings.name == '/';
            });
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
                focusedDay: _focusedDay,
                firstDay: DateTime.now().subtract(const Duration(days: 365)),
                lastDay: DateTime.now().add(const Duration(days: 365)),
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  _loadMealsForSelectedDay();
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                }),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildMealCard(selectedBreakfast, 'Breakfast'),
                  const SizedBox(height: 16),
                  _buildMealCard(selectedLunch, 'Lunch'),
                  const SizedBox(height: 16),
                  _buildMealCard(selectedDinner, 'Dinner'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildNutritionSummary(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[800],
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: () async {
            try {
              if (_selectedDay != null) {
                final dateStr =
                    "${_selectedDay!.year}-${_selectedDay!.month.toString().padLeft(2, '0')}-${_selectedDay!.day.toString().padLeft(2, '0')}";

                final childBloc =
                    BlocProvider.of<ChildBloc>(context).state as LoadChildState;
                final foodBloc = BlocProvider.of<FoodBloc>(context);

                // Tunggu sampai data lama terhapus
                final meals = await mealSqflite.getMealsByDate(
                    childBloc.child.id, dateStr);
                for (var meal in meals) {
                  await foodSqflite.deleteFoodById(meal.foodId);
                }
                await mealSqflite.deleteMealsByDate(
                    childBloc.child.id, dateStr);

                // Simpan data baru secara berurutan
                if (breakfastData['name']?.isNotEmpty == true) {
                  await _saveMeal(
                      foodBloc, childBloc, breakfastData, 'Breakfast');
                }
                if (lunchData['name']?.isNotEmpty == true) {
                  await _saveMeal(foodBloc, childBloc, lunchData, 'Lunch');
                }
                if (dinnerData['name']?.isNotEmpty == true) {
                  await _saveMeal(foodBloc, childBloc, dinnerData, 'Dinner');
                }

                // Tampilkan pesan sukses setelah semua operasi selesai
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Meal plan berhasil disimpan!')));

                Navigator.popUntil(context, (route) {
                  return route.isFirst || route.settings.name == '/';
                });
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error menyimpan rencana makan: $e')));
            }
          },
          child: const Text('Save',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
        ),
      ),
    );
  }

  Widget _buildMealCard(Meal? meal, String type) {
    Map<String, String> savedData;
    int? amount;

    switch (type) {
      case 'Breakfast':
        savedData = breakfastData;
        amount = mealAmounts['breakfast'];
        break;
      case 'Lunch':
        savedData = lunchData;
        amount = mealAmounts['lunch'];
        break;
      case 'Dinner':
        savedData = dinnerData;
        amount = mealAmounts['dinner'];
        break;
      default:
        savedData = {};
        amount = 0;
    }

    // Tampilkan data dari SharedPreferences jika tidak ada meal dari database
    if (meal == null && savedData['name']?.isNotEmpty == true) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  savedData['image']?.isNotEmpty == true
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            savedData['image']!,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.red[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.restaurant,
                              color: Colors.red[800], size: 48),
                        ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          savedData['name'] ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          type,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.grey[600]),
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();

                      // Hapus data dari SharedPreferences sesuai dengan tipe meal
                      if (type == 'Breakfast') {
                        await prefs.remove('breakfast_name');
                        await prefs.remove('breakfast_calories');
                        await prefs.remove('breakfast_protein');
                        await prefs.remove('breakfast_carbs');
                        await prefs.remove('breakfast_fat');
                        await prefs.remove('breakfast_image');
                        await prefs.remove('breakfast_amount');
                        setState(() {
                          selectedBreakfast = null;
                        });
                      } else if (type == 'Lunch') {
                        await prefs.remove('lunch_name');
                        await prefs.remove('lunch_calories');
                        await prefs.remove('lunch_protein');
                        await prefs.remove('lunch_carbs');
                        await prefs.remove('lunch_fat');
                        await prefs.remove('lunch_image');
                        await prefs.remove('lunch_amount');
                        setState(() {
                          selectedLunch = null;
                        });
                      } else if (type == 'Dinner') {
                        await prefs.remove('dinner_name');
                        await prefs.remove('dinner_calories');
                        await prefs.remove('dinner_protein');
                        await prefs.remove('dinner_carbs');
                        await prefs.remove('dinner_fat');
                        await prefs.remove('dinner_image');
                        await prefs.remove('dinner_amount');
                        setState(() {
                          selectedDinner = null;
                        });
                      }

                      // Reload data setelah menghapus
                      _loadSavedMeals();
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Kalori di bawah gambar
              Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.orange[100]!,
                      Colors.orange[50]!,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      color: Colors.orange[700],
                      size: 28,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${savedData['calories']} kcal',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.orange[700],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              // Nutrisi lainnya
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNutrientInfo(
                      icon: Icons.egg_outlined,
                      value: '${savedData['protein']}',
                      unit: 'g protein',
                      color: Colors.red,
                    ),
                    _buildNutrientInfo(
                      icon: Icons.breakfast_dining,
                      value: '${savedData['carbs']}',
                      unit: 'g carbs',
                      color: Colors.blue,
                    ),
                    _buildNutrientInfo(
                      icon: Icons.opacity,
                      value: '${savedData['fat']}',
                      unit: 'g fat',
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
              if (amount != null && amount > 0) ...[
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.red[400]!,
                        Colors.red[300]!,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red[200]!.withOpacity(0.5),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.restaurant,
                        size: 18,
                        color: Colors.white,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Portion: $amount',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    // Tampilkan card kosong jika tidak ada data
    if (meal == null) {
      // Tentukan warna berdasarkan tipe makanan
      Color backgroundColor;
      Color iconColor;
      Color textColor;

      switch (type) {
        case 'Breakfast':
          backgroundColor = Colors.orange[50]!;
          iconColor = Colors.orange[800]!;
          textColor = Colors.orange[800]!;
          break;
        case 'Lunch':
          backgroundColor = Colors.blue[50]!;
          iconColor = Colors.blue[800]!;
          textColor = Colors.blue[800]!;
          break;
        case 'Dinner':
          backgroundColor = Colors.purple[50]!;
          iconColor = Colors.purple[800]!;
          textColor = Colors.purple[800]!;
          break;
        default:
          backgroundColor = Colors.red[50]!;
          iconColor = Colors.red[800]!;
          textColor = Colors.red[800]!;
      }

      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        child: InkWell(
          onTap: () async {
            FoodBloc foodBloc = BlocProvider.of<FoodBloc>(context);
            if (type == 'Breakfast') {
              foodBloc.add(InitialBreakfastEvent());
            } else if (type == 'Lunch') {
              foodBloc.add(InitialLunchEvent());
            } else if (type == 'Dinner') {
              foodBloc.add(InitialDinnerEvent());
            }

            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchMealCustom(mealType: type),
              ),
            );

            if (result != null) {
              setState(() {
                switch (type) {
                  case 'Breakfast':
                    selectedBreakfast = result as Meal;
                    break;
                  case 'Lunch':
                    selectedLunch = result as Meal;
                    break;
                  case 'Dinner':
                    selectedDinner = result as Meal;
                    break;
                }
              });
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.add,
                    color: iconColor,
                    size: 40,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Add $type",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: textColor,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Tap to choose meal for $type",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Tampilkan data dari database jika ada
    return FutureBuilder<List<Food>>(
      future: foodSqflite.getFoodbyId(meal.foodId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: const ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: Text('Loading...'),
            ),
          );
        }

        final food = snapshot.data!.first;
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: SizedBox(
              width: 100,
              height: 100,
              child: food.imageUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        food.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: Colors.red[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.restaurant,
                        color: Colors.red[800],
                        size: 40,
                      ),
                    ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  food.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  type,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNutrientInfo(
                        icon: Icons.local_fire_department,
                        value: '${food.calories}',
                        unit: 'kcal',
                        color: Colors.orange,
                      ),
                      _buildNutrientInfo(
                        icon: Icons.egg_outlined,
                        value: '${food.protein}',
                        unit: 'g protein',
                        color: Colors.red,
                      ),
                      _buildNutrientInfo(
                        icon: Icons.breakfast_dining,
                        value: '${food.carbs}',
                        unit: 'g carbs',
                        color: Colors.blue,
                      ),
                      _buildNutrientInfo(
                        icon: Icons.opacity,
                        value: '${food.fat}',
                        unit: 'g fat',
                        color: Colors.green,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.close, color: Colors.grey[600]),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();

                // Hapus data dari SharedPreferences sesuai dengan tipe meal
                if (type == 'Breakfast') {
                  await prefs.remove('breakfast_name');
                  await prefs.remove('breakfast_calories');
                  await prefs.remove('breakfast_image');
                  await prefs.remove('breakfast_protein');
                  await prefs.remove('breakfast_carbs');
                  await prefs.remove('breakfast_fat');
                  await prefs.remove('breakfast_amount');
                  setState(() {
                    selectedBreakfast = null;
                  });
                } else if (type == 'Lunch') {
                  await prefs.remove('lunch_name');
                  await prefs.remove('lunch_calories');
                  await prefs.remove('lunch_image');
                  await prefs.remove('lunch_protein');
                  await prefs.remove('lunch_carbs');
                  await prefs.remove('lunch_fat');
                  await prefs.remove('lunch_amount');
                  setState(() {
                    selectedLunch = null;
                  });
                } else if (type == 'Dinner') {
                  await prefs.remove('dinner_name');
                  await prefs.remove('dinner_calories');
                  await prefs.remove('dinner_image');
                  await prefs.remove('dinner_protein');
                  await prefs.remove('dinner_carbs');
                  await prefs.remove('dinner_fat');
                  await prefs.remove('dinner_amount');
                  setState(() {
                    selectedDinner = null;
                  });
                }

                // Reload data setelah menghapus
                _loadSavedMeals();
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildNutrientInfo({
    required IconData icon,
    required String value,
    required String unit,
    required MaterialColor color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.shade100,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color.shade700,
            size: 24,
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: color.shade700,
            ),
          ),
          Text(
            unit,
            style: TextStyle(
              fontSize: 12,
              color: color.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionSummary() {
    double totalCalories = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;

    // Hitung dari data SharedPreferences
    if (breakfastData['calories']?.isNotEmpty == true) {
      totalCalories += double.parse(breakfastData['calories']!) *
          (mealAmounts['breakfast'] ?? 1);
      totalProtein += double.parse(breakfastData['protein']!) *
          (mealAmounts['breakfast'] ?? 1);
      totalCarbs += double.parse(breakfastData['carbs']!) *
          (mealAmounts['breakfast'] ?? 1);
      totalFat +=
          double.parse(breakfastData['fat']!) * (mealAmounts['breakfast'] ?? 1);
    }

    if (lunchData['calories']?.isNotEmpty == true) {
      totalCalories +=
          double.parse(lunchData['calories']!) * (mealAmounts['lunch'] ?? 1);
      totalProtein +=
          double.parse(lunchData['protein']!) * (mealAmounts['lunch'] ?? 1);
      totalCarbs +=
          double.parse(lunchData['carbs']!) * (mealAmounts['lunch'] ?? 1);
      totalFat += double.parse(lunchData['fat']!) * (mealAmounts['lunch'] ?? 1);
    }

    if (dinnerData['calories']?.isNotEmpty == true) {
      totalCalories +=
          double.parse(dinnerData['calories']!) * (mealAmounts['dinner'] ?? 1);
      totalProtein +=
          double.parse(dinnerData['protein']!) * (mealAmounts['dinner'] ?? 1);
      totalCarbs +=
          double.parse(dinnerData['carbs']!) * (mealAmounts['dinner'] ?? 1);
      totalFat +=
          double.parse(dinnerData['fat']!) * (mealAmounts['dinner'] ?? 1);
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[500]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNutrientSummaryItem(
                icon: Icons.local_fire_department,
                value: totalCalories.toStringAsFixed(1),
                unit: 'kcal',
                color: Colors.orange,
              ),
              _buildNutrientSummaryItem(
                icon: Icons.egg_outlined,
                value: totalProtein.toStringAsFixed(1),
                unit: 'g protein',
                color: Colors.red,
              ),
              _buildNutrientSummaryItem(
                icon: Icons.breakfast_dining,
                value: totalCarbs.toStringAsFixed(1),
                unit: 'g karbo',
                color: Colors.blue,
              ),
              _buildNutrientSummaryItem(
                icon: Icons.opacity,
                value: totalFat.toStringAsFixed(1),
                unit: 'g lemak',
                color: Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientSummaryItem({
    required IconData icon,
    required String value,
    required String unit,
    required MaterialColor color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color.shade700, size: 24),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color.shade700,
          ),
        ),
        Text(
          unit,
          style: TextStyle(
            fontSize: 12,
            color: color.shade700,
          ),
        ),
      ],
    );
  }

  Future<void> _saveMeal(FoodBloc foodBloc, LoadChildState childBloc,
      Map<String, String> mealData, String mealTime) async {
    try {
      final calories = double.tryParse(mealData['calories'] ?? '0') ?? 0.0;
      final protein = double.tryParse(mealData['protein'] ?? '0') ?? 0.0;
      final carbs = double.tryParse(mealData['carbs'] ?? '0') ?? 0.0;
      final fat = double.tryParse(mealData['fat'] ?? '0') ?? 0.0;

      foodBloc.add(SaveFoodEvent(
          childId: childBloc.child.id,
          foodName: mealData['name']!,
          calories: calories,
          protein: protein,
          carbs: carbs,
          fat: fat,
          imageUrl: mealData['image'] ?? '',
          mealTime: mealTime,
          qty: mealAmounts[mealTime.toLowerCase()] ?? 1,
          dateTime: _selectedDay!));
    } catch (e) {
      throw Exception('Error saving $mealTime: $e');
    }
  }
}
