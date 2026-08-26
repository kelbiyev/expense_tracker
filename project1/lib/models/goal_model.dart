import 'categories_model.dart';

class GoalModel {
  final int id;
  final CategoriesModel category;
  final double monthlyLimit;
  final double alertThreshold;
  final double spentAmount;
  final double progressPercentage;

  const GoalModel({
    required this.id,
    required this.category,
    required this.monthlyLimit,
    required this.alertThreshold,
    required this.spentAmount,
    required this.progressPercentage,
  });

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json['id'] as int? ?? 0,
      category: CategoriesModel.fromJson(
        json['category'] as Map<String, dynamic>? ?? const {},
      ),
      monthlyLimit: (json['monthlyLimit'] as num?)?.toDouble() ?? 0,
      alertThreshold: (json['alertThreshold'] as num?)?.toDouble() ?? 0,
      spentAmount: (json['spentAmount'] as num?)?.toDouble() ?? 0,
      progressPercentage: (json['progressPercentage'] as num?)?.toDouble() ?? 0,
    );
  }
}