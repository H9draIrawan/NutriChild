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
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = [
      Homepage(),
      Searchpage(),
      Chatpage(),
      Profilepage()
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
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
            backgroundColor: Colors.orange,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}
