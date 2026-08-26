class CategoriesModel {
  final int id;
  final String key;
  final String displayName;

  const CategoriesModel({
    required this.id,
    required this.key,
    required this.displayName,
  });

  factory CategoriesModel.fromJson(Map<String, dynamic> json) {
    return CategoriesModel(
      id: json['id'] as int? ?? 0,
      key: json['key'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
    );
  }
}