class AppCategory {
  final int id;
  final String key;
  final String displayName;
 
  AppCategory({
    required this.id,
    required this.key,
    required this.displayName,
  });
 
  factory AppCategory.fromJson(Map<String, dynamic> json) {
    return AppCategory(
      id: json['id'],
      key: json['key'],
      displayName: json['displayName'],
    );
  }
}