class Category {
  final String idCategory;
  final String strCategory;
  final String strCategoryThumb;

  Category({required this.idCategory, required this.strCategory, required this.strCategoryThumb});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      idCategory: json['idCategory'],
      strCategory: json['strCategory'],
      strCategoryThumb: json['strCategoryThumb'],
    );
  }
} 