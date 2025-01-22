import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrichild/bloc/child/child_bloc.dart';
import 'package:nutrichild/bloc/child/child_state.dart';

import 'ChooseNewPlan.dart';

class Mealpage extends StatefulWidget {
  const Mealpage({super.key});

  @override
  State<Mealpage> createState() => _MealpageState();
}

class _MealpageState extends State<Mealpage> {
  late ChildBloc _childBloc;

  @override
  void initState() {
    super.initState();
    _childBloc = BlocProvider.of<ChildBloc>(context);
  }

  @override
  void dispose() {
    // Bersihkan resources jika diperlukan
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Meal Plan',
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'WorkSans',
              fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section: Your Goal
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
                color: Colors.white,
                shadowColor: Colors.black.withOpacity(0.2),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/goal');
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.orange.shade100,
                                    ),
                                    child: Icon(
                                      Icons.flag_rounded,
                                      color: Colors.orange.shade800,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  const Flexible(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Goal',
                                          style: TextStyle(
                                            fontFamily: 'WorkSans',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  BlocBuilder<ChildBloc, ChildState>(
                                    bloc: _childBloc,
                                    builder: (context, state) {
                                      if (state is LoadChildState) {
                                        return Text(
                                          state.child.goal ?? 'Not set',
                                          style: TextStyle(
                                            fontFamily: 'WorkSans',
                                            fontSize: 14,
                                            color: Colors.orange.shade800,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        );
                                      }
                                      return Text(
                                        'Loading...',
                                        style: TextStyle(
                                          fontFamily: 'WorkSans',
                                          fontSize: 14,
                                          color: Colors.orange.shade800,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(Icons.arrow_forward_ios,
                                      size: 14, color: Colors.orange.shade800)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Section: Recommended Meal Plan
              const Text(
                'Meal plan recommended for you',
                style: TextStyle(
                  fontFamily: 'WorkSans',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Colors.white,
                shadowColor: Colors.black.withOpacity(0.2),
                elevation: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 200,
                        child: Image.asset(
                          'assets/images/pic1.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: Text(
                                  'Image not found',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Protein power',
                            style: TextStyle(
                              fontFamily: 'WorkSans',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'This meal plan allows all types of meat, fish, poultry, eggs, cheese, non-starchy vegetables, butter, oil, and salad dressing.',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontFamily: 'WorkSans'),
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red[50],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                'RICH IN PROTEIN',
                                style: TextStyle(
                                    color: Colors.red[800],
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'WorkSans'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Section: Create Your Own
              const Text(
                'Create your own',
                style: TextStyle(
                  fontFamily: 'WorkSans',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              LayoutBuilder(builder: (context, constraints) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  color: Colors.white,
                  shadowColor: Colors.black.withOpacity(0.2),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChooseNewPlan()),
                      );
                    },
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: SizedBox(
                            width: double.infinity,
                            height: 200,
                            child: Image.asset(
                              'assets/images/Default.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: Text(
                                      'Image not found',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          top: constraints.maxWidth *
                              0.2, // Atur posisi vertikal
                          left: 0,
                          right: 0,
                          child: Column(
                            children: [
                              const SizedBox(height: 16),
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red[800],
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Create new meal plan',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'WorkSans',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
