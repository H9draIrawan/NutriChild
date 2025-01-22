import 'package:flutter/material.dart';
import 'package:nutrichild/ui/Meal/CustomMealPlan.dart';

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
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          height: 40,
          child: TextField(
            decoration: InputDecoration(
              hintText: "Find recipes",
              hintStyle: TextStyle(color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: mealData.length,
        itemBuilder: (context, index) {
          return MealCard(
            title: mealData[index]['title'],
            calories: mealData[index]['calories'],
            protein: mealData[index]['protein'],
            carbs: mealData[index]['carbs'],
            fat: mealData[index]['fat'],
            imageUrl: mealData[index]['imageUrl'],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CustomMealPlan(
                          name: mealData[index]['title'],
                          calories: mealData[index]['calories'],
                          protein: mealData[index]['protein'],
                          carbs: mealData[index]['carbs'],
                          fat: mealData[index]['fat'],
                          imageUrl: mealData[index]['imageUrl'],
                        )),
              );
            },
          );
        },
      ),
    );
  }
}

class MealCard extends StatelessWidget {
  final String title;
  final String calories;
  final String protein;
  final String carbs;
  final String fat;
  final String imageUrl;
  final Function() onTap;

  const MealCard({
    super.key,
    required this.title,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.local_fire_department, size: 14, color: Colors.orange),
                          SizedBox(width: 4),
                          Text(
                            '$calories kcal',
                            style: TextStyle(
                              color: Colors.orange.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _NutrientInfo(
                            label: 'Protein',
                            value: protein,
                            color: Colors.red.shade100,
                            textColor: Colors.red.shade700,
                          ),
                          SizedBox(width: 8),
                          _NutrientInfo(
                            label: 'Carbs',
                            value: carbs,
                            color: Colors.blue.shade100,
                            textColor: Colors.blue.shade700,
                          ),
                          SizedBox(width: 8),
                          _NutrientInfo(
                            label: 'Fat',
                            value: fat,
                            color: Colors.green.shade100,
                            textColor: Colors.green.shade700,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NutrientInfo extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Color textColor;

  const _NutrientInfo({
    required this.label,
    required this.value,
    required this.color,
    required this.textColor,
  });

  IconData _getIcon() {
    switch (label.toLowerCase()) {
      case 'protein':
        return Icons.egg_outlined;
      case 'carbs':
        return Icons.breakfast_dining;
      case 'fat':
        return Icons.opacity;
      default:
        return Icons.circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: textColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getIcon(),
            size: 24,
            color: textColor,
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: textColor,
            ),
          ),
          SizedBox(height: 4),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                TextSpan(
                  text: 'g',
                  style: TextStyle(
                    fontSize: 12,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final List<Map<String, dynamic>> mealData = [
  {
    'title': 'Salmon with salad',
    'calories': '450',
    'protein': '35',
    'carbs': '10',
    'fat': '28',
    'imageUrl':
        'https://cdn-assets-eu.frontify.com/s3/frontify-enterprise-files-eu/eyJvYXV0aCI6eyJjbGllbnRfaWQiOiJmcm9udGlmeS1maW5kZXIifSwicGF0aCI6ImloaC1oZWFsdGhjYXJlLWJlcmhhZFwvZmlsZVwvSGhleHdSaUVCYWJ0b1dFRWpUM1EuanBnIn0:ihh-healthcare-berhad:6Zk6UuetaajSDB-43bdLAoamTKKBCqQFMfjY38nWPbk?format=webp',
  },
  {
    'title': 'Quinoa with carrots',
    'calories': '507',
    'protein': '15',
    'carbs': '85',
    'fat': '12',
    'imageUrl':
        'https://www.allrecipes.com/thmb/qAywXhsLSx1XGNgoc8Y62kjX5RE=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/216999simple-savory-quinoaFranceC-398611140dcf4e829a55fdfa967bdec6.jpg',
  },
  {
    'title': 'Pasta and vegetables',
    'calories': '640',
    'protein': '15',
    'carbs': '85',
    'fat': '12',
    'imageUrl':
        'https://media.istockphoto.com/id/509409312/photo/whole-wheat-fusilli-pasta-with-vegetables.jpg?s=612x612&w=0&k=20&c=Dwmq0NgYiA7oZcULyZll-AvDA9FW-XWD6sqSWLCnHjE=',
  },
  {
    'title': 'Guacamole and salad',
    'calories': '450',
    'protein': '35',
    'carbs': '10',
    'fat': '28',
    'imageUrl':
        'https://www.delishknowledge.com/wp-content/uploads/Guacamole-Salad_2.jpg',
  },
  {
    'title': 'Carrots and quinoa',
    'calories': '507',
    'protein': '15',
    'carbs': '85',
    'fat': '12',
    'imageUrl':
        'https://media-cdn2.greatbritishchefs.com/media/lo4ptoar/img54264.whqc_768x512q80.jpg',
  },
  {
    'title': 'Roasted chicken',
    'calories': '640',
    'protein': '15',
    'carbs': '85',
    'fat': '12',
    'imageUrl':
        'https://allthehealthythings.com/wp-content/uploads/2021/11/The-Best-Whole-Roasted-Chicken-5-scaled.jpg',
  },
];
