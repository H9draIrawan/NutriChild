import 'package:flutter/material.dart';
import 'package:nutrichild/ui/CustomMealPlan.dart';

class SearchMealCustom extends StatelessWidget {
  const SearchMealCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
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
        padding: EdgeInsets.all(16),
        itemCount: 7, // Sesuai dengan jumlah item pada gambar
        itemBuilder: (context, index) {
          return MealCard(
            title: mealData[index]['title'],
            time: mealData[index]['time'],
            calories: mealData[index]['calories'],
            imageUrl: mealData[index]['imageUrl'],
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

  const MealCard({
    super.key,
    required this.title,
    required this.time,
    required this.calories,
    required this.imageUrl,
  });

  @override
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Handle the onClick action here
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CustomMealPlan(
              name: title,
              calories: calories,
              imageUrl: imageUrl,
            ),
          ),
        );
      },
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
    'imageUrl':
        'https://www.paleorunningmomma.com/wp-content/uploads/2022/08/salmon-cobb-salad-3-scaled.jpg',
  },
  {
    'title': 'Quinoa with carrots',
    'time': '30 min',
    'calories': '507',
    'imageUrl':
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ9Wku9H-CswGOicQqg5LP7RXz5U4Ess-hLrw&s',
  },
  {
    'title': 'Pasta and vegetables',
    'time': '25 min',
    'calories': '640',
    'imageUrl':
        'https://www.cookingclassy.com/wp-content/uploads/2018/09/pasta-primavera-2.jpg',
  },
  {
    'title': 'Guacamole and salad',
    'time': '30 min',
    'calories': '450',
    'imageUrl':
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLz0CvLrm3k6NMr3tYrZREIQAQB5Ze9WE8hg&s',
  },
  {
    'title': 'Carrots and quinoa',
    'time': '30 min',
    'calories': '507',
    'imageUrl':
        'https://withtwospoons.com/wp-content/uploads/2019/08/Roasted-Carrot-and-Quinoa-Salad-EDIT-RI-1.jpg',
  },
  {
    'title': 'Roasted chicken',
    'time': '45 min',
    'calories': '640',
    'imageUrl':
        'https://www.foodandwine.com/thmb/t9YqzGbmH-huAbV6xitCQs0-G4s=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/FAW-recipes-herb-and-lemon-roasted-chicken-hero-c4ba0aec56884683be482c47b1e1df11.jpg',
  },
  {
    'title': 'Pesto pasta with vegetables',
    'time': '25 min',
    'calories': '640',
    'imageUrl':
        'https://richanddelish.com/wp-content/uploads/2023/02/creamy-pesto-pasta-1.jpg',
  },
];
