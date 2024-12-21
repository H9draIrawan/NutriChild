import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:nutrichild/ui/LoginPage.dart';

class Welcomepage extends StatefulWidget {
  static const routeName = "/welcome";
  const Welcomepage({super.key});

  @override
  State<Welcomepage> createState() => _WelcomepageState();
}

class _WelcomepageState extends State<Welcomepage> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                isLastPage = index == 3;
              });
            },
            children: [
              // First Page
              OnboardingPage(
                title: 'Delicious recipies and\npersonalized mealplans',
                image: 'assets/images/food1.png',
                showButton: true,
                buttonText: 'CONTINUE',
                centerContent: true,
                onButtonPressed: () => _controller.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                ),
              ),

              // Second Page
              OnboardingPage(
                title: "What's your diet goal?",
                showCards: true,
                showButton: true,
                buttonText: 'CONTINUE',
                centerContent: true,
                onButtonPressed: () => _controller.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                ),
                cards: [
                  GoalCard(
                    title: 'Get inspiration',
                    subtitle: 'Challenge your taste buds',
                  ),
                  GoalCard(
                    title: 'Eat healthy',
                    subtitle: 'Have balanced diet and stay lean',
                  ),
                  GoalCard(
                    title: 'Loose weight',
                    subtitle: 'Get lean without struggle',
                  ),
                  GoalCard(
                    title: 'Build muscles',
                    subtitle: 'Stay active and get stronger',
                  ),
                ],
              ),

              // Third Page
              OnboardingPage(
                title: 'Any allergies?',
                showAllergies: true,
                showButton: true,
                buttonText: 'CONTINUE',
                centerContent: true,
                onButtonPressed: () => _controller.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                ),
              ),

              // Fourth Page
              OnboardingPage(
                title: 'You are all set up!',
                subtitle:
                    'Explore our delicios recipies\nand personalised mealplans.',
                showRecipeGrid: true,
                showButton: true,
                buttonText: "LET'S BEGIN",
                centerContent: true,
                onButtonPressed: () {
                  Navigator.pushReplacementNamed(context, Loginpage.routeName);
                },
              ),
            ],
          ),

          // Skip button
          Positioned(
            top: 50,
            right: 20,
            child: isLastPage
                ? const SizedBox()
                : TextButton(
                    onPressed: () {
                      _controller.jumpToPage(3);
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
          ),

          // Page indicator
          Container(
            alignment: const Alignment(0, 0.85),
            child: SmoothPageIndicator(
              controller: _controller,
              count: 4,
              effect: const WormEffect(
                spacing: 16,
                dotColor: Colors.black26,
                activeDotColor: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? image;
  final bool showButton;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final bool showCards;
  final List<GoalCard>? cards;
  final bool showAllergies;
  final bool showRecipeGrid;
  final bool centerContent;

  const OnboardingPage({
    super.key,
    required this.title,
    this.subtitle,
    this.image,
    this.showButton = false,
    this.buttonText,
    this.onButtonPressed,
    this.showCards = false,
    this.cards,
    this.showAllergies = false,
    this.showRecipeGrid = false,
    this.centerContent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: centerContent
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            title,
            textAlign: centerContent ? TextAlign.center : TextAlign.start,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 10),
            Text(
              subtitle!,
              textAlign: centerContent ? TextAlign.center : TextAlign.start,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ],
          if (image != null) ...[
            const SizedBox(height: 20),
            Center(child: Image.asset(image!)),
          ],
          if (showCards && cards != null) ...[
            const SizedBox(height: 30),
            ...cards!,
          ],
          if (showAllergies) buildAllergyGrid(),
          if (showRecipeGrid) ...[
            const SizedBox(height: 20),
            buildRecipeGrid(),
          ],
          if (showButton) ...[
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: onButtonPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  buttonText!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ],
      ),
    );
  }

  Widget buildAllergyGrid() {
    final allergies = [
      {'icon': '🥚', 'name': 'Egg'},
      {'icon': '🥛', 'name': 'Milk'},
      {'icon': '🥜', 'name': 'Nut'},
      {'icon': '🫘', 'name': 'Soybean'},
      {'icon': '🐟', 'name': 'Fish'},
      {'icon': '🌾', 'name': 'Wheat'},
      {'icon': '🌽', 'name': 'Celery'},
      {'icon': '🦐', 'name': 'Crustacean'},
      {'icon': '🫙', 'name': 'Mustard'},
    ];

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount:
            (allergies.length / 3).ceil(), // Bagi menjadi baris dengan 3 item
        itemBuilder: (context, rowIndex) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(3, (index) {
                final itemIndex = rowIndex * 3 + index;
                if (itemIndex >= allergies.length) {
                  return const SizedBox(
                      width: 100); // Placeholder untuk item kosong
                }
                return Container(
                  width: 100,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.withOpacity(0.1)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        allergies[itemIndex]['icon']!,
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        allergies[itemIndex]['name']!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          );
        },
      ),
    );
  }

  Widget buildRecipeGrid() {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10),
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1, // Mengatur rasio aspek agar square
        ),
        itemCount: 8,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: AssetImage('assets/images/food1.png'),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}

class GoalCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const GoalCard({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
