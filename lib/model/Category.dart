class Category {
  final String idCategory;
  final String strCategory;
  final String strCategoryThumb;
  final String categoryType;

  Category({
    required this.idCategory,
    required this.strCategory,
    required this.strCategoryThumb,
    required this.categoryType,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    final category = json['strCategory'] as String;
    final categoryType = _getCategoryType(category);

    return Category(
      idCategory: json['idCategory'] ?? '',
      strCategory: category,
      strCategoryThumb: json['strCategoryThumb'] ?? '',
      categoryType: categoryType,
    );
  }

  static String _getCategoryType(String category) {
    final mainDishes = [
      'beef',
      'chicken',
      'lamb',
      'pork',
      'goat',
      'seafood',
      'pasta'
    ];

    return mainDishes.contains(category.toLowerCase())
        ? 'Main Dishes'
        : 'Other Dishes';
  }
}
