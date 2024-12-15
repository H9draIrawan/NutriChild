import 'package:flutter/material.dart';
import 'package:nutrichild/api/ApiService.dart';

class Searchpage extends StatefulWidget {
  const Searchpage({super.key});

  @override
  State<Searchpage> createState() => _SearchpageState();
}

class _SearchpageState extends State<Searchpage> {
  final ApiService apiService = ApiService();
  List articles = [];
  bool isLoading = false;
  final TextEditingController _searchController = TextEditingController();

  Future<void> searchFood(String query) async {
    if (query.isEmpty) {
      setState(() {
        articles = [];
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final result = await apiService.topHeadlines(query);
      print("Search Results: ${result.articles}");
      setState(() {
        articles = result.articles;
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 50),
          // Search TextField
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Cari makanan...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              onChanged: (value) {
                searchFood(value);
              },
            ),
          ),
          const SizedBox(height: 20),
          
          // Results
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : articles.isEmpty
                    ? const Center(child: Text('Tidak ada hasil pencarian'))
                    : ListView.builder(
                        itemCount: articles.length,
                        itemBuilder: (context, index) {
                          final article = articles[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            child: ListTile(
                              title: Text(article.Food_Name),
                              subtitle: Text(
                                  'Kalori: ${article.Calories} | Protein: ${article.Protein}g'),
                              onTap: () {
                                // Tambahkan aksi ketika item diklik
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
