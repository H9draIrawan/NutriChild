import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Welcomepage extends StatefulWidget {
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
                isLastPage = index == 4;
              });
            },
            children: [
              // First Page
              OnboardingPage(
                title: 'Delicious recipies and\npersonalized mealplans',
                image: 'assets/images/Logo.png',
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
                title: "Let's setup your child's profile",
                showChildForm: true,
                showButton: true,
                buttonText: 'CONTINUE',
                centerContent: true,
                onButtonPressed: () => _controller.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                ),
              ),

              

              // Third Page
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

              // Fourth Page
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

              // Fifth Page
              OnboardingPage(
                title: 'You are all set up!',
                subtitle:
                    'Explore our delicios recipies\nand personalised mealplans.',
                showRecipeGrid: true,
                showButton: true,
                buttonText: "LET'S BEGIN",
                centerContent: true,
                onButtonPressed: () {
                  Navigator.pushReplacementNamed(context, '/');
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
                      _controller.jumpToPage(4);
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
              count: 5,
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
  final bool showChildForm;

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
    this.showChildForm = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.green.shade50],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: centerContent
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              Text(
                title,
                textAlign: centerContent ? TextAlign.center : TextAlign.start,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                  height: 1.2,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 12),
                Text(
                  subtitle!,
                  textAlign: centerContent ? TextAlign.center : TextAlign.start,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
              ],
              if (image != null) ...[
                const SizedBox(height: 30),
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        image!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
              if (showCards && cards != null) ...[
                const SizedBox(height: 20),
                Expanded(
                  flex: 4,
                  child: ListView(
                    children: cards!,
                  ),
                ),
              ],
              if (showAllergies) 
                Expanded(
                  flex: 4,
                  child: buildAllergyGrid(),
                ),
              if (showRecipeGrid) 
                Expanded(
                  flex: 4,
                  child: buildRecipeGrid(),
                ),
              if (showChildForm) 
                Expanded(
                  flex: 5,
                  child: buildChildForm(),
                ),
              if (showButton) ...[
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: onButtonPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      minimumSize: const Size(double.infinity, 56),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      buttonText!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ],
          ),
        ),
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
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                allergies[index]['icon']!,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 4),
              Text(
                allergies[index]['name']!,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildRecipeGrid() {
    final List<String> recipeImages = [
      'assets/images/pic1.png',
      'assets/images/pic2.png',
      'assets/images/pic3.png',
      'assets/images/pic4.png',
    ];

    return Column(
      children: [
        const SizedBox(height: 20),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10),
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1,
            ),
            itemCount: recipeImages.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    recipeImages[index],
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildChildForm() {
    return Form(
      key: GlobalKey<FormState>(),
      child: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 20),
          _buildFormField(
            label: 'Child Name',
            icon: Icons.person,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter child name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildFormField(
            label: 'Age (years)',
            icon: Icons.cake,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter age';
              }
              if (int.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildDropdownField(),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildFormField(
                  label: 'Weight (kg)',
                  icon: Icons.monitor_weight,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    if (double.tryParse(value) == null) return 'Invalid';
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFormField(
                  label: 'Height (cm)',
                  icon: Icons.height,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    if (double.tryParse(value) == null) return 'Invalid';
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[700]),
          prefixIcon: Icon(icon, color: Colors.green[600]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.green.shade400),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }

  Widget _buildDropdownField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Gender',
          labelStyle: TextStyle(color: Colors.grey[700]),
          prefixIcon: Icon(Icons.people, color: Colors.green[600]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.green.shade400),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        value: null,
        items: ['Male', 'Female'].map((String gender) {
          return DropdownMenuItem(
            value: gender,
            child: Text(gender),
          );
        }).toList(),
        onChanged: (String? value) {
          // Handle gender change
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select gender';
          }
          return null;
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
