class TransactionRequest {
  final String name;
  final double amount;
  final String type;
  final int categoryId;
  final String date;

  TransactionRequest({
    required this.name,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'amount': amount,
        'type': type,
        'categoryId': categoryId,
        'date': date,
      };
}