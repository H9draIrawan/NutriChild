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
  int currentPage = 0;
  static const int itemsPerPage = 5;
  bool hasMoreItems = true;

  List get paginatedArticles {
    final startIndex = 0;
    final endIndex = (currentPage + 1) * itemsPerPage;
    if (articles.length > startIndex) {
      return articles.sublist(startIndex, endIndex.clamp(0, articles.length));
    }
    return [];
  }

  Future<void> searchFood(String query) async {
    if (query.isEmpty) {
      setState(() {
        articles = [];
        currentPage = 0;
        hasMoreItems = true;
      });
      return;
    }

    setState(() {
      isLoading = true;
      currentPage = 0;
    });

    try {
      final result = await apiService.topHeadlines(query);
      setState(() {
        articles = result.articles;
        isLoading = false;
        hasMoreItems = articles.length > itemsPerPage;
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void loadMore() {
    if (!hasMoreItems || isLoading) return;
    
    setState(() {
      currentPage++;
      hasMoreItems = articles.length > (currentPage + 1) * itemsPerPage;
    });
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
                    : NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollInfo) {
                          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                            loadMore();
                          }
                          return true;
                        },
                        child: ListView.builder(
                          itemCount: paginatedArticles.length + (hasMoreItems ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index >= paginatedArticles.length) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: hasMoreItems
                                      ? const CircularProgressIndicator()
                                      : const Text('Tidak ada data lagi'),
                                ),
                              );
                            }

                            final article = paginatedArticles[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: ListTile(
                                title: Text(article.Food_Name),
                                subtitle: Text(
                                  'Kalori: ${article.Calories?.toStringAsFixed(1) ?? 'Memuat...'} kcal | '
                                  'Protein: ${article.Protein?.toStringAsFixed(1) ?? 'Memuat...'}g'
                                ),
                                trailing: (article.Calories == null || article.Protein == null) 
                                  ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ) 
                                  : null,
                                onTap: () {
                                  // Tambahkan aksi ketika item diklik
                                },
                              ),
                            );
                          },
                        ),
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
