class CategoryStatisticItem {
  final int categoryId;
  final String category;
  final String categoryName;
  final double totalAmount;
  final double percentage;

  const CategoryStatisticItem({
    required this.categoryId,
    required this.category,
    required this.categoryName,
    required this.totalAmount,
    required this.percentage,
  });

  factory CategoryStatisticItem.fromJson(Map<String, dynamic> json) {
    return CategoryStatisticItem(
      categoryId: json['categoryId'] as int? ?? 0,
      category: json['category'] as String? ?? '',
      categoryName: json['categoryName'] as String? ?? '',
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0,
    );
  }
}

class CategoryStatisticsModel {
  final double totalExpense;
  final List<CategoryStatisticItem> categories;

  const CategoryStatisticsModel({
    required this.totalExpense,
    required this.categories,
  });

  factory CategoryStatisticsModel.fromJson(Map<String, dynamic> json) {
    return CategoryStatisticsModel(
      totalExpense: (json['totalExpense'] as num?)?.toDouble() ?? 0,
      categories: (json['categories'] as List? ?? [])
          .map((e) => CategoryStatisticItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}