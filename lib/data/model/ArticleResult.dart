import 'package:nutrichild/data/model/Article.dart';

class ArticleResults {
  List<Article> articles;

  ArticleResults({
    required this.articles,
  });

  factory ArticleResults.fromJson(Map<String, dynamic> json) => ArticleResults(
        articles:
            List<Article>.from(json["common"].map((x) => Article.fromJson(x))),
      );
}
