import 'package:flutter/material.dart';
import 'package:nutrichild/ui/CustomMealPlan.dart';
import 'package:nutrichild/data/model/Meal.dart';

class SearchMealCustom extends StatelessWidget {
  final String mealType;

  const SearchMealCustom({
    super.key,
    required this.mealType,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          decoration: InputDecoration(
            hintText: "Find recipes",
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: mealData.length,
        itemBuilder: (context, index) {
          return MealCard(
            title: mealData[index]['title'],
            time: mealData[index]['time'],
            calories: mealData[index]['calories'],
            imageUrl: mealData[index]['imageUrl'],
            onTap: () {
              final meal = Meal(
                id: DateTime.now().toString(),
                childId: 'default',
                foodId: index.toString(),
                mealTime: mealType,
                dateTime: DateTime.now().toString(),
                qty: 1,
                name: mealData[index]['title'],
                calories: int.parse(mealData[index]['calories']),
                imageUrl: mealData[index]['imageUrl'],
              );

              Navigator.pop(context, meal);
            },
          );
        },
      ),
    );
  }
}

class MealCard extends StatelessWidget {
  final String title;
  final String time;
  final String calories;
  final String imageUrl;
  final Function() onTap;

  const MealCard({
    super.key,
    required this.title,
    required this.time,
    required this.calories,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.timer, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(time),
                      SizedBox(width: 16),
                      Icon(Icons.local_fire_department,
                          size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text('$calories kcal'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final List<Map<String, dynamic>> mealData = [
  {
    'title': 'Salmon with salad',
    'time': '30 min',
    'calories': '450',
    'imageUrl': '/assets/images/pic1.png',
  },
  {
    'title': 'Quinoa with carrots',
    'time': '30 min',
    'calories': '507',
    'imageUrl': '/assets/images/pic2.png',
  },
  {
    'title': 'Pasta and vegetables',
    'time': '25 min',
    'calories': '640',
    'imageUrl': '/assets/images/pic3.png',
  },
  {
    'title': 'Guacamole and salad',
    'time': '30 min',
    'calories': '450',
    'imageUrl': '/assets/images/pic4.png',
  },
  {
    'title': 'Carrots and quinoa',
    'time': '30 min',
    'calories': '507',
    'imageUrl': '/assets/images/pic5.png',
  },
  {
    'title': 'Roasted chicken',
    'time': '45 min',
    'calories': '640',
    'imageUrl': '/assets/images/Default.png',
  },
];
