import 'package:flutter/material.dart';
import 'package:nutrichild/presentation/pages/home/home_page.dart';
import 'package:nutrichild/presentation/pages/recommendation/recommendation_page.dart';
import 'package:nutrichild/presentation/pages/profile/profile_page.dart';
import 'package:nutrichild/presentation/pages/meal/meal_page.dart';
import 'package:nutrichild/presentation/pages/chatbot/chatbot_page.dart';

class NavigationBottom extends StatefulWidget {
  const NavigationBottom({super.key});

  @override
  State<NavigationBottom> createState() => _NavigationBottomState();
}

class _NavigationBottomState extends State<NavigationBottom> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = [
      HomePage(),
      RecommendationPage(),
      ProfilePage(),
      MealPage(),
      ChatbotPage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.red,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Recommendation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Meal Planner',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome),
            label: 'Nutri AI',
          ),
        ],
      ),
    );
  }
}
