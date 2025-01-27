import 'package:flutter/material.dart';
import 'package:nutrichild/domain/entities/child.dart';
import 'package:nutrichild/presentation/bloc/auth/auth_state.dart';
import '../../widgets/intro/intro_content.dart';
import '../../widgets/intro/goal_card.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nutrichild/core/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrichild/presentation/bloc/auth/auth_bloc.dart';
import 'package:nutrichild/presentation/bloc/child/child_bloc.dart';
import 'package:nutrichild/presentation/bloc/child/child_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final PageController _controller = PageController();
  final GlobalKey<FormState> _childFormKey = GlobalKey<FormState>();
  bool isLastPage = false;
  String? selectedGoal;

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

  Future<Map<String, dynamic>> getChildData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('child_name') ?? '',
      'age': prefs.getInt('child_age') ?? 0,
      'weight': prefs.getDouble('child_weight') ?? 0,
      'height': prefs.getDouble('child_height') ?? 0,
      'gender': prefs.getString('child_gender') ?? '',
      'goal': prefs.getString('child_goal') ?? '',
    };
  }

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
    final List<Widget> onboardingPages = [
      IntroContent(
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
      IntroContent(
        title: "Let's setup your child's profile",
        showChildForm: true,
        showButton: true,
        buttonText: 'CONTINUE',
        centerContent: true,
        formKey: _childFormKey,
        onButtonPressed: _handleChildFormContinue,
      ),
      // Third Page - Goal Selection
      IntroContent(
        title: "What's your diet goal?",
        showCards: true,
        showButton: true,
        buttonText: 'CONTINUE',
        centerContent: true,
        cards: [
          GoalCard(
            title: 'Eat healthy',
            subtitle: 'Have balanced diet and stay lean',
            isSelected: selectedGoal == 'Eat healthy',
            onTap: () => _handleGoalSelection('Eat healthy'),
          ),
          GoalCard(
            title: 'Loose weight',
            subtitle: 'Get lean without struggle',
            isSelected: selectedGoal == 'Loose weight',
            onTap: () => _handleGoalSelection('Loose weight'),
          ),
          GoalCard(
            title: 'Build muscles',
            subtitle: 'Stay active and get stronger',
            isSelected: selectedGoal == 'Build muscles',
            onTap: () => _handleGoalSelection('Build muscles'),
          ),
        ],
        onButtonPressed: _handleGoalContinue,
      ),
      IntroContent(
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
      IntroContent(
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

            final childData = await getChildData();

            final userId = (authBloc.state as LoginAuthState).user.id;

            // Simpan data ke bloc
            BlocProvider.of<ChildBloc>(context).add(AddChildEvent(
                child: Child(
                    id: childId,
                    userId: userId,
                    name: childData['name'].toString(),
                    age: childData['age'],
                    weight: childData['weight'],
                    height: childData['height'],
                    gender: childData['gender'].toString(),
                    goal: childData['goal'].toString())));

            Future.delayed(const Duration(milliseconds: 500), () {
              BlocProvider.of<ChildBloc>(context)
                  .add(GetChildEvent(id: userId));
            });
            context.go(AppRoutes.navigation);
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

  void _handleGoalSelection(String goalName) {
    setState(() {
      selectedGoal = goalName;
    });
  }

  void _handleGoalContinue() {
    if (selectedGoal != null) {
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
