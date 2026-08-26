class StatisticsSummary {
  final double totalBalance;
  final double totalIncome;
  final double totalExpense;

  StatisticsSummary({
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpense,
  });

  factory StatisticsSummary.fromJson(Map<String, dynamic> json) {
    return StatisticsSummary(
      totalBalance: (json['totalBalance'] as num?)?.toDouble() ?? 0,
      totalIncome: (json['totalIncome'] as num?)?.toDouble() ?? 0,
      totalExpense: (json['totalExpense'] as num?)?.toDouble() ?? 0,
    );
  }
}