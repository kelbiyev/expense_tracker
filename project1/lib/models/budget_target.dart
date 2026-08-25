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
      id: json['id'],
      category: AppCategory.fromJson(json['category']),
      monthlyLimit: (json['monthlyLimit'] as num).toDouble(),
      alertThreshold: (json['alertThreshold'] as num).toDouble(),
      spentAmount: (json['spentAmount'] as num).toDouble(),
      progressPercentage: (json['progressPercentage'] as num).toDouble(),
    );
  }
}