import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nutrichild/data/model/ArticleResult.dart';

class ApiService {
  static const String apiKey = "41e1f1b636539e82c15d60b757958247";

  Future<ArticleResults> topHeadlines(String item) async {
    final url = Uri.parse(
        "https://trackapi.nutritionix.com/v2/search/instant/?query=$item");
    final headers = {
      'x-app-id': 'b55062a2',
      'x-app-key': apiKey,
      'Content-Type': 'application/json'
    };
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return ArticleResults.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data from Newsapi');
    }
  }
}
