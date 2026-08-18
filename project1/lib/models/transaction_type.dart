enum TransactionType {
  expense('expense'),
  income('income');

  const TransactionType(this.key);
  final String key;

  static TransactionType fromKey(String? key) =>
      values.firstWhere((t) => t.key == key, orElse: () => TransactionType.expense);
}