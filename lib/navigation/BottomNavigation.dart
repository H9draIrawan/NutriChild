import 'package:flutter/material.dart';
import 'package:nutrichild/ui/ChatPage.dart';
import 'package:nutrichild/ui/HomePage.dart';
import 'package:nutrichild/ui/ProfilePage.dart';
import 'package:nutrichild/ui/SearchPage.dart';

class Bottomnavigation extends StatefulWidget {
  static const routeName = '/';
  const Bottomnavigation({super.key});

  @override
  State<Bottomnavigation> createState() => _BottomnavigationState();
}

class _BottomnavigationState extends State<Bottomnavigation> {
  @override
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = [
      Homepage(),
      Searchpage(),
      Chatpage(),
      Profilepage()
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
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
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
