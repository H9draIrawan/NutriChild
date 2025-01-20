import 'package:flutter/material.dart';
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
    'imageUrl':
        'https://cdn-assets-eu.frontify.com/s3/frontify-enterprise-files-eu/eyJvYXV0aCI6eyJjbGllbnRfaWQiOiJmcm9udGlmeS1maW5kZXIifSwicGF0aCI6ImloaC1oZWFsdGhjYXJlLWJlcmhhZFwvZmlsZVwvSGhleHdSaUVCYWJ0b1dFRWpUM1EuanBnIn0:ihh-healthcare-berhad:6Zk6UuetaajSDB-43bdLAoamTKKBCqQFMfjY38nWPbk?format=webp',
  },
  {
    'title': 'Quinoa with carrots',
    'time': '30 min',
    'calories': '507',
    'imageUrl':
        'https://www.allrecipes.com/thmb/qAywXhsLSx1XGNgoc8Y62kjX5RE=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/216999simple-savory-quinoaFranceC-398611140dcf4e829a55fdfa967bdec6.jpg',
  },
  {
    'title': 'Pasta and vegetables',
    'time': '25 min',
    'calories': '640',
    'imageUrl':
        'https://media.istockphoto.com/id/509409312/photo/whole-wheat-fusilli-pasta-with-vegetables.jpg?s=612x612&w=0&k=20&c=Dwmq0NgYiA7oZcULyZll-AvDA9FW-XWD6sqSWLCnHjE=',
  },
  {
    'title': 'Guacamole and salad',
    'time': '30 min',
    'calories': '450',
    'imageUrl':
        'https://www.delishknowledge.com/wp-content/uploads/Guacamole-Salad_2.jpg',
  },
  {
    'title': 'Carrots and quinoa',
    'time': '30 min',
    'calories': '507',
    'imageUrl':
        'https://media-cdn2.greatbritishchefs.com/media/lo4ptoar/img54264.whqc_768x512q80.jpg',
  },
  {
    'title': 'Roasted chicken',
    'time': '45 min',
    'calories': '640',
    'imageUrl':
        'https://allthehealthythings.com/wp-content/uploads/2021/11/The-Best-Whole-Roasted-Chicken-5-scaled.jpg',
  },
];
