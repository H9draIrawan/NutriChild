import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrichild/bloc/food/food_bloc.dart';
import 'package:nutrichild/database/database_food.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:nutrichild/data/model/Meal.dart';

import '../bloc/food/food_event.dart';
import '../database/database_meal.dart';
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

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Tambahkan variabel untuk menyimpan meal yang dipilih
  Meal? selectedBreakfast;
  Meal? selectedLunch;
  Meal? selectedDinner;

  @override
  void initState() {
    super.initState();
    _loadMealPlanInfo();
  }

  Future<void> _loadMealPlanInfo() async {
    final info = await mealSqflite.getMealPlanInfo();
    setState(() {
      _titleController.text = info['title'] ?? '';
      _descriptionController.text = info['description'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Custom Meal',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Background image that scrolls with the page
            Column(
              children: [
                SizedBox(
                  height: 250,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/pic1.png',
                    fit: BoxFit.cover,
                  ),
                ),
                // Empty space below image to allow scrolling
                Container(
                  height: 800,
                  color: Colors.white,
                ),
              ],
            ),
            Column(
              children: [
                const SizedBox(
                    height: 200), // Push card below the top of the screen
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: _buildDescriptionSection(),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Calendar',
                  style: TextStyle(
                    fontFamily: 'WorkSans',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                TableCalendar(
                  focusedDay: _focusedDay,
                  firstDay: DateTime.utc(2025, 1, 1),
                  lastDay: DateTime.utc(2025, 12, 31),
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[800],
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () async {
            try {
              if (_selectedDay != null) {
                await mealSqflite.saveMealPlan(
                  date: _selectedDay!,
                  breakfast:
                      selectedBreakfast != null ? [selectedBreakfast!] : null,
                  lunch: selectedLunch != null ? [selectedLunch!] : null,
                  dinner: selectedDinner != null ? [selectedDinner!] : null,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Meal plan saved successfully!'),
                    duration: Duration(seconds: 2),
                  ),
                );
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please select a date first'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error saving meal plan: $e'),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
          child: const Text(
            'SAVE CHANGES',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label,
      {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: Colors.white,
        shadowColor: Colors.black.withOpacity(0.2),
        child: Container(
          height: 80,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.green,
                size: 32,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'WorkSans',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _titleController.text.isEmpty
                      ? 'My mealplan'
                      : _titleController.text,
                  style: const TextStyle(
                    fontFamily: 'WorkSans',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        final tempTitleController =
                            TextEditingController(text: _titleController.text);
                        final tempDescController = TextEditingController(
                            text: _descriptionController.text);

                        return AlertDialog(
                          title: const Text('Edit Meal Plan'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: tempTitleController,
                                decoration: const InputDecoration(
                                  labelText: 'Title',
                                  hintText: 'Enter meal plan title',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: tempDescController,
                                maxLines: 3,
                                decoration: const InputDecoration(
                                  labelText: 'Description',
                                  hintText: 'Enter meal plan description',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Update controllers terlebih dahulu
                                _titleController.text =
                                    tempTitleController.text;
                                _descriptionController.text =
                                    tempDescController.text;

                                // Tutup dialog
                                Navigator.of(context).pop();

                                // Simpan ke database dan update UI
                                setState(() {});
                                mealSqflite
                                    .saveMealPlanInfo(
                                  title: _titleController.text,
                                  description: _descriptionController.text,
                                )
                                    .then((_) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Changes saved successfully!'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                });
                              },
                              child: const Text('Save'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Colors.red[800],
                  ),
                ),
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
            Text(
              _descriptionController.text,
              style: const TextStyle(
                fontFamily: 'WorkSans',
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealCard(Meal? meal, String type) {
    if (meal == null) {
      return _buildActionButton(
        Icons.add,
        "Add $type",
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  SearchMealCustom(mealType: type.toLowerCase()),
            ),
          );

          if (result != null && result is Meal) {
            setState(() {
              switch (type.toLowerCase()) {
                case 'breakfast':
                  selectedBreakfast = result;
                  break;
                case 'lunch':
                  selectedLunch = result;
                  break;
                case 'dinner':
                  selectedDinner = result;
                  break;
              }
            });
          }
        },
      );
    }

    return Card(
      child: ListTile(
        leading: Image.asset(
          meal.imageUrl,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
        title: Text(meal.name),
        subtitle: Text('${meal.calories} kcal'),
        trailing: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            setState(() {
              switch (type.toLowerCase()) {
                case 'breakfast':
                  selectedBreakfast = null;
                  break;
                case 'lunch':
                  selectedLunch = null;
                  break;
                case 'dinner':
                  selectedDinner = null;
                  break;
              }
            });
          },
        ),
      ),
    );
  }
}
