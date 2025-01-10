import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_state.dart';
import '../ui/AllRecipesPage.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String? username;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    if (authBloc.state is LoginAuthState) {
      final state = authBloc.state as LoginAuthState;
      setState(() {
        username = state.username;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        toolbarHeight: 80,
        title: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Welcome, ",
                      style: TextStyle(
                        fontFamily: 'WorkSans',
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      username ?? '',
                      style: const TextStyle(
                        fontFamily: 'WorkSans',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "What do you want to cook today?",
                style: TextStyle(
                  fontFamily: 'WorkSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Find recipes",
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 16,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey[400],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF19A413),
                          padding: const EdgeInsets.all(12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child:
                            const Icon(Icons.filter_list, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: const [
                    CategoryButton(label: "LUNCH"),
                    SizedBox(width: 12),
                    CategoryButton(label: "DINNER"),
                    SizedBox(width: 12),
                    CategoryButton(label: "BREAKFAST"),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              RecipeSection(
                title: "Rich in protein recipes",
                recipes: [
                  RecipeCard(
                    image: 'assets/images/pic3.png',
                    title: "Roasted chicken",
                  ),
                  RecipeCard(
                    image: 'assets/images/pic4.png',
                    title: "Salmon with salad",
                  ),
                  RecipeCard(
                    image: 'assets/images/pic5.png',
                    title: "Roasted lamb",
                  ),
                  RecipeCard(
                    image: 'assets/images/pic3.png',
                    title: "Ravioli with pesto",
                  ),
                  RecipeCard(
                    image: 'assets/images/pic4.png',
                    title: "Grilled steak",
                  ),
                  RecipeCard(
                    image: 'assets/images/pic5.png',
                    title: "Tuna salad",
                  ),
                  RecipeCard(
                    image: 'assets/images/pic3.png',
                    title: "Beef stir fry",
                  ),
                  RecipeCard(
                    image: 'assets/images/pic4.png',
                    title: "Chicken curry",
                  ),
                  RecipeCard(
                    image: 'assets/images/pic5.png',
                    title: "Grilled fish",
                  ),
                  RecipeCard(
                    image: 'assets/images/pic3.png',
                    title: "Turkey breast",
                  ),
                  RecipeCard(
                    image: 'assets/images/pic4.png',
                    title: "Shrimp scampi",
                  ),
                ],
              ),
              const SizedBox(height: 24),
              RecipeSection(
                title: "Popular recipes this week",
                recipes: [
                  RecipeCard(
                    image: 'assets/images/pic4.png',
                    title: "Tomato soup",
                  ),
                  RecipeCard(
                    image: 'assets/images/pic5.png',
                    title: "Pumpkin soup",
                  ),
                  RecipeCard(
                    image: 'assets/images/pic3.png',
                    title: "Roasted chicken",
                  ),
                  RecipeCard(
                    image: 'assets/images/pic4.png',
                    title: "Ravioli with pesto",
                  ),
                  RecipeCard(
                    image: 'assets/images/pic5.png',
                    title: "Caesar salad",
                  ),
                  RecipeCard(
                    image: 'assets/images/pic3.png',
                    title: "Beef stew",
                  ),
                  RecipeCard(
                    image: 'assets/images/pic4.png',
                    title: "Pasta carbonara",
                  ),
                  RecipeCard(
                    image: 'assets/images/pic5.png',
                    title: "Greek salad",
                  ),
                  RecipeCard(
                    image: 'assets/images/pic3.png',
                    title: "Mushroom risotto",
                  ),
                  RecipeCard(
                    image: 'assets/images/pic4.png',
                    title: "Vegetable curry",
                  ),
                  RecipeCard(
                    image: 'assets/images/pic5.png',
                    title: "Fish tacos",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String label;
  const CategoryButton({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF19A413),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'WorkSans',
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class RecipeSection extends StatelessWidget {
  final String title;
  final List<RecipeCard> recipes;
  const RecipeSection({super.key, required this.title, required this.recipes});

  @override
  Widget build(BuildContext context) {
    final recipesList = recipes
        .map((recipe) => {
              'image': recipe.image,
              'title': recipe.title,
            })
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'WorkSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllRecipesPage(
                      categoryTitle: title,
                      recipes: recipesList,
                    ),
                  ),
                );
              },
              child: const Text(
                "Show all",
                style: TextStyle(
                  color: Color(0xFF19A413),
                  fontFamily: 'WorkSans',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recipes.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: recipes[index],
            ),
          ),
        ),
      ],
    );
  }
}

class RecipeCard extends StatelessWidget {
  final String image;
  final String title;
  const RecipeCard({super.key, required this.image, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              image,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 12,
                      fontFamily: 'WorkSans',
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(
                  Icons.favorite_border,
                  color: Colors.grey,
                  size: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
