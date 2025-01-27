import 'package:nutrichild/.model/Article.dart';

class ArticleResult {
  final List<Article> articles;

  ArticleResult({
    required this.articles,
  });

  factory ArticleResult.fromJson(Map<String, dynamic> json) {
    var list = json["common"] as List;
    List<Article> articleList =
        list.map((item) => Article.fromJson(item)).toList();

    return ArticleResult(
      articles: articleList,
    );
  }
}
