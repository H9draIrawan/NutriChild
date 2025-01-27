import 'package:flutter/material.dart';
import 'package:nutrichild/.ui/Chat/ChatPage.dart';
import 'package:nutrichild/.ui/Home/HomePage.dart';
import 'package:nutrichild/.ui/Meal/MealPage.dart';
import 'package:nutrichild/.ui/Profile/ProfilePage.dart';
import 'package:nutrichild/.ui/Recommend/RecommendPage.dart';

class Bottomnavigation extends StatefulWidget {
  static const routeName = '/';
  const Bottomnavigation({super.key});

  @override
  State<Bottomnavigation> createState() => _BottomnavigationState();
}

class _BottomnavigationState extends State<Bottomnavigation> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = [
      Homepage(),
      Recommendpage(),
      Profilepage(),
      Mealpage(),
      Chatpage(),
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
            label: 'Recommend',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Meal Plan',
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
