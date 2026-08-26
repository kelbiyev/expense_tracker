import 'package:intl/intl.dart';

import 'categories_model.dart';

class TransactionModel {
  static const String typeExpense = 'XERC';
  static const String typeIncome = 'GELIR';

  final int id;
  final String name;
  final CategoriesModel category;
  final double amount;
  final DateTime date;
  final String type;

  const TransactionModel({
    required this.id,
    required this.name,
    required this.category,
    required this.amount,
    required this.date,
    required this.type,
  });

  bool get isExpense => type == typeExpense;

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      category: CategoriesModel.fromJson(
        json['category'] as Map<String, dynamic>? ?? const {},
      ),
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      type: json['type'] as String? ?? typeExpense,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'categoryId': category.id,
        'amount': amount,
        'date': DateFormat('yyyy-MM-dd').format(date),
        'type': type,
      };
}