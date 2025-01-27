import 'package:flutter/material.dart';
import '../../widgets/intro/intro_content.dart';
import '../../widgets/intro/goal_card.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final PageController _controller = PageController();
  final GlobalKey<FormState> _childFormKey = GlobalKey<FormState>();
  bool isLastPage = false;
  int? selectedGoalIndex;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleChildFormContinue() {
    if (_childFormKey.currentState?.validate() ?? false) {
      // Simpan data form
      _childFormKey.currentState?.save();

      // Pindah ke halaman berikutnya
      _controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> onboardingPages = [
      OnboardingContent(
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
      OnboardingContent(
        title: "Let's setup your child's profile",
        showChildForm: true,
        showButton: true,
        buttonText: 'CONTINUE',
        centerContent: true,
        formKey: _childFormKey,
        onButtonPressed: _handleChildFormContinue,
      ),
      // Third Page - Goal Selection
      OnboardingContent(
        title: "What's your diet goal?",
        showCards: true,
        showButton: true,
        buttonText: 'CONTINUE',
        centerContent: true,
        cards: [
          GoalCard(
            title: 'Eat healthy',
            subtitle: 'Have balanced diet and stay lean',
            isSelected: selectedGoalIndex == 0,
            onTap: () => _handleGoalSelection(0, 'Eat healthy'),
          ),
          GoalCard(
            title: 'Loose weight',
            subtitle: 'Get lean without struggle',
            isSelected: selectedGoalIndex == 1,
            onTap: () => _handleGoalSelection(1, 'Loose weight'),
          ),
          GoalCard(
            title: 'Build muscles',
            subtitle: 'Stay active and get stronger',
            isSelected: selectedGoalIndex == 2,
            onTap: () => _handleGoalSelection(2, 'Build muscles'),
          ),
        ],
        onButtonPressed: _handleGoalContinue,
      ),
      OnboardingContent(
        title: 'Do you have any allergies?',
        subtitle:
            'Select the allergies you have so we can adjust the food recommendations for you',
        showAllergies: true,
        showButton: true,
        buttonText: 'CONTINUE',
        onButtonPressed: () => _controller.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        ),
      ),
      // Fifth Page
      OnboardingContent(
        title: "You're all set!",
        subtitle:
            "Let's explore delicious recipes\nand personalized meal plans",
        showRecipeGrid: true,
        showButton: true,
        buttonText: "LET'S BEGIN",
        centerContent: true,
        onButtonPressed: () async {
          try {
            // Simpan data anak
            final childId = "C${DateTime.now().millisecondsSinceEpoch}";
            final childPref = await SharedPreferences.getInstance();
            await childPref.setString('childId', childId);
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error saving data: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                isLastPage = index == onboardingPages.length - 1;
              });
            },
            children: onboardingPages,
          ),
          Container(
            alignment: const Alignment(0, 0.85),
            child: SmoothPageIndicator(
              controller: _controller,
              count: onboardingPages.length,
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

  void _handleGoalSelection(int index, String goalName) {
    setState(() {
      selectedGoalIndex = selectedGoalIndex == index ? null : index;
    });
  }

  void _handleGoalContinue() {
    if (selectedGoalIndex != null) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select your diet goal'),
        ),
      );
    }
  }
}
