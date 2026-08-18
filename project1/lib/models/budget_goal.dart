class BudgetGoal {
  final String category;
  final double monthlyLimit;
  final double notificationThreshold; // 0.0–1.0, не проценты

  const BudgetGoal({required this.category, required this.monthlyLimit, required this.notificationThreshold});

  factory BudgetGoal.fromMap(Map<String, dynamic> map) => BudgetGoal(
    category: map['category'] as String? ?? '',
    monthlyLimit: (map['monthlyLimit'] as num?)?.toDouble() ?? 0,
    notificationThreshold: (map['notificationThreshold'] as num?)?.toDouble() ?? 0.9,
  );

  Map<String, dynamic> toMap() => {'category': category, 'monthlyLimit': monthlyLimit, 'notificationThreshold': notificationThreshold};

  double progress(double spent) => monthlyLimit == 0 ? 0 : (spent / monthlyLimit).clamp(0.0, 1.0);
  bool isNearLimit(double spent) => monthlyLimit > 0 && spent / monthlyLimit >= notificationThreshold;
}