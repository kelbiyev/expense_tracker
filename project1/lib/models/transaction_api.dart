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
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      type: json['type'] as String? ?? 'XERC',
      category: AppCategory.fromJson(
        json['category'] as Map<String, dynamic>? ?? const {},
      ),
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
    );
  }
}