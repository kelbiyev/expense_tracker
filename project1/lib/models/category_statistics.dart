class CategoryStatEntry {
  final int categoryId;
  final String category;
  final String categoryName;
  final double totalAmount;
  final double percentage;

  CategoryStatEntry({
    required this.categoryId,
    required this.category,
    required this.categoryName,
    required this.totalAmount,
    required this.percentage,
  });

  factory CategoryStatEntry.fromJson(Map<String, dynamic> json) {
    return CategoryStatEntry(
      categoryId: json['categoryId'],
      category: json['category'],
      categoryName: json['categoryName'],
      totalAmount: (json['totalAmount'] as num).toDouble(),
      percentage: (json['percentage'] as num).toDouble(),
    );
  }
}

class CategoryStatistics {
  final double totalExpense;
  final List<CategoryStatEntry> categories;

  CategoryStatistics({required this.totalExpense, required this.categories});

  factory CategoryStatistics.fromJson(Map<String, dynamic> json) {
    return CategoryStatistics(
      totalExpense: (json['totalExpense'] as num).toDouble(),
      categories: (json['categories'] as List)
          .map((e) => CategoryStatEntry.fromJson(e))
          .toList(),
    );
  }
}