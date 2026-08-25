import 'app_category.dart';

class TransactionApi {
  final int id;
  final String name;
  final double amount;
  final String type;
  final AppCategory category;
  final DateTime date;

  TransactionApi({
    required this.id,
    required this.name,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
  });

  factory TransactionApi.fromJson(Map<String, dynamic> json) {
    return TransactionApi(
      id: json['id'],
      name: json['name'],
      amount: (json['amount'] as num).toDouble(),
      type: json['type'],
      category: AppCategory.fromJson(json['category']),
      date: DateTime.parse(json['date']),
    );
  }
}