import 'app_category.dart';

class BudgetTarget {
  final int id;
  final AppCategory category;
  final double monthlyLimit;
  final double alertThreshold;
  final double spentAmount;
  final double progressPercentage;

  BudgetTarget({
    required this.id,
    required this.category,
    required this.monthlyLimit,
    required this.alertThreshold,
    required this.spentAmount,
    required this.progressPercentage,
  });

  factory BudgetTarget.fromJson(Map<String, dynamic> json) {
    return BudgetTarget(
      id: json['id'] as int? ?? 0,
      category: AppCategory.fromJson(
        json['category'] as Map<String, dynamic>? ?? const {},
      ),
      monthlyLimit: (json['monthlyLimit'] as num?)?.toDouble() ?? 0,
      alertThreshold: (json['alertThreshold'] as num?)?.toDouble() ?? 0,
      spentAmount: (json['spentAmount'] as num?)?.toDouble() ?? 0,
      progressPercentage: (json['progressPercentage'] as num?)?.toDouble() ?? 0,
    );
  }
}