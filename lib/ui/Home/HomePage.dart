import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';
import 'AllRecipesPage.dart';
import 'ui_recipe.dart';
import '../../api/ApiService.dart';
import '../../model/Category.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String? username;
  List<Category> categories = [];
  List<Category> filteredCategories = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _fetchCategories();
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

  Future<void> _fetchCategories() async {
    final apiService = ApiService();
    try {
      final fetchedCategories = await apiService.fetchCategories();
      setState(() {
        categories = fetchedCategories;
        filteredCategories = fetchedCategories;
      });
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  void _filterCategories(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredCategories = categories;
      } else {
        filteredCategories = categories
            .where((category) => category.strCategory
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
                        controller: searchController,
                        onChanged: _filterCategories,
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
                        onPressed: () {
                          // Clear search
                          searchController.clear();
                          _filterCategories('');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF19A413),
                          padding: const EdgeInsets.all(12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: const Icon(Icons.clear, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.85,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                children: filteredCategories.map((category) {
                  return CategoryButton(
                    label: category.strCategory,
                    imageUrl: category.strCategoryThumb,
                  );
                }).toList(),
              ),
              if (filteredCategories.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No categories found",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String label;
  final String imageUrl;

  const CategoryButton(
      {super.key, required this.label, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Handle category tap
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey[200],
                        child: Icon(Icons.error, color: Colors.grey[400]),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'WorkSans',
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
