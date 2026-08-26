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
      categoryId: json['categoryId'] as int? ?? 0,
      category: json['category'] as String? ?? '',
      categoryName: json['categoryName'] as String? ?? '',
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0,
    );
  }
}

class CategoryStatistics {
  final double totalExpense;
  final List<CategoryStatEntry> categories;

  CategoryStatistics({required this.totalExpense, required this.categories});

  factory CategoryStatistics.fromJson(Map<String, dynamic> json) {
    return CategoryStatistics(
      totalExpense: (json['totalExpense'] as num?)?.toDouble() ?? 0,
      categories: (json['categories'] as List? ?? [])
          .map((e) => CategoryStatEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}