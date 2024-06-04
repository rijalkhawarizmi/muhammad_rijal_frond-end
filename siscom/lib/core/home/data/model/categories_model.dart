class CategoriesField {
  static final List<String> values = [id, categoryName];
  static const String id = '_id';
  static const String categoryName = 'category_name';
}

class CategoryModel {
  int? id;
  String? categoryName;

  CategoryModel({this.id, this.categoryName});

  CategoryModel copy({int? id, String? categoryName}) => CategoryModel(
      id: id ?? this.id, categoryName: categoryName ?? this.categoryName);

  static CategoryModel fromJson(Map<String, Object?> json) => CategoryModel(
        id: json[CategoriesField.id] as int,
        categoryName: json[CategoriesField.categoryName] as String,
      );
  Map<String, Object?> toJson() =>
      {CategoriesField.id: id, CategoriesField.categoryName: categoryName};
}
