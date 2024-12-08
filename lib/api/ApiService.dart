import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nutrichild/data/model/ArticleResult.dart';

class ApiService {
  static const String apiKey = "0922bc87ce2c2c9a1afb4509a9a96c11";

  Future<ArticleResults> topHeadlines(String item) async {
    final url = Uri.parse(
        "https://trackapi.nutritionix.com/v2/search/instant/?query=$item");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return ArticleResults.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data from Newsapi');
    }
  }
}
