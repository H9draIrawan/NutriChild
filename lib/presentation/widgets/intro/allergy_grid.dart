import 'package:flutter/material.dart';

class AllergyGrid extends StatefulWidget {
  const AllergyGrid({super.key});

  @override
  State<AllergyGrid> createState() => _AllergyGridState();
}

class _AllergyGridState extends State<AllergyGrid> {
  final List<Map<String, dynamic>> allergies = [
    {
      'icon': '🥚',
      'name': 'Egg',
      'isSelected': false,
      'color': Colors.orange[50],
      'selectedColor': Colors.orange[100]
    },
    {
      'icon': '🥛',
      'name': 'Milk',
      'isSelected': false,
      'color': Colors.blue[50],
      'selectedColor': Colors.blue[100]
    },
    {
      'icon': '🥜',
      'name': 'Peanut',
      'isSelected': false,
      'color': Colors.brown[50],
      'selectedColor': Colors.brown[100]
    },
    {
      'icon': '🌱',
      'name': 'Soybean',
      'isSelected': false,
      'color': Colors.green[50],
      'selectedColor': Colors.green[100]
    },
    {
      'icon': '🐟',
      'name': 'Fish',
      'isSelected': false,
      'color': Colors.blue[50],
      'selectedColor': Colors.blue[100]
    },
    {
      'icon': '🌾',
      'name': 'Wheat',
      'isSelected': false,
      'color': Colors.amber[50],
      'selectedColor': Colors.amber[100]
    },
    {
      'icon': '🥬',
      'name': 'Celery',
      'isSelected': false,
      'color': Colors.lightGreen[50],
      'selectedColor': Colors.lightGreen[100]
    },
    {
      'icon': '🦐',
      'name': 'Crustacean',
      'isSelected': false,
      'color': Colors.red[50],
      'selectedColor': Colors.red[100]
    },
    {
      'icon': '🌶️',
      'name': 'Mustard',
      'isSelected': false,
      'color': Colors.yellow[50],
      'selectedColor': Colors.yellow[100]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return GridView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10),
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.2,
          ),
          itemCount: allergies.length,
          itemBuilder: (context, index) {
            final isSelected = allergies[index]['isSelected'] as bool;

            return InkWell(
              onTap: () {
                setState(() {
                  allergies[index]['isSelected'] = !isSelected;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? allergies[index]['selectedColor']
                      : allergies[index]['color'],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? Colors.green
                        : Colors.grey.withOpacity(0.1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      allergies[index]['icon']!,
                      style: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      allergies[index]['name']!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Colors.green[700] : Colors.black54,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
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
}
