import 'package:flutter/material.dart';
import 'package:nutrichild/api/ApiService.dart';

class Checkfetch extends StatefulWidget {
  const Checkfetch({super.key});

  @override
  State<Checkfetch> createState() => _NewsPageState();
}

class _NewsPageState extends State<Checkfetch> {
  final ApiService apiService = ApiService();
  List articles = [];

  @override
  void initState() {
    super.initState();
    fetchArticles("nasi");
  }

  Future<void> fetchArticles(String item) async {
    print("fetch data");
    try {
      final result = await apiService.topHeadlines(item);
      setState(() {
        articles = result.articles;
      });
    } catch (e) {
      print("Error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Nutrinix Syndigo"),
        ),
        body: articles.isEmpty
            ? const Center(child: Text('No available news'))
            : ListView.builder(
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  final article = articles[index];
                  return ListTile(title: Text(article.Food_Name));
                }));
  }
}
