import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrichild/bloc/auth/auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/child/child_bloc.dart';

import '../../bloc/child/child_event.dart';

class Welcomepage extends StatefulWidget {
  const Welcomepage({super.key});

  @override
  State<Welcomepage> createState() => _WelcomepageState();
}

class _WelcomepageState extends State<Welcomepage> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    OnboardingData.loadFromPrefs();
  }

  @override
  Widget build(BuildContext context) {
    AuthBloc blocAuth = BlocProvider.of<AuthBloc>(context);
    ChildBloc blocChild = BlocProvider.of<ChildBloc>(context);
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                isLastPage = index == 4;
              });
            },
            children: [
              // First Page
              OnboardingPage(
                title: 'Delicious recipies and\npersonalized mealplans',
                image: 'assets/images/logo.png',
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
                    title: 'Eat healthy',
                    subtitle: 'Have balanced diet and stay lean',
                    onTap: () {
                      // Handle tap
                    },
                  ),
                  GoalCard(
                    title: 'Loose weight',
                    subtitle: 'Get lean without struggle',
                    onTap: () {
                      // Handle tap
                    },
                  ),
                  GoalCard(
                    title: 'Build muscles',
                    subtitle: 'Stay active and get stronger',
                    onTap: () {
                      // Handle tap
                    },
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
                onButtonPressed: () async {
                  try {
                    final loginState = blocAuth.state as LoginAuthState;
                    final userId = loginState.id;
                    final childId = "C${DateTime.now().millisecondsSinceEpoch}";
                    final childPref = await SharedPreferences.getInstance();
                    await childPref.setString('childId', childId);

                    blocChild.add(SaveChildEvent(
                      id: childId,
                      userId: userId,
                      name: OnboardingData.childName!,
                      age: OnboardingData.childAge!,
                      gender: OnboardingData.childGender!,
                      weight: OnboardingData.childWeight!,
                      height: OnboardingData.childHeight!,
                      goal: OnboardingData.selectedGoalName!,
                    ));

                    for (var allergy in OnboardingData.selectedAllergies) {
                      blocChild.add(SaveAllergyEvent(
                        name: allergy,
                        childId: childId,
                      ));
                    }

                    blocChild.add(LoadChildEvent(childId: childId));

                    Navigator.pushReplacementNamed(context, '/');
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error saving data: $e')),
                    );
                  }
                },
              ),
            ],
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

class OnboardingPage extends StatefulWidget {
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
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  String? selectedGender;
  String? selectedAllergy;
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
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    weightController.dispose();
    heightController.dispose();
    super.dispose();
  }

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
            crossAxisAlignment: widget.centerContent
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                textAlign:
                    widget.centerContent ? TextAlign.center : TextAlign.start,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                  height: 1.2,
                ),
              ),
              if (widget.subtitle != null) ...[
                const SizedBox(height: 12),
                Text(
                  widget.subtitle!,
                  textAlign:
                      widget.centerContent ? TextAlign.center : TextAlign.start,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
              ],
              if (widget.image != null) ...[
                const SizedBox(height: 30),
                Expanded(
                  flex: 6,
                  child: Image.asset(
                    widget.image!,
                    fit: BoxFit.contain,
                    width: MediaQuery.of(context).size.width * 0.8,
                  ),
                ),
              ],
              if (widget.showCards && widget.cards != null) ...[
                const SizedBox(height: 20),
                Expanded(
                  flex: 4,
                  child: GoalCardList(cards: widget.cards!),
                ),
              ],
              if (widget.showAllergies)
                Expanded(
                  flex: 4,
                  child: buildAllergyGrid(),
                ),
              if (widget.showRecipeGrid)
                Expanded(
                  flex: 4,
                  child: buildRecipeGrid(),
                ),
              if (widget.showChildForm)
                Expanded(
                  flex: 5,
                  child: buildChildForm(),
                ),
              if (widget.showButton) ...[
                const Spacer(),
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
                    onPressed: () {
                      if (widget.showChildForm) {
                        if (formKey.currentState?.validate() ?? false) {
                          if (selectedGender == null) {
                            return;
                          }

                          // Simpan data anak
                          OnboardingData.childName = nameController.text;
                          OnboardingData.childAge = int.parse(ageController.text);
                          OnboardingData.childGender = selectedGender;
                          OnboardingData.childWeight = double.parse(weightController.text);
                          OnboardingData.childHeight = double.parse(heightController.text);
                          OnboardingData.saveToPrefs().then((_) {
                            widget.onButtonPressed?.call();
                          });
                        }
                      } else if (widget.title == "What's your diet goal?") {
                        // Cek apakah goal sudah dipilih dari OnboardingData
                        if (OnboardingData.selectedGoal != null) {
                          widget.onButtonPressed?.call();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please select your diet goal')),
                          );
                        }
                      } else if (widget.title == 'Any allergies?') {
                        final selectedAllergies = allergies
                            .where((allergy) => allergy['isSelected'] as bool)
                            .map((a) => {
                                  'name': a['name'] as String,
                                  'icon': a['icon'] as String,
                                })
                            .toList();

                        // Simpan ke OnboardingData
                        OnboardingData.selectedAllergies =
                            selectedAllergies.map((a) => a['name']!).toList();

                        widget.onButtonPressed?.call();
                      } else {
                        widget.onButtonPressed?.call();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      minimumSize: const Size(double.infinity, 56),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      widget.buttonText!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAllergyGrid() {
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
      key: formKey,
      child: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 20),
          _buildFormField(
            controller: nameController,
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
            controller: ageController,
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
          _buildGenderSelection(),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildFormField(
                  controller: weightController,
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
                  controller: heightController,
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
    required TextEditingController controller,
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
        controller: controller,
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
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Gender',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _buildGenderCard(
                icon: Icons.male,
                label: 'Male',
                isSelected: selectedGender == 'Male',
                color: Colors.blue,
                onTap: () {
                  setState(() {
                    selectedGender = selectedGender == 'Male' ? null : 'Male';
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildGenderCard(
                icon: Icons.female,
                label: 'Female',
                isSelected: selectedGender == 'Female',
                color: Colors.red,
                onTap: () {
                  setState(() {
                    selectedGender = selectedGender == 'Female' ? null : 'Female';
                  });
                },
              ),
            ),
          ],
        ),
        if (selectedGender == null)
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 8),
            child: Text(
              'Please select gender',
              style: TextStyle(
                fontSize: 12,
                color: Colors.red[400],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildGenderCard({
    required IconData icon,
    required String label,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade200,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 40,
              color: isSelected ? color : Colors.grey[600],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? color : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingData {
  static String? childName;
  static int? childAge;
  static String? childGender;
  static double? childWeight;
  static double? childHeight;
  static int? selectedGoal;
  static List<String> selectedAllergies = [];
  static String? selectedGoalName;

  static Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('child_name', childName ?? '');
    await prefs.setInt('child_age', childAge ?? 0);
    await prefs.setString('child_gender', childGender ?? '');
    await prefs.setDouble('child_weight', childWeight ?? 0);
    await prefs.setDouble('child_height', childHeight ?? 0);
    await prefs.setInt('selected_goal', selectedGoal ?? 0);
    await prefs.setStringList('selected_allergies', selectedAllergies);
    await prefs.setString('selected_goal_name', selectedGoalName ?? '');
  }

  static Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    childName = prefs.getString('child_name');
    childAge = prefs.getInt('child_age');
    childGender = prefs.getString('child_gender');
    childWeight = prefs.getDouble('child_weight');
    childHeight = prefs.getDouble('child_height');
    selectedGoal = prefs.getInt('selected_goal');
    selectedAllergies = prefs.getStringList('selected_allergies') ?? [];
    selectedGoalName = prefs.getString('selected_goal_name');
  }

  static void clear() {
    childName = null;
    childAge = null;
    childGender = null;
    childWeight = null;
    childHeight = null;
    selectedGoal = null;
    selectedAllergies.clear();
    selectedGoalName = null;
  }
}

class GoalCardList extends StatefulWidget {
  final List<GoalCard> cards;

  const GoalCardList({
    super.key,
    required this.cards,
  });

  @override
  State<GoalCardList> createState() => _GoalCardListState();
}

class _GoalCardListState extends State<GoalCardList> {
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    loadSelectedGoal();
  }

  Future<void> loadSelectedGoal() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedIndex = prefs.getInt('selected_goal');
      // Update OnboardingData saat load
      OnboardingData.selectedGoal = selectedIndex;
      if (selectedIndex != null) {
        final goalTitles = ['Eat healthy', 'Loose weight', 'Build muscles'];
        if (selectedIndex! < goalTitles.length) {
          OnboardingData.selectedGoalName = goalTitles[selectedIndex!];
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: widget.cards.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final goalTitles = ['Eat healthy', 'Loose weight', 'Build muscles'];
        return GoalCard(
          title: widget.cards[index].title,
          subtitle: widget.cards[index].subtitle,
          isSelected: selectedIndex == index,
          onTap: () {
            setState(() {
              selectedIndex = selectedIndex == index ? null : index;
              OnboardingData.selectedGoal = selectedIndex;
              if (selectedIndex != null && selectedIndex! < goalTitles.length) {
                OnboardingData.selectedGoalName = goalTitles[selectedIndex!];
                OnboardingData.saveToPrefs();
              } else {
                OnboardingData.selectedGoalName = null;
                OnboardingData.selectedGoal = null;
                OnboardingData.saveToPrefs();
              }
            });
          },
        );
      },
    );
  }
}

class GoalCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const GoalCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        width: double.infinity,
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.transparent,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w600,
                      color: isSelected ? Colors.green : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color:
                          isSelected ? Colors.green.shade700 : Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 20,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
