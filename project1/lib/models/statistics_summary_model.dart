class StatisticsSummaryModel {
  final double totalBalance;
  final double totalIncome;
  final double totalExpense;

  const StatisticsSummaryModel({
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpense,
  });

  factory StatisticsSummaryModel.fromJson(Map<String, dynamic> json) {
    return StatisticsSummaryModel(
      totalBalance: (json['totalBalance'] as num?)?.toDouble() ?? 0,
      totalIncome: (json['totalIncome'] as num?)?.toDouble() ?? 0,
      totalExpense: (json['totalExpense'] as num?)?.toDouble() ?? 0,
    );
  }
}