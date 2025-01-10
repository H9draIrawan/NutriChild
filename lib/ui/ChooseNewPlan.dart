import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrichild/bloc/food/food_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../bloc/food/food_event.dart';
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
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
                            const Text(
                              'Thin and lean. Plan for a "skinny guy" who have a hard time gaining weight.',
                              style: TextStyle(
                                fontFamily: 'WorkSans',
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
                        _buildActionButton(
                          Icons.add,
                          "Add Breakfast",
                          onTap: () {
                            BlocProvider.of<FoodBloc>(context)
                                .add(InitialBreakfastEvent());
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchMealCustom()),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildActionButton(
                          Icons.add,
                          "Add Lunch",
                          onTap: () {
                            BlocProvider.of<FoodBloc>(context)
                                .add(InitialLunchEvent());
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchMealCustom()),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildActionButton(
                          Icons.add,
                          "Add Dinner",
                          onTap: () {
                            BlocProvider.of<FoodBloc>(context)
                                .add(InitialDinnerEvent());
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchMealCustom()),
                            );
                          },
                        ),
                      ],
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
                        onPressed: () {
                          // Logic for Continue button
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
                  ),
                ],
              ),
            ],
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
}
