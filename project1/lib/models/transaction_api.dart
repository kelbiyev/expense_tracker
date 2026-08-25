import 'category.dart';

class ApiTransaction {
  final int id;
  final String name;
  final double amount;
  final String type;
  final AppCategory category;
  final DateTime date;

  ApiTransaction({
    required this.id,
    required this.name,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
  });

  factory ApiTransaction.fromJson(Map<String, dynamic> json) {
    return ApiTransaction(
      id: json['id'],
      name: json['name'],
      amount: (json['amount'] as num).toDouble(),
      type: json['type'],
      category: AppCategory.fromJson(json['category']),
      date: DateTime.parse(json['date']),
    );
  }
}